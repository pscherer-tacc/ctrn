CREATE VIEW rcap_ctau_sample_info_joined_view
AS
SELECT si.si_tube_id,
    si.source_subject_id,
    sched.event_name,
    sched.sched_ctrn_id,
    sa.subject_id,
    sa.project_id,
    sa.id_type,
    sched.sched_base_complete, -- NEW FIELD
    sched.sched_base_complete_date,
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
    tlfb.tlfb_smoke_days,
    tc.tc_1_1,
    tc.tc_1_1_how_often,
    tp.tp_1_1_age_first,
    tc.tc_1_1_worst,
    tc.tc_1_2,
    tc.tc_1_2_how_often,
    tp.tp_1_2_age_first,
    tc.tc_1_2_worst,
    tc.tc_1_3,
    tc.tc_1_3_how_often,
    tp.tp_1_3_age_first,
    tc.tc_1_3_worst,
    tc.tc_1_4,
    tc.tc_1_4_how_often,
    tp.tp_1_4a_age_first,
    tp.tp_1_4b_age_first,
    tc.tc_1_4_worst,
    tc.tc_1_5,
    tc.tc_1_5_how_often,
    tp.tp_1_5_age_first,
    tc.tc_1_5_worst,
    tc.tc_1_6,
    tc.tc_1_6_how_often,
    tp.tp_1_6_age_first,
    tc.tc_1_6_worst,
    tc.tc_2_1,
    tc.tc_2_1_how_often,
    tp.tp_2_1_age_first,
    tc.tc_2_1_worst,
    tc.tc_2_2,
    tc.tc_2_2_how_often,
    tp.tp_2_2_age_first,
    tc.tc_2_2_worst,
    tc.tc_2_3,
    tc.tc_2_3_how_often,
    tp.tp_2_3_age_first,
    tc.tc_2_3_worst,
    tc.tc_2_4,
    tc.tc_2_4_how_often,
    tp.tp_2_4_age_first,
    tc.tc_2_4_worst,
    tc.tc_2_5,
    tc.tc_2_5_how_often,
    tp.tp_2_5_age_first,
    tc.tc_2_5_worst,
    tc.tc_3_1,
    tc.tc_3_1_how_often,
    tp.tp_3_1_age_first,
    tc.tc_3_1_worst,
    tc.tc_3_2,
    tc.tc_3_2_how_often,
    tp.tp_3_2_age_first,
    tc.tc_3_2_worst,
    tc.tc_3_3,
    tc.tc_3_3_how_often,
    tp.tp_3_3_age_first,
    tc.tc_3_3_worst,
    tc.tc_4_1,
    tc.tc_4_1_how_often,
    tp.tp_4_1_age_first,
    tc.tc_4_1_worst,
    tc.tc_4_2,
    tc.tc_4_2_how_often,
    tp.tp_4_2_age_first,
    tc.tc_4_2_worst,
    tc.tc_4_3,
    tc.tc_4_3_how_often,
    tp.tp_4_3_age_first,
    tc.tc_4_3_worst,
    tc.tc_5,
    tc.tc_5_how_often,
    tp.tp_5_1_age_first,
    tp.tp_5_2_age_first,
    tc.tc_5_worst,
    tc.tc_6_1,
    tp.tp_6_1_age_first,
    tc.tc_6_2,
    tc.tc_6_2_how_often,
    tp.tp_6_2_age_first,
    tc.tc_7,
    tc.tc_7_how_often,
    tp.tp_7_1_age_first,
    tc.tc_7_worst,
    tc.tc_8_1,
    tc.tc_8_2,
    tc.tc_8_3,
    tc.tc_8_3_less_than_1mo,
    tc.tc_8_4,
    mini.mini_primary_dx,
    aud.audit_score,
    tc.tc_administrator,
    tc.tc_interview_date
FROM rcap_ctau_sample_info si
LEFT JOIN rcap_ctau_scheduling_form sched
    ON sched.source_subject_id = si.source_subject_id
    AND si.event_name LIKE 'baseline%'
    AND sched.event_name LIKE 'baseline%'
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
    AND tlfb.event_name LIKE 'baseline%'
LEFT JOIN rcap_tesic tc 
    ON tc.source_subject_id = sched.sched_ctrn_id
LEFT JOIN rcap_tesip tp 
    ON tp.source_subject_id = sched.sched_ctrn_id
LEFT JOIN rcap_miniss_v2 mini
    ON mini.source_subject_id = sched.sched_ctrn_id
    AND mini.event_name LIKE 'baseline%'
LEFT JOIN rcap_ctau_audit aud
    ON aud.source_subject_id = si.source_subject_id
    AND aud.event_name like 'baseline%'
;