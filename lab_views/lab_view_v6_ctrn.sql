--------- CTAU part of the lab view
with ctrn_main_instruments_union
as (
    select source_subject_id, event_name
    from view_tesic_union
    union
    select source_subject_id,
    case 
        when event_name = 'baseline_parent_arm_1' then 'baseline_both_arm_1'
        else event_name
    end as event_name
    from rcap_tesip
    union
    select source_subject_id, event_name
    from rcap_pfh_adult_child
    union
    select source_subject_id,
    case 
        when event_name = 'baseline_parent_arm_1' then 'baseline_both_arm_1'
        else event_name
    end as event_name
    from rcap_pfh_parent
--    
    -- Uniting rcap_child_assistance table adds many 
    -- source_subject_id-event_name pairs, 
    -- which can lead to many sparse records in the final view.
    union
    select source_subject_id, event_name
    from rcap_child_assistance -- Uniting this table adds many source_subject_id - event_name pairs, which can lead to many sparces
--    
    union
    select source_subject_id, event_name
    from rcap_miniss_v2
    union
    select source_subject_id, event_name
    from rcap_ctau_audit
    union
    select source_subject_id, event_name
    from rcap_capsca5
    union
    select source_subject_id, event_name
    from rcap_phqa
    union
    select source_subject_id, event_name
    from rcap_scared_child
    union
    select source_subject_id, event_name
    from rcap_chrt16
    union
    select source_subject_id, event_name
    from rcap_casss_child
    union
    select source_subject_id, event_name
    from rcap_casss_college
)
select
    sa1.subject_id,
    ctrn_union.source_subject_id as ctrn_source_subject_id, -- PII CTRN record_id; Remove after curation
    ctrn_union.event_name, -- event_name from a corresponding CTRN Main record for this and the following case
	case
	  when ctrn_union.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
      when ctrn_union.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
	  when ctrn_union.event_name like 'six_month%' then to_char(sched_6mo_complete_date,'mm/dd/yyyy')
	  when ctrn_union.event_name like 'one_year%' then to_char(sched.sched_1yr_complete_date,'mm/dd/yyyy')
      when ctrn_union.event_name like '18_month%' then to_char(sched.sched_18mo_complete_date,'mm/dd/yyyy')
	  when ctrn_union.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as sched_ctrn_complete_date, -- PII. Remove after curation.
    dem.dem_ch_dob,  -- PII; Remove after curation
    case 
      when ctrn_union.event_name like 'baseline%' then age_days_between(dem.dem_ch_dob::date, sched.sched_base_complete_date)
      when ctrn_union.event_name like 'one_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_1mo_complete_date)
      when ctrn_union.event_name like 'six_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_6mo_complete_date)
      when ctrn_union.event_name like 'one_year%' then age_days_between(dem.dem_ch_dob::date, sched.sched_1yr_complete_date)
      when ctrn_union.event_name like '18_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_18mo_complete_date)
      when ctrn_union.event_name like '24_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_2yr_complete_date)
    end as age_days_interview,
    case
      when ctrn_union.event_name like 'baseline%' then sched.sched_base_complete
      when ctrn_union.event_name like 'one_month%' then sched.sched_1mo_complete
      when ctrn_union.event_name like 'six_month%' then sched.sched_6mo_complete
      when ctrn_union.event_name like 'one_year%' then sched.sched_1yr_complete
      when ctrn_union.event_name like '18_month%' then sched.sched_18mo_complete
      when ctrn_union.event_name like '24_month%' then sched.sched_2yr_complete
    end as complete,
    case
      when ctrn_union.event_name like 'baseline%' then '00_baseline_ctrn'
	  when ctrn_union.event_name like 'one_month%' then '01_month_ctrn'
      when ctrn_union.event_name like 'six_month%' then '06_month_ctrn'
      when ctrn_union.event_name like 'one_year%' then '12_month_ctrn'
	  when ctrn_union.event_name like '18_month%' then '18_month_ctrn'
      when ctrn_union.event_name like '24_month%' then '24_month_ctrn'
    end as visit,
    case
      when pfhc.hc_sex_birth_cert::text = '1' then 'F'
      when pfhc.hc_sex_birth_cert::text = '2' then 'M'
      else null
    end as sex,
    pfhc.hc_race as race,
    pfhc.hc_hispanic as hispanic,
--
    pfha_u.instrument,
    pfha_u.parent1_relationship,
    pfha_u.parent1_sex,
    pfha_u.parent1_educ,
    pfha_u.parent2_gender,
    pfha_u.parent2_educ,
    pfha_u.alc_abuse__0_child,
    pfha_u.alc_abuse__1_you,
    pfha_u.alc_abuse__2_othpar,
    pfha_u.alc_abuse__3_brother,
    pfha_u.alc_abuse__4_sister,
    pfha_u.thc_abuse__0_child,
    pfha_u.thc_abuse__1_you,
    pfha_u.thc_abuse__2_othpar,
    pfha_u.thc_abuse__3_brother,
    pfha_u.thc_abuse__4_sister,
    pfha_u.drug_abuse__0_child,
    pfha_u.drug_abuse__1_you,
    pfha_u.drug_abuse__2_othpar,
    pfha_u.drug_abuse__3_brother,
    pfha_u.drug_abuse__4_sister,
