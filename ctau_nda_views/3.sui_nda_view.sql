-- Creating sui_nda_view

select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
    ,case
        when sui.event_name like 'baseline%' then sched.sched_base_complete_date
        when sui.event_name like 'one_month%' then sched.sched_1mo_complete_date
        when sui.event_name like 'six_month%' then sched.sched_6mo_complete_date
        when sui.event_name like 'one_year%' then sched.sched_1yr_date
        when sui.event_name like '18_month%' then sched.sched_18mo_complete_date
        when sui.event_name like '24_month%' then sched.sched_2yr_complete_date
    end as interview_date
    ,case
        when sui.event_name like 'baseline%' then months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
        when sui.event_name like 'one_month%' then months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
        when sui.event_name like 'six_month%' then months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
        when sui.event_name like 'one_year%' then months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
        when sui.event_name like '18_month%' then months_between(sched.sched_18mo_complete_date, ctau_dem.dem_ch_dob)
        when sui.event_name like '24_month%' then months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
    end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,case 
        when sui.event_name like 'baseline%' then 'baseline'
        when sui.event_name like 'one_month%' then 'one_month'
        when sui.event_name like 'six_month%' then 'six_month'
        when sui.event_name like 'one_year%' then 'one_year'
        when sui.event_name like '18_month%' then '18_month'
        when sui.event_name like '24_month%' then '24_month'
    end as timepoint_label
    ,sui_1
	,sui_2
	,sui_3
	,sui_4
	,sui_5
	,sui_6
	,sui_7
	,sui_8
from rcap_ctau_sui sui
inner join subject_alias sa1
    on sa1.source_subject_id = sui.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = sui.source_subject_id 
    and sched.event_name = sui.event_name
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id;