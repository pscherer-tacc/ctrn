----oosmb01 (OOSMB) nda view
--- Name of the view: oosmb01_nda_view
---
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query export is curated as follows:
---   1) Records with NULL schedule [visit]_complete_dates are removed
---   2) Records with NULL dem_ch_dob are removed
---	  3) Incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are removed
---   4) Any remaining duplicate and partial duplicate records are removed with the goal of the curated data products containing 1 record per event per participant. 
---	  5) "Complete" and "sufficiently complete" records with NULL sex are removed as per NDA requirements and reported to the Data Core team for correction
---   6) Variables containing pii/phi and/or unstructured text are removed as per comments below
---   7) Variables used solely for curation/administration are removed as per comments below
select
    dem.dem_guid as subjectkey,
    sa1.subject_id as src_subject_id,
	ossmb.source_subject_id, -- only for validation; delete before submission
	ossmb.event_name, -- only for validation; delete before submission
	case	
		when ossmb.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when ossmb.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when ossmb.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when ossmb.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
	    --when ossmb.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')   --- no 18 month in ctau
		when ossmb.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date,
	case
	    when ossmb.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when ossmb.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when ossmb.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when ossmb.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when ossmb.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when ossmb.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age, 
	case
	    when ossmb.event_name like 'baseline%' then sched_main.sched_base_complete
		when ossmb.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when ossmb.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when ossmb.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when ossmb.event_name like '18_month%' then sched.sched_18mo_complete
		when ossmb.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete, -- only for validation; delete before submission
	case
	    when pfhc.hc_sex_birth_cert='1' then 'F'
		when pfhc.hc_sex_birth_cert='2' then 'M'
		else null
	end as sex,
	case
		when ossmb.event_name like 'baseline%' then 'baseline'
		when ossmb.event_name like 'one_month%' then 'one_month'
		when ossmb.event_name like 'six_month%' then 'six_month'
		when ossmb.event_name like 'one_year%' then 'one_year'
		-- when ossmb.event_name like '18_month%' then '18_month'
		when ossmb.event_name like '24_month%' then '24_month'
	end as timepoint_label,
	ossmb.ossmb_01,          
	ossmb.ossmb_02,
	ossmb.ossmb_03,	
	ossmb.ossmb_04,
	ossmb.ossmb_05,
	ossmb.ossmb_06,
	ossmb.ossmb_07,
	ossmb.ossmb_08,
	ossmb.ossmb_09,
	ossmb.ossmb_10,
	ossmb.ossmb_11,
	ossmb.ossmb_12,
	ossmb.ossmb_13,
	ossmb.ossmb_14,
	ossmb.ossmb_15,
	ossmb.ossmb_16,
	ossmb.ossmb_17,
	ossmb.ossmb_18,
	ossmb.ossmb_19,
	ossmb.ossmb_20,
	ossmb.ossmb_21
from rcap_ossmb as ossmb -- attention! rcap_ossmbn is NOT a ctau table.
inner join rcap_ctau_scheduling_form as sched -- to keep ctau participants only
	on sched.sched_ctrn_id = ossmb.source_subject_id
	and sched.event_name like 'baseline%'
	-- and ossmb.event_name not like 'unscheduled%'-- optional if want to include
inner join subject_alias as sa1
    on sa1.source_subject_id = ossmb.source_subject_id
left join rcap_scheduling_form as sched_main 
    on sched_main.source_subject_id = ossmb.source_subject_id 
left join rcap_demographics as dem
    on dem.source_subject_id = ossmb.source_subject_id
left join rcap_pfh_child as pfhc 
    on pfhc.source_subject_id = ossmb.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
