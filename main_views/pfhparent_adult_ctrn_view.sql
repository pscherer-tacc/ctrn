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
        when pfh_acp_duplicates.src_subject_id is not null then 'YES'
        else 'NO'
    end as potential_duplicate,
    pfh_acp_view.*
from pfh_adult_child_parent_view pfh_acp_view
left join (
    select src_subject_id, event_name
    from pfh_adult_child_parent_view
    group by src_subject_id, event_name
    having count(*) > 1
) pfh_acp_duplicates
    on pfh_acp_duplicates.src_subject_id = pfh_acp_view.src_subject_id
    and pfh_acp_duplicates.event_name = pfh_acp_view.event_name
order by
    case
        when pfh_acp_duplicates.src_subject_id is not null then 'YES'
        else 'NO'
    end,
    pfh_acp_view.src_subject_id,
    pfh_acp_view.event_name
;


-- The body of the view
create or replace view pfh_adult_child_parent_view
as 
select
	sa1.subject_id as src_subject_id
	,pfh_acp.event_name
	,case
		when pfh_acp.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when pfh_acp.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when pfh_acp.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when pfh_acp.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when pfh_acp.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when pfh_acp.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when pfh_acp.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when pfh_acp.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when pfh_acp.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when pfh_acp.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when pfh_acp.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when pfh_acp.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when pfh_acp.event_name like 'baseline%' then sched_main.sched_base_complete
		when pfh_acp.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when pfh_acp.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when pfh_acp.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when pfh_acp.event_name like '18_month%' then sched_main.sched_18mo_complete
		when pfh_acp.event_name like '24_month%' then sched_main.sched_2yr_complete
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
		when pfh_acp.event_name like 'baseline%' then '00_baseline'
		when pfh_acp.event_name like 'one_month%' then '01_one_month'
		when pfh_acp.event_name like 'six_month%' then '06_six_month'
		when pfh_acp.event_name like 'one_year%' then '12_month'
		when pfh_acp.event_name like '18_month%' then '18_month'
		when pfh_acp.event_name like '24_month%' then '24_month'
	end as visit
