---- Child_treatment VT View
--- Name of the view: child_treatment_vt_view.sql
select
  dem.dem_guid as subjectkey
  ,sa1.subject_id as src_subject_id
	,ctx.source_subject_id -- only for validation; DELETE before submission
	,ctx.event_name -- only for validation; DELETE before submission
	,case
		when ctx.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when ctx.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when ctx.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when ctx.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when ctx.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when ctx.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when ctx.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when ctx.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when ctx.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when ctx.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when ctx.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when ctx.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when ctx.event_name like 'baseline%' then sched_main.sched_base_complete
		when ctx.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when ctx.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when ctx.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when ctx.event_name like '18_month%' then sched_main.sched_18mo_complete
		when ctx.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
  ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
  end as sex
	,case 
        when pfhc.hc_race='1' then 'American Indian or Alaska Native'
        when pfhc.hc_race='2' then 'Asian'
	    	when pfhc.hc_race='3' then 'Native Hawaian or Pacific Islander'
	    	when pfhc.hc_race='4' then 'Black or African American'
    		when pfhc.hc_race='5' then 'White'
    		when pfhc.hc_race='6' then 'Multi-racial'
        else null
  end as race
	,pfhc.hc_hispanic
	,case
		when ctx.event_name like 'baseline%' then 'baseline'
		when ctx.event_name like 'one_month%' then 'one_month'
		when ctx.event_name like 'six_month%' then 'six_month'
		when ctx.event_name like 'one_year%' then 'one_year'
		when ctx.event_name like '18_month%' then '18_month'
		when ctx.event_name like '24_month%' then '24_month'
	end as visit
  ,ctx.ctx_itx       -- Individual therapy: 1 = "No"; 2 = "Yes, but not any longer"; 3 = "Yes, continue to receive individual therapy"
  ,ctx.ctx_iftx      -- Family therapy: 1 = "No"; 2 = "Yes, but not any longer"; 3 = "Yes, continue to receive individual therapy"
  ,ctx.ctx_ipsy_hosp -- Has child been admitted to psych hospital since last visit? 1 = "Yes"; 0 = "No"
  ,ctx.ctx_ipsy_meds -- Psych meds since last visit? 1 = "No"; 2 = "No, recommended but not taken"; 3 = "Yes, but not any longer"; 4 = "Yes, continues to take psych meds"	
from rcap_child_assistance ctx
inner join subject_alias sa1
    on sa1.source_subject_id = ctx.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and ctx.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = ctx.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = ctx.source_subject_id
left join rcap_pfh_child pfhc
    on pfhc.source_subject_id = ctx.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
