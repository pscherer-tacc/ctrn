---- Creating deq_view

select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,deq.deq_complete -- only for validation; DELETE before submission
	,deq.source_subject_id as ctau_source_subject_id -- only for validation; DELETE before submission
	,case
		when deq.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
		when deq.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
		when deq.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date,'mm/dd/yyyy')
		when deq.event_name like 'one_year%' then to_char(sched.sched_1yr_date,'mm/dd/yyyy')
		when deq.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as interview_date
	,case
		when deq.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
		when deq.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
		when deq.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
		when deq.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
		when deq.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
	end as interview_age
	,case
		when deq.event_name like 'baseline%' then sched.sched_base_complete
		when deq.event_name like 'one_month%' then sched.sched_1mo_complete
		when deq.event_name like 'six_month%' then sched.sched_6mo_complete
		when deq.event_name like 'one_year%' then sched.sched_1yr_complete
		when deq.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when deq.event_name like 'baseline%' then 'baseline'
		when deq.event_name like 'one_month%' then 'one_month'
		when deq.event_name like 'six_month%' then 'six_month'
		when deq.event_name like 'one_year%' then 'one_year'
		when deq.event_name like '18_month%' then '18_month'
		when deq.event_name like '24_month%' then '24_month'
	end as timepoint_label
	,to_char(deq.deq_alc_use_dt,'mm/dd/yyyy') as deq_alc_use_dt
	,deq.deq_alc_last_amt
	,deq.deq_alc_dur
	,deq.deq_alc_mem_diff
	,deq.deq_alc_blackout
	,deq.deq_alc_hungover
	,deq.deq_alc_effects
	,deq.deq_alc_effects_2
	,deq.deq_alc_effects_3
	,deq.deq_alc_effects_4
	,to_char(deq.deq_drug_use_dt,'mm/dd/yyyy') as deq_drug_use_dt
	,deq.deq_drug_mdma
	,deq.deq_drug_heroin
	,deq.deq_drug_cocaine
	,deq.deq_drug_crack
	,deq.deq_drug_k
	,deq.deq_drug_meth
	,deq.deq_drug_pain
	,deq.deq_drug_stim
	,deq.deq_drug_k2
	,deq.deq_drug_benzos
	,deq.deq_drug_none
	,deq.deq_drugs_dur
	,deq.deq_drugs_snort
	,deq.deq_drugs_inject
	,deq.deq_drugs_smoke
	,deq.deq_drugs_oral
	,deq.deq_drugs_other
	,deq.deq_drugs_mem_diff
	,deq.deq_drugs_blackout
	,deq.deq_drugs_hungover
	,deq.deq_drugs_effects
	,deq.deq_drugs_effects_2
	,deq.deq_drugs_effects_3
from rcap_ctau_deq deq
inner join subject_alias sa1
    on sa1.source_subject_id = deq.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = deq.source_subject_id 
    and sched.event_name like 'baseline%'
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id
order by sa2.subject_id;







------ !!!!OUTDATED!!!! See the current version above
-- Step 2: Creat deq_view itself

select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,deq.deq_complete -- only for validation; DELETE before submission
	,deq.source_subject_id as ctau_source_subject_id -- only for validation; DELETE before submission
    ,to_char(sched.interview_date,'mm/dd/yyyy') as interview_date
    ,nda_months_between(sched.interview_date, ctau_dem.dem_ch_dob) as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when deq.event_name like 'baseline%' then 'baseline'
		when deq.event_name like 'one_month%' then 'one_month'
		when deq.event_name like 'six_month%' then 'six_month'
		when deq.event_name like 'one_year%' then 'one_year'
		when deq.event_name like '18_month%' then '18_month'
		when deq.event_name like '24_month%' then '24_month'
	end as timepoint_label
	,to_char(deq.deq_alc_use_dt,'mm/dd/yyyy') as deq_alc_use_dt
	,deq.deq_alc_last_amt
	,deq.deq_alc_dur
	,deq.deq_alc_mem_diff
	,deq.deq_alc_blackout
	,deq.deq_alc_hungover
	,deq.deq_alc_effects
	,deq.deq_alc_effects_2
	,deq.deq_alc_effects_3
	,deq.deq_alc_effects_4
	,to_char(deq.deq_drug_use_dt,'mm/dd/yyyy') as deq_drug_use_dt
	,deq.deq_drug_mdma
	,deq.deq_drug_heroin
	,deq.deq_drug_cocaine
	,deq.deq_drug_crack
	,deq.deq_drug_k
	,deq.deq_drug_meth
	,deq.deq_drug_pain
	,deq.deq_drug_stim
	,deq.deq_drug_k2
	,deq.deq_drug_benzos
	,deq.deq_drug_none
	,deq.deq_drugs_dur
	,deq.deq_drugs_snort
	,deq.deq_drugs_inject
	,deq.deq_drugs_smoke
	,deq.deq_drugs_oral
	,deq.deq_drugs_other
	,deq.deq_drugs_mem_diff
	,deq.deq_drugs_blackout
	,deq.deq_drugs_hungover
	,deq.deq_drugs_effects
	,deq.deq_drugs_effects_2
	,deq.deq_drugs_effects_3
from rcap_ctau_deq deq
inner join subject_alias sa1
    on sa1.source_subject_id = deq.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form_agg_view sched
    on sched.source_subject_id = deq.source_subject_id 
    and sched.event_name = deq.event_name
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id
order by sa2.subject_id;





--- use rcap_ctau_scheduling_form_agg_view
select 
	source_subject_id
	,event_name
	,interview_date
	,sched_base_complete_date
	,sched_1mo_complete_date
	,sched_6mo_complete_date
	-- ,sch1.sched_1yr_date
	-- ,sch1.sched_18mo_complete_date
	-- ,sch1.sched_2yr_complete_date
from rcap_ctau_scheduling_form_agg_view;