--
    tc.tc_1_1, -- In a bad accident
    tc.tc_1_1_crit_a1,
	tc.tc_1_1_how_often,
    tp.tp_1_1_age_first,
    tc.tc_1_1_worst, -- Worst checkboxes from baseline and tcfu; the coalesced variable name should be entered as tc_8_1.
    tc.tc_1_2, -- Saw a bad accident
    tc.tc_1_2_crit_a1,
    tc.tc_1_2_how_often,
    tp.tp_1_2_age_first,
    tc.tc_1_2_worst,
    tc.tc_1_3,  -- Bad storm, flood, earthquake 
    tc.tc_1_3_crit_a1,
    tc.tc_1_3_how_often,
    tp.tp_1_3_age_first,
    tc.tc_1_3_worst,
    tc.tc_1_4, -- Serious illness/death of another
    tc.tc_1_4_crit_a1,
    tc.tc_1_4_how_often,
    tp.tp_1_4a_age_first,
    tp.tp_1_4b_age_first,
    tc.tc_1_4_worst,
    tc.tc_1_5, -- Hospitalization
    tc.tc_1_5_crit_a1,
    tc.tc_1_5_how_often,
    tp.tp_1_5_age_first,
    tc.tc_1_5_worst,
    tc.tc_1_6, -- Separation from parents or guardian
    tc.tc_1_6_crit_a1,
    tc.tc_1_6_how_often,
    tp.tp_1_6_age_first,
    tc.tc_1_6_worst,
    tc.tc_2_1, -- Attacked and badly hurt)
    tc.tc_2_1_crit_a1,
    tc.tc_2_1_how_often,
    tp.tp_2_1_age_first,
    tc.tc_2_1_worst,
    tc.tc_2_2, -- Threats to hurt you
    tc.tc_2_2_crit_a1,
    tc.tc_2_2_how_often,
    tp.tp_2_2_age_first,
    tc.tc_2_2_worst,
    tc.tc_2_3,  -- Robbed
    tc.tc_2_3_crit_a1,
    tc.tc_2_3_how_often,
    tp.tp_2_3_age_first,
    tc.tc_2_3_worst,
    tc.tc_2_4, -- Kidnapping
    tc.tc_2_4_crit_a1,
    tc.tc_2_4_how_often,
    tp.tp_2_4_age_first,
    tc.tc_2_4_worst,
    tc.tc_2_5, -- Dog or animal attack
    tc.tc_2_5_crit_a1,
    tc.tc_2_5_how_often,
    tp.tp_2_5_age_first,
    tc.tc_2_5_worst,
    tc.tc_3_1, -- Physical family violence
	tc.tc_3_1_crit_a1,
    tc.tc_3_1_how_often,
    tp.tp_3_1_age_first,
    tc.tc_3_1_worst,
    tc.tc_3_2, -- Frequent family arguments
    tc.tc_3_2_crit_a1,
    tc.tc_3_2_how_often,
    tp.tp_3_2_age_first,
    tc.tc_3_2_worst,
    tc.tc_3_3, -- Family member jailed or arrested 
    tc.tc_3_3_crit_a1,
    tc.tc_3_3_how_often,
    tp.tp_3_3_age_first,
    tc.tc_3_3_worst,
    tc.tc_4_1,  -- Witness physical violence outside home
    tc.tc_4_1_crit_a1,
    tc.tc_4_1_how_often,
    tp.tp_4_1_age_first,
    tc.tc_4_1_worst,
    tc.tc_4_2, -- Witness nonphysical violence outside home 
    tc.tc_4_2_crit_a1,
    tc.tc_4_2_how_often,
    tp.tp_4_2_age_first,
    tc.tc_4_2_worst,
    tc.tc_4_3, -- Violence on TV or media
    tc.tc_4_3_crit_a1,
    tc.tc_4_3_how_often,
    tp.tp_4_3_age_first,
    tc.tc_4_3_worst,
    tc.tc_5, -- Touched inappropriately
  	tc.tc_5_crit_a1,
    tc.tc_5_how_often,
    tp.tp_5_1_age_first,
    tp.tp_5_2_age_first,
    tc.tc_5_worst,
    tc.tc_6_1, -- Repeated bullying,
	tc.tc_6_1_how_often,
    tp.tp_6_1_age_first,
    tc.tc_6_2, -- Cyberbullying
    tc.tc_6_2_how_often,
    tp.tp_6_2_age_first,
    tc.tc_7, -- Somebody did or said something that made you feel the most scared or unhappy you've ever felt, or that bothers you a lot now? Or you were left all alone and you were afraid you would die or no one would ever help
    tc.tc_7_crit_a1,
    tc.tc_7_how_often,
    tp.tp_7_1_age_first,
    tc.tc_7_worst,
    case
      when tc.tc_1_1_worst = '1' then '1_1'
      when tc.tc_1_2_worst = '1' then '1_2'
      when tc.tc_1_3_worst = '1' then '1_3'
      when tc.tc_1_4_worst = '1' then '1_4'
      when tc.tc_1_5_worst = '1' then '1_5'
      when tc.tc_1_6_worst = '1' then '1_6'
      when tc.tc_2_1_worst = '1' then '2_1'
      when tc.tc_2_2_worst = '1' then '2_2'
      when tc.tc_2_3_worst = '1' then '2_3'
      when tc.tc_2_4_worst = '1' then '2_4'
      when tc.tc_2_5_worst = '1' then '2_5'
      when tc.tc_3_1_worst = '1' then '3_1'
      when tc.tc_3_2_worst = '1' then '3_2'
      when tc.tc_3_3_worst = '1' then '3_3'
      when tc.tc_4_1_worst = '1' then '4_1'
      when tc.tc_4_2_worst = '1' then '4_2'
      when tc.tc_4_3_worst = '1' then '4_3'
      when tc.tc_5_worst = '1' then '5'
      when tc.tc_7_worst = '1' then '7'
      else null
    end as tc_8_1_worst,
    tc.tc_8_1 as tc_worst,    -- Classification of the worst trauma within the period prior to the visit
    tc.tc_8_1_less_than_1mo as tc_worst_less_than_1mo,
	tc.tc_8_2,                -- PII, date for calculating worst age and duration; remove after curation 
    age_years_between(tc.tc_8_2::date, dem.dem_ch_dob::date) as worst_age_yrs,
    age_days_between(tc.tc_8_2::date, tc.tc_interview_date::date) AS worst_days_b4visit,
    tc.tcfu_8_3,   -- This is a checkbox indicating that the trauma identified in tcfu_8_1 was the "worst ever". 
	-- tc_8_worst_ever,  -- This variable needs to be initialized with tc_8_1_worst at baseline and updated with the new tc_8_1_worst when tcfu_8_3 is "1"
	tc.tc_8_4,         -- PII, date of the most recent trauma reported at baseline; used to calculate age and recency; remove after curation  
    case
      when tc.tc_1_1_most_recent = '1' then '1_1'
      when tc.tc_1_2_most_recent = '1' then '1_2'
      when tc.tc_1_3_most_recent = '1' then '1_3'
      when tc.tc_1_4_most_recent = '1' then '1_4'
      when tc.tc_1_5_most_recent = '1' then '1_5'
      when tc.tc_1_6_most_recent = '1' then '1_6'
      when tc.tc_2_1_most_recent = '1' then '2_1'
      when tc.tc_2_2_most_recent = '1' then '2_2'
      when tc.tc_2_3_most_recent = '1' then '2_3'
      when tc.tc_2_4_most_recent = '1' then '2_4'
      when tc.tc_2_5_most_recent = '1' then '2_5'
      when tc.tc_3_1_most_recent = '1' then '3_1'
      when tc.tc_3_2_most_recent = '1' then '3_2'
      when tc.tc_3_3_most_recent = '1' then '3_3'
      when tc.tc_4_1_most_recent = '1' then '4_1'
      when tc.tc_4_2_most_recent = '1' then '4_2'
      when tc.tc_4_3_most_recent = '1' then '4_3'
      when tc.tc_5_most_recent = '1' then '5'
      when tc.tc_7_most_recent = '1' then '7'
      else null
    end as tc_8_3_most_recent,
    tc.tc_8_3 AS most_recent,   -- Classification of the most recent trauma
    tc.tc_8_3_less_than_1mo as tc_most_recent_less_than_1mo, -- "1" indicates that the most recent trauma was less than 1 month prior to this visit 
    age_years_between(tc.tc_8_4::date, dem.dem_ch_dob::date) as most_recent_trauma_age_yrs, -- Remove dates before sharing publicly
    age_days_between(tc.tc_8_4::date, tc.tc_interview_date::date) as recent_days_b4visit,
    ---- Criteria A1 trauma count subtotals
    (
        coalesce(tc.tc_1_1_crit_a1::int, 0) + coalesce(tc.tc_1_2_crit_a1::int, 0)
        + coalesce(tc.tc_1_3_crit_a1::int, 0) + coalesce(tc.tc_1_4_crit_a1::int, 0)
        + coalesce(tc.tc_1_5_crit_a1::int, 0) + coalesce(tc.tc_1_6_crit_a1::int, 0)
        + coalesce(tc.tc_2_5_crit_a1::int, 0)
    ) as tc_unintentional_a1_cnt,

    (
        coalesce(tc.tc_2_1_crit_a1::int, 0) + coalesce(tc.tc_2_2_crit_a1::int, 0)
        + coalesce(tc.tc_2_3_crit_a1::int, 0) + coalesce(tc.tc_2_4_crit_a1::int, 0)
        + coalesce(tc.tc_5_crit_a1::int, 0)
    ) as tc_interpers_direct_a1_cnt,

    (
        coalesce(tc.tc_3_1_crit_a1::int, 0) + coalesce(tc.tc_3_2_crit_a1::int, 0)
        + coalesce(tc.tc_3_3_crit_a1::int, 0)
    ) as tc_interpers_witn_home_a1_cnt,

    (
        coalesce(tc.tc_4_1_crit_a1::int, 0) + coalesce(tc.tc_4_2_crit_a1::int, 0)
        + coalesce(tc.tc_4_3_crit_a1::int, 0)
    ) as tc_interpers_witn_comm_a1_cnt,

    (
        coalesce(tc.tc_6_1::int, 0)
        + coalesce(tc.tc_6_2::int, 0)
    ) as tc_bullying_cnt,
