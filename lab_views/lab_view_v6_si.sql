----- The lab view based rcap_ctau_sample_info
select
    sa1.subject_id,
    si.si_tube_id,
    si.source_subject_id, -- only for validation
    case 
        when si.event_name like 'baseline%' then '00_baseline_ctau'
        when si.event_name like 'one_month%' then '01_one_month_ctau'
        when si.event_name like 'six_month%' then '06_six_month_ctau'
        when si.event_name like 'one_year%' then '12_month_ctau'
        when si.event_name like '18_month%' then '18_month_ctau'
        when si.event_name like '24_month%' then '24_month_ctau'
    end as visit,
    ctrn_main_dem.dem_ch_dob, -- only for validation
    si.si_freeze_dt_tm, -- only for validation
    age_days_between(
        ctrn_main_dem.dem_ch_dob::date, -- Attention! Date-of-birth is taken from the CTRN-MAIN table
        si.si_freeze_dt_tm::date
    ) as age_days_sample_collection,
    case
        when pfhc.hc_sex_birth_cert = '1' then 'F'
        when pfhc.hc_sex_birth_cert = '2' then 'M'
        else null
    end as sex,
    pfhc.hc_race,
    pfhc.hc_hispanic
from rcap_ctau_sample_info si
inner join subject_alias sa1
    on sa1.source_subject_id = si.source_subject_id
    and sa1.project_id = 2515 -- CTAU only
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696
    and sa2.id_type = 'redcap'
left join rcap_demographics ctrn_main_dem
    on ctrn_main_dem.source_subject_id = sa2.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa2.source_subject_id
    and pfhc.event_name like 'baseline%'
---
where si.si_tube_id ilike '%\_1\_1';
;

