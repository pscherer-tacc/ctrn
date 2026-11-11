---- ASCKIDS CTRN View
--- Name of the view: asckids_ctrn_view
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query export is curated as follows:
--- 	1) Records with NULL schedule [visit]_complete_dates are removed
---     2) Records with NULL dem_ch_dob are removed
---		3) Incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are removed
---     4) Any remaining duplicate and partial duplicate records are removed with the goal of the curated data products containing 1 record per event per participant. 
---		5) "Complete" and "sufficiently complete" records with NULL sex are retained and reported to the Data Core team for correction
---     6) Variables containing pii/phi and/or unstructured text are removed as per comments below
---     7) Variables used solely for curation/administration are removed as per comments below
--- Note that there should be just 1 record per subject_id as data is only collected at baseline.
--- 
--- Query the data from the view
--- select * from asckids_ctrn_view
--- where interview_date is not null;
---
--- The body of the view
--- create or replace view asckids_ctrn_view
--- as
select
    dem.dem_guid as subjectkey          -- only used for NIH projects; may be omitted for CTRN Main studies
    ,sa1.subject_id
	,case
		when asck.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when asck.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when asck.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date      -- only for validation; DELETE before sharing
	,case 
		when asck.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when asck.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when asck.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when asck.event_name like 'baseline%' then sched_main.sched_base_complete
		when asck.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when asck.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when asck.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when asck.event_name like '18_month%' then sched_main.sched_18mo_complete
		when asck.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case 
        when pfhc.hc_race='1' then 'American Indian or Alaska Native'
        when pfhc.hc_race='2' then 'Asian'
    	when pfhc.hc_race='3' then 'Native Hawaiian or Pacific Islander'
	 	when pfhc.hc_race='4' then 'Black or African American'
    	when pfhc.hc_race='5' then 'White'
    	when pfhc.hc_race='6' then 'Multi-racial'
        else null
    end as race
	,pfhc.hc_hispanic
    ,case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when asck.event_name like 'baseline%' then '00_baseline'      
		when asck.event_name like 'one_month%' then '01_one_month'
		when asck.event_name like 'six_month%' then '06_six_month'
		when asck.event_name like 'one_year%' then '12_month'
		when asck.event_name like '18_month%' then '18_month'
		when asck.event_name like '24_month%' then '24_month'
	end as visit
--- Curation notes: asck is administered for baseline only; unstructured data and pii noted below was purposefully omitted from the query
,asck.asc_1
    ,asck.asc_2
    ,asck.asc_3
    ,asck.asc_4
    ,asck.asc_5
    ,asck.asc_6
    ,asck.asc_7
    ,asck.asc_8
    ,asck.asc_9
    ,asck.asc_10
    ,asck.asc_11
    ,asck.asc_12
    ,asck.asc_13
    ,asck.asc_14
    ,asck.asc_15
    ,asck.asc_16
    ,asck.asc_17
    ,asck.asc_18
    ,asck.asc_19
    ,asck.asc_20
    ,asck.asc_21
    ,asck.asc_22
    ,asck.asc_23
    ,asck.asc_24
    ,asck.asc_25
    ,asck.asc_26
    ,asck.asc_27
    ,asck.asc_28
    ,asck.asc_29	
from rcap_asc_kids asck -- Attention! rcap_asc_kids is not a CTAU table.    
inner join subject_alias sa1
    on sa1.source_subject_id = asck.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = asck.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = asck.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = asck.source_subject_id
    and pfhc.event_name like 'baseline%'
order by sa1.subject_id;
