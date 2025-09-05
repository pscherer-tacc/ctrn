-- Creating scared_child NDA view

SELECT dem.dem_guid AS subjectkey,
	   sa1.subject_id AS src_subject_id,
	   scared_child.source_subject_id, -- only for validation; DELETE before submission
	   scared_child.event_name, -- only for validation; DELETE before submission
	CASE
		WHEN scared_child.event_name LIKE 'baseline%' THEN TO_CHAR(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'one_month%' THEN TO_CHAR(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'six_month%' THEN TO_CHAR(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE 'one_year%' THEN TO_CHAR(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
	    --WHEN scared_child.event_name LIKE '18_month%' THEN TO_CHAR(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		WHEN scared_child.event_name LIKE '24_month%' THEN TO_CHAR(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end AS interview_date,
	CASE
	    WHEN scared_child.event_name LIKE 'baseline%' THEN nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'one_month%' THEN nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'six_month%' THEN nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		WHEN scared_child.event_name LIKE 'one_year%' THEN nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--WHEN scared_child.event_name LIKE '18_month%' THEN nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when scared_child.event_name LIKE '24_month%' THEN nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end AS interview_age, 
	CASE
	    WHEN scared_child.event_name LIKE 'baseline%' THEN sched_main.sched_base_complete
		WHEN scared_child.event_name LIKE 'one_month%' THEN sched_main.sched_1mo_complete
		WHEN scared_child.event_name LIKE 'six_month%' THEN sched_main.sched_6mo_complete
		WHEN scared_child.event_name LIKE 'one_year%' THEN sched_main.sched_1yr_complete
		--WHEN scared_child.event_name LIKE '18_month%' THEN sched.sched_18mo_complete
		WHEN scared_child.event_name LIKE '24_month%' THEN sched_main.sched_2yr_complete
	end AS complete, -- only for validation; DELETE before submission,
	CASE
	    WHEN pfhc.hc_sex_birth_cert='1' THEN 'F'
		WHEN pfhc.hc_sex_birth_cert='2' THEN 'M'
		ELSE NULL
	end AS sex,
	-- simplified since all records are already filtered to be '2'. Refer to WHERE clause
	'scared child complete' AS scared_version,
	CASE
        WHEN pfhp.hp_parent1_relationship='0' OR pfhp.hp_parent1_relationship IS NULL THEN -999
        WHEN pfhp.hp_parent1_relationship='1' THEN 89 -- Biological parent
        WHEN pfhp.hp_parent1_relationship='2' THEN 92 -- Adoptive parent
        WHEN pfhp.hp_parent1_relationship='3' THEN 93 -- Foster parent
        WHEN pfhp.hp_parent1_relationship='4' THEN 91 -- Stepparent
        WHEN pfhp.hp_parent1_relationship='5' THEN 90 -- Other
    end AS relationship,
	scared_child.scaredc_1 AS scared_1,
	scared_child.scaredc_2 AS scared_2,
	scared_child.scaredc_3 AS scared_3,
	scared_child.scaredc_4 AS scared_4,
	scared_child.scaredc_5 AS scared_5,
	scared_child.scaredc_6 AS scared_6,
	scared_child.scaredc_7 AS scared_7,
	scared_child.scaredc_8 AS scared_8,
	scared_child.scaredc_9 AS scared_9,
	scared_child.scaredc_10 AS scared_10,
	scared_child.scaredc_11 AS scared_11,
	scared_child.scaredc_12 AS scared_12,
	scared_child.scaredc_13 AS scared_13,
	scared_child.scaredc_14 AS scared_14,
	scared_child.scaredc_15 AS scared_15,
	scared_child.scaredc_16 AS scared_16,
	scared_child.scaredc_17 AS scared_17,
	scared_child.scaredc_18 AS scared_18,
	scared_child.scaredc_19 AS scared_19,
	scared_child.scaredc_20 AS scared_20,
	scared_child.scaredc_21 AS scared_21,
	scared_child.scaredc_22 AS scared_22,
	scared_child.scaredc_23 AS scared_23,
	scared_child.scaredc_24 AS scared_24,
	scared_child.scaredc_25 AS scared_25,
	scared_child.scaredc_26 AS scared_26,
	scared_child.scaredc_27 AS scared_27,
	scared_child.scaredc_28 AS scared_28,
	scared_child.scaredc_29 AS scared_29,
	scared_child.scaredc_30 AS scared_30,
	scared_child.scaredc_31 AS scared_31,
	scared_child.scaredc_32 AS scared_32,
	scared_child.scaredc_33 AS scared_33,
	scared_child.scaredc_34 AS scared_34,
	scared_child.scaredc_35 AS scared_35,
	scared_child.scaredc_36 AS scared_36,
	scared_child.scaredc_37 AS scared_37,
	scared_child.scaredc_38 AS scared_38,
	scared_child.scaredc_39 AS scared_39,
	scared_child.scaredc_40 AS scared_40,
	scared_child.scaredc_41 AS scared_41,
	COALESCE(CAST(base.brpt_scared_tot_score AS INTEGER), 999) AS scared_total,
	COALESCE(CAST(base.brpt_scared_paso_score AS INTEGER), 999) AS scared_pd_score,
	COALESCE(CAST(base.brpt_scared_ga_score AS INTEGER), 999) AS scared_gad_score,
	COALESCE(CAST(base.brpt_scared_sep_score AS INTEGER), 999) AS scared_sad_score,
	COALESCE(CAST(base.brpt_scared_soc_score AS INTEGER), 999) AS scared_socad_score,
	COALESCE(CAST(base.brpt_scared_sch_score AS INTEGER), 999) AS scared_ssa_score,
	CASE
		WHEN scared_child.event_name LIKE 'baseline%' THEN 'baseline'
		WHEN scared_child.event_name LIKE 'one_month%' THEN 'one_month'
		WHEN scared_child.event_name LIKE 'six_month%' THEN 'six_month'
		WHEN scared_child.event_name LIKE 'one_year%' THEN 'one_year'
		-- WHEN scared_child.event_name LIKE '18_month%' THEN '18_month'
		WHEN scared_child.event_name LIKE '24_month%' THEN '24_month'
	end AS visit
FROM rcap_scared_child AS scared_child -- Attention! rcap_scared_child is not a CTAU table.
INNER JOIN rcap_ctau_scheduling_form AS sched -- to keep CTAU participants only
	ON sched.sched_ctrn_id = scared_child.source_subject_id
	AND sched.event_name LIKE 'baseline%'
	AND scared_child.event_name NOT LIKE 'unscheduled%'
INNER JOIN subject_alias AS sa1
	ON sa1.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_scheduling_form AS sched_main
	ON sched_main.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_demographics AS dem
	ON dem.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_pfh_child AS pfhc
	ON pfhc.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_pfh_parent AS pfhp
    on pfhp.source_subject_id = scared_child.source_subject_id
LEFT JOIN rcap_baseline_report AS base
	on base.source_subject_id = scared_child.source_subject_id
WHERE scared_child.scaredc_complete='2'
	AND scared_child.event_name NOT LIKE '18_month%'
--ORDER BY sa1.subject_id
;

