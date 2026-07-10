
-- campaign id union campaign id * product id 数据
WITH ad_creation AS (
    SELECT  a.shop_id,
            a.campaign_id,
            a.specific_spu_id,
            a.shop_operation_country,
            a.product_specific_type,
            a.specific_spu_id_list,
            CASE
                WHEN product_specific_type='1' THEN b.product_id
                ELSE specific_spu_id
            END AS creation_product_id,
            if(c.campaign_id IS NOT NULL, 1, 0) AS last_hour_delivered,
            is_campaign_paused
    FROM    (
                SELECT  cast(shop_id AS BIGINT) AS shop_id,
                        cast(campaign_id AS BIGINT) AS campaign_id,
                        cast(exploded_spu_id AS BIGINT) AS specific_spu_id,
                        shop_operation_country,
                        product_specific_type,
                        specific_spu_id_list
                FROM    (
                            SELECT  max(shop_id) AS shop_id,
                                    campaign_id,
                                    max(shop_operation_country) AS shop_operation_country,
                                    max(product_specific_type) AS product_specific_type,
                                    max(specific_spu_id_list) AS specific_spu_id_list
                            FROM    ad_dm.dm_overseas_shop_m10n_overture_dataset_di_utc0
                            WHERE   p_date between '20260401' and '20260520'
                            AND     if(shop_automation_type='2', 'ROI2', 'ROI1')='ROI2'
                            AND     is_ug='non-UG'
                            AND     delivery_type IN ('video', 'product')
                            AND     dollar_cost>0
                            GROUP BY
                                    campaign_id
                        ) a LATERAL VIEW EXPLODE(
                            split(
                                regexp_replace(
                                    COALESCE(specific_spu_id_list, ''),
                                    '[\\[\\]"]',
                                    ''
                                ),
                                ','
                            )
                        ) t AS exploded_spu_id
            ) a
    LEFT JOIN
            (
                SELECT  DISTINCT
                        seller_id AS shop_id,
                        product_id
                FROM    ecom.dim_product_base_info_df_global
                WHERE   date between '20260401' and '20260520'
                AND     country_sale_status=0 -- available for sale
                AND     sale_status=3
            ) b
    ON      a.product_specific_type='1'
    AND     a.shop_id=b.shop_id
    LEFT JOIN
            (
                -- 是否当天最后一个时刻在投
                SELECT  DISTINCT
                        campaign_id
                FROM    ad_dim.dim_overseas_campaign_hourly
                WHERE   p_date between '20260401' and '20260520'
                AND     HOUR='23'
                AND     campaign_id>0
                AND     opt_status=0 -- 开启投放
                AND     DATA IS NOT NULL
                AND     get_json_object(DATA, '$.shop_automation_type')='2'
            ) c
    ON      a.campaign_id=c.campaign_id
    LEFT JOIN
            (
                SELECT  object_id AS campaign_id,
                        max(
                            CASE
                                WHEN opt_key='stat1' AND CAST(opt_old_value AS BIGINT)=0 AND CAST(opt_new_value AS BIGINT)=1 THEN 1
                                ELSE 0
                            END
                        ) AS is_campaign_paused
                FROM    ad_dwd.dwd_overseas_ad_opt_log_utc0
                WHERE   p_date between '20260401' and '20260520'
                AND     object_type=4
                AND     opt_key='stat1'
                GROUP BY
                        object_id
            ) d
    ON      a.campaign_id=d.campaign_id
),
campaign AS (
    -- campaign info
    SELECT  campaign_id,
            sum(dollar_cost) AS dollar_cost,
            sum(if(delivery_type NOT IN ('live'), dollar_cost, 0)) AS pgm_dollar_cost,
            sum(
                if(content_type IN ('product_card'), dollar_cost, 0)
            ) AS psa_dollar_cost,
            sum(if(ecom_card_type=4, dollar_cost, 0)) AS carousel_dollar_cost,
            sum(if(roi2_ad_type=1, direct_pay_amount, 0)) AS direct_normal_ads_gmv,
            sum(
                if(
                    delivery_type NOT IN ('live') AND roi2_ad_type=1,
                    direct_pay_amount,
                    0
                )
            ) AS pgm_direct_normal_ads_gmv,
            sum(
                if(
                    content_type IN ('product_card') AND roi2_ad_type=1,
                    direct_pay_amount,
                    0
                )
            ) AS psa_direct_normal_ads_gmv,
            sum(
                if(
                    delivery_type NOT IN ('live') AND ecom_card_type=4 AND roi2_ad_type=1,
                    direct_pay_amount,
                    0
                )
            ) AS carousel_direct_normal_ads_gmv,
            'campaign_id' AS analysis_granularity
            -- normal_ads_gmv
    FROM    ad_dm.dm_overseas_shop_m10n_overture_dataset_di_utc0
    WHERE   p_date between '20260401' and '20260520'
    AND     if(shop_automation_type='2', 'ROI2', 'ROI1')='ROI2'
    AND     is_ug='non-UG'
    AND     delivery_type IN ('video', 'product')
            --AND     dollar_cost>0
    GROUP BY
            campaign_id
),
prod AS (
    SELECT  shop_id,
            shop_operation_country,
            a.campaign_id,
            a.creation_product_id AS product_id,
            if(b.product_id IS NOT NULL, 1, 0) AS has_delivered_event,
            dollar_cost,
            pgm_dollar_cost,
            carousel_dollar_cost,
            direct_normal_ads_gmv,
            pgm_direct_normal_ads_gmv,
            carousel_direct_normal_ads_gmv,
            analysis_granularity,
            psa_dollar_cost,
            psa_direct_normal_ads_gmv,
            last_hour_delivered,
            is_campaign_paused
    FROM    ad_creation a
    LEFT JOIN
            (
                SELECT  product_id,
                        campaign_id,
                        sum(dollar_cost/100000) AS dollar_cost,
                        sum(
                            if(
                                nvl(content_type, 'product_card') IN ('video', 'product_card'),
                                dollar_cost/100000,
                                0
                            )
                        ) AS pgm_dollar_cost,
                        sum(
                            if(
                                nvl(content_type, 'product_card') IN ('product_card'),
                                dollar_cost/100000,
                                0
                            )
                        ) AS psa_dollar_cost,
                        sum(
                            if(
                                nvl(content_type, 'product_card') IN ('product_card') AND rit IN (
                                    11180001,
                                    11233001,
                                    11180006,
                                    11233006,
                                    11180008,
                                    11233008
                                ),
                                dollar_cost/100000,
                                0
                            )
                        ) AS carousel_dollar_cost,
                        sum(
                            if(
                                roi2_ad_type='normal ads',
                                direct_ads_gmv/100000,
                                0
                            )
                        ) AS direct_normal_ads_gmv,
                        sum(
                            if(
                                nvl(content_type, 'product_card') NOT IN ('live') AND roi2_ad_type='normal ads',
                                direct_ads_gmv/100000,
                                0
                            )
                        ) AS pgm_direct_normal_ads_gmv,
                        sum(
                            if(
                                nvl(content_type, 'product_card') IN ('product_card') AND roi2_ad_type='normal ads',
                                direct_ads_gmv/100000,
                                0
                            )
                        ) AS psa_direct_normal_ads_gmv,
                        sum(
                            if(
                                roi2_ad_type='normal ads' AND nvl(content_type, 'product_card') IN ('product_card') AND rit IN (
                                    11180001,
                                    11233001,
                                    11180006,
                                    11233006,
                                    11180008,
                                    11233008
                                ),
                                direct_ads_gmv/100000,
                                0
                            )
                        ) AS carousel_direct_normal_ads_gmv,
                        'campaign_id * product_id' AS analysis_granularity
                FROM    ad_dwa.dwa_shop_m10n_product_delivery_stats_di_utc0
                WHERE   p_date between '20260401' and '20260520'
                        --AND     (
                        --            app_code<>573733
                        --            OR      app_code IS NULL
                        --        ) --剔除toko，2025.2.25
                AND     shop_automation_type='ROI2'
                GROUP BY
                        product_id,
                        campaign_id
            ) b
    ON      a.campaign_id=b.campaign_id
    AND     STRING (a.creation_product_id)=STRING (b.product_id)
),
prod_pure AS (
    SELECT  max(shop_id) AS shop_id,
            max(shop_operation_country) AS shop_operation_country,
            product_id,
            max(last_hour_delivered) AS last_hour_delivered,
            max(is_campaign_paused) AS is_campaign_paused,
            sum(dollar_cost) AS dollar_cost,
            sum(pgm_dollar_cost) AS pgm_dollar_cost,
            sum(carousel_dollar_cost) AS carousel_dollar_cost,
            sum(direct_normal_ads_gmv) AS direct_normal_ads_gmv,
            sum(pgm_direct_normal_ads_gmv) AS pgm_direct_normal_ads_gmv,
            sum(carousel_direct_normal_ads_gmv) AS carousel_direct_normal_ads_gmv,
            sum(psa_dollar_cost) AS psa_dollar_cost,
            sum(psa_direct_normal_ads_gmv) AS psa_direct_normal_ads_gmv,
            'product_id' AS analysis_granularity,
            max(has_delivered_event) AS has_delivered_event
    FROM    prod
    GROUP BY
            product_id
),
product_scenarios_base AS (
    -- product_scenarios底表数据处理 -> 聚合到product粒度
    SELECT  shop_id,
            product_id,
            sum(COALESCE(payment_l30d, 0)) AS payment_l30d,
            -- 过去30天gmv聚合到product_id粒度
            max(nvl(sub_order_cnt_l30d, 0)) AS sub_order_cnt_l30d -- 过去30天子订单量，已经是product_id粒度了，取一条记录即可
    FROM    ad_dm.dm_overseas_shop_m10n_product_scenarios_stats_extra_di_utc0
    WHERE   p_date  between '20260401' and '20260520'
    GROUP BY
            shop_id,
            product_id
),
product_tier AS (
    SELECT  shop_id,
            product_id,
            -- payment_l30d, -- 过去30天gmv
            -- sub_order_cnt_l30d, -- 过去30天子订单量
            CASE
                WHEN (payment_l30d>=1000000) OR (sub_order_cnt_l30d>=3000) THEN '大爆品'
                WHEN (payment_l30d>=30000) OR (sub_order_cnt_l30d>=1000) THEN '爆品'
                WHEN (payment_l30d>=10000) OR (sub_order_cnt_l30d>=300) THEN '潜力品'
                WHEN (payment_l30d>=3500) OR (sub_order_cnt_l30d>=100) THEN '生存品'
                WHEN (payment_l30d>=250) OR (sub_order_cnt_l30d>=3) THEN '冷启成功品'
                WHEN (payment_l30d>=0) OR (sub_order_cnt_l30d>=1) THEN '动销品'
                ELSE '无动销'
            END AS product_tier
    FROM    product_scenarios_base
),
item AS (
    SELECT  a.campaign_id,
            a.spu_id,
            a.used_active_item_cnt,
            a.affiliant_used_active_item_cnt,
            b.campaign_used_active_item_cnt,
            b.campaign_affiliant_used_active_item_cnt
    FROM    (
                SELECT  campaign_id,
                        spu_id,
                        count(
                            DISTINCT if(
                                (
                                    item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                                ) OR dollar_cost_1d>0,
                                item_id,
                                NULL
                            )
                        ) AS used_active_item_cnt,
                        count(
                            DISTINCT if(
                                item_have_alliance_product=1 AND (
                                    (
                                        item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                                    ) OR dollar_cost_1d>0
                                ),
                                item_id,
                                NULL
                            )
                        ) AS affiliant_used_active_item_cnt
                FROM    ad_dm.dm_shop_m10n_roi2_ads_reporting_stats_df_utc0
                WHERE   p_date  between '20260401' and '20260520'
                AND     delivery_type IN ('video')
                        --AND     campaign_opt_status=0
                GROUP BY
                        campaign_id,
                        spu_id
            ) a
    LEFT JOIN
            (
                SELECT  campaign_id,
                        count(
                            DISTINCT if(
                                (
                                    item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                                ) OR dollar_cost_1d>0,
                                item_id,
                                NULL
                            )
                        ) AS campaign_used_active_item_cnt,
                        count(
                            DISTINCT if(
                                item_have_alliance_product=1 AND (
                                    (
                                        item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                                    ) OR dollar_cost_1d>0
                                ),
                                item_id,
                                NULL
                            )
                        ) AS campaign_affiliant_used_active_item_cnt
                FROM    ad_dm.dm_shop_m10n_roi2_ads_reporting_stats_df_utc0
                WHERE   p_date  between '20260401' and '20260520'
                AND     delivery_type IN ('video')
                        --AND     campaign_opt_status=0
                GROUP BY
                        campaign_id
            ) b
    ON      a.campaign_id=b.campaign_id
),
item_product AS (
    SELECT  spu_id,
            count(
                DISTINCT if(
                    (
                        item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                    ) OR dollar_cost_1d>0,
                    item_id,
                    NULL
                )
            ) AS used_active_item_cnt,
            count(
                DISTINCT if(
                    item_have_alliance_product=1 AND (
                        (
                            item_delivery_status IN (1, 2, 3, 4) AND is_active_item=1
                        ) OR dollar_cost_1d>0
                    ),
                    item_id,
                    NULL
                )
            ) AS affiliant_used_active_item_cnt
    FROM    ad_dm.dm_shop_m10n_roi2_ads_reporting_stats_df_utc0
    WHERE   p_date between '20260401' and '20260520'
    AND     delivery_type IN ('video')
            --AND     campaign_opt_status=0
    GROUP BY
            spu_id
),
shop_take_rate AS (
    SELECT  shop_id,
            max(payment_30d) AS payment_30d,
            max(
                nvl(nonug_dollar_revenue_l30d, 0)/nvl(payment_30d, 0)
            ) AS shop_take_rate
    FROM    ad_dm.dm_vertical_shop_tag_df_utc0
    WHERE   p_date='20260520' -- 存量表，取最后一天的即可
    GROUP BY
            shop_id
),
shop_author_commission_rate AS (
    SELECT  a.shop_id,
            nvl(author_total_commission_30d, 0)/nvl(payment_30d, 0) AS shop_author_commission_rate -- 达人佣金率
    FROM    shop_take_rate a
    LEFT JOIN
            (
                SELECT  shop_id,
                        sum(
                            nvl(author_ad_commission_1d, 0)+nvl(author_affiliate_commission_1d, 0)
                        ) AS author_total_commission_30d -- 达人佣金
                FROM    ad_dm.dm_shop_ads_aca_order_stats_global_di_utc0
                WHERE   p_date  between '20260401' and '20260520'
                GROUP BY
                        shop_id
            ) b
    ON      a.shop_id=b.shop_id
),
campaign_full AS (
    SELECT  NULL AS product_id,
            a.campaign_id,
            dollar_cost,
            pgm_dollar_cost,
            carousel_dollar_cost,
            direct_normal_ads_gmv,
            pgm_direct_normal_ads_gmv,
            carousel_direct_normal_ads_gmv,
            analysis_granularity,
            used_active_item_cnt,
            affiliant_used_active_item_cnt,
            'null' AS product_tier,
            roi2_total_gmv AS roi2_total_gmv,
            0 AS product_gmv,
            psa_dollar_cost,
            psa_direct_normal_ads_gmv,
            0 AS has_delivered_event
    FROM    campaign a
    LEFT JOIN
            (
                SELECT  campaign_id,
                        max(campaign_used_active_item_cnt) AS used_active_item_cnt,
                        max(campaign_affiliant_used_active_item_cnt) AS affiliant_used_active_item_cnt
                FROM    item
                GROUP BY
                        campaign_id
            ) b
    ON      a.campaign_id=b.campaign_id
    LEFT JOIN
            (
                SELECT  roi2_campaign_id,
                        sum(onsite_shopping_value_usd) AS roi2_total_gmv
                FROM    ad_dwa.dwa_ad_shop_gmv_hi_utc0
                WHERE   p_date between '20260401' and '20260520'
                GROUP BY
                        roi2_campaign_id
            ) c
    ON      a.campaign_id=c.roi2_campaign_id
),
product_full AS (
    SELECT  a.product_id,
            a.campaign_id,
            dollar_cost,
            pgm_dollar_cost,
            carousel_dollar_cost,
            direct_normal_ads_gmv,
            pgm_direct_normal_ads_gmv,
            carousel_direct_normal_ads_gmv,
            analysis_granularity,
            used_active_item_cnt,
            affiliant_used_active_item_cnt,
            product_tier,
            roi2_total_gmv,
            0 AS product_gmv,
            psa_dollar_cost,
            psa_direct_normal_ads_gmv,
            has_delivered_event
    FROM    prod a
    LEFT JOIN
            (
                SELECT  campaign_id,
                        spu_id,
                        max(used_active_item_cnt) AS used_active_item_cnt,
                        max(affiliant_used_active_item_cnt) AS affiliant_used_active_item_cnt
                FROM    item
                GROUP BY
                        campaign_id,
                        spu_id
            ) b
    ON      a.campaign_id=b.campaign_id
    AND     STRING (a.product_id)=STRING (b.spu_id)
    LEFT JOIN
            product_tier c
    ON      STRING (a.product_id)=STRING (c.product_id)
    LEFT JOIN
            (
                SELECT  roi2_campaign_id,
                        spu_id,
                        sum(onsite_shopping_value_usd) AS roi2_total_gmv
                FROM    ad_dwa.dwa_ad_shop_gmv_hi_utc0
                WHERE   p_date between '20260401' and '20260520'
                GROUP BY
                        roi2_campaign_id,
                        spu_id
            ) d
    ON      a.campaign_id=d.roi2_campaign_id
    AND     STRING (a.product_id)=STRING (d.spu_id)
),
product_pure_full AS (
    SELECT  a.shop_id,
            a.shop_operation_country,
            a.product_id,
            NULL AS campaign_id,
            dollar_cost,
            pgm_dollar_cost,
            carousel_dollar_cost,
            direct_normal_ads_gmv,
            pgm_direct_normal_ads_gmv,
            carousel_direct_normal_ads_gmv,
            analysis_granularity,
            used_active_item_cnt,
            affiliant_used_active_item_cnt,
            product_tier,
            roi2_total_gmv,
            product_gmv,
            psa_dollar_cost,
            psa_direct_normal_ads_gmv,
            has_delivered_event,
            last_hour_delivered,
            is_campaign_paused
    FROM    prod_pure a
    LEFT JOIN
            (
                SELECT  spu_id,
                        max(used_active_item_cnt) AS used_active_item_cnt,
                        max(affiliant_used_active_item_cnt) AS affiliant_used_active_item_cnt
                FROM    item_product
                GROUP BY
                        spu_id
            ) b
    ON      STRING (a.product_id)=STRING (b.spu_id)
    LEFT JOIN
            product_tier c
    ON      STRING (a.product_id)=STRING (c.product_id)
    LEFT JOIN
            (
                SELECT  spu_id,
                        sum(roi2_total_gmv) AS roi2_total_gmv
                FROM    prod a
                LEFT JOIN
                        (
                            SELECT  roi2_campaign_id,
                                    spu_id,
                                    sum(onsite_shopping_value_usd) AS roi2_total_gmv
                            FROM    ad_dwa.dwa_ad_shop_gmv_hi_utc0
                            WHERE   p_date between '20260401' and '20260520'
                            GROUP BY
                                    roi2_campaign_id,
                                    spu_id
                        ) b
                ON      a.campaign_id=b.roi2_campaign_id
                AND     STRING (a.product_id)=STRING (b.spu_id)
                GROUP BY
                        spu_id
            ) d
    ON      STRING (a.product_id)=STRING (d.spu_id)
    LEFT JOIN
            (
                SELECT  product_id,
                        sum(payment_1d) AS product_gmv
                FROM    ad_dm.dm_overseas_shop_m10n_product_scenarios_stats_extra_di_utc0
                WHERE   p_date between '20260401' and '20260520'
                AND     nvl(content_type, 'product_card')!='live'
                GROUP BY
                        product_id
            ) e
    ON      STRING (a.product_id)=STRING (e.product_id)
),
a AS (
    SELECT  a.shop_id,
            shop_operation_country,
            product_id,
            a.campaign_id,
            dollar_cost,
            pgm_dollar_cost,
            carousel_dollar_cost,
            direct_normal_ads_gmv,
            pgm_direct_normal_ads_gmv,
            carousel_direct_normal_ads_gmv,
            analysis_granularity,
            used_active_item_cnt,
            affiliant_used_active_item_cnt,
            product_tier,
            roi2_total_gmv,
            product_gmv,
            psa_dollar_cost,
            psa_direct_normal_ads_gmv,
            has_delivered_event,
            last_hour_delivered,
            is_campaign_paused
    FROM    ad_creation a
    LEFT JOIN
            (
                SELECT  *
                FROM    campaign_full
                UNION  
                SELECT  *
                FROM    product_full
            ) a0
    ON      a.campaign_id=a0.campaign_id
    UNION  
    (
        SELECT  shop_id,
                shop_operation_country,
                product_id,
                campaign_id,
                dollar_cost,
                pgm_dollar_cost,
                carousel_dollar_cost,
                direct_normal_ads_gmv,
                pgm_direct_normal_ads_gmv,
                carousel_direct_normal_ads_gmv,
                analysis_granularity,
                used_active_item_cnt,
                affiliant_used_active_item_cnt,
                product_tier,
                roi2_total_gmv,
                product_gmv,
                psa_dollar_cost,
                psa_direct_normal_ads_gmv,
                has_delivered_event,
                last_hour_delivered,
                is_campaign_paused
        FROM    product_pure_full
    )
)
SELECT  a.shop_id,
        a.campaign_id, -- 当天消耗>0 的PGM campaign
        product_id, -- 对应的在投商品
        dollar_cost,
        pgm_dollar_cost,
        carousel_dollar_cost,
        direct_normal_ads_gmv,
        pgm_direct_normal_ads_gmv,
        carousel_direct_normal_ads_gmv,
        analysis_granularity,
        used_active_item_cnt,
        affiliant_used_active_item_cnt,
        key_seller_label_detailed,
        key_seller_label,
        is_key_seller_label,
        available_for_sale_cnt,
        status,
        c.global_seller_gmv_tier,
        shop_operation_country,
        product_tier,
        shop_take_rate,
        shop_author_commission_rate,
        roi2_total_gmv,
        product_gmv,
        psa_dollar_cost,
        psa_direct_normal_ads_gmv,
        has_delivered_event, -- 是否最近30天有广告事件/有动销
        last_hour_delivered,
        is_campaign_paused
FROM    a
LEFT JOIN -- 战略重点商家
        (
            SELECT  shop_id,
                    key_seller_label_detailed,
                    key_seller_label,
                    is_key_seller_label
            FROM    ecom.dim_slr_shop_key_strategic_df_global
            WHERE   date between '20260401' and '20260520'
        ) b
ON      STRING (a.shop_id)=STRING (b.shop_id)
LEFT JOIN
        (
            SELECT  shop_id,
                    available_for_sale_cnt,
                    status,
                    global_seller_gmv_tier
            FROM    ad_dm.dm_vertical_shop_tag_df_utc0
            WHERE   p_date between '20260401' and '20260520'
        ) c
ON      STRING (a.shop_id)=STRING (c.shop_id)
LEFT JOIN
        shop_take_rate d
ON      STRING (a.shop_id)=STRING (d.shop_id)
LEFT JOIN
        shop_author_commission_rate f
ON      STRING (a.shop_id)=STRING (f.shop_id)




