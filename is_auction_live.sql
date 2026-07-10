WITH sales AS (
    -- 客销关系匹配：每个 global_seller_id 仅保留 daily_revenue 最大的一行
    SELECT  `global_seller_id`,
            `shop_latest_dominant_advertiser_id`,
            `sales_team_naap`,
            `top_category_name`,
            CASE
                WHEN `top_category_name` IN ('Pre-Owned', 'Collectibles') THEN 'CP'
                ELSE 'non-CP'
            END AS `cp_flag`
    FROM    (
                SELECT  `global_seller_id`,
                        `shop_latest_dominant_advertiser_id`,
                        `sales_team_naap`,
                        `top_category_name`,
                        `daily_revenue`,
                        ROW_NUMBER() OVER (
                            PARTITION BY
                                    `global_seller_id`
                            ORDER BY
                                    `daily_revenue` DESC
                        ) AS `rn`
                FROM    facade_qe_tmp_table.auction_shop_id_match_naap_sales_team_n
            ) t
    WHERE   `rn`=1
),
auction AS (
    SELECT  global_seller_id,
            global_seller_name,
            -- 使用 substr 截取前6位，直接得到 yyyyMM
            substr(date, 1, 6) AS date_month,
            if(
                min(is_old_auction_seller)>0,
                'old_acution_seller',
                'new_acution_seller'
            ) AS is_month_old_auction_seller,
            CAST(
                COALESCE(
                    SUM(cl_pay_live_gmv_1d),
                    CAST(0 AS DECIMAL(38, 6))
                ) AS DECIMAL(38, 6)
            ) AS ttl_cl_pay_live_gmv_1d,
            CAST(
                COALESCE(
                    SUM(cl_pay_auction_gmv_1d),
                    CAST(0 AS DECIMAL(38, 6))
                ) AS DECIMAL(38, 6)
            ) AS ttl_cl_pay_auction_gmv_1d,
            CAST(
                COALESCE(
                    SUM(tts_paid_total_gmv_1d),
                    CAST(0 AS DECIMAL(38, 6))
                ) AS DECIMAL(38, 6)
            ) AS ttl_tts_paid_total_gmv_1d,
            coalesce(sum(ec_live_watch_cnt), 0) AS ttl_ec_live_watch_cnt,
            coalesce(sum(ec_live_auction_watch_cnt), 0) AS ttl_ec_live_auction_watch_cnt,
            coalesce(sum(ecom_live_onlive_live_cnt_1d), 0) AS ttl_ecom_live_onlive_live_cnt_1d,
            coalesce(sum(ecom_live_auction_onlive_live_cnt_1d), 0) AS ttl_ecom_live_auction_onlive_live_cnt_1d,
            CAST(
                COALESCE(
                    SUM(temp_listing_cl_pay_gmv_1d),
                    CAST(0 AS DECIMAL(38, 6))
                ) AS DECIMAL(38, 6)
            ) AS ttl_temp_listing_cl_pay_gmv_1d,
            coalesce(sum(ecom_live_temp_listing_onlive_live_cnt_1d), 0) AS ttl_ecom_live_temp_listing_onlive_live_cnt_1d,
            coalesce(sum(temp_listing_create_today_product_cnt), 0) AS ttl_temp_listing_create_today_product_cnt,
            coalesce(sum(temp_listing_product_cnt), 0) AS ttl_temp_listing_product_cnt,
            coalesce(sum(temp_listing_sold_product_cnt), 0) AS ttl_temp_listing_sold_product_cnt,
            CAST(
                COALESCE(
                    SUM(multi_sku_auction_cl_pay_usd_pay_amt_1d),
                    CAST(0 AS DECIMAL(38, 6))
                ) AS DECIMAL(38, 6)
            ) AS ttl_multi_sku_auction_cl_pay_usd_pay_amt_1d,
            coalesce(sum(multi_sku_auction_product_cnt), 0) AS ttl_multi_sku_auction_product_cnt,
            coalesce(sum(multi_sku_auction_sku_cnt), 0) AS ttl_multi_sku_auction_sku_cnt
    FROM    ecom.app_solution_auction_seller_day_global
    WHERE   date BETWEEN '20260101' AND '20260605'
    GROUP BY
            global_seller_id,
            global_seller_name,
            -- GROUP BY 里也要改成 substr
            substr(date, 1, 6)
)
SELECT  a.*,
        s.global_seller_id AS matched_global_seller_id,
        s.shop_latest_dominant_advertiser_id,
        s.sales_team_naap,
        s.top_category_name,
        s.cp_flag,
        CASE
            WHEN s.global_seller_id IS NOT NULL THEN 'US'
            ELSE 'US non NAAP'
        END AS naap_region
FROM    auction a
LEFT JOIN
        sales s
ON      CAST(a.global_seller_id AS STRING)=CAST(s.global_seller_id AS STRING)