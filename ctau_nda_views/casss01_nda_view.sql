--- CASSS01 NDA View v2
--- Name of the view: casss_nda_view
--- Unlike the merged data format requested for the main CTRN project, the casss01 view employs separate variables for the casss child 
--- and the casss college answers from 18+ year old participants.
---
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query export is curated as follows:
---   1) Records with NULL schedule [visit]_complete_dates are removed
---   2) Records with NULL dem_ch_dob are removed
---	  3) Incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are removed
---   4) Any remaining duplicate and partial duplicate records are removed with the goal of the curated data products containing 1 record per event per participant. 
---	  5) "Complete" and "sufficiently complete" records with NULL sex are retained and reported to the Data Core team for correction
---   6) Variables containing pii/phi and/or unstructured text are removed as per comments below
---   7) Variables used solely for curation/administration are removed as per comments below
---
--- Query the data from a union of the rcap_casch and rcap_cascol model tables.
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,ctrn_union.source_subject_id -- only for validation; DELETE before sharing
	,case
		when ctrn_union.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when ctrn_union.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when ctrn_union.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when ctrn_union.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when ctrn_union.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when ctrn_union.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date  -- only for validation; DELETE before sharing
	,case 
		when ctrn_union.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when ctrn_union.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when ctrn_union.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when ctrn_union.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when ctrn_union.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when ctrn_union.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when ctrn_union.event_name like 'baseline%' then sched_main.sched_base_complete
		when ctrn_union.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when ctrn_union.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when ctrn_union.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when ctrn_union.event_name like '18_month%' then sched_main.sched_18mo_complete
		when ctrn_union.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before sharing
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,case 
        when pfhc.hc_race='1' then 'American Indian/Alaska Native'
        when pfhc.hc_race='2' then 'Asian'
        when pfhc.hc_race='3' then 'Hawaiian or Pacific Islander'
        when pfhc.hc_race='4' then 'Black or African American'
        when pfhc.hc_race='5' then 'White'
        when pfhc.hc_race='6' then 'More than one race'
        else 'Unknown or not reported'
    end as race
	,pfhc.hc_hispanic
	,case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when ctrn_union.event_name like 'baseline%' then '00_baseline'      
		when ctrn_union.event_name like 'one_month%' then '01_one_month'
		when ctrn_union.event_name like 'six_month%' then '06_six_month'
		when ctrn_union.event_name like 'one_year%' then '12_month'
		when ctrn_union.event_name like '18_month%' then '18_month'
		when ctrn_union.event_name like '24_month%' then '24_month'
	end as visit,
