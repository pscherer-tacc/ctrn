---- CRAFFTN CTRN View
--- Name of the view: crafftn_ctrn_view
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query includes incomplete records which are curated as follows:
--- 	1) Records with NULL interview dates are removed
---		2) Records with NULL sex are removed
---		3) Remove duplicate incomplete records where sched_[event_name]_complete not equal "1"(complete) or "8"(sufficiently complete)
---     4) Report any remaining records for correction if sched_[event_name]_complete not equal "1"(complete) or "8"(sufficiently complete), but they contain data 
---
--- Query the data from the view
--- select * from crafftn_ctrn_view
--- where interview_date is not null;
---
--- The body of the view
--- create or replace crafftn_ctrn_view
--- as
select
  dem.dem_guid			-- only used for NIH projects; may be omitted for CTRN Main studies
  ,sa1.subject_id
	,crafftn.source_subject_id -- only for validation; DELETE before sharing
	,case
		when crafftn.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when crafftn.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date  -- only for validation; DELETE before sharing
	,case 
		when crafftn.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when crafftn.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when crafftn.event_name like 'baseline%' then sched_main.sched_base_complete
		when crafftn.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when crafftn.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when crafftn.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when crafftn.event_name like '18_month%' then sched_main.sched_18mo_complete
		when crafftn.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before sharing
  ,case 
    when pfhc.hc_sex_birth_cert='1' then 'F'
    when pfhc.hc_sex_birth_cert='2' then 'M'
    else null
  end as sex
	,case 
    when pfhc.hc_race='1' then 'American Indian or Alaska Native'
    when pfhc.hc_race='2' then 'Asian'
  	when pfhc.hc_race='3' then 'Native Hawaian or Pacific Islander'
	 	when pfhc.hc_race='4' then 'Black or African American'
  	when pfhc.hc_race='5' then 'White'
  	when pfhc.hc_race='6' then 'Multi-racial'
    else null
  end as race
	,pfhc.hc_hispanic
	,case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when crafftn.event_name like 'baseline%' then '00_baseline'      
		when crafftn.event_name like 'one_month%' then '01_one_month'
		when crafftn.event_name like 'six_month%' then '06_six_month'
		when crafftn.event_name like 'one_year%' then '12_month'
		when crafftn.event_name like '18_month%' then '18_month'
		when crafftn.event_name like '24_month%' then '24_month'
	end as visit
	,crafftn.crafftn_1
	,crafftn.crafftn_2
	,crafftn.crafftn_3
	,crafftn.crafftn_4
	,crafftn.crafftn_5
	,crafftn.crafftn_6
	,crafftn.crafftn_7
	,crafftn.crafftn_8
	,crafftn.crafftn_9
	,crafftn.crafftn_10
from rcap_crafftn crafftn
inner join subject_alias sa1
    on sa1.source_subject_id = crafftn.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and crafftn.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = crafftn.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = crafftn.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = crafftn.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;	
