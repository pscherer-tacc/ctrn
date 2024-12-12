---- chrt16 NDA view

select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,chrt.source_subject_id -- only for validation; DELETE before submission
	,chrt.event_name -- only for validation; DELETE before submission
	,case
		when chrt.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when chrt.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when chrt.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when chrt.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when chrt.event_name like 'baseline%' then sched.sched_base_complete
		when chrt.event_name like 'one_month%' then sched.sched_1mo_complete
		when chrt.event_name like 'six_month%' then sched.sched_6mo_complete
		when chrt.event_name like 'one_year%' then sched.sched_1yr_complete
		--when chrt.event_name like '18_month%' then sched.sched_18mo_complete
		when chrt.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when chrt.event_name like 'baseline%' then 'baseline'
		when chrt.event_name like 'one_month%' then 'one_month'
		when chrt.event_name like 'six_month%' then 'six_month'
		when chrt.event_name like 'one_year%' then 'one_year'
		when chrt.event_name like '18_month%' then '18_month'
		when chrt.event_name like '24_month%' then '24_month'
	end as visit
    ,chrt.chrt_1 as chrt_01
    ,chrt.chrt_2 as chrt_02
    ,chrt.chrt_3 as chrt_03
    ,chrt.chrt_4 as chrt_04
    ,chrt.chrt_5 as chrt_05
    ,chrt.chrt_6 as chrt_06
    ,chrt.chrt_7 as chrt_07
    ,chrt.chrt_8 as chrt_08
    ,chrt.chrt_9 as chrt_09
    ,chrt.chrt_10
    ,chrt.chrt_11
    ,chrt.chrt_12
    ,chrt.chrt_13
    ,chrt.chrt_14
    ,chrt.chrt_15
    ,chrt.chrt_16
from rcap_chrt16 chrt -- Attention! rcap_chrt16 is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = chrt.source_subject_id
	and sched.event_name like 'baseline%'
    and chrt.event_name not like 'unscheduled%'
inner join subject_alias sa1
    on sa1.source_subject_id = chrt.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = chrt.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = chrt.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = chrt.source_subject_id
order by sa1.subject_id;