---
    --- TBD: Nazan's cumulative trauma variety index (unique trauma counts) TBD
    --- ,tc_cumvaridx_unintentional	      -- unique cumulative count of tc_1_1 thru tc_1_6 and tc_2_5 criteria a1   
    --- ,tc_cumvaridx_interpers_direct     -- unique cumulative count of tc_2_1 thru tc_2_4 and tc_5 criteria a1
    --- ,tc_cumvaridx_interpers_witn_home  -- unique cumulative count of tc_3_1 thru tc_3_3 criteria a1
 	--- ,tc_cumvaridx_interpers_witn_comm  -- unique cumulative count of tc_4_1 thru tc_4_3 criteria a1
	--- ,tc_cumvaridx_bullying             -- unique cumulative count of tc_6_1 and tc_6_2
    ---	   ,(
    ---            tc_cumvaridx_unintentional
    ---            + tc_cumvaridx_interpers_direct 
    ---            + tc_cumvaridx_interpers_witn_home 
    ---            + tc_cumvaridx_interpers_witn_comm 
    ---            + coalesce(tc_7_crit_a1::int,0)
    ---	   ) as tc_cumvaridx_life_overall,
--- Fields from rcap_child_assistance and mini
    chass.ctx_itx,         -- Child individual therapy treatment
	chass.ctx_iftx,        -- Family therapy treatment
    chass.ctx_ipsy_hosp,   -- Child admitted to psych hospital
    chass.ctx_ipsy_meds,   -- Child prescribed psych meds
    mini.mini_primary_dx,  -- Primary diagnosis
