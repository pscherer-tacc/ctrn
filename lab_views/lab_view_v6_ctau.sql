--------- CTAU part of the lab view
---
------ Important: run the whole query (CTE + query) 
------ starting with "with ctau_instruments_union ..."
---
-- Below is a common table expression (CTE) uniting all source_subject_id-event_name pairs.
-- The CTE will be used as a main/"central" table to which other tables will 
-- be joined.
with ctau_instruments_union
as
(
    select source_subject_id, event_name
    from rcap_ctau_deq
    union
    select source_subject_id, event_name
    from rcap_ctau_sui
    union
    select source_subject_id, event_name
    from rcap_ctau_tlfb
    union
    select source_subject_id, event_name
    from rcap_ctau_audit
    union
    select source_subject_id, event_name
    from ctau_scheduling_form_view
)
-- The main query.
select  
    sa1.subject_id,
    ctau_union.source_subject_id as ctau_source_subject_id, -- PII CTAU record_id; Remove after curation
    ctau_union.event_name,
    case
	  when ctau_union.event_name like 'baseline%' then to_char(ctau_sched.sched_base_complete_date,'mm/dd/yyyy')
      when ctau_union.event_name like 'one_month%' then to_char(ctau_sched.sched_1mo_complete_date,'mm/dd/yyyy')
	  when ctau_union.event_name like 'six_month%' then to_char(ctau_sched.sched_6mo_complete_date,'mm/dd/yyyy')
	  when ctau_union.event_name like 'one_year%' then to_char(ctau_sched.sched_1yr_date,'mm/dd/yyyy')
	  when ctau_union.event_name like '24_month%' then to_char(ctau_sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as sched_ctau_complete_date, -- PII. Remove after curation.
    ctrn_main_dem.dem_ch_dob,  -- PII; Remove after curation
    case 
        when ctau_union.event_name like 'baseline%' then age_days_between(ctrn_main_dem.dem_ch_dob::date, ctau_sched.sched_base_complete_date::date)
        when ctau_union.event_name like 'one_month%' then age_days_between(ctrn_main_dem.dem_ch_dob::date, ctau_sched.sched_1mo_complete_date::date)
        when ctau_union.event_name like 'six_month%' then age_days_between(ctrn_main_dem.dem_ch_dob::date, ctau_sched.sched_6mo_complete_date::date)
        when ctau_union.event_name like 'one_year%' then age_days_between(ctrn_main_dem.dem_ch_dob::date, ctau_sched.sched_1yr_date::date)
        when ctau_union.event_name like '24_month%' then age_days_between(ctrn_main_dem.dem_ch_dob::date, ctau_sched.sched_2yr_complete_date::date)
    end as age_days_interview,
    case
        when ctau_union.event_name like 'baseline%' then ctau_sched.sched_base_complete
        when ctau_union.event_name like 'one_month%' then ctau_sched.sched_6mo_complete
        when ctau_union.event_name like 'six_month%' then ctau_sched.sched_6mo_complete
        when ctau_union.event_name like 'one_year%' then ctau_sched.sched_1yr_complete
        when ctau_union.event_name like '24_month%' then ctau_sched.sched_2yr_complete
    end as complete,
    case 
        when ctau_union.event_name like 'baseline%' then '00_baseline_ctau'
        when ctau_union.event_name like 'one_month%' then '01_one_month_ctau'
        when ctau_union.event_name like 'six_month%' then '06_six_month_ctau'
        when ctau_union.event_name like 'one_year%' then '12_month_ctau'
        when ctau_union.event_name like '18_month%' then '18_month_ctau'
        when ctau_union.event_name like '24_month' then '24_month_ctau'
    end as visit,
    case
        when pfhc.hc_sex_birth_cert = '1' then 'F'
        when pfhc.hc_sex_birth_cert = '2' then 'M'
        else null
    end as sex,
    pfhc.hc_race,
    pfhc.hc_hispanic,
---
    tlfb.tlfb_drink_mo,
    tlfb.tlfb_drink_days,
    tlfb.tlfb_drink_per_day,
    tlfb.tlfb_hv_ep_dr_days,
    tlfb.tlfb_24_max,
    tlfb.tlfb_cig_mo,
    tlfb.tlfb_smoke_days,
    tlfb.tlfb_cig_per_day,
    tlfb.tlfb_thc_days,
---
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
---
    sui.sui_1,
    sui.sui_2,
	sui.sui_3,
	sui.sui_4,
	sui.sui_5,
--- sui.sui_6,		         Unstructured text needs to be deidentified or removed prior to public sharing
 	sui.sui_7,
	sui.sui_8,
---    
    age_years_between(
        deq.deq_alc_use_dt::date,
        ctrn_main_dem.dem_ch_dob::date
    ) as deq_age_last_alc,   
	deq.deq_alc_last_amt,
	deq.deq_alc_dur,
    deq_alc_mem_diff,
    deq.deq_alc_blackout,
    deq.deq_alc_hungover,
    deq.deq_alc_effects,
    deq.deq_alc_effects_2,
    deq.deq_alc_effects_3,
    deq.deq_alc_effects_4,
    age_years_between(
        deq.deq_drug_use_dt::date, 
        ctrn_main_dem.dem_ch_dob::date
    ) as deq_age_last_drug,
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
from ctau_instruments_union ctau_union
inner join subject_alias sa1
    on sa1.source_subject_id = ctau_union.source_subject_id
    and sa1.project_id = 2515
left join rcap_ctau_deq deq
    on deq.source_subject_id = ctau_union.source_subject_id
    and deq.event_name = ctau_union.event_name
left join rcap_ctau_sui sui
    on sui.source_subject_id = ctau_union.source_subject_id
    and sui.event_name = ctau_union.event_name
left join rcap_ctau_tlfb tlfb
    on tlfb.source_subject_id = ctau_union.source_subject_id
    and tlfb.event_name = ctau_union.event_name
left join rcap_ctau_audit aud
    on aud.source_subject_id = ctau_union.source_subject_id
    and aud.event_name = ctau_union.event_name
left join rcap_ctau_scheduling_form ctau_sched
    on ctau_sched.source_subject_id = ctau_union.source_subject_id
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696
    and sa2.id_type = 'redcap'
left join rcap_demographics ctrn_main_dem
    on ctrn_main_dem.source_subject_id = sa2.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa2.source_subject_id
    and pfhc.event_name like 'baseline%'
;


