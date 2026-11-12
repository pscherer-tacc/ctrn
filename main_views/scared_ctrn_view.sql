---- SCARED CHILD CTRN View
--- Name of the view: scared_ctrn_view
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
--- select * from scared_ctrn_view
--- where interview_date is not null;
---
--- The body of the view
--- create or replace scared_ctrn_view
--- as

SELECT dem.dem_guid,    -- only used for NIH projects; may be omitted for CTRN Main studies
	   sa1.subject_id,
	   scared_child.source_subject_id, -- only for validation; DELETE before submission
	   scared_child.event_name, -- only for validation; DELETE before submission
	CASE
		WHEN scared_child.event_name LIKE 'baseline%' THEN TO_CHAR(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'one_month%' THEN TO_CHAR(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'six_month%' THEN TO_CHAR(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'one_year%' THEN TO_CHAR(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
	  WHEN scared_child.event_name LIKE '18_month%' THEN TO_CHAR(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE '24_month%' THEN TO_CHAR(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end AS interview_date,
	CASE
	  WHEN scared_child.event_name LIKE 'baseline%' THEN nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'one_month%' THEN nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'six_month%' THEN nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'one_year%' THEN nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE '18_month%' THEN nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when scared_child.event_name LIKE '24_month%' THEN nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end AS interview_age, 
	CASE
    WHEN scared_child.event_name LIKE 'baseline%' THEN sched_main.sched_base_complete
		WHEN scared_child.event_name LIKE 'one_month%' THEN sched_main.sched_1mo_complete
		WHEN scared_child.event_name LIKE 'six_month%' THEN sched_main.sched_6mo_complete
		WHEN scared_child.event_name LIKE 'one_year%' THEN sched_main.sched_1yr_complete
		WHEN scared_child.event_name LIKE '18_month%' THEN sched_main.sched_18mo_complete
		WHEN scared_child.event_name LIKE '24_month%' THEN sched_main.sched_2yr_complete
	end AS complete, -- only for validation; DELETE before submission,
	CASE
	  WHEN pfhc.hc_sex_birth_cert='1' THEN 'F'
		WHEN pfhc.hc_sex_birth_cert='2' THEN 'M'
		ELSE NULL
	end AS sex,
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
		when scared_child.event_name like 'baseline%' then '00_baseline'      
		when scared_child.event_name like 'one_month%' then '01_one_month'
		when scared_child.event_name like 'six_month%' then '06_six_month'
		when scared_child.event_name like 'one_year%' then '12_month'
		when scared_child.event_name like '18_month%' then '18_month'
		when scared_child.event_name like '24_month%' then '24_month'
	end as visit,
	pfhp.hp_parent1_relationship,   -- Will need to recast as varchar if labels are requested for data values.
	---CASE
    ---    WHEN pfhp.hp_parent1_relationship='0' OR pfhp.hp_parent1_relationship IS NULL THEN -999
    ---    WHEN pfhp.hp_parent1_relationship='1' THEN 'Biological parent'
    ---    WHEN pfhp.hp_parent1_relationship='2' THEN 'Adoptive parent'
    ---    WHEN pfhp.hp_parent1_relationship='3' THEN 'Foster parent'
    ---    WHEN pfhp.hp_parent1_relationship='4' THEN 'Stepparent'
    ---    WHEN pfhp.hp_parent1_relationship='5' THEN 'Other'
  ---end AS relationship,
	scared_child.scaredc_1,
	scared_child.scaredc_2,
	scared_child.scaredc_3,
	scared_child.scaredc_4,
	scared_child.scaredc_5,
	scared_child.scaredc_6,
	scared_child.scaredc_7,
	scared_child.scaredc_8,
	scared_child.scaredc_9,
	scared_child.scaredc_10,
	scared_child.scaredc_11,
	scared_child.scaredc_12,
	scared_child.scaredc_13,
	scared_child.scaredc_14,
	scared_child.scaredc_15,
	scared_child.scaredc_16,
	scared_child.scaredc_17,
	scared_child.scaredc_18,
	scared_child.scaredc_19,
	scared_child.scaredc_20,
	scared_child.scaredc_21,
	scared_child.scaredc_22,
	scared_child.scaredc_23,
	scared_child.scaredc_24,
	scared_child.scaredc_25,
	scared_child.scaredc_26,
	scared_child.scaredc_27,
	scared_child.scaredc_28,
	scared_child.scaredc_29,
	scared_child.scaredc_30,
	scared_child.scaredc_31,
	scared_child.scaredc_32,
	scared_child.scaredc_33,
	scared_child.scaredc_34,
	scared_child.scaredc_35,
	scared_child.scaredc_36,
	scared_child.scaredc_37,
	scared_child.scaredc_38,
	scared_child.scaredc_39,
	scared_child.scaredc_40,
	scared_child.scaredc_41,
	--Total: all 41 items
    COALESCE(
        CAST(scared_child.scaredc_1 AS INTEGER) +
        CAST(scared_child.scaredc_2 AS INTEGER) +
        CAST(scared_child.scaredc_3 AS INTEGER) +
        CAST(scared_child.scaredc_4 AS INTEGER) +
        CAST(scared_child.scaredc_5 AS INTEGER) +
        CAST(scared_child.scaredc_6 AS INTEGER) +
        CAST(scared_child.scaredc_7 AS INTEGER) +
        CAST(scared_child.scaredc_8 AS INTEGER) +
        CAST(scared_child.scaredc_9 AS INTEGER) +
        CAST(scared_child.scaredc_10 AS INTEGER) +
        CAST(scared_child.scaredc_11 AS INTEGER) +
        CAST(scared_child.scaredc_12 AS INTEGER) +
        CAST(scared_child.scaredc_13 AS INTEGER) +
        CAST(scared_child.scaredc_14 AS INTEGER) +
        CAST(scared_child.scaredc_15 AS INTEGER) +
        CAST(scared_child.scaredc_16 AS INTEGER) +
        CAST(scared_child.scaredc_17 AS INTEGER) +
        CAST(scared_child.scaredc_18 AS INTEGER) +
        CAST(scared_child.scaredc_19 AS INTEGER) +
        CAST(scared_child.scaredc_20 AS INTEGER) +
        CAST(scared_child.scaredc_21 AS INTEGER) +
        CAST(scared_child.scaredc_22 AS INTEGER) +
        CAST(scared_child.scaredc_23 AS INTEGER) +
        CAST(scared_child.scaredc_24 AS INTEGER) +
        CAST(scared_child.scaredc_25 AS INTEGER) +
        CAST(scared_child.scaredc_26 AS INTEGER) +
        CAST(scared_child.scaredc_27 AS INTEGER) +
        CAST(scared_child.scaredc_28 AS INTEGER) +
        CAST(scared_child.scaredc_29 AS INTEGER) +
        CAST(scared_child.scaredc_30 AS INTEGER) +
        CAST(scared_child.scaredc_31 AS INTEGER) +
        CAST(scared_child.scaredc_32 AS INTEGER) +
        CAST(scared_child.scaredc_33 AS INTEGER) +
        CAST(scared_child.scaredc_34 AS INTEGER) +
        CAST(scared_child.scaredc_35 AS INTEGER) +
        CAST(scared_child.scaredc_36 AS INTEGER) +
        CAST(scared_child.scaredc_37 AS INTEGER) +
        CAST(scared_child.scaredc_38 AS INTEGER) +
        CAST(scared_child.scaredc_39 AS INTEGER) +
        CAST(scared_child.scaredc_40 AS INTEGER) +
        CAST(scared_child.scaredc_41 AS INTEGER),
        999
    ) AS scared_total,
    --- PD: 13 items
    COALESCE(
        CAST(scared_child.scaredc_1 AS INTEGER) +
        CAST(scared_child.scaredc_6 AS INTEGER) +
        CAST(scared_child.scaredc_9 AS INTEGER) +
        CAST(scared_child.scaredc_12 AS INTEGER) +
        CAST(scared_child.scaredc_15 AS INTEGER) +
        CAST(scared_child.scaredc_18 AS INTEGER) +
        CAST(scared_child.scaredc_19 AS INTEGER) +
        CAST(scared_child.scaredc_22 AS INTEGER) +
        CAST(scared_child.scaredc_24 AS INTEGER) +
        CAST(scared_child.scaredc_27 AS INTEGER) +
        CAST(scared_child.scaredc_30 AS INTEGER) +
        CAST(scared_child.scaredc_34 AS INTEGER) +
        CAST(scared_child.scaredc_38 AS INTEGER),
        999
    ) AS scared_pd_score,
    --- GAD: 9 items
    COALESCE(
        CAST(scared_child.scaredc_5 AS INTEGER) +
        CAST(scared_child.scaredc_7 AS INTEGER) +
        CAST(scared_child.scaredc_14 AS INTEGER) +
        CAST(scared_child.scaredc_21 AS INTEGER) +
        CAST(scared_child.scaredc_23 AS INTEGER) +
        CAST(scared_child.scaredc_28 AS INTEGER) +
        CAST(scared_child.scaredc_33 AS INTEGER) +
        CAST(scared_child.scaredc_35 AS INTEGER) +
        CAST(scared_child.scaredc_37 AS INTEGER),
        999
    ) AS scared_gad_score,
    --- SAD: 8 items
    COALESCE(
        CAST(scared_child.scaredc_4 AS INTEGER) +
        CAST(scared_child.scaredc_8 AS INTEGER) +
        CAST(scared_child.scaredc_13 AS INTEGER) +
        CAST(scared_child.scaredc_16 AS INTEGER) +
        CAST(scared_child.scaredc_20 AS INTEGER) +
        CAST(scared_child.scaredc_25 AS INTEGER) +
        CAST(scared_child.scaredc_29 AS INTEGER) +
        CAST(scared_child.scaredc_31 AS INTEGER),
        999
    ) AS scared_sad_score,
    --- SOCAD: 7 items
    COALESCE(
        CAST(scared_child.scaredc_3 AS INTEGER) +
        CAST(scared_child.scaredc_10 AS INTEGER) +
        CAST(scared_child.scaredc_26 AS INTEGER) +
        CAST(scared_child.scaredc_32 AS INTEGER) +
        CAST(scared_child.scaredc_39 AS INTEGER) +
        CAST(scared_child.scaredc_40 AS INTEGER) +
        CAST(scared_child.scaredc_41 AS INTEGER),
        999
    ) AS scared_socad_score,
    -- SSA: 4 items
    COALESCE(
        CAST(scared_child.scaredc_2 AS INTEGER) +
        CAST(scared_child.scaredc_11 AS INTEGER) +
        CAST(scared_child.scaredc_17 AS INTEGER) +
        CAST(scared_child.scaredc_36 AS INTEGER),
        999
    ) AS scared_ssa_score
FROM rcap_scared_child AS scared_child -- Attention! rcap_scared_child is not a CTAU table.
inner join subject_alias sa1
    on sa1.source_subject_id = scared_child.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
  	and scared_child.event_name not like 'unscheduled%'
LEFT JOIN rcap_scheduling_form sched_main
	ON sched_main.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_demographics AS dem
	ON dem.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_pfh_child AS pfhc
	ON pfhc.source_subject_id = scared_child.source_subject_id
	AND pfhc.event_name like 'baseline%'
LEFT JOIN rcap_pfh_parent AS pfhp
  on pfhp.source_subject_id = scared_child.source_subject_id
WHERE scared_child.scaredc_complete='2'
ORDER BY sa1.subject_id
;
