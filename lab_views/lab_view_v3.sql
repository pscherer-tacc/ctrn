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
---			Request on 11/25/25 to add information from TLFB, SUI, DEQ and AUDIT 
---
--- 	Remove any duplicates, pii/phi, and fields not specifically required by the lab
---     Specimens sent to Drs Champagne (Epigenomics tube_ids ending in 1_1), Ressler (Genetics tube_ids ending in 2_1),
---     and Beurel (Cytokines tube_ids ending in 3_1). Genetics lab only requires baseline data; epigenomics and cytokine labs
---     require data from all (follow-up) sample collections.
---
--- March 2026 request to expand the above with:

--- DONE	       - Race and hispanic from pfhc
--- DONE	       - Time since worst and most recent trauma (tc_8_1_less_than_1mo; tc_8_3_less_than_1mo,…
--- DONE(partially)	- Substance use in the family (pfhp_alc_abuse, pfhp_thc_abuse, pfhp_drug_abuse,  baseline) – from the pfh_parent
--- DONE(partially)  - and (pfha_alc_abuse_18, pfha_thc_abuse_18, pfhp_drug_abuse_18,  baseline) – from the pfh_adult_child instruments
--- DONE 	       - Follow-up treatment (Interval_tx, Interval_fam_tx, Interval_psych_hosp, and Interval_psych_meds) - from child_assistance_and_treatment

select si_tube_id,
       source_subject_id,
       event_name,
       sched_ctrn_id,
       subject_id,
       project_id,
       id_type,
       sched_base_complete_date,
       dem_ch_dob,
       case 
              when event_name like 'baseline%' then age_days_between(dem_ch_dob::date, sched_base_complete_date)
              when event_name like 'one_year%' then age_days_between(dem_ch_dob::date, sched_1yr_date)
              when event_name like '24_month%' then age_days_between(dem_ch_dob::date, sched_2yr_complete_date)
       end as age_days,
       case
             when event_name like 'baseline%' then sched_base_complete
             when event_name like 'one_year%' then sched_1yr_complete
             when event_name like '24_month%' then sched_2yr_complete
       end as complete,
       sex,
	   hc_race as race,
	   hc_hispanic as hispanic,
       pfh_instrument,
       parent1_relationship,
       parent1_sex,
       parent1_educ,
       --hp_parent2_relationship,
       parent2_gender,
       parent2_educ,
	   tlfb_drink_mo,
	   tlfb_drink_days,
	   tlfb_drink_per_day,
	   tlfb_hv_ep_dr_days,
	   tlfb_24_max,
	   tlfb_cig_mo,
       tlfb_smoke_days,
	   tlfb_cig_per_day,
	   tlfb_thc_days,
       -- alc_abuse fields; experiment with an aggregate form.
       alc_abuse__0_child,
       alc_abuse__1_you,
       alc_abuse__2_othpar,
       alc_abuse__3_brother,
       alc_abuse__4_sister,
       -- thc_abuse fields; experiment with an aggregate form.
       thc_abuse__0_child,
       thc_abuse__1_you,
       thc_abuse__2_othpar,
       thc_abuse__3_brother,
       thc_abuse__4_sister,
       -- drug_abuse fields; experiment with an aggregate form.
       drug_abuse__0_child,
       drug_abuse__1_you,
       drug_abuse__2_othpar,
       drug_abuse__3_brother,
       drug_abuse__4_sister,
       coalesce (tc_1_1, tcfu_1_1) as tc_1_1,
       tc_1_1_how_often,
       tp_1_1_age_first,
       -- tc_1_1_worst, Worst selections aggregate into tc_8_1
       coalesce (tc_1_2, tcfu_1_2) as tc_1_2,
       tc_1_2_how_often,
       tp_1_2_age_first,
       -- tc_1_2_worst,
       coalesce (tc_1_3, tcfu_1_3) as tc_1_3,
       tc_1_3_how_often,
       tp_1_3_age_first,
       -- tc_1_3_worst,
       coalesce (tc_1_4, tcfu_1_4) as tc_1_4,
       tc_1_4_how_often,
       tp_1_4a_age_first,
       tp_1_4b_age_first,
       -- tc_1_4_worst,
       coalesce (tc_1_5, tcfu_1_5) as tc_1_5,
       tc_1_5_how_often,
       tp_1_5_age_first,
       -- tc_1_5_worst,
       coalesce (tc_1_6, tcfu_1_6) as tc_1_6,
       tc_1_6_how_often,
       tp_1_6_age_first,
       -- tc_1_6_worst,
       coalesce (tc_2_1, tcfu_2_1) as tc_2_1,
       tc_2_1_how_often,
       tp_2_1_age_first,
       -- tc_2_1_worst,
       coalesce (tc_2_2, tcfu_2_2) as tc_2_2,
       tc_2_2_how_often,
       tp_2_2_age_first,
       -- tc_2_2_worst,
       coalesce (tc_2_3, tcfu_2_3) as tc_2_3,
       tc_2_3_how_often,
       tp_2_3_age_first,
       -- tc_2_3_worst,
       coalesce (tc_2_4, tcfu_2_4) as tc_2_4,
       tc_2_4_how_often,
       tp_2_4_age_first,
       -- tc_2_4_worst,
       coalesce (tc_2_5, tcfu_2_5) as tc_2_5,
       tc_2_5_how_often,
       tp_2_5_age_first,
       -- tc_2_5_worst,
       coalesce (tc_3_1, tcfu_3_1) as tc_3_1,
       tc_3_1_how_often,
       tp_3_1_age_first,
       -- tc_3_1_worst,
       coalesce (tc_3_2, tcfu_3_2) as tc_3_2,
       tc_3_2_how_often,
       tp_3_2_age_first,
       -- tc_3_2_worst,
       coalesce (tc_3_3, tcfu_3_3) as tc_3_3,
       tc_3_3_how_often,
       tp_3_3_age_first,
       -- tc_3_3_worst,
       coalesce (tc_4_1, tcfu_4_1) as tc_4_1,
       tc_4_1_how_often,
       tp_4_1_age_first,
       -- tc_4_1_worst,
       coalesce (tc_4_2, tcfu_4_2) as tc_4_2,
       tc_4_2_how_often,
       tp_4_2_age_first,
       -- tc_4_2_worst,
       coalesce (tc_4_3, tcfu_4_3) as tc_4_3,
       tc_4_3_how_often,
       tp_4_3_age_first,
       -- tc_4_3_worst,
       coalesce (tc_5, tcfu_5) as tc_5,
       tc_5_how_often,
       tp_5_1_age_first,
       tp_5_2_age_first,
       -- tc_5_worst,
       coalesce (tc_6_1, tcfu_6_1) as tc_6_1,
       tp_6_1_age_first,
       coalesce (tc_6_2, tcfu_6_2) as tc_6_2,
       tc_6_2_how_often,
       tp_6_2_age_first,
       coalesce (tc_7, tcfu_7) as tc_7,
       tc_7_how_often,
       tp_7_1_age_first,
       -- tc_7_worst,
       tc_8_1 AS worst,
       tc_8_1_less_than_1mo,
       age_years_between(tc_8_2::date, dem_ch_dob::date) AS worst_age_yrs,
	   age_days_between(tc_8_2::date, tc_interview_date::date) AS worst_days_b4visit,
       tc_8_3 AS most_recent,
       tc_8_3_less_than_1mo, -- "1" indicates that the most recent trauma was less than 1 month prior to this visit 
       age_years_between(tc_8_4::date, dem_ch_dob::date) AS most_recent_trauma_age_yrs, -- Remove dates before sharing publicly
       age_days_between(tc_8_4::date, tc_interview_date::date) AS recent_days_b4visit,
	   ctx_itx,
	   ctx_iftx,
       ctx_ipsy_hosp,
	   ctx_ipsy_meds,
	   mini_primary_dx,
       audit_q1_sc,
	   audit_q2_sc,
	   audit_q3_sc,
	   audit_q4_sc,
	   audit_q5_sc,
	   audit_q6_sc,
	   audit_q7_sc,
	   audit_q8_sc,
	   audit_q9_sc,
	   audit_q10_sc,
       audit_score, 
	   sui_1,
	   sui_2,
	   sui_3,
	   sui_4, 
	   sui_5,
	   sui_6,		         -- This contains unstructured text which needs to be deidentified or removed prior to public sharing
	   sui_7,
	   sui_8,
       age_years_between(deq_alc_use_dt::date, dem_ch_dob::date) as deq_age_last_alc, -- NEW FIELD
       case
        when event_name like 'baseline%' then age_days_between(deq_alc_use_dt::date, sched_base_complete_date)
        when event_name like 'one_year%' then age_days_between(deq_alc_use_dt::date, sched_1yr_date)
        when event_name like '24_month%' then age_days_between(deq_alc_use_dt::date, sched_2yr_complete_date)
       end as deq_days_since_last_alc, -- NEW FIELD   
	   deq_alc_last_amt,
	   deq_alc_dur,
	   deq_alc_mem_diff,
	   deq_alc_blackout,
	   deq_alc_hungover,
	   deq_alc_effects,
	   deq_alc_effects_2,
	   deq_alc_effects_3,
	   deq_alc_effects_4,
	   age_years_between(deq_drug_use_dt::date, dem_ch_dob::date) as deq_age_last_drug, -- NEW FIELD
       case
        when event_name like 'baseline%' then age_days_between(deq_drug_use_dt::date, sched_base_complete_date)
        when event_name like 'one_year%' then age_days_between(deq_drug_use_dt::date, sched_1yr_date)
        when event_name like '24_month%' then age_days_between(deq_drug_use_dt::date, sched_2yr_complete_date)
       end as deq_days_since_last_drug, -- NEW FIELD
       deq_drug_mdma,
	   deq_drug_heroin,
	   deq_drug_cocaine, 
	   deq_drug_crack,
	   deq_drug_k,
	   deq_drug_meth,
	   deq_drug_pain,
	   deq_drug_stim,
	   deq_drug_k2,
	   deq_drug_benzos, 
	   deq_drug_none,
	   deq_drugs_dur,
	   deq_drugs_snort,
	   deq_drugs_inject,
	   deq_drugs_smoke,
	   deq_drugs_oral,
	   deq_drugs_other,
	   deq_drugs_mem_diff,
	   deq_drugs_blackout,
	   deq_drugs_hungover,
	   deq_drugs_effects,
	   deq_drugs_effects_2,
	   deq_drugs_effects_3
from rcap_ctau_sample_info_joined_view
where si_tube_id ilike '%_1_1'
and (tc_administrator is not null OR tc_interview_date is not null);