--- Fields from capsca (main)
    caps.caps_summary_a,            -- Criterian A met? 1=yes  
	-- Unless otherwise noted, scales are 0-4 where 0="absent", 1="mild/subthreshold, 2="moderate", 3="severe", 4="extreme/incapacitating"
	caps.caps_summary_b1_sev_q1,    -- Intrusive memories
	caps.caps_summary_b2_sev_q2,    -- Distressing dreams
	caps.caps_summary_b3_sev_q3,    -- Dissociative reactions
	caps.caps_summary_b4_sev_q4,    -- Cued psychological distress
	caps.caps_summary_b5_sev_q5,    -- Cued psychological reactions
    caps.caps_summary_c1_sev_q6,    -- Avoidance of memories, thoughts, feelings
	caps.caps_summary_c2_sev_q7,    -- Avoidance of external reminders
	caps.caps_summary_d1_sev_q8,    -- Inability to recall important aspect of event
	caps.caps_summary_d2_sev_q9,    -- Exaggerated negative beliefs or expectations
	caps.caps_summary_d3_sev_q10,   -- Distorted cognitions leading to blame
	caps.caps_summary_d4_sev_q11,   -- Persistent negative emotional state
	caps.caps_summary_d5_sev_q12,   -- Diminished interest or participation in activities
	caps.caps_summary_d6_sev_q13,   -- Detachment or estrangement from others
	caps.caps_summary_d7_sev_q14,   -- Persistent inability to experience positive emotions
	caps.caps_summary_e1_sev_q15,   -- Irritable behavior and angry outbursts 	
	caps.caps_summary_e2_sev_q16,   -- Reckless or self-destructive behavior
	caps.caps_summary_e3_sev_q17,   -- Hypervigilance
	caps.caps_summary_e4_sev_q18,   -- Exaggerated startle response		
	caps.caps_summary_e5_sev_q19,   -- Problems with concentration	
	caps.caps_summary_e6_sev_q20,   -- Sleep disturbance	
	caps.caps_summary_f1_q22,       -- Duration of disturbance >= 1 month
	caps.caps_summary_g1_sev_q23,   -- Subjective distress
	caps.caps_summary_g2_sev_q24,   -- Impairment in social functioning
	caps.caps_summary_g3_sev_q25,	-- Impairment in development
    caps.caps_summary_validity_q26,	-- Global validity; scales are 0-4 where (0) Excellent, no reason to suspect invalid responses, (1) Good, factors present that may adversely affect validity,(2) Fair, factors present that definitely reduce validity, (3) Poor, substantially reduced validity, (4) Invalid responses   
	caps.caps_summary_severity_q27, -- Global severity
	caps.caps_summary_improve_q28,  -- Global improvement;Scales are 0-5 where (0) Asymptomatic,(1) Considerable improvement,(2) Moderate improvement,(3) Slight improvement,(4) No improvement,(5) Insufficient information 
	caps.caps_sum_depers_sev_q29,   -- Depersonalization
	caps.caps_sum_dereal_sev_q30,   -- Derealization		
    caps.caps_sum_ptsd_present,		
    caps.caps_summary_dissoc,	
    caps.caps_sum_delayed,
