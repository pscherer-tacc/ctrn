----crafftn nda view

select
    dem.dem_guid as subjectkey,
    sa1.subject_id as src_subject_id,
	crafftn.source_subject_id, -- only for validation; delete before submission
	crafftn.event_name, -- only for validation; delete before submission
	case	
		when crafftn.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
	    --when crafftn.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')   --- no 18 month in ctau
		when crafftn.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date,
	case
	    when crafftn.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when crafftn.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age, 
	case
	    when crafftn.event_name like 'baseline%' then sched_main.sched_base_complete
		when crafftn.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when crafftn.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when crafftn.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when crafftn.event_name like '18_month%' then sched.sched_18mo_complete
		when crafftn.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete, -- only for validation; delete before submission
	case
	    when pfhc.hc_sex_birth_cert='1' then 'F'
		when pfhc.hc_sex_birth_cert='2' then 'M'
		else null
	end as sex,
	case
		when crafftn.event_name like 'baseline%' then 'baseline'
		when crafftn.event_name like 'one_month%' then 'one_month'
		when crafftn.event_name like 'six_month%' then 'six_month'
		when crafftn.event_name like 'one_year%' then 'one_year'
		-- when crafftn.event_name like '18_month%' then '18_month'
		when crafftn.event_name like '24_month%' then '24_month'
	end as visit,
	crafftn.crafftn_1 as crafft_a_1,         
	crafftn.crafftn_2 as crafft_a_2,
	crafftn.crafftn_3 as crafft_a_3,
	crafftn.crafftn_4 as crafft_a_4,
	crafftn.crafftn_5 as crafft_b_1,
	crafftn.crafftn_6 as crafft_b_2,
	crafftn.crafftn_7 as crafft_b_3,
	crafftn.crafftn_8 as crafft_b_4,
	crafftn.crafftn_9 as crafft_b_5,
	crafftn.crafftn_10 as crafft_b_6
from rcap_crafftn as crafftn -- attention! rcap_crafftn is NOT a ctau table.
inner join rcap_ctau_scheduling_form as sched -- to keep ctau participants only
	on sched.sched_ctrn_id = crafftn.source_subject_id
	and sched.event_name like 'baseline%'
	-- and crafftn.event_name not like 'unscheduled%'-- optional if want to include
inner join subject_alias as sa1
    on sa1.source_subject_id = crafftn.source_subject_id
left join rcap_scheduling_form as sched_main 
    on sched_main.source_subject_id = crafftn.source_subject_id 
left join rcap_demographics as dem
    on dem.source_subject_id = crafftn.source_subject_id
left join rcap_pfh_child as pfhc 
    on pfhc.source_subject_id = crafftn.source_subject_id
order by sa1.subject_id; -- should run, but syntax error appeared on scared_child view -- if case then can comment out this line