--- casss child
    casch.casch_sec1_q1a as casss1,  -- My parent(s) show they are proud of me. - How often 1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q1b as casss1a,  -- My parent(s) show they are proud of me. - Important 1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q2a as casss2,  -- My parent(s) understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q2b as casss2a,  -- My parent(s) understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q3a as casss3,  -- My parent(s) listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q3b as casss3a,  -- My parent(s) listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q4a as casss4,  -- My parent(s) make suggestions when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q4b as casss4a,  -- My parent(s) make suggestions when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q5a as casss5,  -- My parent(s) give me good advice. How often?	1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q5b as casss5a,  -- My parent(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q6a as casss6,  -- My parent(s) help me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q6b as casss6a,  -- My parent(s) help me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q7a as casss7,  -- My parent(s) tell me I did a good job when I do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q7b as casss7a,  -- My parent(s) tell me I did a good job when I do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q8a as casss8,  -- My parent(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q8b as casss8a,  -- My parent(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q9a as casss9,  -- My parent(s) reward me when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q9b as casss9a,  -- My parent(s) reward me when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q10a as casss10, -- My parent(s) help me practice my activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q10b as casss10a,	-- My parent(s) help me practice my activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q11a as casss11,	-- My parent(s) take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q11b as casss11a,	-- My parent(s) take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec1_q12a as casss12,	-- My parent(s) get me many of the things I need. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec1_q12b as casss12a,	-- My parent(s) get me many of the things I need. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q1a as casss13,	-- My teacher(s) cares about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q1b as casss13a,	-- My teacher(s) cares about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q2a as casss14,	-- My teacher(s) treats me fairly - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q2b as casss14a,	-- My teacher(s) treats me fairly - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q3a as casss15,	-- My teacher(s) makes it okay to ask questions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q3b as casss15a,	-- My teacher(s) makes it okay to ask questions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q4a as casss16,	-- My teacher(s) explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q4b as casss16a,	-- My teacher(s) explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q5a as casss17,	-- My teacher(s) shows me how to do things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q5b as casss17a,	-- My teacher(s) shows me how to do things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q6a as casss18,   -- My teacher(s) helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q6b as casss18a,	-- My teacher(s) helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q7a as casss19,	-- My teacher(s) tells me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q7b as casss19a,	-- My teacher(s) tells me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q8a as casss20,	-- My teacher(s) nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q8b as casss20a,	-- My teacher(s) nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q9a as casss21,	-- My teacher(s) tells me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q9b as casss21a,	-- My teacher(s) tells me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q10a as casss22,	-- My teacher(s) makes sure I have what I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q10b as casss22a,	-- My teacher(s) makes sure I have what I need for school. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q11a as casss23,  -- My teacher(s) takes time to help me learn to do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q11b as casss23a,	-- My teacher(s) takes time to help me learn to do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec2_q12a as casss24,	-- My teacher(s) spends time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec2_q12b as casss24a,	-- My teacher(s) spends time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q1a as casss25,	-- My classmate(s) treat me nicely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q1b as casss25a,	-- My classmate(s) treat me nicely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q2a as casss26,	-- My classmate(s) like most of my ideas and opinions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q2b as casss26a,	-- My classmate(s) like most of my ideas and opinions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q3a as casss27,	-- My classmate(s) pay attention to me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q3b as casss27a,	-- My classmate(s) pay attention to me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q4a as casss28,	-- My classmate(s) give me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q4b as casss28a,	-- My classmate(s) give me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q5a as casss29,	-- My classmate(s) give me information so I can learn new things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q5b as casss29a,	-- My classmate(s) give me information so I can learn new things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q6a as casss30,	-- My classmate(s) give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q6b as casss30a,	-- My classmate(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q7a as casss31,	-- My classmate(s) tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q7b as casss31a,	-- My classmate(s) tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q8a as casss32,	-- My classmate(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q8b as casss32a,	-- My classmate(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q9a as casss33,	-- My classmate(s) notice when I have worked hard. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q9b as casss33a,	-- My classmate(s) notice when I have worked hard. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q10a as casss34,	-- My classmate(s) ask me to join activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q10b as casss34a,	-- My classmate(s) ask me to join activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q11a as casss35,	-- My classmate(s) spend time doing things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q11b as casss35a,	-- My classmate(s) spend time doing things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec3_q12a as casss36,	-- My classmate(s) help me with projects in class. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec3_q12b as casss36a,	-- My classmate(s) help me with projects in class. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q1a as casss37,	-- My close friend understands my feelings. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q1b as casss37a,	-- My close friend understands my feelings. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q2a as casss38,	-- My close friend sticks up for me if others are treating me badly. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q2b as casss38a,	-- My close friend sticks up for me if others are treating me badly. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q3a as casss39,	-- My close friend spends time with me when I'm lonely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q3b as casss39a,	-- My close friend spends time with me when I'm lonely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q4a as casss40,	-- My close friend gives me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q4b as casss40a,	-- My close friend gives me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q5a as casss41,	-- My close friend gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q5b as casss41a,	-- My close friend gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q6a as casss42,	-- My close friend explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q6b as casss42a,	-- My close friend explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q7a as casss43,	-- My close friend tells me he or she likes what I do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q7b as casss43a,	-- My close friend tells me he or she likes what I do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q8a as casss44,	-- My close friend nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q8b as casss44a,	-- My close friend nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q9a as casss45,	-- My close friend nicely tells me the truth about how I do on things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q9b as casss45a,	-- My close friend nicely tells me the truth about how I do on things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q10a as casss46,	-- My close friend helps me when I need it. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q10b as casss46a,	-- My close friend helps me when I need it. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q11a as casss47,	-- My close friend shares his or her things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q11b as casss47a,	-- My close friend shares his or her things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec4_q12a as casss48,	-- My close friend takes time to help me solve my problems. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec4_q12b as casss48a,	-- My close friend takes time to help me solve my problems. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q1a as casss49,	-- People in my school care about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q1b as casss49a,	-- People in my school care about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q2a as casss50,	-- People in my school understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q2b as casss50a,	-- People in my school understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q3a as casss51,	-- People in my school listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q3b as casss51a,	-- People in my school listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q4a as casss52,	-- People in my school give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q4b as casss52a,	-- People in my school give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q5a as casss53,	-- People in my school help me solve my problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q5b as casss53a,	-- People in my school help me solve my problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q6a as casss54,	-- People in my school explain things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q6b as casss54a,	-- People in my school explain things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q7a as casss55,	-- People in my school tell me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q7b as casss55a,	-- People in my school tell me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q8a as casss56,	-- People in my school tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q8b as casss56a,	-- People in my school tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q9a as casss57,	-- People in my school nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q9b as casss57a,	-- People in my school nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q10a as casss58,	-- People in my school take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q10b as casss58a,	-- People in my school take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q11a as casss59,	-- People in my school spend time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q11b as casss59a,	-- People in my school spend time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch.casch_sec5_q12a as casss60,	-- People in my school make sure I have the things I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch.casch_sec5_q12b as casss60a,	-- People in my school make sure I have the things I need for school. - Important	 
--- casss college
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
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = ctrn_union.source_subject_id
	and sched.event_name like 'baseline%'
    and ctrn_union.event_name not like 'unscheduled%'
inner join subject_alias sa1
    on sa1.source_subject_id = ctrn_union.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = ctrn_union.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = ctrn_union.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = ctrn_union.source_subject_id
	and pfhc.event_name like 'baseline%'
left join view_pfh_adult_child_parent_union pfha_u
    on pfha_u.source_subject_id = ctrn_union.source_subject_id
    and ctrn_union.event_name like 'baseline%'
left join rcap_casss_child casch
    on casch.source_subject_id = ctrn_union.source_subject_id
    and casch.event_name = ctrn_union.event_name
left join rcap_casss_college cascol
    on cascol.source_subject_id = ctrn_union.source_subject_id
    and cascol.event_name = ctrn_union.event_name	
order by sa1.subject_id;
