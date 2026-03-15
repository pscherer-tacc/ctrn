----------- Create NDA cde_phqa9_view

-- NEW version 2.0
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,phqa.source_subject_id -- only for validation; DELETE before submission
	,phqa.event_name -- only for validation; DELETE before submission
	,case
		when phqa.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when phqa.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when phqa.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
	    when phqa.event_name like 'baseline%' then sched_main.sched_base_complete
		when phqa.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when phqa.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when phqa.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when phqa.event_name like '18_month%' then sched.sched_18mo_complete
		when phqa.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; delete before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,phqa.phq_2_val as phq9_1
	,phqa.phq_1_val as phq9_2
	,phqa.phq_3_val as phq9_3
	,phqa.phq_4_val as phq9_4
	,phqa.phq_5_val as phq9_5
	,phqa.phq_6_val as phq9_6
	,phqa.phq_7_val as phq9_7	
	,phqa.phq_8_val as phq9_8
	,phqa.phq_9_val as phq9_9
	,case 
		when phqa.language = 'sp' then '70' -- Spanish for the United States
		else '1' -- English
	end as phq9_10
	,phqa.phqa_complete
from rcap_phqa phqa -- Attention! rcap_phqa is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = phqa.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = phqa.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = phqa.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = phqa.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = phqa.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
