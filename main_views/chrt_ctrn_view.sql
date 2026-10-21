---- CHRT16 CTRN View
--- Name of the view: chrt_ctrn_view
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query export is curated as follows:
--- 	1) Records with NULL schedule [visit]_complete_dates are removed
---   2) Records with NULL dem_ch_dob are removed
---		3) Incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are removed
---   4) Any remaining duplicate and partial duplicate records are removed with the goal of the curated data products containing 1 record per event per participant. 
---		5) "Complete" and "sufficiently complete" records with NULL sex are retained and reported to the Data Core team for correction
---   6) Variables containing pii/phi and/or unstructured text are removed as per comments below
---   7) Variables used solely for curation/administration are removed as per comments below
---
--- Query the data from the view
select
	case
		when chrt_duplicates.source_subject_id is not null then 'YES'
		else 'NO'
	end as potential_duplicate,
	chrt_view.* 
from chrt_ctrn_view chrt_view
left join (
	select source_subject_id, event_name
	from chrt_ctrn_view
	group by source_subject_id, event_name
	having count(*) > 1
) chrt_duplicates
	on chrt_duplicates.source_subject_id = chrt_view.source_subject_id
	and chrt_duplicates.event_name = chrt_view.event_name
--where interview_date is not null
order by
	case
		when chrt_duplicates.source_subject_id is not null then 'YES'
		else 'NO'
	end,
	chrt_view.source_subject_id,
	chrt_view.event_name
;



-- The body of the view
create or replace view chrt_ctrn_view
as
select
	dem.dem_guid,	-- only used for NIH projects; may be omitted for CTRN Main studies
	sa1.subject_id,
	chrt.source_subject_id, -- only for validation; DELETE before sharing
	chrt.event_name,
	case
		when chrt.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date,  -- only for validation; DELETE before sharing
	case 
		when chrt.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when chrt.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age,
	case
		when chrt.event_name like 'baseline%' then sched_main.sched_base_complete
		when chrt.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when chrt.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when chrt.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when chrt.event_name like '18_month%' then sched_main.sched_18mo_complete
		when chrt.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete, -- only for validation; DELETE before sharing
	case 
    	when pfhc.hc_sex_birth_cert='1' then 'F'
    	when pfhc.hc_sex_birth_cert='2' then 'M'
    	else null
	end as sex,
	case 
    	when pfhc.hc_race='1' then 'American Indian or Alaska Native'
    	when pfhc.hc_race='2' then 'Asian'
  		when pfhc.hc_race='3' then 'Native Hawaiian or Pacific Islander'
	 	when pfhc.hc_race='4' then 'Black or African American'
  		when pfhc.hc_race='5' then 'White'
  		when pfhc.hc_race='6' then 'Multi-racial'
    	else null
  	end as race,
	pfhc.hc_hispanic,
	case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when chrt.event_name like 'baseline%' then '00_baseline'      
		when chrt.event_name like 'one_month%' then '01_one_month'
		when chrt.event_name like 'six_month%' then '06_six_month'
		when chrt.event_name like 'one_year%' then '12_month'
		when chrt.event_name like '18_month%' then '18_month'
		when chrt.event_name like '24_month%' then '24_month'
	end as visit,
	chrt.chrt_1,
    chrt.chrt_2,
    chrt.chrt_3,
    chrt.chrt_4,
    chrt.chrt_5,
    chrt.chrt_6,
    chrt.chrt_7,
    chrt.chrt_8,
    chrt.chrt_9,
    chrt.chrt_10,
	chrt.chrt_11,
    chrt.chrt_12,
    chrt.chrt_13,
    chrt.chrt_14,
    chrt.chrt_15,
    chrt.chrt_16,
from rcap_chrt16 chrt
inner join subject_alias sa1
    on sa1.source_subject_id = chrt.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and chrt.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = chrt.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = chrt.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = chrt.source_subject_id
	and pfhc.event_name like 'baseline%'
order by sa1.subject_id;	
