------ CALM Team X Shop TTS Dataset (Full Snapshot)
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
-- CALM Region
CASE
 WHEN shop_operation_region='EU' THEN (case when `shop_operation_country`='GB' then 'UK' when `shop_operation_country` IN ('DE','IT','ES','FR','IE') then 'EU_others' else 'Others' end)
 ELSE shop_operation_region end

-- Region Breakdown by OB/ENT/SMB
case
  when [operation_region]='US' then (
    case
      when `latest_owner_calm_direct_first_combi_apac`='NA' then 'ENT'
      when `latest_owner_calm_direct_first_combi_apac`='SMB' then 'SMB'
      when `latest_owner_calm_direct_first_combi_apac` in('CNOB', 'APAC') then (
        case
          when `latest_owner_calm_direct_first_split_sea` in('CNOB') then 'CNOB'
          when `latest_owner_calm_direct_first_split_sea` in('KR') then 'KROB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
  when [operation_region]='SEA' then (
    case
      when `latest_owner_calm_direct_first_combi_apac`='SMB' then 'SMB'
      when `latest_owner_calm_direct_first_combi_apac`='CNOB' then 'CNOB'
      when `latest_owner_calm_direct_first_combi_apac`='APAC'
      and `latest_owner_calm_direct_first_split_sea` in('SG', 'ID', 'MY', 'TH', 'PH', 'VN') then 'ENT'
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
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `latest_owner_calm_direct_first_split_sea` in ('Brazil','ENT') then 'ENT' 
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `latest_owner_calm_direct_first_split_sea`in('Mexico','ENT') then 'ENT' 
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `latest_owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `latest_owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `latest_owner_calm_direct_first_split_sea`='SMB' then 'SMB'
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
-- CALM Region
CASE
 WHEN shop_operation_region='EU' THEN (case when `shop_operation_country`='GB' then 'UK' when `shop_operation_country` IN ('DE','IT','ES','FR','IE') then 'EU_others' else 'Others' end)
 ELSE shop_operation_region end
 
-- Region Breakdown by OB/ENT/SMB
case
  when [Operation Region]='US' then (
    case
      when [Daily Latest GBS Direct First GBS - 1]='NA' then 'ENT'
      when [Daily Latest GBS Direct First GBS - 1]='SMB' then 'SMB'
      when [Daily Latest GBS Direct First GBS - 1]='CALM' then (
        case
          when owner_calm_direct_first_combi_sea in('CNOB') then 'CNOB'
          when owner_calm_direct_first_combi_sea in('KR') then 'KROB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
  when [Operation Region]='SEA' then (
    case
      when [Daily Latest GBS Direct First CALM - 1]='SMB' then 'SMB'
      when [Daily Latest GBS Direct First CALM - 1]='CNOB' then 'CNOB'
      when [Daily Latest GBS Direct First CALM - 1]='APAC'
      and owner_calm_direct_first_combi_sea in('SG', 'ID', 'MY', 'TH', 'PH', 'VN') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when owner_calm_direct_first_combi_sea='JP' then 'ENT'
          when owner_calm_direct_first_split_sea='SMB' then 'SMB'
          when owner_calm_direct_first_split_sea='CNOB' then 'CNOB'  
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when owner_calm_direct_first_combi_sea='EUI' then 'ENT'
          when owner_calm_direct_first_split_sea='SMB' then 'SMB'
          when owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when owner_calm_direct_first_combi_sea='LATAM'then 'ENT'
          when owner_calm_direct_first_split_sea='SMB' then 'SMB'
          when owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when owner_calm_direct_first_combi_sea='LATAM'then 'ENT'
          when owner_calm_direct_first_split_sea='SMB' then 'SMB'
          when owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when owner_calm_direct_first_combi_sea='EUI' then 'ENT'
          when owner_calm_direct_first_split_sea='SMB' then 'SMB'
          when owner_calm_direct_first_split_sea='CNOB' then 'CNOB'
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


---- Promotion US
-- Promotion Calendar US


-- Promotion Daily&Promotion&Others US


-- Daily VS Promotion US


---- Promotion SEA
-- Promotion Calendar SEA


-- Promotion Daily&Promotion&Others SEA


-- Daily VS Promotion SEA


------ Shop M10n GMV Max Session Stat(Adv timezone,TikTok&Pangle&Toko)
---- Sales Team Breakdown
-- CALM Region
CASE
 WHEN [operation_region]='EU' THEN (case when `shop_operation_country`='GB' then 'UK' when `shop_operation_country` IN ('DE','IT','ES','FR','IE') then 'EU_others' else 'Others' end)
 ELSE [operation_region] end

-- Region Breakdown by OB/ENT/SMB
case
  when [operation_region]='US' then (
    case
      when `owner_gbs_direct_first_split_sea`='NA' then 'ENT'
      when `owner_gbs_direct_first_split_sea` in('CNOB') then 'CNOB'
      when `owner_gbs_direct_first_split_sea` in('KR') then 'KROB'
      when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
      else 'Others'
    end
  )
  when [operation_region]='SEA' then (
    case
      when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
      when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
      when `owner_gbs_direct_first_split_sea` in('SG', 'ID', 'MY', 'TH', 'PH', 'VN') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when shop_operation_country='JP' then (
        case
          when `owner_gbs_direct_first_split_sea`='JP' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='GB' then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='BR' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Brazil','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country='MX' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Mexico','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when shop_operation_country in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `owner_gbs_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      else 'Others'
    end
  )
end

------  [AC,Joined] Product Commission Setup (UTC0, Global)
---- Sales Team Breakdown
-- CALM Region
CASE
 WHEN [shop_operation_region]='EU' THEN (case when `operation_country`='GB' then 'UK' when `operation_country` IN ('DE','IT','ES','FR','IE') then 'EU_others' else 'Others' end)
 ELSE [shop_operation_region] end

-- Region Breakdown by OB/ENT/SMB
case
  when [shop_operation_region]='US' then (
    case
      when `owner_calm_direct_first_split_sea`='NA' then 'ENT'
      when `owner_calm_direct_first_split_sea` in('CNOB') then 'CNOB'
      when `owner_calm_direct_first_split_sea` in('KR') then 'KROB'
      when `owner_calm_direct_first_split_sea`='SMB' then 'SMB'
      else 'Others'
    end
  )
  when [shop_operation_region]='SEA' then (
    case
      when `owner_calm_direct_first_split_sea`='SMB' then 'SMB'
      when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
      when `owner_calm_direct_first_split_sea` in('SG', 'ID', 'MY', 'TH', 'PH', 'VN') then 'ENT'
      else 'Others'
    end
  )
  else (
    case
      when `operation_country`='JP' then (
        case
          when `owner_calm_direct_first_split_sea`='JP' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='GB' then (
        case
          when `owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_calm_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='BR' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Brazil','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country`='MX' then (
        case
          when `owner_gbs_direct_first_split_sea`in ('Mexico','ENT') then 'ENT'
          when `owner_gbs_direct_first_split_sea`='SMB' then 'SMB'
          when `owner_gbs_direct_first_split_sea`='CNOB' then 'CNOB'
          else 'Others'
        end
      )
      when `operation_country` in('DE', 'IT', 'ES', 'FR', 'IE') then (
        case
          when `owner_calm_direct_first_split_sea`='EUI' then 'ENT'
          when `owner_calm_direct_first_split_sea`='SMB' then 'SMB'
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