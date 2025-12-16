--- Construct a view to generate output from the DW for Dr. Ressler's Genetics Lab and Dr. Champagne’s Epigenomics Lab as per the following rqmts:
--- 	Pull data (all events) for samples sent to Ressler's lab only (si.si_tube_id ilike '%_2_1'):
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

select si_tube_id,
       source_subject_id,
       event_name,
       sched_ctrn_id,
       subject_id,
       project_id,
       id_type,
       case
        when event_name like 'baseline%' then sched_base_complete_date
        when event_name like 'one_year%' then sched_1yr_date
        when event_name like '24_month%' then sched_2yr_complete_date
       end as sched_visit_complete_date,
       dem_ch_dob,
       case 
        when event_name like 'baseline%' then age_days_between(dem_ch_dob::date, sched_base_complete_date)
        when event_name like 'one_year%' then age_days_between(dem_ch_dob::date, sched_1yr_date)
        when event_name like '24_month%' then age_days_between(dem_ch_dob::date, sched_2yr_complete_date)
       end as age_days, -- NEW FIELD
       sex,
       hp_parent1_relationship,
       hp_parent1_sex,
       hp_parent1_educ,
       --hp_parent2_relationship,
       hp_parent2_gender,
       hp_parent2_educ,
	   tlfb_drink_mo,
	   tlfb_drink_days,
	   tlfb_drink_per_day,
	   tlfb_hv_ep_dr_days,
	   tlfb_24_max,
	   tlfb_cig_mo,
       tlfb_smoke_days,
	   tlfb_cig_per_day,
	   tlfb_thc_days,
       tc_1_1,
       tcfu_1_1,
       tc_1_1_how_often,
       tp_1_1_age_first,
       -- tc_1_1_worst, Worst selections aggregate into tc_8_1
       tc_1_2,
       tcfu_1_2,
       tc_1_2_how_often,
       tp_1_2_age_first,
       -- tc_1_2_worst,
       tc_1_3,
       tcfu_1_3,
       tc_1_3_how_often,
       tp_1_3_age_first,
       -- tc_1_3_worst,
       tc_1_4,
       tcfu_1_4,
       tc_1_4_how_often,
       tp_1_4a_age_first,
       tp_1_4b_age_first,
       -- tc_1_4_worst,
       tc_1_5,
       tcfu_1_5,
       tc_1_5_how_often,
       tp_1_5_age_first,
       -- tc_1_5_worst,
       tc_1_6,
       tcfu_1_6,
       tc_1_6_how_often,
       tp_1_6_age_first,
       -- tc_1_6_worst,
       tc_2_1,
       tcfu_2_1,
       tc_2_1_how_often,
       tp_2_1_age_first,
       -- tc_2_1_worst,
       tc_2_2,
       tcfu_2_2,
       tc_2_2_how_often,
       tp_2_2_age_first,
       -- tc_2_2_worst,
       tc_2_3,
       tcfu_2_3,
       tc_2_3_how_often,
       tp_2_3_age_first,
       -- tc_2_3_worst,
       tc_2_4,
       tcfu_2_4,
       tc_2_4_how_often,
       tp_2_4_age_first,
       -- tc_2_4_worst,
       tc_2_5,
       tcfu_2_5,
       tc_2_5_how_often,
       tp_2_5_age_first,
       -- tc_2_5_worst,
       tc_3_1,
       tcfu_3_1,
       tc_3_1_how_often,
       tp_3_1_age_first,
       -- tc_3_1_worst,
       tc_3_2,
       tcfu_3_2,
       tc_3_2_how_often,
       tp_3_2_age_first,
       -- tc_3_2_worst,
       tc_3_3,
       tcfu_3_3,
       tc_3_3_how_often,
       tp_3_3_age_first,
       -- tc_3_3_worst,
       tc_4_1,
       tcfu_4_1,
       tc_4_1_how_often,
       tp_4_1_age_first,
       -- tc_4_1_worst,
       tc_4_2,
       tcfu_4_2,
       tc_4_2_how_often,
       tp_4_2_age_first,
       --tc_4_2_worst,
       tc_4_3,
       tcfu_4_3,
       tc_4_3_how_often,
       tp_4_3_age_first,
       -- tc_4_3_worst,
       tc_5,
       tcfu_5,
       tc_5_how_often,
       tp_5_1_age_first,
       tp_5_2_age_first,
       -- tc_5_worst,
       tc_6_1,
       tcfu_6_1,
       tp_6_1_age_first,
       tc_6_2,
       tcfu_6_2,
       tc_6_2_how_often,
       tp_6_2_age_first,
       tc_7,
       tcfu_7,
       tc_7_how_often,
       tp_7_1_age_first,
       -- tc_7_worst,
       tc_8_1 AS worst,          -- This contains unstructured text which needs to be deidentified or removed prior to public sharing
       age_years_between(tc_8_2::date, dem_ch_dob::date) AS worst_age_yrs,
       tc_8_3 AS most_recent,    -- This contains unstructured text which needs to be deidentified or removed prior to public sharing
       tc_8_3_less_than_1mo,     -- "1" indicates that the most recent trauma was less than 1 month prior to this visit 
       age_years_between(tc_8_4::date, dem_ch_dob::date) AS most_recent_trauma_age_yrs, -- Recalculate this into "most_recent_trauma_age_yrs" and remove dates before sharing publicly
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
---where si_tube_id ilike '%_1_1' -- Samples sent to Dr. Champagne's Epigenomics Lab
where si_tube_id ilike '%_2_1'	-- Samples sent to Dr. Ressler's Genetics Lab
---where si_tube_id ilike '%_3_1'	-- Samples sent to Dr. Beurel's Cytokines Lab	 			
order by
        case 
         when event_name like 'baseline%' then 1
         when event_name like 'one_year%' then 2
         when event_name like '24_month' then 3 
        end
        ,source_subject_id
;




