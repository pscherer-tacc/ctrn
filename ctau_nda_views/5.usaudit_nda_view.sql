-- Creating usaudit01_nda_view

select
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
    ,case
        when audit.event_name like 'baseline%' then sched.sched_base_complete_date
        when audit.event_name like 'one_month%' then sched.sched_1mo_complete_date
        when audit.event_name like 'six_month%' then sched.sched_6mo_complete_date
        when audit.event_name like 'one_year%' then sched.sched_1yr_date
        when audit.event_name like '24_month%' then sched.sched_2yr_complete_date
    end as interview_date
    ,case
        when audit.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
        when audit.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
        when audit.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
        when audit.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
        when audit.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
    end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,case 
        when audit.event_name like 'baseline%' then 'baseline'
        when audit.event_name like 'one_month%' then 'one_month'
        when audit.event_name like 'six_month%' then 'six_month'
        when audit.event_name like 'one_year%' then 'one_year'
        when audit.event_name like '24_month%' then '24_month'
    end as timepoint_label
    ,audit_q1_sc
	,audit_q2_sc
	,audit_q3_sc
	,audit_q4_sc
	,audit_q5_sc
	,audit_q6_sc
	,audit_q7_sc
	,audit_q8_sc
	,audit_q9_sc
	,audit_q10_sc
	,audit_score as usaudit_total
from rcap_ctau_audit audit
inner join subject_alias sa1
    on sa1.source_subject_id = audit.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = audit.source_subject_id 
    --and sched.event_name = audit.event_name
    and sched.event_name like 'baseline%'
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id;