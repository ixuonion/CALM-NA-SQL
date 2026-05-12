------ NAAP Team X Shop TTS Dataset (Full Snapshot)
---- PGM/LGM Rev & GMV Shares
-- PGM GMV Share
sum(
  (
    `pgmax_total_gmv`-[pgmax_onsite_subtotal_deduction_platform_usd]
  )+(
    case
      when [shop_operation_country]='US' then 0
      else [pgmax_onsite_tax_amount_usd]
    end
  )
)/sum(`video_gmv`+`product_gmv`)

-- LGM GMV Share
sum(
  (
    `lgmax_total_gmv`-[lgmax_onsite_subtotal_deduction_platform_usd]
  )+(
    case
      when [shop_operation_country]='US' then 0
      else [lgmax_onsite_tax_amount_usd]
    end
  )
)/sum(`live_gmv`)

-- PGM Rev Share & LGM Rev Share
-- Table can not devided by content type (Delivery Type / Ads or Content Type / Organic), So if needed plz refer to table CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)
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
      WHEN `latest_owner_calm_direct_first_split_sea`='SMB' THEN 'Self Serve'
      WHEN `latest_owner_calm_direct_first_split_sea` IN('NA-US', 'NA-Canada', 'NA-Others') THEN 'NA-US'
      WHEN `latest_owner_calm_direct_first_split_sea`='NA-SMB' THEN 'NA-SMB'
      ELSE 'Others'
    END
  )
  when [operation_region]='SEA' then (
    case
      when `latest_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
      when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
      when `latest_owner_calm_direct_first_split_sea` in('MY','PH','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when `latest_owner_calm_direct_first_split_sea`='JP' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'  
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when `latest_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `latest_owner_calm_direct_first_split_sea` in ('Brazil','KA') then 'ENT' 
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `latest_owner_calm_direct_first_split_sea`in('Mexico','KA') then 'ENT' 
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `latest_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
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
      WHEN this_year_owner_calm_direct_first_split_sea='SMB' THEN 'Self Serve'
      WHEN this_year_owner_calm_direct_first_split_sea IN('NA-US', 'NA-Canada', 'NA-Others') THEN 'NA-US'
      WHEN this_year_owner_calm_direct_first_split_sea='NA-SMB' THEN 'NA-SMB'
      ELSE 'Others'
    END
  )
  when [Operation Region]='SEA' then (
    case
      when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
      when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
      when  this_year_owner_calm_direct_first_split_sea in('MY','PH','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when this_year_owner_calm_direct_first_split_sea='JP' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when this_year_owner_calm_direct_first_split_sea='EUI' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when this_year_owner_calm_direct_first_split_sea='Brazil' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when this_year_owner_calm_direct_first_split_sea='Mexico' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when this_year_owner_calm_direct_first_split_sea='EUI' then 'ENT'
          when this_year_owner_calm_direct_first_split_sea='SMB' then 'Self Serve'
          when this_year_owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

---- PGM/LGM Rev & GMV Shares
-- PGM Rev Share
sum(
  case
    WHEN [Delivery Type] in('product', 'video')
    OR [Content Type] in('product_card', 'video') then `payment_1d`
    else 0
  end
)/sum(`payment_1d`)

-- LGM Rev Share
sum(
  case
    WHEN [Delivery Type]='live'
    OR [Content Type]='live' then `payment_1d`
    else 0
  end
)/sum(`payment_1d`)

---- Products
-- Gmax/Non-Gmax
CASE WHEN [Shop Ads Product Type] like '%ROI2%' THEN [Shop Ads Product Type] ELSE 'ROI1' END



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

-- Region Breakdown by OB/KA/SMB [Latest]
case
  when [operation_region]='US' then (
    CASE
      WHEN owner_calm_direct_first_split_sea='CNOB' THEN 'CNOB'
      WHEN owner_calm_direct_first_split_sea='KR' THEN 'KROB'
      WHEN owner_calm_direct_first_split_sea='NA' THEN (
        case
          when [L2 Direct Salesteam Tag (Latest)] Like '%North America-SMB%' then 'NA-SMB'
          else 'KA'
        end
      )
      WHEN owner_calm_direct_first_split_sea IN('NA-US', 'NA-Canada', 'NA-Others') THEN 'NA-US'
      WHEN owner_calm_direct_first_split_sea='NA-SMB' THEN 'NA-SMB'
      WHEN owner_calm_direct_first_split_sea='SMB' THEN 'Self Serve'
      ELSE 'Others'
    END
  )
  when [operation_region]='SEA' then (
    case
      when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
      when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
      when `owner_gbs_direct_first_split_sea` in('MY','PH','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when `owner_gbs_direct_first_split_sea`='JP' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `owner_gbs_direct_first_split_sea` in('Brazil', 'ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `owner_gbs_direct_first_split_sea` in('Mexico', 'ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
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

-- Region Breakdown by OB/KA/SMB [Latest]
case
  when [operation_region]='US' then (
    CASE
      WHEN owner_calm_direct_first_split_sea='CNOB' THEN 'CNOB'
      WHEN owner_calm_direct_first_split_sea='KR' THEN 'KROB'
      WHEN owner_calm_direct_first_split_sea='NA' THEN (
        case
          when [L2 Direct Salesteam Tag (Latest)] Like '%North America-SMB%' then 'NA-SMB'
          else 'KA'
        end
      )
      WHEN owner_calm_direct_first_split_sea IN('NA-US', 'NA-Canada', 'NA-Others') THEN 'NA-US'
      WHEN owner_calm_direct_first_split_sea='NA-SMB' THEN 'NA-SMB'
      WHEN owner_calm_direct_first_split_sea='SMB' THEN 'Self Serve'
      ELSE 'Others'
    END
  )
  when [operation_region]='SEA' then (
    case
      when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
      when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
      when `owner_gbs_direct_first_split_sea` in('MY','PH','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when `owner_gbs_direct_first_split_sea`='JP' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `owner_gbs_direct_first_split_sea` in('Brazil', 'ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `owner_gbs_direct_first_split_sea` in('Mexico', 'ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

---- Promotion SEA
-- Promotion Calendar SEA [MAY26]
CASE shop_operation_country
  WHEN 'ID' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-09') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date = toDate('2026-02-02')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-22') AND toDate('2025-12-26')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-03') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-30')) THEN '11月Payday'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-12')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-25') AND toDate('2026-03-27')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-25') AND toDate('2025-09-29')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-01') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-25') AND toDate('2025-08-29')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-01') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-25') AND toDate('2025-07-29')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-23') AND toDate('2025-05-27')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-01') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-25') AND toDate('2025-06-28')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-23') AND toDate('2026-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-23') AND toDate('2025-04-25')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'MY' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-13')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-01') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-12') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-29') AND toDate('2025-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date BETWEEN toDate('2025-02-02') AND toDate('2025-02-04')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-27')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-24') AND toDate('2025-07-26')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-05') AND toDate('2025-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-26')) THEN '1月Payday'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'PH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-06') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-26') AND toDate('2025-12-30')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-23') AND toDate('2026-03-28')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-06') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-29') AND toDate('2025-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-05') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-27') AND toDate('2025-06-29')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-05') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-30')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-04') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-29') AND toDate('2025-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-07')) THEN '5月double day'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-30')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-01') AND toDate('2025-04-04')) THEN '4月double day'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-30')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-28') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-03')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-26') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-26') AND toDate('2025-02-28')) THEN '2月Payday'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-04') AND toDate('2026-05-07')) THEN '5月double day'
              WHEN (p_date = toDate('2026-05-01')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-26') AND toDate('2026-02-28')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'SG' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-03') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-10')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-12')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-26')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-03') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-26') AND toDate('2025-07-28')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-04') AND toDate('2025-12-14')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2026-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'TH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-06') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-25') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-05')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-28') AND toDate('2026-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-07') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-28') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-28') AND toDate('2025-10-31')) THEN '10月Payday'
              WHEN (p_date BETWEEN toDate('2025-10-07') AND toDate('2025-10-10')) THEN '10月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-31')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-06') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-28') AND toDate('2025-07-31')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-05') AND toDate('2025-07-07')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-03') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-28') AND toDate('2025-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-31')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-31')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-02') AND toDate('2025-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-28') AND toDate('2026-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-28') AND toDate('2025-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2025-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-08') AND toDate('2025-12-13')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-01') AND toDate('2026-02-03')) THEN '2月double day'
              WHEN (p_date IN (toDate('2026-02-27'), toDate('2026-02-28'))) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-06')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'VN' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-05') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-25') AND toDate('2025-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-04') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date IN (toDate('2025-11-24'), toDate('2025-11-25'))) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              WHEN (p_date IN (toDate('2026-04-24'), toDate('2026-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-07') AND toDate('2025-09-10')) THEN '9月double day'
              WHEN (p_date IN (toDate('2025-09-24'), toDate('2025-09-25'))) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-04') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date IN (toDate('2025-06-24'), toDate('2025-06-25'))) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-07') AND toDate('2025-08-09')) THEN '8月double day'
              WHEN (p_date IN (toDate('2025-08-24'), toDate('2025-08-25'))) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-04')) THEN '3月double day'
              WHEN (p_date IN (toDate('2025-03-24'), toDate('2025-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-03-24'), toDate('2026-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date IN (toDate('2025-10-24'), toDate('2025-10-25'))) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              WHEN (p_date IN (toDate('2025-07-24'), toDate('2025-07-25'))) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-06')) THEN '5月double day'
              WHEN (p_date IN (toDate('2025-05-24'), toDate('2025-05-25'))) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              WHEN (p_date IN (toDate('2025-04-24'), toDate('2025-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-24'), toDate('2025-02-25'))) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  ELSE '非大促'
END

------  [AC,Joined] Product Commission Setup (UTC0, Global)
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
case
  when [shop_operation_region]='US' then (
    CASE
      WHEN `owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
      WHEN `owner_calm_direct_first_split_sea`='KR' THEN 'KROB'
      WHEN `owner_calm_direct_first_split_sea` IN('NA-US', 'NA-Canada', 'NA-Others') THEN 'NA-US'
      WHEN `owner_calm_direct_first_split_sea`='NA-SMB' THEN 'NA-SMB'
      WHEN `owner_calm_direct_first_split_sea`='SMB' THEN 'Self Serve'
      ELSE 'Others'
    END
  )
  when [shop_operation_region]='SEA' then (
    case
      when `owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
      when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
      when `owner_calm_direct_first_split_sea` in('MY','PH','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `operation_country`='JP' then (
        case
          when `owner_calm_direct_first_split_sea`='JP' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='GB' then (
        case
          when `owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='BR' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Brazil','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='MX' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Mexico','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

---- Revenue & Cost
-- ACA Revenue Share% (Dual Commission Enabled Only)
sum(
  case
    when isNull(
      [public_contract_affiliate_commission_set_rate]
    )=0
    and isNull(
      [public_contract_ad_commission_rate]
    )=0 then [shop_dollar_cost_1d]
  end
)/sum([shop_dollar_cost_1d])

---- Promotion US
-- Promotion Calendar US

---- Promotion SEA
-- Promotion Calendar SEA [MAY26]
CASE shop_operation_country
  WHEN 'ID' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-09') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date = toDate('2026-02-02')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-22') AND toDate('2025-12-26')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-03') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-30')) THEN '11月Payday'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-12')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-25') AND toDate('2026-03-27')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-25') AND toDate('2025-09-29')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-01') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-25') AND toDate('2025-08-29')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-01') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-25') AND toDate('2025-07-29')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-23') AND toDate('2025-05-27')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-01') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-25') AND toDate('2025-06-28')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-23') AND toDate('2026-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-23') AND toDate('2025-04-25')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'MY' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-13')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-01') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-12') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-29') AND toDate('2025-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date BETWEEN toDate('2025-02-02') AND toDate('2025-02-04')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-27')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-24') AND toDate('2025-07-26')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-05') AND toDate('2025-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-26')) THEN '1月Payday'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'PH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-06') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-26') AND toDate('2025-12-30')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-23') AND toDate('2026-03-28')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-06') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-29') AND toDate('2025-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-05') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-27') AND toDate('2025-06-29')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-05') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-30')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-04') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-29') AND toDate('2025-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-07')) THEN '5月double day'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-30')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-01') AND toDate('2025-04-04')) THEN '4月double day'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-30')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-28') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-03')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-26') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-26') AND toDate('2025-02-28')) THEN '2月Payday'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-04') AND toDate('2026-05-07')) THEN '5月double day'
              WHEN (p_date = toDate('2026-05-01')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-26') AND toDate('2026-02-28')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'SG' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-03') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-10')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-12')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-26')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-03') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-26') AND toDate('2025-07-28')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-04') AND toDate('2025-12-14')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2026-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'TH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-06') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-25') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-05')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-28') AND toDate('2026-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-07') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-28') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-28') AND toDate('2025-10-31')) THEN '10月Payday'
              WHEN (p_date BETWEEN toDate('2025-10-07') AND toDate('2025-10-10')) THEN '10月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-31')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-06') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-28') AND toDate('2025-07-31')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-05') AND toDate('2025-07-07')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-03') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-28') AND toDate('2025-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-31')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-31')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-02') AND toDate('2025-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-28') AND toDate('2026-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-28') AND toDate('2025-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2025-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-08') AND toDate('2025-12-13')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-01') AND toDate('2026-02-03')) THEN '2月double day'
              WHEN (p_date IN (toDate('2026-02-27'), toDate('2026-02-28'))) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-06')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'VN' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-05') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-25') AND toDate('2025-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-04') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date IN (toDate('2025-11-24'), toDate('2025-11-25'))) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              WHEN (p_date IN (toDate('2026-04-24'), toDate('2026-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-07') AND toDate('2025-09-10')) THEN '9月double day'
              WHEN (p_date IN (toDate('2025-09-24'), toDate('2025-09-25'))) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-04') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date IN (toDate('2025-06-24'), toDate('2025-06-25'))) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-07') AND toDate('2025-08-09')) THEN '8月double day'
              WHEN (p_date IN (toDate('2025-08-24'), toDate('2025-08-25'))) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-04')) THEN '3月double day'
              WHEN (p_date IN (toDate('2025-03-24'), toDate('2025-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-03-24'), toDate('2026-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date IN (toDate('2025-10-24'), toDate('2025-10-25'))) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              WHEN (p_date IN (toDate('2025-07-24'), toDate('2025-07-25'))) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-06')) THEN '5月double day'
              WHEN (p_date IN (toDate('2025-05-24'), toDate('2025-05-25'))) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              WHEN (p_date IN (toDate('2025-04-24'), toDate('2025-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-24'), toDate('2025-02-25'))) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  ELSE '非大促'
END


---- NAAP_TTS_Shop Ads Product Dataset (utc0, incremental)
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
      WHEN [Latest Direct Country Split SEA]='CNOB' THEN 'CNOB'
      WHEN [Latest Direct Country Split SEA]='KR' THEN 'KROB'
      WHEN [Latest Direct Country Split SEA]='NA-US' THEN 'NA-US'
      WHEN [Latest Direct Country Split SEA]='NA-SMB' THEN 'NA-SMB'
      WHEN [Latest Direct Country Split SEA]='SMB' THEN 'Self Serve'
      ELSE 'Others'
    END
  )
  when [shop_operation_region]='SEA' then (
    case
      when [Latest Direct Country Split SEA]='SMB' then 'Self Serve'
      when [Latest Direct Country Split SEA]='CNOB' then 'CNOB'
      when [Latest Direct Country Split SEA] in('MY','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `shop_operation_country`='JP' then (
        case
          when [Latest Direct Country Split SEA]='JP' then 'ENT'
          when [Latest Direct Country Split SEA]='SMB' then 'Self Serve'
          when [Latest Direct Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='GB' then (
        case
          when [Latest Direct Country Split SEA]='EUI' then 'ENT'
          when [Latest Direct Country Split SEA]='SMB' then 'Self Serve'
          when [Latest Direct Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='BR' then (
        case
          when [Latest Direct Country Split SEA]='BR' then 'ENT'
          when [Latest Direct Country Split SEA]='SMB' then 'Self Serve'
          when [Latest Direct Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='MX' then (
        case
          when [Latest Direct Country Split SEA]='MX' then 'ENT'
          WHEN [Latest Direct Country Split SEA]='SMB' THEN 'Self Serve'
          WHEN [Latest Direct Country Split SEA]='CNOB' THEN 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when [Latest Direct Country Split SEA]='EUI' then 'ENT'
          when [Latest Direct Country Split SEA]='SMB' then 'Self Serve'
          when [Latest Direct Country Split SEA]='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

---- Promotion SEA
-- Promotion Calendar SEA -- Same as M10n Session in ROW 429


---- Shop Ads Adload Daily (UTC0,Global)_SG
-- Promotion Calendar SEA [MAY26]
CASE country_code
  WHEN 'ID' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-09') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date = toDate('2026-02-02')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-22') AND toDate('2025-12-26')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-03') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-30')) THEN '11月Payday'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-12')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-25') AND toDate('2026-03-27')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-25') AND toDate('2025-09-29')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-01') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-25') AND toDate('2025-08-29')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-01') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-25') AND toDate('2025-07-29')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-23') AND toDate('2025-05-27')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-01') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-25') AND toDate('2025-06-28')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-23') AND toDate('2026-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-23') AND toDate('2025-04-25')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'MY' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-18')) THEN '斋月 Ramadan P2'
              WHEN (p_date BETWEEN toDate('2025-03-19') AND toDate('2025-03-25')) THEN '斋月 Ramadan P3'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-04') AND toDate('2026-03-13')) THEN '3月Ramadan (Post D3)'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-01') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-24') AND toDate('2025-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-01') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-28')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-12') AND toDate('2026-02-28')) THEN '2月Ramadan (Pre D3)'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-01') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-29') AND toDate('2025-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-01') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-24') AND toDate('2025-02-28')) THEN '2月Payday/Ramadan P1'
              WHEN (p_date BETWEEN toDate('2025-02-02') AND toDate('2025-02-04')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-24') AND toDate('2026-04-27')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-24') AND toDate('2025-07-26')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-05') AND toDate('2025-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-26')) THEN '1月Payday'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-24') AND toDate('2025-01-26')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-01') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'PH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-06') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-26') AND toDate('2025-12-30')) THEN '12月Payday'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-23') AND toDate('2026-03-28')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-06') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-29') AND toDate('2025-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-05') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-02') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-27') AND toDate('2025-06-29')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-05') AND toDate('2025-08-08')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-30')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-04') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-29') AND toDate('2025-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-07')) THEN '5月double day'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-30')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-01') AND toDate('2025-04-04')) THEN '4月double day'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-30')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-28') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-03')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-26') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date BETWEEN toDate('2025-02-26') AND toDate('2025-02-28')) THEN '2月Payday'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-04') AND toDate('2026-05-07')) THEN '5月double day'
              WHEN (p_date = toDate('2026-05-01')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-26') AND toDate('2026-02-28')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'SG' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-05') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-24') AND toDate('2026-03-26')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-05') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-27') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-03') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-24') AND toDate('2025-09-26')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-01') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-24') AND toDate('2025-06-26')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-10')) THEN '8月double day'
              WHEN (p_date BETWEEN toDate('2025-08-24') AND toDate('2025-08-26')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-12')) THEN '10月double day'
              WHEN (p_date BETWEEN toDate('2025-10-24') AND toDate('2025-10-26')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-03') AND toDate('2025-07-07')) THEN '7月double day'
              WHEN (p_date BETWEEN toDate('2025-07-26') AND toDate('2025-07-28')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-08')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-04') AND toDate('2025-12-14')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-24') AND toDate('2025-05-26')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-24') AND toDate('2025-04-26')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date = toDate('2026-01-31')) THEN '2月double day'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2026-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'TH' THEN
    CASE
      WHEN p_date < toDate('2023-01-29') OR p_date > toDate('2026-05-06') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-25') AND toDate('2026-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-05')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-05')) THEN '3月double day'
              WHEN (p_date BETWEEN toDate('2026-03-28') AND toDate('2026-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date BETWEEN toDate('2025-11-07') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-28') AND toDate('2025-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-28') AND toDate('2025-10-31')) THEN '10月Payday'
              WHEN (p_date BETWEEN toDate('2025-10-07') AND toDate('2025-10-10')) THEN '10月double day'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-28') AND toDate('2025-08-31')) THEN '8月Payday'
              WHEN (p_date BETWEEN toDate('2025-08-06') AND toDate('2025-08-08')) THEN '8月double day'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-06') AND toDate('2025-09-09')) THEN '9月double day'
              WHEN (p_date BETWEEN toDate('2025-09-28') AND toDate('2025-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-28') AND toDate('2025-07-31')) THEN '7月Payday'
              WHEN (p_date BETWEEN toDate('2025-07-05') AND toDate('2025-07-07')) THEN '7月double day'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-03') AND toDate('2025-06-06')) THEN '6月double day'
              WHEN (p_date BETWEEN toDate('2025-06-28') AND toDate('2025-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-28') AND toDate('2025-05-31')) THEN '5月Payday'
              WHEN (p_date BETWEEN toDate('2025-05-03') AND toDate('2025-05-05')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-28') AND toDate('2025-03-31')) THEN '3月Payday'
              WHEN (p_date BETWEEN toDate('2025-03-01') AND toDate('2025-03-03')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-28') AND toDate('2025-04-30')) THEN '4月Payday'
              WHEN (p_date BETWEEN toDate('2025-04-02') AND toDate('2025-04-04')) THEN '4月double day'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2026-01-28') AND toDate('2026-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202501 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-01-18') AND toDate('2025-01-22')) THEN '1月-平销期'
              WHEN (p_date BETWEEN toDate('2025-01-28') AND toDate('2025-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-01'), toDate('2025-02-02'))) THEN '2月double day'
              WHEN (p_date = toDate('2025-02-28')) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-08') AND toDate('2025-12-13')) THEN '12月double day'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-02-01') AND toDate('2026-02-03')) THEN '2月double day'
              WHEN (p_date IN (toDate('2026-02-27'), toDate('2026-02-28'))) THEN '3月double day'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-06')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-29') AND toDate('2024-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-29') AND toDate('2024-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-28') AND toDate('2024-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-29') AND toDate('2023-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-26') AND toDate('2023-02-28')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-29') AND toDate('2024-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-29') AND toDate('2023-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-28') AND toDate('2023-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-29') AND toDate('2023-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-28') AND toDate('2023-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-29') AND toDate('2023-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-29') AND toDate('2023-08-31')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-28') AND toDate('2023-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-29') AND toDate('2023-10-31')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-28') AND toDate('2023-11-30')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-29') AND toDate('2023-12-31')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-29') AND toDate('2024-01-31')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-27') AND toDate('2024-02-29')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-29') AND toDate('2024-03-31')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-28') AND toDate('2024-04-30')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-29') AND toDate('2024-05-31')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-28') AND toDate('2024-06-30')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-29') AND toDate('2024-07-31')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-28') AND toDate('2024-09-30')) THEN '9月Payday'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  WHEN 'VN' THEN
    CASE
      WHEN p_date < toDate('2023-01-25') OR p_date > toDate('2026-05-07') THEN '非大促'
      ELSE
        CASE toYYYYMM(p_date)
          WHEN 202512 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-12-05') AND toDate('2025-12-12')) THEN '12月double day'
              WHEN (p_date BETWEEN toDate('2025-12-18') AND toDate('2025-12-21')) THEN '12月-平销期'
              WHEN (p_date BETWEEN toDate('2025-12-25') AND toDate('2025-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202511 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-11-04') AND toDate('2025-11-11')) THEN '11月double day'
              WHEN (p_date BETWEEN toDate('2025-11-18') AND toDate('2025-11-22')) THEN '11月-平销期'
              WHEN (p_date IN (toDate('2025-11-24'), toDate('2025-11-25'))) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202601 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-01-24') AND toDate('2026-01-31')) THEN '1月Payday'
              WHEN (p_date BETWEEN toDate('2026-01-18') AND toDate('2026-01-22')) THEN '1月-平销期'
              ELSE '非大促'
            END
          WHEN 202604 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-04-18') AND toDate('2026-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2026-04-01') AND toDate('2026-04-04')) THEN '4月double day'
              WHEN (p_date IN (toDate('2026-04-24'), toDate('2026-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202509 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-09-18') AND toDate('2025-09-22')) THEN '9月-平销期'
              WHEN (p_date BETWEEN toDate('2025-09-07') AND toDate('2025-09-10')) THEN '9月double day'
              WHEN (p_date IN (toDate('2025-09-24'), toDate('2025-09-25'))) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202506 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-06-18') AND toDate('2025-06-22')) THEN '6月-平销期'
              WHEN (p_date BETWEEN toDate('2025-06-04') AND toDate('2025-06-07')) THEN '6月double day'
              WHEN (p_date IN (toDate('2025-06-24'), toDate('2025-06-25'))) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202508 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-08-18') AND toDate('2025-08-22')) THEN '8月-平销期'
              WHEN (p_date BETWEEN toDate('2025-08-07') AND toDate('2025-08-09')) THEN '8月double day'
              WHEN (p_date IN (toDate('2025-08-24'), toDate('2025-08-25'))) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202503 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-03-18') AND toDate('2025-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2025-03-02') AND toDate('2025-03-04')) THEN '3月double day'
              WHEN (p_date IN (toDate('2025-03-24'), toDate('2025-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202603 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-03-18') AND toDate('2026-03-22')) THEN '3月-平销期'
              WHEN (p_date BETWEEN toDate('2026-03-01') AND toDate('2026-03-03')) THEN '3月double day'
              WHEN (p_date IN (toDate('2026-03-24'), toDate('2026-03-25'))) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202510 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-10-18') AND toDate('2025-10-22')) THEN '10月-平销期'
              WHEN (p_date BETWEEN toDate('2025-10-08') AND toDate('2025-10-10')) THEN '10月double day'
              WHEN (p_date IN (toDate('2025-10-24'), toDate('2025-10-25'))) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202507 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-07-18') AND toDate('2025-07-22')) THEN '7月-平销期'
              WHEN (p_date BETWEEN toDate('2025-07-06') AND toDate('2025-07-08')) THEN '7月double day'
              WHEN (p_date IN (toDate('2025-07-24'), toDate('2025-07-25'))) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202505 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-05-18') AND toDate('2025-05-22')) THEN '5月-平销期'
              WHEN (p_date BETWEEN toDate('2025-05-04') AND toDate('2025-05-06')) THEN '5月double day'
              WHEN (p_date IN (toDate('2025-05-24'), toDate('2025-05-25'))) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202504 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-04-18') AND toDate('2025-04-22')) THEN '4月-平销期'
              WHEN (p_date BETWEEN toDate('2025-04-03') AND toDate('2025-04-05')) THEN '4月double day'
              WHEN (p_date IN (toDate('2025-04-24'), toDate('2025-04-25'))) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202502 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2025-02-18') AND toDate('2025-02-22')) THEN '2月-平销期'
              WHEN (p_date IN (toDate('2025-02-24'), toDate('2025-02-25'))) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202605 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2026-05-03') AND toDate('2026-05-07')) THEN '5月double day'
              ELSE '非大促'
            END
          WHEN 202302 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-02-25') AND toDate('2023-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202412 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-12-25') AND toDate('2024-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202411 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-11-25') AND toDate('2024-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202410 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-10-25') AND toDate('2024-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202301 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-01-25') AND toDate('2023-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202408 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-08-25') AND toDate('2024-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202407 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-07-25') AND toDate('2024-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202303 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-03-25') AND toDate('2023-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202304 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-04-25') AND toDate('2023-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202305 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-05-25') AND toDate('2023-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202306 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-06-25') AND toDate('2023-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202307 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-07-25') AND toDate('2023-07-27')) THEN '7月Payday'
              ELSE '非大促'
            END
          WHEN 202308 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-08-25') AND toDate('2023-08-27')) THEN '8月Payday'
              ELSE '非大促'
            END
          WHEN 202309 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-09-25') AND toDate('2023-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202310 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-10-25') AND toDate('2023-10-27')) THEN '10月Payday'
              ELSE '非大促'
            END
          WHEN 202311 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-11-25') AND toDate('2023-11-27')) THEN '11月Payday'
              ELSE '非大促'
            END
          WHEN 202312 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2023-12-25') AND toDate('2023-12-27')) THEN '12月Payday'
              ELSE '非大促'
            END
          WHEN 202401 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-01-25') AND toDate('2024-01-27')) THEN '1月Payday'
              ELSE '非大促'
            END
          WHEN 202402 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-02-25') AND toDate('2024-02-27')) THEN '2月Payday'
              ELSE '非大促'
            END
          WHEN 202403 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-03-25') AND toDate('2024-03-27')) THEN '3月Payday'
              ELSE '非大促'
            END
          WHEN 202404 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-04-25') AND toDate('2024-04-27')) THEN '4月Payday'
              ELSE '非大促'
            END
          WHEN 202405 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-05-25') AND toDate('2024-05-27')) THEN '5月Payday'
              ELSE '非大促'
            END
          WHEN 202406 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-06-25') AND toDate('2024-06-27')) THEN '6月Payday'
              ELSE '非大促'
            END
          WHEN 202409 THEN
            CASE
              WHEN (p_date BETWEEN toDate('2024-09-25') AND toDate('2024-09-27')) THEN '9月Payday'
              ELSE '非大促'
            END
          WHEN 202602 THEN
            CASE
              WHEN (p_date IN (toDate('2026-02-01'), toDate('2026-02-02'))) THEN '2月double day'
              ELSE '非大促'
            END
          ELSE '非大促'
        END
    END
  ELSE '非大促'
END

---- Products cnt & rate
-- Have_GMV & Have_Cost Products Cnt (Daily*Sales Team)
count(
  distinct case 
    when {filter=true: fixed [product_id],[p_date],`owner_calm_direct_first_split_sea`: sum([payment_1d])} > 0
     and {filter=true: fixed [product_id],[p_date],`owner_calm_direct_first_split_sea`: sum([dollar_cost])} > 0
    then [product_id]
  end
)


---- Video Product Material(UTC0,Global)
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
case
  when `shop_operation_country`='US' then (
    CASE
      WHEN `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
      WHEN `dominant_adv_owner_calm_direct_first_split_sea`='KR' THEN 'KROB'
      WHEN `dominant_adv_owner_calm_direct_first_split_sea`='NA-US' THEN 'NA-US'
      WHEN `dominant_adv_owner_calm_direct_first_split_sea`='NA-SMB' THEN 'NA-SMB'
      WHEN `dominant_adv_owner_calm_direct_first_split_sea`='SMB' THEN 'Self Serve'
      ELSE 'Others'
    END
  )
  when `shop_operation_country` IN('MY','VN','TH','SG','ID','PH') then (
    case
      when `dominant_adv_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
      when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
      when `dominant_adv_owner_calm_direct_first_split_sea` IN('MY','VN','TH','SG','ID','Strategic Accounts','SEA-Others','Marketplace') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `shop_operation_country`='JP' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='JP' then 'ENT'
          when `dominant_adv_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='GB' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `dominant_adv_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='BR' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='BR' then 'ENT'
          when `dominant_adv_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country`='MX' then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='MX' then 'ENT'
          WHEN `dominant_adv_owner_calm_direct_first_split_sea`='SMB' THEN 'Self Serve'
          WHEN `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' THEN 'CNOB'
          else 'Others'
        end
      )
      when `shop_operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `dominant_adv_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `dominant_adv_owner_calm_direct_first_split_sea`='SMB' then 'Self Serve'
          when `dominant_adv_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

---- show & GPM
-- GPM
1000.0*SUM(
  toFloat64OrZero(product_content_cl_pay_gmv)
)/nullIf(
  SUM(
    toFloat64OrZero(
      mapElement(
        product_show_count_1d_metric_data,
        'show_count_1d'
      )
    )
  ),
  0.0
)

-- ads GPM
1000.0*SUMIf(
  toFloat64OrZero(
    mapElement(
      ads_gmv_1d_metric_data,
      'ads_manager_ads_gmv_1d'
    )
  ),
  toFloat64OrZero(
    mapElement(
      dollar_cost_1d_metric_data,
      'dollar_cost_1d'
    )
  )>0
)/nullIf(
  SUMIf(
    toFloat64OrZero(
      mapElement(
        show_count_1d_metric_data,
        'ads_manager_show_count_1d'
      )
    ),
    toFloat64OrZero(
      mapElement(
        dollar_cost_1d_metric_data,
        'dollar_cost_1d'
      )
    )>0
  ),
  0.0
)