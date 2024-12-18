---- CAPSCA VT View
--- Name of the view: view_vt_capsca

-- Query the data from the view
select * from view_vt_capsca
where interview_date is not null;

-- The body of the view
create or replace view view_vt_capsca
as
select
    dem.dem_guid
    ,sa1.subject_id
	,caps.source_subject_id -- only for validation; DELETE before submission
	,case
		when caps.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when caps.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when caps.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when caps.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when caps.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when caps.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when caps.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when caps.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when caps.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when caps.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when caps.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when caps.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when caps.event_name like 'baseline%' then 'baseline'
		when caps.event_name like 'one_month%' then 'one_month'
		when caps.event_name like 'six_month%' then 'six_month'
		when caps.event_name like 'one_year%' then 'one_year'
		when caps.event_name like '18_month%' then '18_month'
		when caps.event_name like '24_month%' then '24_month'
	end as visit
	,caps.caps_summary_improve_q28
	,caps.caps_summary_a1
	,caps.caps_summary_b1_sev_q1
	,caps.caps_summary_b2_sev_q2
	,caps.caps_summary_b3_sev_q3
	,caps.caps_summary_b4_sev_q4
	,caps.caps_summary_b5_sev_q5
	,caps.caps_summary_c1_sev_q6
	,caps.caps_summary_c2_sev_q7
	,caps.caps_summary_d1_sev_q8
	,caps.caps_summary_d2_sev_q9
	,caps.caps_summary_d3_sev_q10
	,caps.caps_summary_d4_sev_q11
	,caps.caps_summary_d5_sev_q12
	,caps.caps_summary_d6_sev_q13
	,caps.caps_summary_d7_sev_q14
	,caps.caps_summary_e1_sev_q15	
	,caps.caps_summary_e2_sev_q16
	,caps.caps_summary_e3_sev_q17
	,caps.caps_summary_e4_sev_q18		
	,caps.caps_summary_e5_sev_q19	
	,caps.caps_summary_e6_sev_q20	
	,caps.caps_summary_f1_q22
	,caps.caps_summary_g1_sev_q23
	,caps.caps_summary_g2_sev_q24
	,caps.caps_summary_g3_sev_q25		
	,caps.caps_summary_severity_q27
	,caps.caps_sum_depers_sev_q29
	,caps.caps_sum_dereal_sev_q30		
	,caps.caps_sum_ptsd_present		
	,caps.caps_sum_dissociative	
	,caps.caps_sum_delayed	
	,caps.caps_summary_validity_q26
from rcap_capsca5 caps
inner join subject_alias sa1
    on sa1.source_subject_id = caps.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and caps.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = caps.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = caps.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = caps.source_subject_id
order by sa1.subject_id;