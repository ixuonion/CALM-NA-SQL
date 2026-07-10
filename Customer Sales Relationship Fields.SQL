------ Customer Sales Relationship Fields
---- Structure
-- Source: NAAP Fields.sql
-- Purpose: collect customer/sales relationship fields in one file.
-- Current source structure: Dataset -> Field Type -> Field Name -> SQL expression.
-- This file keeps the same structure and extracts fields mainly from Sales Team Breakdown / Sale Team Breakdown.

---- Outline
-- 1. Overall Structure
--    1) Dataset section: starts with "------", matching the dataset name in NAAP Fields.sql.
--    2) Field type section: starts with "----", currently focused on Sales Team Breakdown / Sale Team Breakdown.
--    3) Field definition: starts with "--", followed by the SQL expression used in the BI calculated field.
--
-- 2. Field Categories
--    1) Region mapping fields:
--       - NAAP Region
--       - NAAP Region (shop_operation_country_code)
--    2) Sales ownership / customer-sales relationship fields:
--       - Region Breakdown by OB/KA/SMB [Latest]
--       - Region Breakdown by OB/KA/SMB [Daily Latest]
--    3) CNOB department mapping fields:
--       - CNOB SN3 Department
--
-- 3. Dataset Coverage
--    1) NAAP Team X Shop TTS Dataset (Full Snapshot)
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--    2) CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)
--       - CNOB SN3 Department
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Daily Latest]
--    3) Shop M10n GMV Max Session Stat(Adv timezone,TikTok&Pangle&Toko)
--       - CNOB SN3 Department
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--    4) [AC,Joined] Product Commission Setup (UTC0, Global)
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--    5) NAAP_TTS_Shop Ads Product Dataset (utc0, incremental)
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--    6) Video Product Material(UTC0,Global)
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--    7) Shop M10n Shop Perspective Pro (UTC0,Global,TikTok&Pangle&Toko端)
--       - NAAP Region (shop_operation_country_code)
--       - NAAP Region
--       - Region Breakdown by OB/KA/SMB [Latest]
--
-- 4. Maintenance Notes
--    1) When adding a new customer-sales relationship field, place it under the matching dataset and Sales Team Breakdown section.
--    2) If the same field exists in multiple datasets, keep each dataset-specific version because source columns can differ.

