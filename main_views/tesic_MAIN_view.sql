---- TESIC MAIN View (a unioned view that includes tesic baseline and follow-ups from CTRN Main project)
--- Name of the view: tesic_MAIN_view
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query includes incomplete records which are curated as follows:
--- 	1) Records with NULL schedule [visit]_complete_dates are removed
---     2) Records with NULL dem_ch_dob are removed
---		3) Records with NULL sex are removed
---		4) Duplicate and incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are reported for possible correction and removed
---     5) Variables containing pii/phi and/or unstructured text are removed as per comments below
---     6) Variables used solely for curation/administration are removed as per comments below
---
--- Query the data from the view
--- select * from tesic_MAIN_view
--- where interview_date is not null;
---
--- The body of the view
--- create or replace view tesic_ctrn_view
--- as
select
    sa1.subject_id,
    tesic_u.source_subject_id,
    tesic_u.tc_administrator,
    tesic_u.tc_administrator_other,

--- TBD: Add the sched_main.sched_[visit]_complete status (the "complete" status used for curating incomplete records)
    tesic_u.tc_interview_date,   -- PII; remove after curation
    dem.dem_ch_dob,              -- PII; remove after curation
    case
        when tesic_u.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
    end as interview_age,
    case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex,
    case
        when pfhc.hc_race='1' then 'American Indian/Alaska Native'
        when pfhc.hc_race='2' then 'Asian'
        when pfhc.hc_race='3' then 'Hawaiian or Pacific Islander'
        when pfhc.hc_race='4' then 'Black or African American'
        when pfhc.hc_race='5' then 'White'
        when pfhc.hc_race='6' then 'More than one race'
        when pfhc.hc_race in (null,'0') then 'Unknown or not reported' 
    end as race,
    case
        when pfhc.hc_hispanic = '0' then 'Not Hispanic'
        when pfhc.hc_hispanic = '1' then 'Hispanic'
        else null
    end as hispanic,
   case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when tesic_u.event_name like 'baseline%' then '00_baseline'      
		when tesic_u.event_name like 'one_month%' then '01_one_month'
		when tesic_u.event_name like 'six_month%' then '06_six_month'
		when tesic_u.event_name like 'one_year%' then '12_month'
		when tesic_u.event_name like '18_month%' then '18_month'
		when tesic_u.event_name like '24_month%' then '24_month'
	end as visit,
	--- Unstructured data which may contain pii should be omitted from data products and is thus commented below 
    -- tesic_u.tc_1_1_explain,
    tesic_u.tc_1_1,
    tesic_u.tc_1_1_crit_a1,
    -- tesic_u.tc_1_1_brief,
    tesic_u.tc_1_1_crit_a2,
    tesic_u.tc_1_1_how_often,
    -- tesic_u.tc_1_2_explain,
    tesic_u.tc_1_2,
    tesic_u.tc_1_2_crit_a1,
    -- tesic_u.tc_1_2_brief,
    tesic_u.tc_1_2_crit_a2,
    tesic_u.tc_1_2_how_often,
    -- tesic_u.tc_1_3_explain,
    tesic_u.tc_1_3,
    tesic_u.tc_1_3_crit_a1,
    -- tesic_u.tc_1_3_brief,
    tesic_u.tc_1_3_crit_a2,
    tesic_u.tc_1_3_how_often,
    -- tesic_u.tc_1_4_explain,
    tesic_u.tc_1_4,
    tesic_u.tc_1_4_crit_a1,
    -- tesic_u.tc_1_4_brief,
    tesic_u.tc_1_4_crit_a2,
    tesic_u.tc_1_4_who__no_answer,
    tesic_u.tc_1_4_who__1_mother,
    tesic_u.tc_1_4_who__2_father,
    tesic_u.tc_1_4_who__3_sibling,
    tesic_u.tc_1_4_who__4_grandparent,
    tesic_u.tc_1_4_who__5_otherrelative,
    tesic_u.tc_1_4_who__6_kadult,
    tesic_u.tc_1_4_who__7_kkid,
    tesic_u.tc_1_4_who__8_else,
    -- tesic_u.tc_1_4_other,
    tesic_u.tc_1_4_how_often,
    -- tesic_u.tc_1_5_explain,
    tesic_u.tc_1_5,
    tesic_u.tc_1_5_crit_a1,
    -- tesic_u.tc_1_5_brief,
    tesic_u.tc_1_5_crit_a2,
    tesic_u.tc_1_5_how_often,
    -- tesic_u.tc_1_6_explain,
    tesic_u.tc_1_6,
    tesic_u.tc_1_6_crit_a1,
    -- tesic_u.tc_1_6_brief,
    tesic_u.tc_1_6_crit_a2,
    tesic_u.tc_1_6_how_often,
    -- tesic_u.tc_2_1_explain,
    tesic_u.tc_2_1,
    tesic_u.tc_2_1_crit_a1,
    -- tesic_u.tc_2_1_brief,
    tesic_u.tc_2_1_crit_a2,
    tesic_u.tc_2_1_who__no_answer,
    tesic_u.tc_2_1_who__1_mother,
    tesic_u.tc_2_1_who__2_father,
    tesic_u.tc_2_1_who__3_sibling,
    tesic_u.tc_2_1_who__4_grandparent,
    tesic_u.tc_2_1_who__5_otherrelative,
    tesic_u.tc_2_1_who__6_kadult,
    tesic_u.tc_2_1_who__8_kkid,
    tesic_u.tc_2_1_who__7_unkadult,
    tesic_u.tc_2_1_who__9_unkkid,
    tesic_u.tc_2_1_who__10_else,
    -- tesic_u.tc_2_1_who_other,
    tesic_u.tc_2_1_how__no_answer,
    tesic_u.tc_2_1_how__1_hit_kick_bite,
    tesic_u.tc_2_1_how__2_choke_smother,
    tesic_u.tc_2_1_how__3_burn,
    tesic_u.tc_2_1_how__4_gun_knife,
    tesic_u.tc_2_1_how__5_bat_club,
    tesic_u.tc_2_1_how__6_other,
    -- tesic_u.tc_2_1_how_other,
    tesic_u.tc_2_1_how_often,
    -- tesic_u.tc_2_2_explain,
    tesic_u.tc_2_2,
    tesic_u.tc_2_2_crit_a1,
    -- tesic_u.tc_2_2_brief,
    tesic_u.tc_2_2_crit_a2,
    tesic_u.tc_2_2_who__no_answer,
    tesic_u.tc_2_2_who__1_mother,
    tesic_u.tc_2_2_who__2_father,
    tesic_u.tc_2_2_who__3_sibling,
    tesic_u.tc_2_2_who__4_grandparent,
    tesic_u.tc_2_2_who__5_otherrelative,
    tesic_u.tc_2_2_who__6_kadult,
    tesic_u.tc_2_2_who__8_kkid,
    tesic_u.tc_2_2_who__7_unkadult,
    tesic_u.tc_2_2_who__9_unkkid,
    tesic_u.tc_2_2_who__10_else,
    -- tesic_u.tc_2_2_who_other,
    tesic_u.tc_2_2_how__no_answer,
    tesic_u.tc_2_2_how__1_hit_kick_bite,
    tesic_u.tc_2_2_how__2_choke_smother,
    tesic_u.tc_2_2_how__3_burn,
    tesic_u.tc_2_2_how__4_gun_knife,
    tesic_u.tc_2_2_how__5_bat_club,
    tesic_u.tc_2_2_how__6_other,
    -- tesic_u.tc_2_2_how_other,
    tesic_u.tc_2_2_how_often,
    -- tesic_u.tc_2_3_explain,
    tesic_u.tc_2_3,
    tesic_u.tc_2_3_crit_a1,
    -- tesic_u.tc_2_3_brief,
    tesic_u.tc_2_3_crit_a2,
    tesic_u.tc_2_3_how,
    -- tesic_u.tc_2_3_how_other,
    tesic_u.tc_2_3_how_often,
    -- tesic_u.tc_2_4_explain,
    tesic_u.tc_2_4,
    tesic_u.tc_2_4_crit_a1,
    -- tesic_u.tc_2_4_brief,
    tesic_u.tc_2_4_crit_a2,
    tesic_u.tc_2_4_who__no_answer,
    tesic_u.tc_2_4_who__1_mother,
    tesic_u.tc_2_4_who__2_father,
    tesic_u.tc_2_4_who__3_sibling,
    tesic_u.tc_2_4_who__4_grandparent,
    tesic_u.tc_2_4_who__5_otherrelative,
    tesic_u.tc_2_4_who__6_kadult,
    tesic_u.tc_2_4_who__7_unkadult,
    tesic_u.tc_2_4_who__10_else,
    -- tesic_u.tc_2_4_who_other,
    tesic_u.tc_2_4_how__no_answer,
    tesic_u.tc_2_4_how__1_none,
    tesic_u.tc_2_4_how__2_gun,
    tesic_u.tc_2_4_how__3_knife,
    tesic_u.tc_2_4_how__4_other,
    tesic_u.tc_2_4_how_other,
    tesic_u.tc_2_4_how_often,
    -- tesic_u.tc_2_5_explain,
    tesic_u.tc_2_5,
    tesic_u.tc_2_5_crit_a1,
    -- tesic_u.tc_2_5_brief,
    tesic_u.tc_2_5_crit_a2,
    tesic_u.tc_2_5_how_often,
    -- tesic_u.tc_3_1_explain,
    tesic_u.tc_3_1,
    tesic_u.tc_3_1_crit_a1,
    -- tesic_u.tc_3_1_brief,
    tesic_u.tc_3_1_crit_a2,
    tesic_u.tc_3_1_who__no_answer,
    tesic_u.tc_3_1_who__1_mother,
    tesic_u.tc_3_1_who__2_father,
    tesic_u.tc_3_1_who__3_sibling,
    tesic_u.tc_3_1_who__4_grandparent,
    tesic_u.tc_3_1_who__5_otherrelative,
    tesic_u.tc_3_1_who__6_kadult,
    tesic_u.tc_3_1_who__7_unkadult,
    tesic_u.tc_3_1_who__8_kkid,
    tesic_u.tc_3_1_who__9_unkkid,
    tesic_u.tc_3_1_who__10_else,
    -- tesic_u.tc_3_1_who_other,
    tesic_u.tc_3_1_how__no_answer,
    tesic_u.tc_3_1_how__1_hit_kick_bite,
    tesic_u.tc_3_1_how__2_choke_smother,
    tesic_u.tc_3_1_how__3_burn,
    tesic_u.tc_3_1_how__4_gun_knife,
    tesic_u.tc_3_1_how__5_bat_club,
    tesic_u.tc_3_1_how__6_other,
    -- tesic_u.tc_3_1_how_other,
    tesic_u.tc_3_1_how_often,
    -- tesic_u.tc_3_2_explain,
    tesic_u.tc_3_2,
    tesic_u.tc_3_2_crit_a1,
    -- tesic_u.tc_3_2_brief,
    tesic_u.tc_3_2_crit_a2,
    tesic_u.tc_3_2_who__no_answer,
    tesic_u.tc_3_2_who__1_mother,
    tesic_u.tc_3_2_who__2_father,
    tesic_u.tc_3_2_who__3_sibling,
    tesic_u.tc_3_2_who__4_grandparent,
    tesic_u.tc_3_2_who__5_otherrelative,
    tesic_u.tc_3_2_who__6_kadult,
    tesic_u.tc_3_2_who__7_unkadult,
    tesic_u.tc_3_2_who__8_kkid,
    tesic_u.tc_3_2_who__9_unkkid,
    tesic_u.tc_3_2_who__10_else,
    -- tesic_u.tc_3_2_who_other,
    tesic_u.tc_3_2_how__no_answer,
    tesic_u.tc_3_2_how__1_hit_kick_bite,
    tesic_u.tc_3_2_how__2_choke_smother,
    tesic_u.tc_3_2_how__3_burn,
    tesic_u.tc_3_2_how__4_gun_knife,
    tesic_u.tc_3_2_how__5_bat_club,
    tesic_u.tc_3_2_how__6_other,
    -- tesic_u.tc_3_2_how_other,
    tesic_u.tc_3_2_how_often,
    -- tesic_u.tc_3_3_explain,
    tesic_u.tc_3_3,
    tesic_u.tc_3_3_crit_a1,
    -- tesic_u.tc_3_3_brief,
    tesic_u.tc_3_3_crit_a2,
    tesic_u.tc_3_3_who__no_answer,
    tesic_u.tc_3_3_who__1_mother,
    tesic_u.tc_3_3_who__2_father,
    tesic_u.tc_3_3_who__3_sibling,
    tesic_u.tc_3_3_who__4_grandparent,
    tesic_u.tc_3_3_who__5_otherrelative,
    tesic_u.tc_3_3_how_often,
    -- tesic_u.tc_4_1_explain,
    tesic_u.tc_4_1,
    tesic_u.tc_4_1_crit_a1,
    -- tesic_u.tc_4_1_brief,
    tesic_u.tc_4_1_crit_a2,
    tesic_u.tc_4_1_who__no_answer,
    tesic_u.tc_4_1_who__1_mother,
    tesic_u.tc_4_1_who__2_father,
    tesic_u.tc_4_1_who__3_sibling,
    tesic_u.tc_4_1_who__4_grandparent,
    tesic_u.tc_4_1_who__5_otherrelative,
    tesic_u.tc_4_1_who__6_kadult,
    tesic_u.tc_4_1_who__7_unkadult,
    tesic_u.tc_4_1_who__8_kkid,
    tesic_u.tc_4_1_who__9_unkkid,
    tesic_u.tc_4_1_who__10_else,
    -- tesic_u.tc_4_1_who_other,
    tesic_u.tc_4_1_how__no_answer,
    tesic_u.tc_4_1_how__1_hit_kick_bite,
    tesic_u.tc_4_1_how__2_choke_smother,
    tesic_u.tc_4_1_how__3_burn,
    tesic_u.tc_4_1_how__4_gun_knife,
    tesic_u.tc_4_1_how__5_bat_club,
    tesic_u.tc_4_1_how__6_other,
    -- tesic_u.tc_4_1_how_other,
    tesic_u.tc_4_1_how_often,
    -- tesic_u.tc_4_2_explain,
    tesic_u.tc_4_2,
    tesic_u.tc_4_2_crit_a1,
    -- tesic_u.tc_4_2_brief,
    tesic_u.tc_4_2_crit_a2,
    tesic_u.tc_4_2_who__no_answer,
    tesic_u.tc_4_2_who__1_mother,
    tesic_u.tc_4_2_who__2_father,
    tesic_u.tc_4_2_who__3_sibling,
    tesic_u.tc_4_2_who__4_grandparent,
    tesic_u.tc_4_2_who__5_otherrelative,
    tesic_u.tc_4_2_who__6_kadult,
    tesic_u.tc_4_2_who__7_unkadult,
    tesic_u.tc_4_2_who__8_kkid,
    tesic_u.tc_4_2_who__9_unkkid,
    tesic_u.tc_4_2_who__10_else,
    -- tesic_u.tc_4_2_who_other,
    tesic_u.tc_4_2_how__no_answer,
    tesic_u.tc_4_2_how__1_hit_kick_bite,
    tesic_u.tc_4_2_how__2_choke_smother,
    tesic_u.tc_4_2_how__3_burn,
    tesic_u.tc_4_2_how__4_gun_knife,
    tesic_u.tc_4_2_how__5_bat_club,
    tesic_u.tc_4_2_how__6_other,
    -- tesic_u.tc_4_2_how_other,
    tesic_u.tc_4_2_how_often,
    -- tesic_u.tc_4_3_explain,
    tesic_u.tc_4_3,
    tesic_u.tc_4_3_crit_a1,
    -- tesic_u.tc_4_3_brief,
    tesic_u.tc_4_3_crit_a2,
    tesic_u.tc_4_3_how_often,
    -- tesic_u.tc_5_explain,
    tesic_u.tc_5,
    tesic_u.tc_5_crit_a1,
    -- tesic_u.tc_5_brief,
    tesic_u.tc_5_crit_a2,
    tesic_u.tc_5_who__no_answer,
    tesic_u.tc_5_who__1_mother,
    tesic_u.tc_5_who__2_father,
    tesic_u.tc_5_who__3_sibling,
    tesic_u.tc_5_who__4_grandparent,
    tesic_u.tc_5_who__5_otherrelative,
    tesic_u.tc_5_who__6_kadult,
    tesic_u.tc_5_who__7_unkadult,
    tesic_u.tc_5_who__8_kkid,
    tesic_u.tc_5_who__9_unkkid,
    tesic_u.tc_5_who__10_else,
    -- tesic_u.tc_5_who_other,
    tesic_u.tc_5_how__no_answer,
    tesic_u.tc_5_how__1_fondled_genitals,
    tesic_u.tc_5_how__2_oralchild_genit,
    tesic_u.tc_5_how__3_childoral_genit,
    tesic_u.tc_5_how__4_digitpenetrate,
    tesic_u.tc_5_how__5_intercourse,
    tesic_u.tc_5_how__6_porno_filming,
    tesic_u.tc_5_how__7_prostitution,
    tesic_u.tc_5_how__8_other,
    -- tesic_u.tc_5_how_other,
    tesic_u.tc_5_how_often,
    -- tesic_u.tc_6_1_explain,
    tesic_u.tc_6_1,
    -- tesic_u.tc_6_1_brief,
    tesic_u.tc_6_1_crit_a2,
    tesic_u.tc_6_1_who__no_answer,
    tesic_u.tc_6_1_who__1_older_boy,
    tesic_u.tc_6_1_who__2_younger_boy,
    tesic_u.tc_6_1_who__3_boy_same_grade,
    tesic_u.tc_6_1_who__4_older_girl,
    tesic_u.tc_6_1_who__5_younger_girl,
    tesic_u.tc_6_1_who__6_girl_same_grade,
    tesic_u.tc_6_1_who__7_family,
    tesic_u.tc_6_1_who__8_adultnotfam,
    tesic_u.tc_6_1_who__9_unkkid,
    tesic_u.tc_6_1_who__10_unkadult,
    tesic_u.tc_6_1_who__99_else,
    -- tesic_u.tc_6_1_who_other,
    tesic_u.tc_6_1_how_often,
    -- tesic_u.tc_6_2_explain,
    tesic_u.tc_6_2,
    -- tesic_u.tc_6_2_brief,
    tesic_u.tc_6_2_crit_a2,
    tesic_u.tc_6_2_who__no_answer,
    tesic_u.tc_6_2_who__1_older_boy,
    tesic_u.tc_6_2_who__2_younger_boy,
    tesic_u.tc_6_2_who__3_boy_same_grade,
    tesic_u.tc_6_2_who__4_older_girl,
    tesic_u.tc_6_2_who__5_younger_girl,
    tesic_u.tc_6_2_who__6_girl_same_grade,
    tesic_u.tc_6_2_who__7_family,
    tesic_u.tc_6_2_who__8_adultnotfam,
    tesic_u.tc_6_2_who__9_unkkid,
    tesic_u.tc_6_2_who__10_unkadult,
    tesic_u.tc_6_2_who__99_else,
    tesic_u.tc_6_2_who_other,
    tesic_u.tc_6_2_how_often,
    -- tesic_u.tc_7_explain,
    tesic_u.tc_7,
    tesic_u.tc_7_crit_a1,
    -- tesic_u.tc_7_brief,
    tesic_u.tc_7_crit_a2,
    tesic_u.tc_7_how_often,
    tesic_u.tc_8_1,
    tesic_u.tc_8_2,
    tesic_u.tc_8_1_less_than_1mo,
    tesic_u.tc_8_3,
    tesic_u.tc_8_4,
    tesic_u.tc_8_3_less_than_1mo,
    tesic_u.tc_complete,
	--- TBD: Integration of Luke/Nazan calculations for "cumulative variety indices (tc_cumvaridx_*)" (name replaces "cumulative load")
    -- tesic_u.tc_start_timestamp,
    -- tesic_u.tc_cumload_life_unintentional,
    -- tesic_u.tc_cumload_life_interpers_direct,
    -- tesic_u.tc_cumload_life_interpers_witn_home,
    -- tesic_u.tc_cumload_life_interpers_witn_comm,
    -- tesic_u.tc_cumload_life_bullying,
    -- tesic_u.tc_cumload_life_overall,
	-- Comment or remove the following "worst" variables after curation
    -- tesic_u.tc_1_1_worst,         
    -- tesic_u.tc_1_2_worst,        
	-- tesic_u.tc_1_3_worst,          
    -- tesic_u.tc_1_4_worst,         
    -- tesic_u.tc_1_5_worst,          
    -- tesic_u.tc_1_6_worst,          
    -- tesic_u.tc_2_1_worst,
    -- tesic_u.tc_2_2_worst,
    -- tesic_u.tc_2_3_worst,
    -- tesic_u.tc_2_4_worst,
    -- tesic_u.tc_2_5_worst,
    -- tesic_u.tc_3_1_worst,
    -- tesic_u.tc_3_2_worst,
    -- tesic_u.tc_3_3_worst,
    -- tesic_u.tc_4_1_worst,
    -- tesic_u.tc_4_2_worst,
    -- tesic_u.tc_4_3_worst,
    -- tesic_u.tc_5_worst,
    -- tesic_u.tc_7_worst,
    case
        when tc_1_1_worst = '1' then '1_1'
        when tc_1_2_worst = '1' then '1_2'
        when tc_1_3_worst = '1' then '1_3'
        when tc_1_4_worst = '1' then '1_4'
        when tc_1_5_worst = '1' then '1_5'
        when tc_1_6_worst = '1' then '1_6'
        when tc_2_1_worst = '1' then '2_1'
        when tc_2_2_worst = '1' then '2_2'
        when tc_2_3_worst = '1' then '2_3'
        when tc_2_4_worst = '1' then '2_4'
        when tc_2_5_worst = '1' then '2_5'
        when tc_3_1_worst = '1' then '3_1'
        when tc_3_2_worst = '1' then '3_2'
        when tc_3_3_worst = '1' then '3_3'
        when tc_4_1_worst = '1' then '4_1'
        when tc_4_2_worst = '1' then '4_2'
        when tc_4_3_worst = '1' then '4_3'
        when tc_5_worst = '1' then '5'
        when tc_7_worst = '1' then '7'
        else null 
    end as tc_8_1_worst,
    age_years_between(tesic_u.tc_8_2::date, dem.dem_ch_dob::date) as worst_age_yrs,
    age_days_between(tesic_u.tc_8_2::date, tesic_u.tc_interview_date::date) AS worst_days_b4visit,
    tesic_u.tcfu_8_3,  -- This variable needs to be initialized with tc_8_1_worst at baseline and updated with the new tc_8_1_worst when tcfu_8_3 is "1"
    --tesic_u.tc_8_worst_ever,
	-- Comment or remove the following "most_recent" variables after curation
    -- tesic_u.tc_1_1_most_recent,
    -- tesic_u.tc_1_2_most_recent,
    -- tesic_u.tc_1_3_most_recent,
    -- tesic_u.tc_1_4_most_recent,
    -- tesic_u.tc_1_5_most_recent,
    -- tesic_u.tc_1_6_most_recent,
    -- tesic_u.tc_2_1_most_recent,
    -- tesic_u.tc_2_2_most_recent,
    -- tesic_u.tc_2_3_most_recent,
    -- tesic_u.tc_2_4_most_recent,
    -- tesic_u.tc_2_5_most_recent,
    -- tesic_u.tc_3_1_most_recent,
    -- tesic_u.tc_3_2_most_recent,
    -- tesic_u.tc_3_3_most_recent,
    -- tesic_u.tc_4_1_most_recent,
    -- tesic_u.tc_4_2_most_recent,
    -- tesic_u.tc_4_3_most_recent,
    -- tesic_u.tc_5_most_recent,
    -- tesic_u.tc_7_most_recent,
    case
        when tc_1_1_most_recent = '1' then '1_1'
        when tc_1_2_most_recent = '1' then '1_2'
        when tc_1_3_most_recent = '1' then '1_3'
        when tc_1_4_most_recent = '1' then '1_4'
        when tc_1_5_most_recent = '1' then '1_5'
        when tc_1_6_most_recent = '1' then '1_6'
        when tc_2_1_most_recent = '1' then '2_1'
        when tc_2_2_most_recent = '1' then '2_2'
        when tc_2_3_most_recent = '1' then '2_3'
        when tc_2_4_most_recent = '1' then '2_4'
        when tc_2_5_most_recent = '1' then '2_5'
        when tc_3_1_most_recent = '1' then '3_1'
        when tc_3_2_most_recent = '1' then '3_2'
        when tc_3_3_most_recent = '1' then '3_3'
        when tc_4_1_most_recent = '1' then '4_1'
        when tc_4_2_most_recent = '1' then '4_2'
        when tc_4_3_most_recent = '1' then '4_3'
        when tc_5_most_recent = '1' then '5'
        when tc_7_most_recent = '1' then '7'
    end as tc_8_3_most_recent, 
    age_years_between(tesic_u.tc_8_4::date, dem.dem_ch_dob::date) as recent_age_yrs,
    age_days_between(tesic_u.tc_8_4::date, tesic_u.tc_interview_date::date) as recent_days_b4visit
from view_tesic_union tesic_u -- Attention! The view (not the table) is utilized
inner join subject_alias sa1
    on sa1.source_subject_id = tesic_u.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and tesic_u.event_name not like 'unscheduled%'
left join rcap_demographics dem
    on dem.source_subject_id = tesic_u.source_subject_id
-- left join dim_dem_ch_lang dim_dem_lang -- Joining the dimension table
--     on dim_dem_lang.dem_ch_lang_value = dem.dem_ch_lang
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = tesic_u.source_subject_id 
left join rcap_pfh_child pfhc
    on pfhc.source_subject_id = tesic_u.source_subject_id
    and pfhc.language = dim_dem_lang.dem_ch_lang_language -- the dimension table
    and pfhc.event_name like 'baseline%';