--- Additional data: phq-a; values for phq_1 thru phq_9 are: 1, Not at all | 2, Several Days | 3, More than half the days | 4, Nearly Every Day
    phqa.phq_1_val,  -- Feeling down, depressed, irritable, or hopeless?	
    phqa.phq_2_val,  -- Little interest or pleasure in doing things?
    phqa.phq_3_val,  -- Trouble falling asleep, staying asleep, or sleeping too much?
    phqa.phq_4_val,  -- Poor appetite, weight loss, or overeating?
    phqa.phq_5_val,  -- Feeling tired, or having little energy?
    phqa.phq_6_val,  -- Feeling bad about yourself - or feeling that you are a failure, or that you have let yourself or your family down?
    phqa.phq_7_val,	-- Trouble concentrating on things like school work, reading, or watching TV?
    phqa.phq_8_val,  -- Moving or speaking so slowly that other people could  have noticed? Or the opposite - being so fidgety or restless that you were moving around a lot more than usual?
    phqa.phq_9_val,  -- Thoughts that you would be better off dead, or of   hurting yourself in some way?
    phqa.phq9_score, -- Total 0-27 points for phq_1 through phq_9
    phqa.phqa_10,    -- In the past year have you felt depressed or sad most days, even if you felt okay sometimes?
    phqa.phqa_11,    -- If you are experiencing any of the problems on this form, how difficult have these problems made it for you to  do your work, take care of things at home or get along with other people?
    phqa.phqa_12,    -- Has there been a time in the past month when you have had serious thoughts about ending your life?
    phqa.phqa_13,    -- Have you EVER, in your WHOLE LIFE, tried to kill yourself or made a suicide attempt?
	---   
	--- Additional data: scared_child; values for all scaredc questions are  (0) Not True or Hardly Ever True | 1, (1) Somewhat True or Sometimes True | 2, (2) Very True or Often True
	---
    scaredc.scaredc_1,  -- When I feel frightened, it is hard to breathe.
    scaredc.scaredc_2,  -- I get headaches when I am at school.
    scaredc.scaredc_3,  -- I don't like to be with people I don't know well.
    scaredc.scaredc_4,  -- I get scared if I sleep away from home.
    scaredc.scaredc_5,  -- I worry about other people liking me
    scaredc.scaredc_6,  -- When I get frightened, I feel like passing out
    scaredc.scaredc_7,  -- I am nervous.
    scaredc.scaredc_8,  -- I follow my mother or father wherever they go.
    scaredc.scaredc_9,  -- People tell me that I look nervous.
    scaredc.scaredc_10, -- I feel nervous with people I don't know well.
    scaredc.scaredc_11, -- I feel nervous with people I don't know well.
    scaredc.scaredc_12, -- When I get frightened, I feel like I am going crazy.
    scaredc.scaredc_13, -- I worry about sleeping alone.
    scaredc.scaredc_14, -- I worry about being as good as other kids.
    scaredc.scaredc_15, -- When I get frightened, I feel like things are not real.
    scaredc.scaredc_16, -- I have nightmares about something bad happening to my parents.
    scaredc.scaredc_17, -- I worry about going to school.
    scaredc.scaredc_18, -- When I get frightened, my heart beats fast.
    scaredc.scaredc_19, -- I get shaky.
    scaredc.scaredc_20, -- I have nightmares about something bad happening to me.
    scaredc.scaredc_21, -- I worry about things working out for me.
    scaredc.scaredc_22, -- When I get frightened, I sweat a lot.
    scaredc.scaredc_23, -- I am a worrier.
    scaredc.scaredc_24, -- I get really frightened for no reason at all.
    scaredc.scaredc_25, -- I am afraid to be alone in the house.
    scaredc.scaredc_26, -- It is hard for me to talk with people I don't know well.
    scaredc.scaredc_27, -- When I get frightened, I feel like I am choking.
    scaredc.scaredc_28, -- People tell me that I worry too much.
    scaredc.scaredc_29, -- I don't like to be away from my family.
    scaredc.scaredc_30, -- I am afraid of having anxiety (or panic) attacks.
    scaredc.scaredc_31, -- I worry that something bad might happen to my parents.
    scaredc.scaredc_32, -- I feel shy with people I don't know well.
    scaredc.scaredc_33, -- I worry about what is going to happen in the future
    scaredc.scaredc_34, -- When I get frightened, I feel like throwing up.
    scaredc.scaredc_35, -- I worry about how well I do things.
    scaredc.scaredc_36, -- I am scared to go to school.
    scaredc.scaredc_37, -- I worry about things that have already happened.
    scaredc.scaredc_38, -- When I get frightened, I feel dizzy.
    scaredc.scaredc_39, -- I feel nervous when I am with other children or adults and I have to do something while they watch me (for example: read aloud, speak, play a game, play a sport)
    scaredc.scaredc_40, -- I feel nervous when I am going to parties, dances, or any place where there will be people that I don't know well.
    scaredc.scaredc_41, -- I am shy.   
