---- Creating NDA ptsd01 view

select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
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
	,caps.caps_summary_improve_q28 as capsptsd76
	,caps.caps_summary_a1 as capsptsd77 -- might need to be substituted with caps_tc_a1 or deleted
	,caps.caps_summary_b1_sev_q1 as caps5_b1
	,caps.caps_summary_b2_sev_q2 as caps5_b2
	,caps.caps_summary_b3_sev_q3 as caps5_b3
	,caps.caps_summary_b4_sev_q4 as caps5_b4
	,caps.caps_summary_b5_sev_q5 as caps5_b5
	,caps.caps_summary_c1_sev_q6 as caps5_c1
	,caps.caps_summary_c2_sev_q7 as caps5_c2
	,caps.caps_summary_d1_sev_q8 as caps5_d1
	,caps.caps_summary_d2_sev_q9 as caps5_d2
	,caps.caps_summary_d3_sev_q10 as caps5_d3
	,caps.caps_summary_d4_sev_q11 as caps5_d4
	,caps.caps_summary_d5_sev_q12 as caps5_d5
	,caps.caps_summary_d6_sev_q13 as caps5_d6
	,caps.caps_summary_d7_sev_q14 as caps5_d7
	,caps.caps_summary_e1_sev_q15 as caps5_e1	
	,caps.caps_summary_e2_sev_q16 as caps5_e2
	,caps.caps_summary_e3_sev_q17 as caps5_e3
	,caps.caps_summary_e4_sev_q18 as caps5_e4		
	,caps.caps_summary_e5_sev_q19 as caps5_e5	
	,caps.caps_summary_e6_sev_q20 as caps5_e6	
	,case
		when caps.caps_summary_f1_q22 = '0' then '2'
		when caps.caps_summary_f1_q22 = '-999' then '999'
		else caps.caps_summary_f1_q22
	end as caps5_22b
	,caps.caps_summary_g1_sev_q23 as caps5_23
	,caps.caps_summary_g2_sev_q24 as caps5_24
	,caps.caps_summary_g3_sev_q25 as caps5_25		
	,caps.caps_summary_severity_q27 as caps5_27
	,caps.caps_sum_depers_sev_q29 as caps5_29a
	,caps.caps_sum_dereal_sev_q30 as caps5_30a		
	,case
		when caps.caps_sum_ptsd_present = '0' then '2'
		when caps.caps_sum_ptsd_present in ('999','-999') then null
		else caps.caps_sum_ptsd_present
	end as caps5_dxs_a
	,case 
		when caps.caps_summary_dissoc = '0' then '2'
		when caps.caps_summary_dissoc = '-999' then '999'
		else caps.caps_summary_dissoc
	end as caps5_dxs_b	
	,case 
		when caps.caps_sum_delayed = '0' then '2'
		when caps.caps_sum_delayed = '-999' then '999'
		else caps.caps_sum_delayed
	end as caps5_dxs_c	
	,caps.caps_summary_validity_q26 as caps5_26
from rcap_capsca5 caps
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = caps.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = caps.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = caps.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = caps.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = caps.source_subject_id
order by sa1.subject_id;










--- Pat Scherer's initial script below
Select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
    ,to_char(sched.interview_date,'mm/dd/yyyy') as interview_date
    ,nda_months_between(sched.interview_date, ctau_dem.dem_ch_dob) as interview_age
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
*/
	,caps.caps5_28_improve as capsptsd76
	,caps.caps_summary_a1 as capsptsd77
	,caps.caps_summary_b1_sev_q1 as caps5_b1
	,caps.caps_summary_b2_sev_q2 as caps5_b2
	,caps.caps_summary_b3_sev_q3 as caps5_b3
	,caps.caps_summary_b4_sev_q4 as caps5_b4
	,caps.caps_summary_b5_sev_q5 as caps5_b5
	,caps.caps_summary_c1_sev_q6 as caps5_c1
	,caps.caps_summary_c2_sev_q7 as caps5_c2
	,caps.caps_summary_d1_sev_q8 as caps5_d1
	,caps.caps_summary_d2_sev_q9 as caps5_d2
	,caps.caps_summary_d3_sev_q10 as caps5_d3
	,caps.caps_summary_d4_sev_q11 as caps5_d4
	,caps.caps_summary_d5_sev_q12 as caps5_d5
	,caps.caps_summary_d6_sev_q13 as caps5_d6
	,caps.caps_summary_d7_sev_q14 as caps5_d7
	,caps.caps_summary_e1_sev_q15 as caps5_e1	
	,caps.caps_summary_e2_sev_q16 as caps5_e2
	,caps.caps_summary_e3_sev_q17 as caps5_e3
	,caps.caps_summary_e4_sev_q18 as caps5_e4		
	,caps.caps_summary_e5_sev_q19 as caps5_e5	
	,caps.caps_summary_e6_sev_q20 as caps5_e6	
	,caps.caps_summary_f1_sev_q22 as caps5_22b	
	,caps.caps_summary_g1_sev_q23 as caps5_23
	,caps.caps_summary_g2_sev_q24 as caps5_24
	,caps.caps_summary_g3_sev_q25 as caps5_25		
	,caps.caps_summary_severity_q27 as caps5_27
	,caps.caps_sum_depers_sev_q29 as caps5_29a
	,caps.caps_sum_dereal_sev_q30 as caps5_30a		
	,caps.caps_sum_ptsd_present as caps5_dxs_a		
	,caps.caps_sum_dissociative as caps5_dxs_b	
	,caps.caps_sum_delayed as caps5_dxs_c	
	,caps.caps_summary_validity_q26 as caps5_26	
from rcap_capsca5 caps
inner join subject_alias sa1
    on sa1.source_subject_id = caps.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form_agg_view sched
    on sched.source_subject_id = caps.source_subject_id 
    and sched.event_name = caps.event_name
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id;
