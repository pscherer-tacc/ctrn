---- Personal Family History Parent and Adult Child MAIN View
--- Name of the view: pfhparent_adult_ctrn_view
---
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query includes incomplete records which are curated as follows:
--- 	1) Records with NULL schedule [visit]_complete_dates are removed
---     2) Records with NULL dem_ch_dob are removed
---		3) Records with NULL sex are removed
---		4) Duplicate and incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are reported for possible correction and removed
---     5) Variables containing pii/phi and/or unstructured text are removed as per comments below
---     6) Variables used solely for curation/administration are removed as per comments below
---
---- MAIN QUERY
--- Query the data from the view
select
    case
        when pfhc_duplicates.subject_id is not null then 'YES'
        else 'NO'
    end as potential_duplicate,
    pfhpac_view.*
from pfhparent_adult_ctrn_view
left join (
    select subject_id, event_name
    from pfhparent_adult_ctrn_view
    group by subject_id, event_name
    having count(*) > 1
) pfhpac_duplicates
    on pfhpac_duplicates.subject_id = pfhpac_view.subject_id
    and pfhpac_duplicates.event_name = pfhpac_view.event_name
order by
    case
        when pfhpac_duplicates.subject_id is not null then 'YES'
        else 'NO'
    end,
    pfhpac_view.subject_id,
    pfhpac_view.event_name
;
---
-- Query the data from the view:
---merges data from both rcap_pfh_parent and rcap_pfh_adult_child
---where interview_date is not null;

-- The body of the view
---create or replace view pfhparent_adult_ctrn_view
---as 
select
	sa1.subject_id as src_subject_id
	,case
		when hp.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when hp.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when hp.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when hp.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when hp.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when hp.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when hp.event_name like 'baseline%' then sched_main.sched_base_complete
		when hp.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when hp.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when hp.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when hp.event_name like '18_month%' then sched_main.sched_18mo_complete
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
  ,pfhc.hc_hispanic
  ,case
		when hp.event_name like 'baseline%' then '00_baseline'
		when hp.event_name like 'one_month%' then '01_one_month'
		when hp.event_name like 'six_month%' then '06_six_month'
		when hp.event_name like 'one_year%' then '12_month'
		when hp.event_name like '18_month%' then '18_month'
		when hp.event_name like '24_month%' then '24_month'
	end as visit
--- PFH data is potential pii when analyzed in combination; need rules for aggregating/redacting identifying combinatorial data entries.	
	,hp.hp_parent1_relationship
	,hp.hp_bio_mother_race
	,hp.hp_bio_mother_ethnicity
	,hp.hp_bio_father_race
	,hp.hp_bio_father_ethnicity
	,hp.hp_parent_yob
	,hp.hp_parent1_sex
	,hp.hp_parent1_race
	,hp.hp_parent1_hispanic
	,hp.hp_parent1_birth_country
	,hp.hp_parent1_child_relig
	,hp.hp_parent1_relig_now
	,hp.hp_parent1_relig_import
	,hp.hp_parent1_educ
	,hc.hp_parent_relat
	,hp.hp_parent2_yod
	,hp.hp_parent_sep
	,hp.hp_parent_visit
	,hp.hp_parent_relat_status
	,hp.hp_parent2_relat_status
	,hp.hp_parent2_yob
	,hp.hp_parent2_gender as hp_parent2_sex
	,hp.hp_parent2_race
	,hp.hp_parent2_hispanic
	,hp.hp_parent2_birth_country
	,hp.hp_parent2_c_relig
	,hp.hp_parent2_relig_now
	,hp.hp_parent2_relig_import
	,hp.hp_parent2_educ
	,hp.hp_residence
	,hp.hp_residence_child
	,hp.hp_residence_parent1
	,hp.hp_residence_partner
	,hp.hp_residence_gparents
	,hp.hp_residence_siblings
	,hp.hp_residence_other_adults
	,hp.hp_residence_other_children
	,hp.hp_residence_unrelat_adults
	,hp.hp_residence_unrelat_children
	,hp.hp_residence_sum_v2
	,hp.hp_non_residence_siblings
	,hp.hp_sib1_age
	,hp.hp_sib2_age
	,hp.hp_sib3_age
	,hp.hp_sib4_age
	,hp.hp_sib5_age
	,hp.hp_sib6_age
	,hp.hp_pet
    ,hp.hp_pet_type__1_dog
	,hp.hp_pet_type__2_cat
	,hp.hp_pet_type__3_rodent
	,hp.hp_pet_type__4_reptile
	,hp.hp_pet_type__5_fish
	,hp.hp_pet_type__6_other
	,hp.hp_house_income
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
	from rcap_pfh_parent hp                -- Pls check this line; does it include the adult child entries? 
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
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
