---- TESIP VT View
--- Name of the view: view_vt_tesip

-- Query the data from the view
select * from view_vt_tesip
where interview_date is not null;

-- The body of the view
create or replace view view_vt_tesip
as
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,case
		when tesip.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when tesip.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when tesip.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when tesip.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when tesip.event_name like 'baseline%' then sched_main.sched_base_complete
		when tesip.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when tesip.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when tesip.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when tesip.event_name like '18_month%' then sched.sched_18mo_complete
		when tesip.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,case
        when pfhp.hp_parent1_relationship='0' or pfhp.hp_parent1_relationship is null then -999
        when pfhp.hp_parent1_relationship='1' then 89 -- Biological parent
        when pfhp.hp_parent1_relationship='2' then 92 -- Adoptive parent
        when pfhp.hp_parent1_relationship='3' then 93 -- Foster parent
        when pfhp.hp_parent1_relationship='4' then 91 -- Stepparent
        when pfhp.hp_parent1_relationship='5' then 90 -- Other legal guardian
    end as relationship -- ??? Carefully check all values
    ,tesip.event_name -- ??? So, SHOULD WE OMIT THIS FIELD?
    ,tp_1_1_stem
    --,tp_1_1_accident_type -- omitted 
    --,tp_1_1_victim -- omitted
    ,tp_1_1_any_deaths
    ,tp_1_1_age_first
    ,tp_1_1_age_last
    ,tp_1_1_age_most_stressful
    ,tp_1_1_strongly_affected
    ,tp_1_2_stem
    --,tp_1_2_accident_type -- omitted
    --,tp_1_2_victim -- omitted
    ,tp_1_2_any_deaths
    ,tp_1_2_age_first
    ,tp_1_2_age_last
    ,tp_1_2_age_most_stressful
    ,tp_1_2_strongly_affected
    ,tp_1_3_stem
    --,tp_1_3_disaster_type -- omitted
    ,tp_1_3_any_deaths
    ,tp_1_3_age_first
    ,tp_1_3_age_last
    ,tp_1_3_age_most_stressful
    ,tp_1_3_strongly_affected
    ,tp_1_4a_stem
    --,tp_1_4a_victim -- omitted 
    ,tp_1_4a_age_first
    ,tp_1_4a_age_last
    ,tp_1_4a_age_most_stressful
    ,tp_1_4a_strongly_affected
    ,tp_1_4b_stem
    --,tp_1_4b_victim -- omitted
    ,tp_1_4b_age_first
    ,tp_1_4b_age_last
    ,tp_1_4b_age_most_stressful
    ,tp_1_4b_strongly_affected
    ,tp_1_4b_death_reason__0_natural
    ,tp_1_4b_death_reason__1_illness
    ,tp_1_4b_death_reason__2_accident
    ,tp_1_4b_death_reason__3_violence
    ,tp_1_4b_death_reason__4_unknown
    ,tp_1_5_stem
    --,tp_1_5_describe -- omitted
    ,tp_1_5_age_first
    ,tp_1_5_age_last
    ,tp_1_5_age_most_stressful
    ,tp_1_5_strongly_affected
    ,tp_1_6_stem
    --,tp_1_6_relationship -- omitted
    ,tp_1_6_age_first
    ,tp_1_6_age_last
    ,tp_1_6_age_most_stressful
    ,tp_1_6_strongly_affected
    ,tp_1_7_stem
    --,tp_1_7_relationship -- omitted
    ,tp_1_7_age_first
    ,tp_1_7_age_last
    ,tp_1_7_age_most_stressful
    ,tp_1_7_strongly_affected
    ,tp_2_1_stem
    --,tp_2_1_relationship -- omitted
    ,tp_2_1_weapon
    --,tp_2_1_weapon_type -- omitted
    ,tp_2_1_age_first
    ,tp_2_1_age_last
    ,tp_2_1_age_most_stressful
    ,tp_2_1_strongly_affected
    ,tp_2_2_stem
    --,tp_2_2_relationship -- omitted
    ,tp_2_2_weapon
    --,tp_2_2_weapon_text -- omitted
    ,tp_2_2_age_first
    ,tp_2_2_age_last
    ,tp_2_2_age_most_stressful
    ,tp_2_2_strongly_affected
    ,tp_2_3_stem
    --,tp_2_3_relationship -- omitted
    ,tp_2_3_weapon
    --,tp_2_3_weapon_text -- omitted
    ,tp_2_3_age_first
    ,tp_2_3_age_last
    ,tp_2_3_age_most_stressful
    ,tp_2_3_strongly_affected
    ,tp_2_4_stem
    --,tp_2_4_relationship -- omitted
    --,tp_2_4_kidnapper -- omitted
    ,tp_2_4_age_first
    ,tp_2_4_age_last
    ,tp_2_4_age_most_stressful
    ,tp_2_4_strongly_affected
    ,tp_2_5_stem
    --,tp_2_5_describe -- omitted
    ,tp_2_5_age_first
    ,tp_2_5_age_last
    ,tp_2_5_age_most_stressful
    ,tp_2_5_seriously_hurt
    ,tp_2_5_strongly_affected
    ,tp_3_1_stem
    --,tp_3_1_relationship -- omitted
    ,tp_3_1_weapon
    --,tp_3_1_weapon_text -- omitted
    ,tp_3_1_age_first
    ,tp_3_1_age_last
    ,tp_3_1_age_most_stressful
    ,tp_3_1_strongly_affected
    ,tp_3_2_stem
    --,tp_3_2_relationship -- omitted
    ,tp_3_2_weapon
    --,tp_3_2_weapon_text -- omitted
    ,tp_3_2_age_first
    ,tp_3_2_age_last
    ,tp_3_2_age_most_stressful
    ,tp_3_2_child_present
    ,tp_3_2_strongly_affected
    ,tp_3_3_stem
    --,tp_3_3_relationship -- omitted
    ,tp_3_3_age_first
    ,tp_3_3_age_last
    ,tp_3_3_age_most_stressful
    ,tp_3_3_witness_arrest
    ,tp_3_3_strongly_affected
    ,tp_4_1_stem
    --,tp_4_1_describe -- omitted
    --,tp_4_1_relationship -- omitted
    ,tp_4_1_weapon
    --,tp_4_1_weapon_text -- omitted	
    --,tp_4_1_where -- omitted
    ,tp_4_1_age_first
    ,tp_4_1_age_last
    ,tp_4_1_age_most_stressful
    ,tp_4_1_witness
    ,tp_4_1_strongly_affected
    ,tp_4_2_stem
    --,tp_4_2_describe -- omitted
    ,tp_4_2_age_first
    ,tp_4_2_age_last
    ,tp_4_2_age_most_stressful
    ,tp_4_2_strongly_affected
    ,tp_4_3_stem
    --,tp_4_3_describe -- omitted
    ,tp_4_3_age_first
    ,tp_4_3_age_last
    ,tp_4_3_age_most_stressful
    ,tp_4_3_strongly_affected
    ,tp_5_1_stem
    --,tp_5_1_relationship -- omitted
    ,tp_5_1_violence
    --,tp_5_1_weapon -- omitted
    --, tp_5_1_weapon_text -- omitted
    ,tp_5_1_age_first
    ,tp_5_1_age_last
    ,tp_5_1_age_most_stressful
    --,tp_5_1_witness -- omitted
    ,tp_5_1_strongly_affected
    ,tp_5_2_stem
    --,tp_5_2_relationship -- omitted
    --,tp_5_2_aggressor -- omitted
    ,tp_5_2_violence
    --,tp_5_2_weapon -- omitted
    --,tp_5_2_weapon_text -- omitted
    ,tp_5_2_age_first
    ,tp_5_2_age_last
    ,tp_5_2_age_most_stressful
    ,tp_5_2_strongly_affected
    ,tp_6_1_stem
    --,tp_6_1_relationship -- omitted
    ,tp_6_1_age_first
    ,tp_6_1_age_last
    ,tp_6_1_age_most_stressful
    ,tp_6_1_strongly_affected
    ,tp_6_2_stem
    --,tp_6_2_describe -- omitted
    ,tp_6_2_age_first
    ,tp_6_2_age_last
    ,tp_6_2_age_most_stressful
    ,tp_6_2_strongly_affected
    ,tp_7_1_stem
    --,tp_7_1_describe -- omitted
    ,tp_7_1_age_first
    ,tp_7_1_age_last
    ,tp_7_1_age_most_stressful
    ,tp_7_1_strongly_affected
from rcap_tesip tesip
inner join subject_alias sa1
    on sa1.source_subject_id = tesip.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = tesip.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = tesip.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = tesip.source_subject_id
left join rcap_pfh_parent pfhp -- ??? Doublecheck the fields on which the tables are joined
    on pfhp.source_subject_id = tesip.source_subject_id 
order by sa1.subject_id;