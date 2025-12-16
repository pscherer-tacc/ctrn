CREATE VIEW rcap_ctau_sample_info_joined_view
AS
SELECT si.si_tube_id,
    si.source_subject_id,
    si.event_name,
    sched.sched_ctrn_id,
    sa.subject_id,
    sa.project_id,
    sa.id_type,
    sched.sched_base_complete, -- NEW FIELD
    sched.sched_base_complete_date,
    sched.sched_1yr_date,
    sched.sched_2yr_complete_date,
    dem.dem_ch_dob,
    CASE
        WHEN pfhc.hc_sex_birth_cert::text = '1'::text THEN 'F'::text
        WHEN pfhc.hc_sex_birth_cert::text = '2'::text THEN 'M'::text
        ELSE NULL::text
    END AS sex,
    pfhp.hp_parent1_relationship,
    pfhp.hp_parent1_sex,
    pfhp.hp_parent1_educ,
    pfhp.hp_parent2_gender,
    pfhp.hp_parent2_educ,
    tc.tc_1_1,
    tc.tcfu_1_1,
    tc.tc_1_1_how_often,
    tp.tp_1_1_age_first,
    --tc.tc_1_1_worst,
    tc.tc_1_2,
    tc.tcfu_1_2,
    tc.tc_1_2_how_often,
    tp.tp_1_2_age_first,
    --tc.tc_1_2_worst,
    tc.tc_1_3,
    tc.tcfu_1_3,
    tc.tc_1_3_how_often,
    tp.tp_1_3_age_first,
    --tc.tc_1_3_worst,
    tc.tc_1_4,
    tc.tcfu_1_4,
    tc.tc_1_4_how_often,
    tp.tp_1_4a_age_first,
    tp.tp_1_4b_age_first,
    --tc.tc_1_4_worst,
    tc.tc_1_5,
    tc.tcfu_1_5,
    tc.tc_1_5_how_often,
    tp.tp_1_5_age_first,
    --tc.tc_1_5_worst,
    tc.tc_1_6,
    tc.tcfu_1_6,
    tc.tc_1_6_how_often,
    tp.tp_1_6_age_first,
    --tc.tc_1_6_worst,
    tc.tc_2_1,
    tc.tcfu_2_1,
    tc.tc_2_1_how_often,
    tp.tp_2_1_age_first,
    --tc.tc_2_1_worst,
    tc.tc_2_2,
    tc.tcfu_2_2,
    tc.tc_2_2_how_often,
    tp.tp_2_2_age_first,
    --tc.tc_2_2_worst,
    tc.tc_2_3,
    tc.tcfu_2_3,
    tc.tc_2_3_how_often,
    tp.tp_2_3_age_first,
    --tc.tc_2_3_worst,
    tc.tc_2_4,
    tc.tcfu_2_4,
    tc.tc_2_4_how_often,
    tp.tp_2_4_age_first,
    --tc.tc_2_4_worst,
    tc.tc_2_5,
    tc.tcfu_2_5,
    tc.tc_2_5_how_often,
    tp.tp_2_5_age_first,
    --tc.tc_2_5_worst,
    tc.tc_3_1,
    tc.tcfu_3_1,
    tc.tc_3_1_how_often,
    tp.tp_3_1_age_first,
    --tc.tc_3_1_worst,
    tc.tc_3_2,
    tc.tcfu_3_2,
    tc.tc_3_2_how_often,
    tp.tp_3_2_age_first,
    --tc.tc_3_2_worst,
    tc.tc_3_3,
    tc.tcfu_3_3,
    tc.tc_3_3_how_often,
    tp.tp_3_3_age_first,
    --tc.tc_3_3_worst,
    tc.tc_4_1,
    tc.tcfu_4_1,
    tc.tc_4_1_how_often,
    tp.tp_4_1_age_first,
    --tc.tc_4_1_worst,
    tc.tc_4_2,
    tc.tcfu_4_2,
    tc.tc_4_2_how_often,
    tp.tp_4_2_age_first,
    --tc.tc_4_2_worst,
    tc.tc_4_3,
    tc.tcfu_4_3,
    tc.tc_4_3_how_often,
    tp.tp_4_3_age_first,
    --tc.tc_4_3_worst,
    tc.tc_5,
    tc.tcfu_5,
    tc.tc_5_how_often,
    tp.tp_5_1_age_first,
    tp.tp_5_2_age_first,
    --tc.tc_5_worst,
    tc.tc_6_1,
    tc.tcfu_6_1,
    tp.tp_6_1_age_first,
    tc.tc_6_2,
    tc.tcfu_6_2,
    tc.tc_6_2_how_often,
    tp.tp_6_2_age_first,
    tc.tc_7,
    tc.tcfu_7,
    tc.tc_7_how_often,
    tp.tp_7_1_age_first,
    --tc.tc_7_worst,
    tc.tc_8_1,
    tc.tc_8_2,
    tc.tc_8_3,
    tc.tcfu_8_3,
    tc.tc_8_3_less_than_1mo,
    tc.tc_8_4,
    mini.mini_primary_dx,
    tc.tc_administrator,
    tc.tc_interview_date,
    tlfb.tlfb_drink_mo,
	tlfb.tlfb_drink_days,
	tlfb.tlfb_drink_per_day,
	tlfb.tlfb_hv_ep_dr_days,
	tlfb.tlfb_24_max,
	tlfb.tlfb_cig_mo,
    tlfb.tlfb_smoke_days,
	tlfb.tlfb_cig_per_day,
	tlfb.tlfb_thc_days,
    aud.audit_q1_sc,
	aud.audit_q2_sc,
	aud.audit_q3_sc,
	aud.audit_q4_sc,
	aud.audit_q5_sc,
	aud.audit_q6_sc,
	aud.audit_q7_sc,
	aud.audit_q8_sc,
	aud.audit_q9_sc,
	aud.audit_q10_sc,
    aud.audit_score,
    sui.sui_1,
	sui.sui_2,
	sui.sui_3,
	sui.sui_4, 
	sui.sui_5,
	sui.sui_6,
	sui.sui_7,
	sui.sui_8,
    deq.deq_alc_use_dt,   ---should these be converted to deq_age_last_alc? (Not converted in the NDA)
	deq.deq_alc_last_amt,
	deq.deq_alc_dur,
	deq.deq_alc_mem_diff,
	deq.deq_alc_blackout,
	deq.deq_alc_hungover,
	deq.deq_alc_effects,
	deq.deq_alc_effects_2,
	deq.deq_alc_effects_3,
	deq.deq_alc_effects_4,
	deq.deq_drug_use_dt,   ---should these be converted to deq_age_last_drug? (Not converted in the NDA)
	deq.deq_drug_mdma,
	deq.deq_drug_heroin,
	deq.deq_drug_cocaine, 
	deq.deq_drug_crack,
	deq.deq_drug_k,
	deq.deq_drug_meth,
	deq.deq_drug_pain,
	deq.deq_drug_stim,
	deq.deq_drug_k2,
	deq.deq_drug_benzos, 
	deq.deq_drug_none,
	deq.deq_drugs_dur,
	deq.deq_drugs_snort,
	deq.deq_drugs_inject,
	deq.deq_drugs_smoke,
	deq.deq_drugs_oral,
	deq.deq_drugs_other,
	deq.deq_drugs_mem_diff,
	deq.deq_drugs_blackout,
	deq.deq_drugs_hungover,
	deq.deq_drugs_effects,
	deq.deq_drugs_effects_2,
	deq.deq_drugs_effects_3
