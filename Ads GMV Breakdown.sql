WITH shop_base AS (
    -- A. 店铺池（先筛SEA + 时间）
    SELECT
        p_date,
        shop_id,
        payment_1d,
        video_payment_1d,
        live_payment_1d,
        ads_manager_ads_gmv_1d,
        nonug_roi2_strict_direct_ads_gmv_1d,
        nonug_roi1_ads_direct_gmv_1d
    FROM ad_dm.dm_vertical_shop_tag_df_utc0
    WHERE (
            p_date BETWEEN '20250401' AND '20250430'
         OR p_date BETWEEN '20260401' AND '20260430'
          )
      AND operation_country IN ('MY','PH','VN','TH','SG','ID')
),

session_shop_adv AS (
    -- B. session按 店+日+广告主 聚合（脏数据剔除）
    SELECT
        p_date,
        shop_id,
        advertiser_id,
        SUM(total_gmv) AS total_gmv,
        SUM(pseudo_direct_ads_gmv_lift) AS pseudo_direct_ads_gmv_lift,
        SUM(normal_ads_direct_gmv) AS normal_ads_direct_gmv
    FROM ad_dm.dm_shop_m10n_gmv_max_session_stats_adv_timezone_di_utc0
    WHERE (
            p_date BETWEEN '20250401' AND '20250430'
         OR p_date BETWEEN '20260401' AND '20260430'
          )
      AND is_dirty_data = 0
    GROUP BY
        p_date, shop_id, advertiser_id
),

shop_adv_top1 AS (
    -- C. 每个 店+日 取 total_gmv 最大 advertiser（并列按advertiser_id升序）
    SELECT
        p_date,
        shop_id,
        advertiser_id,
        pseudo_direct_ads_gmv_lift,
        normal_ads_direct_gmv,
        total_gmv
    FROM (
        SELECT
            p_date,
            shop_id,
            advertiser_id,
            pseudo_direct_ads_gmv_lift,
            normal_ads_direct_gmv,
            total_gmv,
            ROW_NUMBER() OVER (
                PARTITION BY p_date, shop_id
                ORDER BY total_gmv DESC, advertiser_id ASC
            ) AS rn
        FROM session_shop_adv
    ) t
    WHERE rn = 1
),

adv_owner AS (
    -- D. adv维度owner（不做MAX，按原始值去重）
    SELECT DISTINCT
        p_date,
        advertiser_id,
        owner_gbs_direct_first_split_sea
    FROM ad_dim.dim_crm_apac_cdl_advertiser_df_utc0
    WHERE (
            p_date BETWEEN '20250401' AND '20250430'
         OR p_date BETWEEN '20260401' AND '20260430'
          )
),

shop_owner_map AS (
    -- E. 先得到“店+日 -> owner/sales_team”映射关系（这是关键）
    SELECT
        t.p_date,
        t.shop_id,
        t.advertiser_id,
        a.owner_gbs_direct_first_split_sea,
        CASE
            WHEN a.owner_gbs_direct_first_split_sea = 'SMB' THEN 'Self Serve'
            WHEN a.owner_gbs_direct_first_split_sea = 'CNOB' THEN 'CNOB'
            WHEN a.owner_gbs_direct_first_split_sea IN (
                'MY','PH','VN','TH','SG','ID',
                'Strategic Accounts','SEA-Others','Marketplace'
            ) THEN 'ENT'
            ELSE 'Others'
        END AS sales_team,
        t.pseudo_direct_ads_gmv_lift,
        t.normal_ads_direct_gmv,
        t.total_gmv
    FROM shop_adv_top1 t
    LEFT JOIN adv_owner a
      ON t.p_date = a.p_date
     AND t.advertiser_id = a.advertiser_id
)

-- F. 再拿映射关系与shop信息聚合
SELECT
    m.p_date,
    m.sales_team,
    SUM(s.payment_1d) AS payment_1d,
    SUM(s.video_payment_1d) AS video_payment_1d,
    SUM(s.live_payment_1d) AS live_payment_1d,
    SUM(s.ads_manager_ads_gmv_1d) AS ads_manager_ads_gmv_1d,
    SUM(s.nonug_roi2_strict_direct_ads_gmv_1d) AS nonug_roi2_strict_direct_ads_gmv_1d,
    SUM(s.nonug_roi1_ads_direct_gmv_1d) AS nonug_roi1_ads_direct_gmv_1d,
    SUM(m.pseudo_direct_ads_gmv_lift) AS pseudo_direct_ads_gmv_lift,
    SUM(m.normal_ads_direct_gmv) AS normal_ads_direct_gmv,
    SUM(m.total_gmv) AS total_gmv
FROM shop_owner_map m
JOIN shop_base s
  ON m.p_date = s.p_date
 AND m.shop_id = s.shop_id
WHERE m.sales_team IN ('CNOB','Self Serve','ENT')
GROUP BY
    m.p_date, m.sales_team
ORDER BY
    m.p_date, m.sales_team;