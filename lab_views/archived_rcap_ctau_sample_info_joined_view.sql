/*

!!!!!!!!!!!!!! ATTENTION !!!!!!!!!!!!!!
This is a script for the first version of the rcap_ctau_sample_info_joined_view developed by Tomislav U. 
It is now deprecated and substituted by the rcap_ctau_sample_info_joined_view_new.sql script.

*/

create view public.rcap_ctau_sample_info_joined_view
            (si_tube_id, source_subject_id, event_name, sched_ctrn_id, subject_id, project_id, id_type,
             sched_base_complete_date, dem_ch_dob, sex, hp_parent1_relationship, hp_parent1_sex, hp_parent1_educ,
             hp_parent2_gender, hp_parent2_educ, tlfb_smoke_days, tc_1_1, tc_1_1_how_often, tp_1_1_age_first,
             tc_1_1_worst, tc_1_2, tc_1_2_how_often, tp_1_2_age_first, tc_1_2_worst, tc_1_3, tc_1_3_how_often,
             tp_1_3_age_first, tc_1_3_worst, tc_1_4, tc_1_4_how_often, tp_1_4a_age_first, tp_1_4b_age_first,
             tc_1_4_worst, tc_1_5, tc_1_5_how_often, tp_1_5_age_first, tc_1_5_worst, tc_1_6, tc_1_6_how_often,
             tp_1_6_age_first, tc_1_6_worst, tc_2_1, tc_2_1_how_often, tp_2_1_age_first, tc_2_1_worst, tc_2_2,
             tc_2_2_how_often, tp_2_2_age_first, tc_2_2_worst, tc_2_3, tc_2_3_how_often, tp_2_3_age_first, tc_2_3_worst,
             tc_2_4, tc_2_4_how_often, tp_2_4_age_first, tc_2_4_worst, tc_2_5, tc_2_5_how_often, tp_2_5_age_first,
             tc_2_5_worst, tc_3_1, tc_3_1_how_often, tp_3_1_age_first, tc_3_1_worst, tc_3_2, tc_3_2_how_often,
             tp_3_2_age_first, tc_3_2_worst, tc_3_3, tc_3_3_how_often, tp_3_3_age_first, tc_3_3_worst, tc_4_1,
             tc_4_1_how_often, tp_4_1_age_first, tc_4_1_worst, tc_4_2, tc_4_2_how_often, tp_4_2_age_first, tc_4_2_worst,
             tc_4_3, tc_4_3_how_often, tp_4_3_age_first, tc_4_3_worst, tc_5, tc_5_how_often, tp_5_1_age_first,
             tp_5_2_age_first, tc_5_worst, tc_6_1, tp_6_1_age_first, tc_6_2, tc_6_2_how_often, tp_6_2_age_first, tc_7,
             tc_7_how_often, tp_7_1_age_first, tc_7_worst, tc_8_1, tc_8_3, mini_primary_dx, audit_score)
as
SELECT si.si_tube_id,
       si.source_subject_id,
       sched.event_name,
       sched.sched_ctrn_id,
       sa1.subject_id,
       sa1.project_id,
       sa1.id_type,
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
       tc.tc_8_3,
       mini.mini_primary_dx,
       aud.audit_score
FROM rcap_ctau_sample_info si
         LEFT JOIN rcap_ctau_scheduling_form sched ON sched.source_subject_id::text = si.source_subject_id::text AND
                                                      sched.event_name::text ~~ 'baseline%'::text
         JOIN subject_alias sa1 ON sa1.source_subject_id::text = si.source_subject_id::text
         LEFT JOIN rcap_ctau_dem dem ON dem.source_subject_id::text = si.source_subject_id::text
         LEFT JOIN rcap_pfh_child pfhc ON pfhc.source_subject_id::text = sched.sched_ctrn_id::text
         LEFT JOIN rcap_pfh_parent pfhp ON pfhp.source_subject_id::text = sched.sched_ctrn_id::text
         LEFT JOIN rcap_ctau_tlfb tlfb
                   ON tlfb.source_subject_id::text = si.source_subject_id::text AND tlfb.event_name::text ~~ 'baseline%'::text
         LEFT JOIN rcap_tesic tc ON tc.source_subject_id::text = sched.sched_ctrn_id::text
         LEFT JOIN rcap_tesip tp ON tp.source_subject_id::text = sched.sched_ctrn_id::text
         LEFT JOIN rcap_miniss_v2 mini
                   ON mini.source_subject_id::text = sched.sched_ctrn_id::text AND mini.event_name::text ~~ 'baseline%'::text
         LEFT JOIN rcap_ctau_audit aud
                   ON aud.source_subject_id::text = si.source_subject_id::text AND aud.event_name::text ~~ 'baseline%'::text
