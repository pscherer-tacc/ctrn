--- Construct a view to generate output from the DW for Dr. Champagne’s Lab as per the following rqmts:
--- 	Pull baseline data for samples sent to Champagne's lab only (si.si_tube_id ilike '%_1_1'):
---			DOB
---			Date of blood collection
---			Calculated age (in days) at date of blood collection
---			tube_id
---			Sex
---			Smoking status
---			Maternal education (cfhx_parent[1 or 2]_educ AND cfhx_parent[1 or 2]_sex=“female”
---			# traumas → sum(each trauma category X how_often)
---			Worst trauma exposure
---			Age at first trauma exposure
---			Primary diagnosis
---			AUDIT score
---
--- 	Remove any duplicates, pii/phi, and fields not specifically required by the lab

select si_tube_id,
       source_subject_id,
       event_name,
       sched_ctrn_id,
       subject_id,
       project_id,
       id_type,
       sched_base_complete_date,
       dem_ch_dob,
       age_days_between(dem_ch_dob::date, sched_base_complete_date) as age_days,
       sex,
       hp_parent1_relationship,
       hp_parent1_sex,
       hp_parent1_educ,
       --hp_parent2_relationship,
       hp_parent2_gender,
       hp_parent2_educ,
       tlfb_smoke_days,
       tc_1_1,
       tc_1_1_how_often,
       tp_1_1_age_first,
       -- tc_1_1_worst, Worst selections aggregate into tc_8_1
       tc_1_2,
       tc_1_2_how_often,
       tp_1_2_age_first,
       -- tc_1_2_worst,
       tc_1_3,
       tc_1_3_how_often,
       tp_1_3_age_first,
       -- tc_1_3_worst,
       tc_1_4,
       tc_1_4_how_often,
       tp_1_4a_age_first,
       tp_1_4b_age_first,
       -- tc_1_4_worst,
       tc_1_5,
       tc_1_5_how_often,
       tp_1_5_age_first,
       -- tc_1_5_worst,
       tc_1_6,
       tc_1_6_how_often,
       tp_1_6_age_first,
       -- tc_1_6_worst,
       tc_2_1,
       tc_2_1_how_often,
       tp_2_1_age_first,
       -- tc_2_1_worst,
       tc_2_2,
       tc_2_2_how_often,
       tp_2_2_age_first,
       -- tc_2_2_worst,
       tc_2_3,
       tc_2_3_how_often,
       tp_2_3_age_first,
       -- tc_2_3_worst,
       tc_2_4,
       tc_2_4_how_often,
       tp_2_4_age_first,
       -- tc_2_4_worst,
       tc_2_5,
       tc_2_5_how_often,
       tp_2_5_age_first,
       -- tc_2_5_worst,
       tc_3_1,
       tc_3_1_how_often,
       tp_3_1_age_first,
       -- tc_3_1_worst,
       tc_3_2,
       tc_3_2_how_often,
       tp_3_2_age_first,
       -- tc_3_2_worst,
       tc_3_3,
       tc_3_3_how_often,
       tp_3_3_age_first,
       -- tc_3_3_worst,
       tc_4_1,
       tc_4_1_how_often,
       tp_4_1_age_first,
       -- tc_4_1_worst,
       tc_4_2,
       tc_4_2_how_often,
       tp_4_2_age_first,
       tc_4_2_worst,
       tc_4_3,
       tc_4_3_how_often,
       tp_4_3_age_first,
       -- tc_4_3_worst,
       tc_5,
       tc_5_how_often,
       tp_5_1_age_first,
       tp_5_2_age_first,
       -- tc_5_worst,
       tc_6_1,
       tp_6_1_age_first,
       tc_6_2,
       tc_6_2_how_often,
       tp_6_2_age_first,
       tc_7,
       tc_7_how_often,
       tp_7_1_age_first,
       -- tc_7_worst,
       tc_8_1 AS worst,
       age_years_between(tc_8_2::date, dem_ch_dob::date) AS worst_age_yrs,
       tc_8_3 AS most_recent,
       tc_8_3_less_than_1mo, -- "1" indicates that the most recent trauma was less than 1 month prior to this visit 
       age_years_between(tc_8_4::date, dem_ch_dob::date) AS most_recent_trauma_age_yrs, -- Recalculate this into "most_recent_trauma_age_yrs" and remove dates before sharing publicly
       mini_primary_dx,
       audit_score
from rcap_ctau_sample_info_joined_view
where si_tube_id ilike '%_1_1'
and (tc_administrator is not null OR tc_interview_date is not null);





------ Additional queries

-- A query for validtation of the "age_years_between" function
select
    source_subject_id,
    age_years_between(tc_8_2::date, dem_ch_dob::date) AS worst_age_yrs,
    tc_8_2::date,
    dem_ch_dob::date,
    age_years_between(tc_8_4::date, dem_ch_dob::date) AS most_recent_trauma_age_yrs,
    tc_8_4::date,
    dem_ch_dob::date
from rcap_ctau_sample_info_joined_view
where si_tube_id ilike '%_1_1'
and (tc_administrator is not null OR tc_interview_date is not null);