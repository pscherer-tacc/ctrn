-- The main query for the NDA asc_kids01 view

select
  asc.dem_guid as subjectkey
  ,sa1.subject_id as src_subject_id
	,asc.source_subject_id -- only for validation; DELETE before submission
	,asc.event_name
	,case
		when asc.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when asc.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when asc.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when asc.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when asc.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when asc.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when asc.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when asc.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when asc.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when asc.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when asc.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when asc.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when asc.event_name like 'baseline%' then sched_main.sched_base_complete
		when asc.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when asc.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when asc.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when asc.event_name like '18_month%' then sched.sched_18mo_complete
		when asc.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,asc_1
    ,asc_2
    ,asc_3
    ,asc_4
    ,asc_5
    ,asc_6
    ,asc_7
    ,asc_8
    ,asc_9
    ,asc_10
    ,asc_11
    ,asc_12
    ,asc_13
    ,asc_14
    ,asc_15
    ,asc_16
    ,asc_17
    ,asc_18
    ,asc_19
    ,asc_20
    ,asc_21
    ,asc_22
    ,asc_23
    ,asc_24
    ,asc_25
    ,asc_26
    ,asc_27
    ,asc_28
    ,asc_29	
from rcap_asc_kids asc -- Attention! rcap_asc_kids is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = asc.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = asc.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = asc.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = asc.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = asc.source_subject_id
    and pfhc.event_name like 'baseline%'
left join rcap_pfh_parent pfhp -- ??? Doublecheck the fields on which the tables are joined
    on pfhp.source_subject_id = asc.source_subject_id 
order by sa1.subject_id;
