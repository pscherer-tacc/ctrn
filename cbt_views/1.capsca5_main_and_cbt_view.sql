select
    sa1.subject_id,
    caps.source_subject_id, --for validation; delete before sending off data
    caps.event_name,
    caps.project_id,

    -- interview date:
    case
        when caps.project_id = 2865 then to_char(caps.caps_date,'mm/dd/yyyy')
        when caps.event_name like 'baseline%' then to_char(sched_ctrn.sched_base_complete_date, 'mm/dd/yyyy')
        when caps.event_name like 'one_month%' then to_char(sched_ctrn.sched_1mo_complete_date, 'mm/dd/yyyy')
        when caps.event_name like 'six_month%' then to_char(sched_ctrn.sched_6mo_complete_date, 'mm/dd/yyyy')
        when caps.event_name like 'one_year%' then to_char(sched_ctrn.sched_1yr_complete_date, 'mm/dd/yyyy')
        when caps.event_name like '18_month%' then to_char(sched_ctrn.sched_18mo_complete_date, 'mm/dd/yyyy')
        when caps.event_name like '24_month%' then to_char(sched_ctrn.sched_2yr_complete_date, 'mm/dd/yyyy')
    end as interview_date,

    -- interview_age:
    case
        when caps.project_id = 2865 then nda_months_between(caps.caps_date, dem_ctrn.dem_ch_dob) -- Attention! Using dem_ch_dob from CTRN-MAIN.
        when caps.event_name like 'baseline%' then nda_months_between(sched_ctrn.sched_base_complete_date, dem_ctrn.dem_ch_dob)
        when caps.event_name like 'one_month%' then nda_months_between(sched_ctrn.sched_1mo_complete_date, dem_ctrn.dem_ch_dob)
        when caps.event_name like 'six_month%' then nda_months_between(sched_ctrn.sched_6mo_complete_date, dem_ctrn.dem_ch_dob)
        when caps.event_name like 'one_year%' then nda_months_between(sched_ctrn.sched_1yr_complete_date, dem_ctrn.dem_ch_dob)
        when caps.event_name like '18_month%' then nda_months_between(sched_ctrn.sched_18mo_complete_date, dem_ctrn.dem_ch_dob)
        when caps.event_name like '24_month%' then nda_months_between(sched_ctrn.sched_2yr_complete_date, dem_ctrn.dem_ch_dob)
    end as interview_age,

    -- CAPSCA items:
    caps_summary_a1,
    caps_summary_b1_sev_q1,
    caps_summary_b2_sev_q2,
    caps_summary_b3_sev_q3,
    caps_summary_b4_sev_q4,
    caps_summary_b5_sev_q5,
    caps_summary_c1_sev_q6,
    caps_summary_c2_sev_q7,
    caps_summary_d1_sev_q8,
    caps_summary_d2_sev_q9,
    caps_summary_d3_sev_q10,
    caps_summary_d4_sev_q11,
    caps_summary_d5_sev_q12,
    caps_summary_d6_sev_q13,
    caps_summary_d7_sev_q14,
    caps_summary_e1_sev_q15,
    caps_summary_e2_sev_q16,
    caps_summary_e3_sev_q17,
    caps_summary_e4_sev_q18,
    caps_summary_e5_sev_q19,
    caps_summary_e6_sev_q20,
    caps_summary_f1_q22,
    caps_summary_g1_sev_q23,
    caps_summary_g2_sev_q24,
    caps_summary_g3_sev_q25,
    caps_summary_validity_q26,
    caps_summary_severity_q27,
    caps_summary_improve_q28,
    caps_sum_depers_sev_q29,
    caps_sum_dereal_sev_q30,
    caps_sum_ptsd_present,
    caps_sum_dissociative,
    caps_sum_delayed,

    -- Optional: join CTRN Personal Family History for demographics
    pfh.hc_sex_birth_cert,
    pfh.hc_race,
    pfh.hc_hispanic

from view_capsca_main_and_cbt caps
left join subject_alias sa1
    on sa1.source_subject_id = caps.source_subject_id
    and sa1.project_id = caps.project_id
    and sa1.id_type = 'redcap'
left join subject_alias sa2 -- mainly to map CBT participants' ids to their ids in CTRN-MAIN
    on sa2.subject_id = sa1.subject_id -- Attention! Join on subject_id! 
    and sa2.project_id = 696
    and sa2.id_type = 'redcap'
left join rcap_scheduling_form sched_ctrn
    on sched_ctrn.source_subject_id = sa2.source_subject_id -- Attention! Join on sa2.source_subject_id as all those ids are from CTRN-MAIN.
left join rcap_demographics dem_ctrn
    on dem_ctrn.source_subject_id = sa2.source_subject_id -- Attention! Join on sa2.source_subject_id as all those ids are from CTRN-MAIN.
left join rcap_pfh_child pfh
	on pfh.source_subject_id = sa2.source_subject_id -- Attention! Join on sa2.source_subject_id as all those ids are from CTRN-MAIN.
left join subject_alias sa3 -- to later filter only the records for CBT participants
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 2865
    and sa3.id_type = 'redcap'

where sa3.source_subject_id is not null -- to keep the records that are only related to CBT participants  
;


