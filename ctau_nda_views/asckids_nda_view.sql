-- The main query for the NDA asc_kids01 view

select
  dem.dem_guid as subjectkey
  ,sa1.subject_id as src_subject_id
	,asck.source_subject_id -- only for validation; DELETE before submission
	,asck.event_name
	,case
		when asck.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when asck.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when asck.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when asck.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when asck.event_name like 'baseline%' then sched_main.sched_base_complete
		when asck.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when asck.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when asck.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when asck.event_name like '18_month%' then sched.sched_18mo_complete
		when asck.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,asck.asc_1
    ,asck.asc_2
    ,asck.asc_3
    ,asck.asc_4
    ,asck.asc_5
    ,asck.asc_6
    ,asck.asc_7
    ,asck.asc_8
    ,asck.asc_9
    ,asck.asc_10
    ,asck.asc_11
    ,asck.asc_12
    ,asck.asc_13
    ,asck.asc_14
    ,asck.asc_15
    ,asck.asc_16
    ,asck.asc_17
    ,asck.asc_18
    ,asck.asc_19
    ,asck.asc_20
    ,asck.asc_21
    ,asck.asc_22
    ,asck.asc_23
    ,asck.asc_24
    ,asck.asc_25
    ,asck.asc_26
    ,asck.asc_27
    ,asck.asc_28
    ,asck.asc_29	
from rcap_asc_kids asck -- Attention! rcap_asc_kids is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = asck.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = asck.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = asck.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = asck.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = asck.source_subject_id
    and pfhc.event_name like 'baseline%'
left join rcap_pfh_parent pfhp -- ??? Doublecheck the fields on which the tables are joined
    on pfhp.source_subject_id = asck.source_subject_id 
order by sa1.subject_id;
