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
      when `latest_owner_calm_direct_first_combi_apac`='CALM' then (
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