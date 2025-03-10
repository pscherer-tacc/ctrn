---- Creating gtfbca01_nda_view (tlfb)

select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,tlfb.tlfb_complete -- only for validation; DELETE before submission
	,tlfb.source_subject_id as ctau_source_subject_id -- only for validation; DELETE before submission
	,case
		when tlfb.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
		when tlfb.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
		when tlfb.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date,'mm/dd/yyyy')
		when tlfb.event_name like 'one_year%' then to_char(sched.sched_1yr_date,'mm/dd/yyyy')
		when tlfb.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as interview_date
	,case
		when tlfb.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
		when tlfb.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
		when tlfb.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
		when tlfb.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
		when tlfb.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
	end as interview_age
	,case
		when tlfb.event_name like 'baseline%' then sched.sched_base_complete
		when tlfb.event_name like 'one_month%' then sched.sched_1mo_complete
		when tlfb.event_name like 'six_month%' then sched.sched_6mo_complete
		when tlfb.event_name like 'one_year%' then sched.sched_1yr_complete
		when tlfb.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when tlfb.event_name like 'baseline%' then 'baseline'
		when tlfb.event_name like 'one_month%' then 'one_month'
		when tlfb.event_name like 'six_month%' then 'six_month'
		when tlfb.event_name like 'one_year%' then 'one_year'
		when tlfb.event_name like '24_month%' then '24_month'
	end as timepoint_label
	,tlfb.tlfb_drink_mo as number_alcholoic_drinks_a
	,tlfb.tlfb_drink_days as last_month_frequency
	,tlfb.tlfb_drink_per_day as subu5b_drink_daily
	,tlfb.tlfb_hv_ep_dr_days as tlfb_hv_ep_dr_days 
	,tlfb.tlfb_24_max as tlfb_alc3 
	,tlfb.tlfb_cig_mo as cddr_3_v2
	,tlfb.tlfb_smoke_days as cddr_3 
	,tlfb.tlfb_cig_per_day as daily_cigarette_tlfb
	,tlfb.tlfb_thc_days as dfaq7
from rcap_ctau_tlfb tlfb
inner join subject_alias sa1
    on sa1.source_subject_id = tlfb.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = tlfb.source_subject_id 
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