GROUP BY si.si_tube_id, si.source_subject_id, sched.event_name, sched.sched_ctrn_id, sa1.subject_id, sa1.project_id,
         sa1.id_type, sched.sched_base_complete_date, dem.dem_ch_dob,
         (
             CASE
                 WHEN pfhc.hc_sex_birth_cert::text = '1'::text THEN 'F'::text
                 WHEN pfhc.hc_sex_birth_cert::text = '2'::text THEN 'M'::text
                 ELSE NULL::text
                 END), pfhp.hp_parent1_relationship, pfhp.hp_parent1_sex, pfhp.hp_parent1_educ, pfhp.hp_parent2_gender,
         pfhp.hp_parent2_educ, tlfb.tlfb_smoke_days, tc.tc_1_1, tc.tc_1_1_how_often, tp.tp_1_1_age_first,
         tc.tc_1_1_worst, tc.tc_1_2, tc.tc_1_2_how_often, tp.tp_1_2_age_first, tc.tc_1_2_worst, tc.tc_1_3,
         tc.tc_1_3_how_often, tp.tp_1_3_age_first, tc.tc_1_3_worst, tc.tc_1_4, tc.tc_1_4_how_often,
         tp.tp_1_4a_age_first, tp.tp_1_4b_age_first, tc.tc_1_4_worst, tc.tc_1_5, tc.tc_1_5_how_often,
         tp.tp_1_5_age_first, tc.tc_1_5_worst, tc.tc_1_6, tc.tc_1_6_how_often, tp.tp_1_6_age_first, tc.tc_1_6_worst,
         tc.tc_2_1, tc.tc_2_1_how_often, tp.tp_2_1_age_first, tc.tc_2_1_worst, tc.tc_2_2, tc.tc_2_2_how_often,
         tp.tp_2_2_age_first, tc.tc_2_2_worst, tc.tc_2_3, tc.tc_2_3_how_often, tp.tp_2_3_age_first, tc.tc_2_3_worst,
         tc.tc_2_4, tc.tc_2_4_how_often, tp.tp_2_4_age_first, tc.tc_2_4_worst, tc.tc_2_5, tc.tc_2_5_how_often,
         tp.tp_2_5_age_first, tc.tc_2_5_worst, tc.tc_3_1, tc.tc_3_1_how_often, tp.tp_3_1_age_first, tc.tc_3_1_worst,
         tc.tc_3_2, tc.tc_3_2_how_often, tp.tp_3_2_age_first, tc.tc_3_2_worst, tc.tc_3_3, tc.tc_3_3_how_often,
         tp.tp_3_3_age_first, tc.tc_3_3_worst, tc.tc_4_1, tc.tc_4_1_how_often, tp.tp_4_1_age_first, tc.tc_4_1_worst,
         tc.tc_4_2, tc.tc_4_2_how_often, tp.tp_4_2_age_first, tc.tc_4_2_worst, tc.tc_4_3, tc.tc_4_3_how_often,
         tp.tp_4_3_age_first, tc.tc_4_3_worst, tc.tc_5, tc.tc_5_how_often, tp.tp_5_1_age_first, tp.tp_5_2_age_first,
         tc.tc_5_worst, tc.tc_6_1, tp.tp_6_1_age_first, tc.tc_6_2, tc.tc_6_2_how_often, tp.tp_6_2_age_first, tc.tc_7,
         tc.tc_7_how_often, tp.tp_7_1_age_first, tc.tc_7_worst, tc.tc_8_1, tc.tc_8_3, mini.mini_primary_dx,
         aud.audit_score, sched.source_subject_id, sa1.source_subject_id, dem.source_subject_id, pfhc.source_subject_id,
         tlfb.source_subject_id, tc.source_subject_id, tp.source_subject_id, mini.source_subject_id,
         aud.source_subject_id;

alter table public.rcap_ctau_sample_info_joined_view
    owner to ctrnload;