--- Additional data:  chrt16; values for all chrt16 questions are 0, Strongly Disagree | 1, Disagree | 2, Neither Agree nor Disagree | 3, Agree | 4, Strongly Agree	 
    chrt16.chrt_1,      -- I feel as if things are never going to get better.
    chrt16.chrt_2,      -- I have no future.
    chrt16.chrt_3,      -- It seems as if I can do nothing right.
    chrt16.chrt_4,      -- Everything I do turns out wrong.
    chrt16.chrt_5,      -- There is no one I can depend on.
    chrt16.chrt_6,      -- The people I care the most for are gone.
    chrt16.chrt_7,      -- I wish my suffering could just all be over.
    chrt16.chrt_8,      -- I feel that there is no reason to live.
    chrt16.chrt_9,      -- I wish I could just go to sleep and not wake up.
    chrt16.chrt_10,     -- I find myself saying or doing things without thinking.
    chrt16.chrt_11,     -- I often make decisions quickly or "on impulse."
    chrt16.chrt_12,     -- I often feel irritable or easily angered
    chrt16.chrt_13,     -- I often overreact with anger or rage over minor things
    chrt16.chrt_14,     -- I have been having thoughts of killing myself.
    chrt16.chrt_15,     -- I have thoughts about how I might kill myself.
    chrt16.chrt_16,     -- I have a plan to kill myself.
