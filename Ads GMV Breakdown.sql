-- SQL 性能优化
set tqs.pbo.overwrite.enabled=false;

--基础资源
set spark.driver.memory=20g;
set spark.driver.cores=4;
set spark.executor.memory=60g;
set spark.executor.memoryOverhead=10g;
set spark.executor.cores=4;
set spark.vcore.boost.ratio=1;

--动态executor申请
set spark.dynamicAllocation.minExecutors=5;
set spark.dynamicAllocation.maxExecutors=1500;

-- AQE
set spark.sql.shuffle.partitions = 400;
set spark.sql.adaptive.enabled=true;
set spark.shuffle.statistics.verbose=true;
set spark.sql.adaptive.skewedJoin.enabled=true;
set spark.sql.adaptive.forceOptimizeSkewedJoin=true;

WITH shop_base AS (
    -- A. 店铺池（先筛SEA + 时间）
    SELECT  p_date,
            shop_id,
            payment_1d,
            video_payment_1d,
            live_payment_1d,
            ads_manager_ads_gmv_1d,
            nonug_roi2_strict_direct_ads_gmv_1d,
            nonug_roi1_ads_direct_gmv_1d
    FROM    ad_dm.dm_vertical_shop_tag_df_utc0
    WHERE   (
                p_date BETWEEN '20250329' AND '20250509'
                OR p_date BETWEEN '20260329' AND '20260509'
            )
    AND     operation_country IN ('MY', 'PH', 'VN', 'TH', 'SG', 'ID')
),
advid_naap AS (
    SELECT  advertiser_id,
            (
                CASE WHEN owner_gbs_direct_first_split_sea = 'SMB' THEN 'Self Serve'
                     WHEN owner_gbs_direct_first_split_sea = 'CNOB' THEN 'CNOB'
                     WHEN owner_gbs_direct_first_split_sea IN(
                         'MY',
                         'PH',
                         'VN',
                         'TH',
                         'SG',
                         'ID',
                         'Strategic Accounts',
                         'SEA-Others',
                         'Marketplace'
                     ) THEN 'ENT'
                     ELSE 'Others'
                END
            ) AS sales_team
    FROM    ad_dim.dim_crm_apac_cdl_advertiser_df_utc0
    WHERE   p_date = '${date}'
    AND     is_apac_today = 1
),
session_shop_adv AS (
    -- B. session按 店+日+广告主 聚合（脏数据剔除）
    SELECT  p_date,
            shop_id,
            session.advertiser_id,
            advid_naap.sales_team,
            SUM(total_gmv) AS total_gmv,
            SUM(pseudo_direct_ads_gmv_lift) AS pseudo_direct_ads_gmv_lift,
            SUM(normal_ads_direct_gmv) AS normal_ads_direct_gmv
    FROM    ad_dm.dm_shop_m10n_gmv_max_session_stats_adv_timezone_di_utc0 session
    LEFT JOIN
            advid_naap
    ON      advid_naap.advertiser_id = session.advertiser_id
    WHERE   (
                session.p_date BETWEEN '20250329' AND '20250509'
                OR session.p_date BETWEEN '20260329' AND '20260509'
            )
    AND     session.is_dirty_data = 0
    AND     session.advertiser_id IN (
                SELECT  advid_naap.advertiser_id
                FROM    advid_naap
            )
    GROUP BY
            p_date,
            shop_id,
            session.advertiser_id,
            advid_naap.sales_team
),
session_shop_adv_grouped AS (
    SELECT  p_date,
            shop_id,
            sales_team,
            SUM(pseudo_direct_ads_gmv_lift) AS pseudo_direct_ads_gmv_lift,
            SUM(normal_ads_direct_gmv) AS normal_ads_direct_gmv
    FROM    session_shop_adv
    GROUP BY
            p_date,
            shop_id,
            sales_team
)
SELECT  shop_base.p_date,
        session_shop_adv_grouped.sales_team,
        SUM(shop_base.payment_1d) AS payment_1d,
        SUM(shop_base.nonug_roi2_strict_direct_ads_gmv_1d) + SUM(shop_base.nonug_roi1_ads_direct_gmv_1d) AS ads_GMV,
        SUM(shop_base.nonug_roi2_strict_direct_ads_gmv_1d) AS nonug_roi2_strict_direct_ads_gmv_1d,
        SUM(shop_base.nonug_roi1_ads_direct_gmv_1d) AS nonug_roi1_ads_direct_gmv_1d,
        SUM(session_shop_adv_grouped.pseudo_direct_ads_gmv_lift) / 100000 AS pseudo_direct_ads_gmv_lift,
        SUM(session_shop_adv_grouped.normal_ads_direct_gmv) / 100000 AS normal_ads_direct_gmv,
        (
            SUM(shop_base.payment_1d) - (
                SUM(shop_base.nonug_roi2_strict_direct_ads_gmv_1d) + SUM(shop_base.nonug_roi1_ads_direct_gmv_1d)
            )
        ) + (
            SUM(shop_base.nonug_roi2_strict_direct_ads_gmv_1d) - (SUM(session_shop_adv_grouped.pseudo_direct_ads_gmv_lift) / 100000) - SUM(session_shop_adv_grouped.normal_ads_direct_gmv) / 100000
        ) AS organic_GMV,
        (
            (SUM(session_shop_adv_grouped.normal_ads_direct_gmv) / 100000) + SUM(shop_base.nonug_roi1_ads_direct_gmv_1d)
        ) AS ads_only_GMV
FROM    shop_base
LEFT JOIN
        session_shop_adv_grouped
ON      shop_base.p_date = session_shop_adv_grouped.p_date
AND     shop_base.shop_id = session_shop_adv_grouped.shop_id
GROUP BY
        shop_base.p_date,
        session_shop_adv_grouped.sales_team