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
-- Table can not devided by content type (Delivery Type or Content Type), So if needed plz refer to table CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)

---- Sales Team Breakdown
-- SEA/US-NA/SEA/CNOB/KROB/SMB/Others
case
  when [operation_region]='US' then (
    case
      when `latest_owner_calm_direct_first_combi_apac`='NA' then 'ENT'
      when `latest_owner_calm_direct_first_combi_apac`='SMB' then 'SMB'
      when `latest_owner_calm_direct_first_combi_apac`in ('CNOB', 'APAC') then (
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
end


------ CALM_TTS_Shop Ads<>TTS Perspective Spending Dataset (utc0, full)
---- Sales Team Breakdown
-- SEA/US-NA/SEA/CNOB/KROB/SMB/Others
case
  when [Operation Region]='US' then (
    case
      when [Daily Latest GBS Direct First GBS - 1]='NA' then 'ENT'
      when [Daily Latest GBS Direct First GBS - 1]='SMB' then 'SMB'
      when [Daily Latest GBS Direct First GBS - 1]='CALM' then (
        case
          when [Daily Latest Direct First Country Split SEA] in('CNOB') then 'CNOB'
          when [Daily Latest Direct First Country Split SEA] in('KR') then 'KROB'
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
      and [Daily Latest Direct First Country Split SEA] in('SG', 'ID', 'MY', 'TH', 'PH', 'VN') then 'ENT'
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
