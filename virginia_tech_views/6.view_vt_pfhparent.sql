---- Personal Family History Parent VT View
--- Name of the view: view_vt_pfhparent

-- Query the data from the view:
---select * from view_vt_pfhparent
---where interview_date is not null;

-- The body of the view
---create or replace view view_vt_pfhparent
---as 
select
	sa1.subject_id as src_subject_id
	,case
		when hp.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when hp.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when hp.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when hp.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when hp.event_name like 'baseline%' then sched_main.sched_base_complete
		when hp.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when hp.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when hp.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when hp.event_name like '18_month%' then sched_main.sched_18mo_complete
		when hp.event_name like '24_month%' then sched_main.sched_2yr_complete
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
	,case
		when hp.event_name like 'baseline%' then 'baseline'
		when hp.event_name like 'one_month%' then 'one_month'
		when hp.event_name like 'six_month%' then 'six_month'
		when hp.event_name like 'one_year%' then 'one_year'
		when hp.event_name like '18_month%' then '18_month'
		when hp.event_name like '24_month%' then '24_month'
	end as visit
	,hp.hp_dep__0_child
	,hp.hp_dep__1_you
	,hp.hp_dep__2_othpar
	,hp.hp_dep__3_brother
	,hp.hp_dep__4_sister
	,hp.hp_ad__0_child
	,hp.hp_ad__1_you
	,hp.hp_ad__2_othpar
	,hp.hp_ad__3_brother
	,hp.hp_ad__4_sister
	,hp.hp_bipolar__0_child
	,hp.hp_bipolar__1_you
	,hp.hp_bipolar__2_othpar
	,hp.hp_bipolar__3_brother
	,hp.hp_bipolar__4_sister
	,hp.hp_ptsd__0_child
	,hp.hp_ptsd__1_you
	,hp.hp_ptsd__2_othpar
	,hp.hp_ptsd__3_brother
	,hp.hp_ptsd__4_sister
	,hp.hp_schiz__0_child
	,hp.hp_schiz__1_you
	,hp.hp_schiz__2_othpar
	,hp.hp_schiz__3_brother
	,hp.hp_schiz__4_sister
	,hp.hp_autism__0_child
	,hp.hp_autism__1_you
	,hp.hp_autism__2_othpar
	,hp.hp_autism__3_brother
	,hp.hp_autism__4_sister
	,hp.hp_add__0_child
	,hp.hp_add__1_you
	,hp.hp_add__2_othpar
	,hp.hp_add__3_brother
	,hp.hp_add__4_sister
	,hp.hp_alc_abuse__0_child
	,hp.hp_alc_abuse__1_you
	,hp.hp_alc_abuse__2_othpar
	,hp.hp_alc_abuse__3_brother
	,hp.hp_alc_abuse__4_sister
	,hp.hp_thc_abuse__0_child
	,hp.hp_thc_abuse__1_you
	,hp.hp_thc_abuse__2_othpar
	,hp.hp_thc_abuse__3_brother
	,hp.hp_thc_abuse__4_sister
	,hp.hp_drug_abuse__0_child
	,hp.hp_drug_abuse__1_you
	,hp.hp_drug_abuse__2_othpar
	,hp.hp_drug_abuse__3_brother
	,hp.hp_drug_abuse__4_sister
	,hp.hp_exp_to_trauma__0_child
	,hp.hp_exp_to_trauma__1_you
	,hp.hp_exp_to_trauma__2_othpar
	,hp.hp_exp_to_trauma__3_brother
	,hp.hp_exp_to_trauma__4_sister
	,hp.hp_suicide_att__0_child
	,hp.hp_suicide_att__1_you
	,hp.hp_suicide_att__2_othpar
	,hp.hp_suicide_att__3_brother
	,hp.hp_suicide_att__4_sister
	,hp.hp_suicide_death__0_child
	,hp.hp_suicide_death__1_you
	,hp.hp_suicide_death__2_othpar
	,hp.hp_suicide_death__3_brother
	,hp.hp_suicide_death__4_sister
	from rcap_pfh_parent hp
inner join subject_alias sa1
    on sa1.source_subject_id = hp.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and hp.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = hp.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = hp.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = hp.source_subject_id
order by sa1.subject_id;
