---- Creating ippa01_nda_view

select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,ippa.source_subject_id -- only for validation; DELETE before submission
	,ippa.event_name -- only for validation; DELETE before submission
	,case
		when ippa.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when ippa.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when ippa.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when ippa.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when ippa.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when ippa.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when ippa.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when ippa.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when ippa.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when ippa.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when ippa.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when ippa.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when ippa.event_name like 'baseline%' then sched_main.sched_base_complete
		when ippa.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when ippa.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when ippa.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when ippa.event_name like '18_month%' then sched_main.sched_18mo_complete
		when ippa.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when ippa.event_name like 'baseline%' then 'baseline'
		when ippa.event_name like 'one_month%' then 'one_month'
		when ippa.event_name like 'six_month%' then 'six_month'
		when ippa.event_name like 'one_year%' then 'one_year'
		when ippa.event_name like '18_month%' then '18_month'
		when ippa.event_name like '24_month%' then '24_month'
	end as timepoint_label
	,ippa.ippa_q1 as ippa_5pt_q8
	,ippa.ippa_q2 as ippa_5pt_q9
	,ippa.ippa_q3 as ippa_5pt_q10
	,ippa.ippa_q4 as ippa_5pt_q11
	,ippa.ippa_q5 as ippa_5pt_q12
	,ippa.ippa_q6 as ippa_5pt_q13
	,ippa.ippa_q7 as ippa_5pt_q14
	,ippa.ippa_q8 as ippa_5pt_q15
	,ippa.ippa_q9 as ippa_5pt_q16
	,ippa.ippa_q10 as ippa_5pt_q17
	,ippa.ippa_q11 as ippa_5pt_q18
	,ippa.ippa_q12 as ippa_5pt_q19
	,ippa.ippa_q13 as ippa_5pt_q20
	,ippa.ippa_q14 as ippa_5pt_q21
	,ippa.ippa_q15 as ippa_5pt_q22
	,ippa.ippa_q16 as ippa_5pt_q23
	,ippa.ippa_q17 as ippa_5pt_q24
	,ippa.ippa_q18 as ippa_5pt_q25
	,ippa.ippa_q19 as ippa_5pt_q26
	,ippa.ippa_q20 as ippa_5pt_q27
	,ippa.ippa_q21 as ippa_5pt_q1
	,ippa.ippa_q22 as ippa_5pt_q28
	,ippa.ippa_q23 as ippa_5pt_q2
	,ippa.ippa_q24 as ippa_5pt_q3
	,ippa.ippa_q25 as ippa_5pt_q4
	,ippa.ippa_q26 as ippa_5pt_q5
	,ippa.ippa_q27 as ippa_5pt_q6
	,ippa.ippa_q28 as ippa_5pt_q7
from rcap_ippa ippa -- Attention! rcap_ippa is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = ippa.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = ippa.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = ippa.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = ippa.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = ippa.source_subject_id
order by sa1.subject_id;





-- Pat's original script below
select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,ippa.ippa_complete -- only for validation; DELETE before submission
	,ippa.source_subject_id as ctau_source_subject_id -- only for validation; DELETE before submission
	,case
		when ippa.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
		when ippa.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
		when ippa.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date,'mm/dd/yyyy')
		when ippa.event_name like 'one_year%' then to_char(sched.sched_1yr_date,'mm/dd/yyyy')
		when ippa.event_name like '18_month%' then to_char(sched.sched_18mo_complete_date,'mm/dd/yyyy')
		when ippa.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as interview_date
	,case
		when ippa.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
		when ippa.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
		when ippa.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
		when ippa.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
		when ippa.event_name like '18_month%' then nda_months_between(sched.sched_18mo_complete_date, ctau_dem.dem_ch_dob)
		when ippa.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
	end as interview_age
	,case
		when ippa.event_name like 'baseline%' then sched.sched_base_complete
		when ippa.event_name like 'one_month%' then sched.sched_1mo_complete
		when ippa.event_name like 'six_month%' then sched.sched_6mo_complete
		when ippa.event_name like 'one_year%' then sched.sched_1yr_complete
		when ippa.event_name like '18_month%' then sched.sched_18mo_complete
		when ippa.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when ippa.event_name like 'baseline%' then 'baseline'
		when ippa.event_name like 'one_month%' then 'one_month'
		when ippa.event_name like 'six_month%' then 'six_month'
		when ippa.event_name like 'one_year%' then 'one_year'
		when ippa.event_name like '18_month%' then '18_month'
		when ippa.event_name like '24_month%' then '24_month'
	end as timepoint_label
	,ippa.ippa_q1 as ippa_5pt_q8
	,ippa.ippa_q2 as ippa_5pt_q9
	,ippa.ippa_q3 as ippa_5pt_q10
	,ippa.ippa_q4 as ippa_5pt_q11
	,ippa.ippa_q5 as ippa_5pt_q12
	,ippa.ippa_q6 as ippa_5pt_q13
	,ippa.ippa_q7 as ippa_5pt_q14
	,ippa.ippa_q8 as ippa_5pt_q15
	,ippa.ippa_q9 as ippa_5pt_q16
	,ippa.ippa_q10 as ippa_5pt_q17
	,ippa.ippa_q11 as ippa_5pt_q18
	,ippa.ippa_q12 as ippa_5pt_q19
	,ippa.ippa_q13 as ippa_5pt_q20
	,ippa.ippa_q14 as ippa_5pt_q21
	,ippa.ippa_q15 as ippa_5pt_q22
	,ippa.ippa_q16 as ippa_5pt_q23
	,ippa.ippa_q17 as ippa_5pt_q24
	,ippa.ippa_q18 as ippa_5pt_q25
	,ippa.ippa_q19 as ippa_5pt_q26
	,ippa.ippa_q20 as ippa_5pt_q27
	,ippa.ippa_q21 as ippa_5pt_q1
	,ippa.ippa_q22 as ippa_5pt_q28
	,ippa.ippa_q23 as ippa_5pt_q2
	,ippa.ippa_q24 as ippa_5pt_q3
	,ippa.ippa_q25 as ippa_5pt_q4
	,ippa.ippa_q26 as ippa_5pt_q5
	,ippa.ippa_q27 as ippa_5pt_q6
	,ippa.ippa_q28 as ippa_5pt_q7
from rcap_ctau_ippa ippa
inner join subject_alias sa1
    on sa1.source_subject_id = ippa.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = ippa.source_subject_id 
    and sched.event_name like 'baseline%'
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id
order by sa2.subject_id;