FROM rcap_ctau_sample_info si
LEFT JOIN ctau_scheduling_form_view sched -- Attention! The view (not the table) is utilized
    ON sched.source_subject_id = si.source_subject_id
INNER JOIN subject_alias sa
    ON sa.source_subject_id = si.source_subject_id
    AND sa.project_id = 2515 -- CTAU only
LEFT JOIN rcap_ctau_dem dem 
    ON dem.source_subject_id = si.source_subject_id
LEFT JOIN rcap_pfh_child pfhc 
    ON pfhc.source_subject_id = sched.sched_ctrn_id
LEFT JOIN rcap_pfh_parent pfhp 
    ON pfhp.source_subject_id = sched.sched_ctrn_id
LEFT JOIN rcap_ctau_tlfb tlfb
    ON tlfb.source_subject_id = si.source_subject_id
    AND tlfb.event_name = si.event_name
LEFT JOIN view_tesic_union tc -- Attention! The view (not the table) is utilized
    ON tc.source_subject_id = sched.sched_ctrn_id
    AND tc.event_name = si.event_name -- !!!!! Doublecheck this condition
LEFT JOIN rcap_tesip tp 
    ON tp.source_subject_id = sched.sched_ctrn_id
LEFT JOIN rcap_miniss_v2 mini
    ON mini.source_subject_id = sched.sched_ctrn_id
    AND mini.event_name = si.event_name
LEFT JOIN rcap_ctau_audit aud
    ON aud.source_subject_id = si.source_subject_id
    AND aud.event_name = si.event_name
LEFT JOIN rcap_ctau_deq deq
    ON deq.source_subject_id = si.source_subject_id
    AND deq.event_name = si.event_name
LEFT JOIN rcap_ctau_sui sui
    ON sui.source_subject_id = si.source_subject_id
    AND sui.event_name = si.event_name
;



------ BASELINE ONLY
-- FROM rcap_ctau_sample_info si
-- LEFT JOIN rcap_ctau_scheduling_form sched
--     ON sched.source_subject_id = si.source_subject_id
--     AND si.event_name LIKE 'baseline%'
--     AND sched.event_name LIKE 'baseline%'
-- INNER JOIN subject_alias sa
--     ON sa.source_subject_id = si.source_subject_id
--     AND sa.project_id = 2515 -- CTAU only
-- LEFT JOIN rcap_ctau_dem dem 
--     ON dem.source_subject_id = si.source_subject_id
-- LEFT JOIN rcap_pfh_child pfhc 
--     ON pfhc.source_subject_id = sched.sched_ctrn_id
-- LEFT JOIN rcap_pfh_parent pfhp 
--     ON pfhp.source_subject_id = sched.sched_ctrn_id
-- LEFT JOIN rcap_ctau_tlfb tlfb
--     ON tlfb.source_subject_id = si.source_subject_id
--     AND tlfb.event_name LIKE 'baseline%'
-- LEFT JOIN rcap_tesic tc 
--     ON tc.source_subject_id = sched.sched_ctrn_id
-- LEFT JOIN rcap_tesip tp 
--     ON tp.source_subject_id = sched.sched_ctrn_id
-- LEFT JOIN rcap_miniss_v2 mini
--     ON mini.source_subject_id = sched.sched_ctrn_id
--     AND mini.event_name LIKE 'baseline%'
-- LEFT JOIN rcap_ctau_audit aud
--     ON aud.source_subject_id = si.source_subject_id
--     AND aud.event_name like 'baseline%'
-- ;