--- Additional data:  casss child
    casch.casch_sec1_q1a,  -- My parent(s) show they are proud of me. - How often 1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q1b,  -- My parent(s) show they are proud of me. - Important 1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q2a,  -- My parent(s) understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q2b,  -- My parent(s) understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q3a,  -- My parent(s) listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q3b,  -- My parent(s) listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q4a,  -- My parent(s) make suggestions when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q4b,  -- My parent(s) make suggestions when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q5a,  -- My parent(s) give me good advice. How often?	1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q5b,  -- My parent(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q6a,  -- My parent(s) help me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q6b,  -- My parent(s) help me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q7a,  -- My parent(s) tell me I did a good job when I do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q7b,  -- My parent(s) tell me I did a good job when I do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q8a,  -- My parent(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q8b,  -- My parent(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q9a,  -- My parent(s) reward me when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q9b,  -- My parent(s) reward me when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q10a, -- My parent(s) help me practice my activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q10b,	-- My parent(s) help me practice my activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q11a,	-- My parent(s) take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q11b,	-- My parent(s) take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q12a,	-- My parent(s) get me many of the things I need. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q12b,	-- My parent(s) get me many of the things I need. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q1a,	-- My teacher(s) cares about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q1b,	-- My teacher(s) cares about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q2a,	-- My teacher(s) treats me fairly - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q2b,	-- My teacher(s) treats me fairly - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q3a,	-- My teacher(s) makes it okay to ask questions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q3b,	-- My teacher(s) makes it okay to ask questions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q4a,	-- My teacher(s) explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q4b,	-- My teacher(s) explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q5a,	-- My teacher(s) shows me how to do things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q5b,	-- My teacher(s) shows me how to do things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q6a,    -- My teacher(s) helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q6b,	-- My teacher(s) helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q7a,	-- My teacher(s) tells me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q7b,	-- My teacher(s) tells me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q8a,	-- My teacher(s) nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q8b,	-- My teacher(s) nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q9a,	-- My teacher(s) tells me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q9b,	-- My teacher(s) tells me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q10a,	-- My teacher(s) makes sure I have what I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q10b,	-- My teacher(s) makes sure I have what I need for school. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q11a,   -- My teacher(s) takes time to help me learn to do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q11b,	-- My teacher(s) takes time to help me learn to do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q12a,	-- My teacher(s) spends time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q12b,	-- My teacher(s) spends time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q1a,	-- My classmate(s) treat me nicely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q1b,	-- My classmate(s) treat me nicely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q2a,	-- My classmate(s) like most of my ideas and opinions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q2b,	-- My classmate(s) like most of my ideas and opinions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q3a,	-- My classmate(s) pay attention to me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q3b,	-- My classmate(s) pay attention to me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q4a,	-- My classmate(s) give me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q4b,	-- My classmate(s) give me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q5a,	-- My classmate(s) give me information so I can learn new things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q5b,	-- My classmate(s) give me information so I can learn new things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q6a,	-- My classmate(s) give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q6b,	-- My classmate(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q7a,	-- My classmate(s) tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q7b,	-- My classmate(s) tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q8a,	-- My classmate(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q8b,	-- My classmate(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q9a,	-- My classmate(s) notice when I have worked hard. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q9b,	-- My classmate(s) notice when I have worked hard. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q10a,	-- My classmate(s) ask me to join activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q10b,	-- My classmate(s) ask me to join activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q11a,	-- My classmate(s) spend time doing things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q11b,	-- My classmate(s) spend time doing things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q12a,	-- My classmate(s) help me with projects in class. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q12b,	-- My classmate(s) help me with projects in class. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q1a,	-- My close friend understands my feelings. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q1b,	-- My close friend understands my feelings. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q2a,	-- My close friend sticks up for me if others are treating me badly. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q2b,	-- My close friend sticks up for me if others are treating me badly. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q3a,	-- My close friend spends time with me when I'm lonely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q3b,	-- My close friend spends time with me when I'm lonely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q4a,	-- My close friend gives me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q4b,	-- My close friend gives me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q5a,	-- My close friend gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q5b,	-- My close friend gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q6a,	-- My close friend explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q6b,	-- My close friend explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q7a,	-- My close friend tells me he or she likes what I do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q7b,	-- My close friend tells me he or she likes what I do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q8a,	-- My close friend nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q8b,	-- My close friend nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q9a,	-- My close friend nicely tells me the truth about how I do on things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q9b,	-- My close friend nicely tells me the truth about how I do on things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q10a,	-- My close friend helps me when I need it. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q10b,	-- My close friend helps me when I need it. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q11a,	-- My close friend shares his or her things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q11b,	-- My close friend shares his or her things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q12a,	-- My close friend takes time to help me solve my problems. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q12b,	-- My close friend takes time to help me solve my problems. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q1a,	-- People in my school care about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q1b,	-- People in my school care about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q2a,	-- People in my school understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q2b,	-- People in my school understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q3a,	-- People in my school listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q3b,	-- People in my school listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q4a,	-- People in my school give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q4b,	-- People in my school give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q5a,	-- People in my school help me solve my problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q5b,	-- People in my school help me solve my problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q6a,	-- People in my school explain things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q6b,	-- People in my school explain things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q7a,	-- People in my school tell me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q7b,	-- People in my school tell me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q8a,	-- People in my school tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q8b,	-- People in my school tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q9a,	-- People in my school nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q9b,	-- People in my school nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q10a,	-- People in my school take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q10b,	-- People in my school take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q11a,	-- People in my school spend time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q11b,	-- People in my school spend time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q12a,	-- People in my school make sure I have the things I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q12b,	-- People in my school make sure I have the things I need for school. - Important	 
--- Additional data:  casss college
    cascol.cascol_sec1_q1a, -- My family shows they are proud of me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q1b,	-- My family shows they are proud of me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q2a,	-- My family understands me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q2b,	-- My family understands me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q3a,	-- My family listens to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q3b,	-- My family listens to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q4a,	-- My family makes suggestions when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q4b,	-- My family makes suggestions when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q5a,	-- My family gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q5b,	-- My family gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q6a,	-- My family helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q6b,	-- My family helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q7a,	-- My family tells me I did a good job when I do something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q7b,	-- My family tells me I did a good job when I do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q8a,	-- My family nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q8b,	-- My family nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q9a,	-- My family rewards me when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q9b,	-- My family rewards me when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q10a, -- My family helps me practice my activities. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q10b, --	My family helps me practice my activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q11a, -- My family takes time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q11b, -- My family takes time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q12a, -- My family gets me many of the things I need. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec1_q12b, -- My family gets me many of the things I need. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec1_q13,	-- 13. How often do you see your family? 1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
    cascol.cascol_sec2_q1a,	-- My best friend / significant other understands my feelings. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q1b,	-- My best friend / significant other understands my feelings. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q2a,	-- My best friend / significant other sticks up for me if others are treating me badly. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q2b,	-- My best friend / significant other sticks up for me if others are treating me badly. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q3a,	-- My best friend / significant other spends time with me when I'm lonely. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q3b,	-- My best friend / significant other spends time with me when I'm lonely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q4a,	-- My best friend / significant other gives me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q4b,	-- My best friend / significant other gives me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q5a,	-- My best friend / significant other gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q5b,	-- My best friend / significant other gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q6a,	-- My best friend / significant other explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q6b,	-- My best friend / significant other explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q7a,	-- My best friend / significant other tells me he or she likes what I do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q7b,	-- My best friend / significant other tells me he or she likes what I do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q8a,	-- My best friend / significant other nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q8b,	-- My best friend / significant other nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q9a,	-- My best friend / significant other nicely tells me the truth about how I do on things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q9b,	-- My best friend / significant other nicely tells me the truth about how I do on things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q10a, -- My best friend / significant other helps me when I need it. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q10b, -- My best friend / significant other helps me when I need it. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q11a, -- My best friend / significant other shares his or her things with me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q11b, --	My best friend / significant other shares his or her things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q12a, -- My best friend / significant other takes time to help me solve my problems. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec2_q12b, -- My best friend / significant other takes time to help me solve my problems. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec2_q13,	 -- Who were you thinking of when you rated "My Best Friend/Significant Other?"		1, Best Friend | 2, Significant Other | 3, Other | 99, Not Applicable
    cascol.cascol_sec2_q14,	 -- How often do you see this person?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
    cascol.cascol_sec3_q1a,	 -- My friends treat me nicely. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q1b,	 -- My friends treat me nicely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q2a,	 -- My friends like most of my ideas and opinions. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q2b,	 -- My friends like most of my ideas and opinions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q3a,	 -- My friends pay attention to me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q3b,	 -- My friends pay attention to me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q4a,	 -- My friends give me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q4b,	 -- My friends give me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q5a,	 -- My friends give me information so I can learn new things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q5b,	 -- My friends give me information so I can learn new things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q6a,	 -- My friends give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q6b,	 -- My friends give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q7a,	 -- My friends tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q7b,	 --	My friends tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q8a,	 --	My friends nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q8b,	 -- My friends nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q9a,	 --	My friends notice when I have worked hard. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q9b,	 -- My friends notice when I have worked hard. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q10a, --	My friends ask me to join activities. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q10b, --	My friends ask me to join activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q11a, --	My friends spend time doing things with me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q11b, --	My friends spend time doing things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q12a, -- My friends help me with projects in class. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol.cascol_sec3_q12b, --	My friends help me with projects in class. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol.cascol_sec3_q13	 -- How often do you see these friends?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
from ctrn_main_instruments_union ctrn_union
inner join subject_alias sa1
    on sa1.source_subject_id = ctrn_union.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
inner join subject_alias sa2 -- To select CTAU participant only.
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 2515
left join rcap_scheduling_form sched
    on sched.source_subject_id = ctrn_union.source_subject_id
left join rcap_demographics dem
    on dem.source_subject_id = ctrn_union.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = ctrn_union.source_subject_id
    and pfhc.event_name like 'baseline%'
left join view_pfh_adult_child_parent_union pfha_u
    on pfha_u.source_subject_id = ctrn_union.source_subject_id
    and pfha_u.event_name = ctrn_union.event_name
left join view_tesic_union tc
    on tc.source_subject_id = ctrn_union.source_subject_id
    and tc.event_name = ctrn_union.event_name
left join rcap_tesip tp
    on tp.source_subject_id = ctrn_union.source_subject_id
    and tp.event_name = ctrn_union.event_name
left join rcap_child_assistance chass
    on chass.source_subject_id = ctrn_union.source_subject_id
    and chass.event_name = ctrn_union.event_name
left join rcap_miniss_v2 mini
    on mini.source_subject_id = ctrn_union.source_subject_id
    and mini.event_name = ctrn_union.event_name
left join rcap_capsca5 caps
    on caps.source_subject_id = ctrn_union.source_subject_id
    and caps.event_name = ctrn_union.event_name
left join rcap_phqa phqa
    on phqa.source_subject_id = ctrn_union.source_subject_id
    and phqa.event_name = ctrn_union.event_name
left join rcap_scared_child scaredc
    on scaredc.source_subject_id = ctrn_union.source_subject_id
    and scaredc.event_name = ctrn_union.event_name
left join rcap_chrt16 chrt16
    on chrt16.source_subject_id = ctrn_union.source_subject_id
    and chrt16.event_name = ctrn_union.event_name
left join rcap_casss_child casch
    on casch.source_subject_id = ctrn_union.source_subject_id
    and casch.event_name = ctrn_union.event_name
left join rcap_casss_college cascol
    on cascol.source_subject_id = ctrn_union.source_subject_id
    and cascol.event_name = ctrn_union.event_name
order by
    sa1.subject_id,
    case 
      when ctrn_union.event_name like 'baseline%' then age_days_between(dem.dem_ch_dob::date, sched.sched_base_complete_date)
      when ctrn_union.event_name like 'one_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_1mo_complete_date)
      when ctrn_union.event_name like 'six_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_6mo_complete_date)
      when ctrn_union.event_name like 'one_year%' then age_days_between(dem.dem_ch_dob::date, sched.sched_1yr_complete_date)
      when ctrn_union.event_name like '18_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_18mo_complete_date)
      when ctrn_union.event_name like '24_month%' then age_days_between(dem.dem_ch_dob::date, sched.sched_2yr_complete_date)
    end
;