------ NAAP Team X Shop TTS Dataset (Full Snapshot)
---- Sales Team Breakdown
-- NAAP Region
CASE
  WHEN shop_operation_region='EU' THEN (
    case
      when `shop_operation_country`='GB' then 'UK'
      when `shop_operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN shop_operation_region='LATAM' THEN (
    case
      when `shop_operation_country`='BR' then 'BR'
      when `shop_operation_country`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE shop_operation_region
end

-- Region Breakdown by OB/KA/SMB [Latest]
case
  when [operation_region]='US' then (
    CASE
      WHEN `latest_owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
      WHEN `latest_owner_calm_direct_first_split_sea`='KR' THEN 'KROB'
      WHEN `latest_owner_calm_direct_first_split_sea`='Scaled Growth' THEN 'Self Serve'
      WHEN `latest_owner_calm_direct_first_split_sea` IN('NA-Others','NA-Non Comm-L&S','NA-Non Comm-A&G','NA-Comm-Retail','NA-Comm-CPG','NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END
  )
  when [operation_region]='SEA' then (
    case
      when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
      when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
      when `latest_owner_calm_direct_first_split_sea` in('MY','PH','VN','TH','SG','ID') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when `latest_owner_calm_direct_first_split_sea`='JP' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when `latest_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `latest_owner_calm_direct_first_split_sea` in ('Brazil','KA') then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `latest_owner_calm_direct_first_split_sea`in('Mexico','KA') then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `latest_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

------ CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)
---- Sales Team Breakdown
-- CNOB SN3 Department
case
  when `this_year_cnob_direct_dept_short_name_l1` like '%Fashion%' then '电综Fashion'
  when `this_year_cnob_direct_dept_short_name_l1` like '%Beauty%' then '电综Beauty'
  when `this_year_cnob_direct_dept_short_name_l1` like '%Elec%' then '电综CE'
  when `this_year_cnob_direct_dept_short_name_l1` like '%Lifestyle%' then '电综Lifestyle'
  when `this_year_cnob_direct_dept_short_name_l1` like '%Lifestyle%' then '电综Lifestyle'
  When `this_year_cnob_direct_dept_short_name_l1` like '%FMCG%' then '电综FMCG'
  else 'Others'
end

-- NAAP Region
CASE
  WHEN shop_operation_region='EU' THEN (
    case
      when `shop_operation_country`='GB' then 'UK'
      when `shop_operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN shop_operation_region='LATAM' THEN (
    case
      when `shop_operation_country`='BR' then 'BR'
      when `shop_operation_country`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE shop_operation_region
end


-- Region Breakdown by OB/KA/SMB [Daily Latest]
case
  when [Operation Region]='US' then (
    CASE
      WHEN this_year_owner_calm_direct_first_split_sea='CNOB' THEN 'CNOB'
      WHEN this_year_owner_calm_direct_first_split_sea='KR' THEN 'KROB'
      WHEN this_year_owner_calm_direct_first_split_sea='Scaled Growth' THEN 'Self Serve'
      WHEN this_year_owner_calm_direct_first_split_sea IN('NA-Others','NA-Non Comm-L&S','NA-Non Comm-A&G','NA-Comm-Retail','NA-Comm-CPG','NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END
  )
  when [Operation Region]='SEA' then (
    case
      when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
      when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
      when  this_year_owner_calm_direct_first_split_sea in('MY','PH','VN','TH','SG','ID') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when this_year_owner_calm_direct_first_split_sea='JP' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when this_year_owner_calm_direct_first_split_sea='EUI' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when this_year_owner_calm_direct_first_split_sea='Brazil' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when this_year_owner_calm_direct_first_split_sea='Mexico' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when this_year_owner_calm_direct_first_split_sea='EUI' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='Scaled Growth' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

------ Shop M10n GMV Max Session Stat(Adv timezone,TikTok&Pangle&Toko)
---- Sales Team Breakdown
-- CNOB SN3 Department
case
  when `direct_sales_department_name` like '%Fashion%' then '电综Fashion'
  when `direct_sales_department_name` like '%Beauty%' then '电综Beauty'
  when `direct_sales_department_name` like '%Elec%' then '电综CE'
  when `direct_sales_department_name` like '%Lifestyle%' then '电综Lifestyle'
  when `direct_sales_department_name` like '%Lifestyle%' then '电综Lifestyle'
  When `direct_sales_department_name` like '%FMCG%' then '电综FMCG'
  else 'Others'
end

-- NAAP Region
CASE
  WHEN [operation_region] = 'EU' AND `shop_operation_country` = 'GB' THEN 'UK'
  WHEN [operation_region] = 'EU' AND `shop_operation_country` IN ('DE', 'IT', 'ES', 'FR', 'IE') THEN 'EU_OTHERS'
  WHEN [operation_region] = 'LATAM' AND `shop_operation_country` = 'BR' THEN 'BR'
  WHEN [operation_region] = 'LATAM' AND `shop_operation_country` = 'MX' THEN 'MX'
  WHEN [operation_region] = 'LATAM' THEN 'LATAM_OTHERS'
  ELSE [operation_region]
END

-- Region Breakdown by OB/KA/SMB [Latest]
CASE
  WHEN [operation_region] = 'US' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` = 'KR' THEN 'KROB'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` IN ('NA-Others', 'NA-Non Comm-L&S', 'NA-Non Comm-A&G', 'NA-Comm-Retail', 'NA-Comm-CPG', 'NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END

  WHEN [operation_region] = 'SEA' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` IN ('MY', 'PH', 'VN', 'TH', 'SG', 'ID') THEN 'ENT'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'JP' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'JP' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` IN ('GB', 'DE', 'IT', 'ES', 'FR', 'IE') THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'EUI' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'BR' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Brazil', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'MX' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Mexico', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  ELSE 'Others'
END

------ [AC,Joined] Product Commission Setup (UTC0, Global)
---- Sales Team Breakdown
-- NAAP Region
CASE
  WHEN [shop_operation_region]='EU' THEN (
    case
      when `operation_country`='GB' then 'UK'
      when `operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN [shop_operation_region]='LATAM' THEN (
    case
      when `operation_country`='BR' then 'BR'
      when `operation_country`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE [shop_operation_region]
end

-- Region Breakdown by OB/KA/SMB [Latest]
CASE
  WHEN [shop_operation_region] = 'US' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` = 'KR' THEN 'KROB'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` IN ('NA-Others', 'NA-Non Comm-L&S', 'NA-Non Comm-A&G', 'NA-Comm-Retail', 'NA-Comm-CPG', 'NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END

  WHEN [shop_operation_region] = 'SEA' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` IN ('MY', 'PH', 'VN', 'TH', 'SG', 'ID') THEN 'ENT'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'JP' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'JP' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` IN ('GB', 'DE', 'IT', 'ES', 'FR', 'IE') THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'EUI' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'BR' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Brazil', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'MX' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Mexico', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  ELSE 'Others'
END

------ NAAP_TTS_Shop Ads Product Dataset (utc0, incremental)
---- Sales Team Breakdown
-- NAAP Region
CASE
  WHEN [shop_operation_region]='EU' THEN (
    case
      when `shop_operation_country`='GB' then 'UK'
      when `shop_operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN [shop_operation_region]='LATAM' THEN (
    case
      when `shop_operation_country`='BR' then 'BR'
      when `shop_operation_country`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE [shop_operation_region]
end

-- Region Breakdown by OB/KA/SMB [Latest]
case
  when [shop_operation_region]='US' then (
      CASE
        WHEN [Latest Direct First Country Split SEA]='CNOB' THEN 'CNOB'
        WHEN [Latest Direct First Country Split SEA]='KR' THEN 'KROB'
        WHEN [Latest Direct First Country Split SEA]='Scaled Growth' THEN 'Self Serve'
        WHEN [Latest Direct First Country Split SEA] IN('NA-Others','NA-Non Comm-L&S','NA-Non Comm-A&G','NA-Comm-Retail','NA-Comm-CPG','NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END
  )
  when [shop_operation_region]='SEA' then (
      case
        when [Latest Direct First Country Split SEA]='Scaled Growth' then 'Self Serve'
      when [Latest Direct First Country Split SEA]='CNOB' then 'CNOB'
        when [Latest Direct First Country Split SEA] in('MY','PH','VN','TH','SG','ID') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `shop_operation_country`='JP' then (
        case
          when [Latest Direct First Country Split SEA]='JP' then 'ENT'
            when [Latest Direct First Country Split SEA]='Scaled Growth' then 'Self Serve'
          when [Latest Direct First Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='GB' then (
        case
          when [Latest Direct First Country Split SEA]='EUI' then 'ENT'
            when [Latest Direct First Country Split SEA]='Scaled Growth' then 'Self Serve'
          when [Latest Direct First Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='BR' then (
        case
          when [Latest Direct First Country Split SEA]='BR' then 'ENT'
            when [Latest Direct First Country Split SEA]='Scaled Growth' then 'Self Serve'
          when [Latest Direct First Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='MX' then (
        case
          when [Latest Direct First Country Split SEA]='MX' then 'ENT'
            WHEN [Latest Direct First Country Split SEA]='Scaled Growth' THEN 'Self Serve'
          WHEN [Latest Direct First Country Split SEA]='CNOB' THEN 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when [Latest Direct First Country Split SEA]='EUI' then 'ENT'
            when [Latest Direct First Country Split SEA]='Scaled Growth' then 'Self Serve'
          when [Latest Direct First Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

------ Video Product Material(UTC0,Global)
---- Sales Team Breakdown
-- NAAP Region
CASE
  when `shop_operation_country`='GB' then 'UK'
  when `shop_operation_country` IN('MY','VN','TH','SG','ID','PH') then 'SEA'
  when `shop_operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
  when `shop_operation_country`='JP' then 'JP'
  when `shop_operation_country`='MX' then 'MX'
  when `shop_operation_country`='BR' then 'BR'
  when `shop_operation_country`='US' then 'US'
  ELSE 'Others'
end

-- Region Breakdown by OB/KA/SMB [Latest]
-- *Unconfirmed due to lack of permission
case
  when `shop_operation_country`='US' then (
      CASE
        WHEN `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
        WHEN `dominant_adv_owner_calm_direct_first_split_sea`='KR' THEN 'KROB'
        WHEN `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' THEN 'Self Serve'
        WHEN `dominant_adv_owner_calm_direct_first_split_sea` IN('NA-Others','NA-Non Comm-L&S','NA-Non Comm-A&G','NA-Comm-Retail','NA-Comm-CPG','NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END
  )
  when `shop_operation_country` IN('MY','VN','TH','SG','ID','PH') then (
      case
        when `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
      when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
        when `dominant_adv_owner_calm_direct_first_split_sea` IN('MY','VN','TH','SG','ID') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `shop_operation_country`='JP' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='JP' then 'ENT'
            when `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='GB' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
            when `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='BR' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='BR' then 'ENT'
            when `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='MX' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='MX' then 'ENT'
            WHEN `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' THEN 'Self Serve'
          WHEN `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
            when `dominant_adv_owner_calm_direct_first_split_sea`='Scaled Growth' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

------ Shop M10n Shop Perspective Pro (UTC0,Global,TikTok&Pangle&Toko端)
---- Sale Team Breakdown
-- NAAP Region (shop_operation_country_code)
CASE
  WHEN [operation_region]='EU' THEN (
    case
      when `shop_operation_country_code`='GB' then 'UK'
      when `shop_operation_country_code` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN [operation_region]='LATAM' THEN (
    case
      when `shop_operation_country_code`='BR' then 'BR'
      when `shop_operation_country_code`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE [operation_region]
end

-- NAAP Region
CASE
  WHEN [operation_region]='EU' THEN (
    case
      when `shop_operation_country`='GB' then 'UK'
      when `shop_operation_country` IN('DE', 'IT', 'ES', 'FR', 'IE') then 'EU_others'
      else 'Others'
    end
  )
  WHEN [operation_region]='LATAM' THEN (
    case
      when `shop_operation_country`='BR' then 'BR'
      when `shop_operation_country`='MX' then 'MX'
      else 'LATAM-Others'
    end
  )
  ELSE [operation_region]
end

-- Region Breakdown by Sales Team with CNOB (Direct, Latest)
case
  when [Sales Team with CNOB(Direct,Latest)]='SMB Team'
  and [operation_country] in(
    'VN',
    'FR',
    'TH',
    'BR',
    'MX',
    'SG',
    'IT',
    'IE',
    'GB',
    'ES',
    'DE',
    'PH',
    'MY',
    'ID',
    'JP',
    'US'
  ) then 'Self Serve'
  when [Sales Team with CNOB(Direct,Latest)]='CNOB Team'
  and [operation_country] in(
    'JP',
    'VN',
    'TH',
    'US',
    'SG',
    'PH',
    'MY',
    'MX',
    'ID',
    'BR',
    'DE',
    'FR',
    'IE',
    'ES',
    'IT',
    'GB'
  ) then 'CNOB'
  when [Sales Team with CNOB(Direct,Latest)]='NA Team'
  and [operation_country]='US' then 'NA-US'
  when [Sales Team with CNOB(Direct,Latest)]='LATAM Team'
  and [operation_country] in('MX', 'BR') then 'ENT'
  when [Sales Team with CNOB(Direct,Latest)]='EUI Team'
  and [operation_country] in('ES', 'IT', 'IE', 'DE', 'FR', 'GB') then 'ENT'
  when [Sales Team with CNOB(Direct,Latest)]='APAC Team(excl. CNOB)'
  and [operation_country]='US' then (
    case
      when [perf_direct_sales_department_4_name_latest]like '%KR%' then 'KROB'
      else 'Others'
    end
  )
  when [Sales Team with CNOB(Direct,Latest)]='APAC Team(excl. CNOB)'
  and [operation_country] in('VN', 'TH', 'SG', 'PH', 'MY', 'ID') then (
    case
      when [perf_direct_sales_department_4_name_latest] like '%SEA%' then 'ENT'
      else 'Others'
    end
  )
  when [Sales Team with CNOB(Direct,Latest)]='APAC Team(excl. CNOB)'
  and [operation_country]='JP' then (
    case
      when [perf_direct_sales_department_4_name_latest] like '%JP%' then 'ENT'
      else 'Others'
    end
  )
  else 'Others'
end

------ Shop M10n Shop Perspective Pro (UTC0,Global,TikTok&Pangle&Toko端)
---- Sale Team Breakdown
-- Region Breakdown by OB/KA/SMB [Latest]
CASE
  WHEN `shop_operation_region` = 'US' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` = 'KR' THEN 'KROB'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` IN ('NA-Others', 'NA-Non Comm-L&S', 'NA-Non Comm-A&G', 'NA-Comm-Retail', 'NA-Comm-CPG', 'NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END

  WHEN `shop_operation_region` = 'SEA' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` IN ('MY', 'PH', 'VN', 'TH', 'SG', 'ID') THEN 'ENT'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'JP' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'JP' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` IN ('GB', 'DE', 'IT', 'ES', 'FR', 'IE') THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'EUI' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'BR' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Brazil', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `shop_operation_country` = 'MX' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Mexico', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END
  ELSE 'Others'
END

---- NAAP Advertising CreativeID DailyIncremental Dataset
-- Region Breakdown by OB/KA/SMB [Latest]
CASE
  WHEN [Operation Region] = 'US' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` = 'KR' THEN 'KROB'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` IN ('NA-Others', 'NA-Non Comm-L&S', 'NA-Non Comm-A&G', 'NA-Comm-Retail', 'NA-Comm-CPG', 'NA-CA') THEN 'NA-US'
      ELSE 'Others'
    END

  WHEN [Operation Region] = 'SEA' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea` IN ('MY', 'PH', 'VN', 'TH', 'SG', 'ID') THEN 'ENT'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'JP' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'JP' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` IN ('GB', 'DE', 'IT', 'ES', 'FR', 'IE') THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` = 'EUI' THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'BR' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Brazil', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END

  WHEN `operation_country` = 'MX' THEN
    CASE
      WHEN `owner_calm_direct_first_split_sea` IN ('Mexico', 'ENT') THEN 'ENT'
      WHEN `owner_calm_direct_first_split_sea` = 'Scaled Growth' THEN 'Self Serve'
      WHEN `owner_calm_direct_first_split_sea` = 'CNOB' THEN 'CNOB'
      ELSE 'Others'
    END
  ELSE 'Others'
END