--- PFH data is potential pii when analyzed in combination; need rules for aggregating/redacting identifying combinatorial data entries.
	,pfh_acp.instrument	
	,pfh_acp.parent1_relationship
	,pfh_acp.bio_mother_race
	,pfh_acp.bio_mother_ethnicity
	,pfh_acp.bio_father_race
	,pfh_acp.bio_father_ethnicity
	,pfh_acp.parent_yob
	,pfh_acp.parent1_sex
	,pfh_acp.parent1_race
	,pfh_acp.parent1_hispanic
	,pfh_acp.parent1_birth_country
	,pfh_acp.parent1_child_relig
	,pfh_acp.parent1_relig_now
	,pfh_acp.parent1_relig_import
	,pfh_acp.parent1_educ
	,pfh_acp.parent_relat
	,pfh_acp.parent2_yod
	,pfh_acp.parent_sep
	,pfh_acp.parent_visit
	,pfh_acp.parent_relat_status
	,pfh_acp.parent2_relat_status
	,pfh_acp.parent2_yob
	,pfh_acp.parent2_gender as parent2_sex
	,pfh_acp.parent2_race
	,pfh_acp.parent2_hispanic
	,pfh_acp.parent2_birth_country
	,pfh_acp.parent2_c_relig
	,pfh_acp.parent2_relig_now
	,pfh_acp.parent2_relig_import
	,pfh_acp.parent2_educ
	,pfh_acp.residence
	,pfh_acp.residence_child
	,pfh_acp.residence_parent1
	,pfh_acp.residence_partner
	,pfh_acp.residence_gparents
	,pfh_acp.residence_siblings
	,pfh_acp.residence_other_adults
	,pfh_acp.residence_other_children
	,pfh_acp.residence_unrelat_adults
	,pfh_acp.residence_unrelat_children
	,pfh_acp.residence_sum_v2
	,pfh_acp.non_residence_siblings
	,pfh_acp.sib1_age
	,pfh_acp.sib2_age
	,pfh_acp.sib3_age
	,pfh_acp.sib4_age
	,pfh_acp.sib5_age
	,pfh_acp.sib6_age
	,pfh_acp.pet
    ,pfh_acp.pet_type__1_dog
	,pfh_acp.pet_type__2_cat
	,pfh_acp.pet_type__3_rodent
	,pfh_acp.pet_type__4_reptile
	,pfh_acp.pet_type__5_fish
	,pfh_acp.pet_type__6_other
	,pfh_acp.house_income
	,pfh_acp.dep__0_child
	,pfh_acp.dep__1_you
	,pfh_acp.dep__2_othpar
	,pfh_acp.dep__3_brother
	,pfh_acp.dep__4_sister
	,pfh_acp.ad__0_child
	,pfh_acp.ad__1_you
	,pfh_acp.ad__2_othpar
	,pfh_acp.ad__3_brother
	,pfh_acp.ad__4_sister
	,pfh_acp.bipolar__0_child
	,pfh_acp.bipolar__1_you
	,pfh_acp.bipolar__2_othpar
	,pfh_acp.bipolar__3_brother
	,pfh_acp.bipolar__4_sister
	,pfh_acp.ptsd__0_child
	,pfh_acp.ptsd__1_you
	,pfh_acp.ptsd__2_othpar
	,pfh_acp.ptsd__3_brother
	,pfh_acp.ptsd__4_sister
	,pfh_acp.schiz__0_child
	,pfh_acp.schiz__1_you
	,pfh_acp.schiz__2_othpar
	,pfh_acp.schiz__3_brother
	,pfh_acp.schiz__4_sister
	,pfh_acp.autism__0_child
	,pfh_acp.autism__1_you
	,pfh_acp.autism__2_othpar
	,pfh_acp.autism__3_brother
	,pfh_acp.autism__4_sister
	,pfh_acp.add__0_child
	,pfh_acp.add__1_you
	,pfh_acp.add__2_othpar
	,pfh_acp.add__3_brother
	,pfh_acp.add__4_sister
	,pfh_acp.alc_abuse__0_child
	,pfh_acp.alc_abuse__1_you
	,pfh_acp.alc_abuse__2_othpar
	,pfh_acp.alc_abuse__3_brother
	,pfh_acp.alc_abuse__4_sister
	,pfh_acp.thc_abuse__0_child
	,pfh_acp.thc_abuse__1_you
	,pfh_acp.thc_abuse__2_othpar
	,pfh_acp.thc_abuse__3_brother
	,pfh_acp.thc_abuse__4_sister
	,pfh_acp.drug_abuse__0_child
	,pfh_acp.drug_abuse__1_you
	,pfh_acp.drug_abuse__2_othpar
	,pfh_acp.drug_abuse__3_brother
	,pfh_acp.drug_abuse__4_sister
	,pfh_acp.exp_to_trauma__0_child
	,pfh_acp.exp_to_trauma__1_you
	,pfh_acp.exp_to_trauma__2_othpar
	,pfh_acp.exp_to_trauma__3_brother
	,pfh_acp.exp_to_trauma__4_sister
	,pfh_acp.suicide_att__0_child
	,pfh_acp.suicide_att__1_you
	,pfh_acp.suicide_att__2_othpar
	,pfh_acp.suicide_att__3_brother
	,pfh_acp.suicide_att__4_sister
	,pfh_acp.suicide_death__0_child
	,pfh_acp.suicide_death__1_you
	,pfh_acp.suicide_death__2_othpar
	,pfh_acp.suicide_death__3_brother
	,pfh_acp.suicide_death__4_sister
from view_pfh_adult_child_parent_union pfh_acp                -- Pls check this line; does it include the adult child entries? 
inner join subject_alias sa1
    on sa1.source_subject_id = pfh_acp.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and pfh_acp.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = pfh_acp.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = pfh_acp.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = pfh_acp.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
