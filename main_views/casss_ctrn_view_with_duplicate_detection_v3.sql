--- CASSS CTRN View Merged v3
--- Name of the view: casss_ctrn_view
---
--- This view merges similar sections and variables of CASCOL with CASSS vs earlier CASSS data products which displayed this data
--- as separate variables. The mapping for the merged sections are as follows:
--- casch section 1 ("parent") <-> cascol section 1 ("family")
--- casch section 2 ("teacher") <-> no match in cascol; retain separate variables
--- casch section 3 ("classmate") <-> cascol section 3 ("friends")
--- casch section 4 ("close friend") <-> cascol section 2 ("best friend")
--- casch section 5 ("people in my school") <-> no match in cascol; retain separate variables   
---
--- This view includes date calculations and fields for cross-checking and curation. Curation fields and associated data must be removed 
--- prior to sharing outside of the CTRN's IRB-approved community. The export from this query includes incomplete records which are curated as follows:
--- 	1) Records with NULL schedule [visit]_complete_dates are removed
---     2) Records with NULL dem_ch_dob are removed
---		3) Incomplete records where sched_[event_name]_complete NOT EQUAL "1"(complete) or "8"(sufficiently complete) are removed
---     4) Any remaining duplicate and partial duplicate records are removed with the goal of the curated data product to contain 1 record per event per participant. 
---		5) "Complete" and "sufficiently complete" records with NULL sex are retained and reported to the Data Core team for correction
---     6) Variables containing pii/phi and/or unstructured text are removed as per comments below
---     7) Variables used solely for curation/administration are removed as per comments below

---- MAIN QUERY
--- Query the data from the view
select
    case
        when casss_duplicates.subject_id is not null then 'YES'
        else 'NO'
    end as potential_duplicate,
    casss_view.*
from casss_ctrn_view casss_view
left join (
    select subject_id, event_name
    from casss_ctrn_view
    group by subject_id, event_name
    having count(*) > 1
) casss_duplicates
    on casss_duplicates.subject_id = casss_view.subject_id
    and casss_duplicates.event_name = casss_view.event_name
order by
    case
        when casss_duplicates.subject_id is not null then 'YES'
        else 'NO'
    end,
    casss_view.subject_id,
    casss_view.event_name
;


---- THE BODY OF THE VIEW
create or replace view casss_ctrn_view 
as
select
    casss_merged.instrument,
    sa1.subject_id,
	casss_merged.source_subject_id, -- only for validation; DELETE before sharing
    casss_merged.event_name, -- only for validation; DELETE before sharing
    	case
		when casss_merged.event_name like 'baseline%' then to_char(sched.sched_base_complete_date, 'mm/dd/yyyy')
		when casss_merged.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date, 'mm/dd/yyyy')
		when casss_merged.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date, 'mm/dd/yyyy')
		when casss_merged.event_name like 'one_year%' then to_char(sched.sched_1yr_complete_date, 'mm/dd/yyyy')
		when casss_merged.event_name like '18_month%' then to_char(sched.sched_18mo_complete_date, 'mm/dd/yyyy')
		when casss_merged.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date,  -- only for validation; DELETE before sharing
	case 
		when casss_merged.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, dem.dem_ch_dob)
		when casss_merged.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, dem.dem_ch_dob)
		when casss_merged.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, dem.dem_ch_dob)
		when casss_merged.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_complete_date, dem.dem_ch_dob)
		when casss_merged.event_name like '18_month%' then nda_months_between(sched.sched_18mo_complete_date, dem.dem_ch_dob)
		when casss_merged.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age,
	case
		when casss_merged.event_name like 'baseline%' then sched.sched_base_complete
		when casss_merged.event_name like 'one_month%' then sched.sched_1mo_complete
		when casss_merged.event_name like 'six_month%' then sched.sched_6mo_complete
		when casss_merged.event_name like 'one_year%' then sched.sched_1yr_complete
		when casss_merged.event_name like '18_month%' then sched.sched_18mo_complete
		when casss_merged.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete, -- only for validation; DELETE before sharing
    case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex,
	case 
        when pfhc.hc_race='1' then 'American Indian or Alaska Native'
        when pfhc.hc_race='2' then 'Asian'
        when pfhc.hc_race='3' then 'Native Hawaian or Pacific Islander'
        when pfhc.hc_race='4' then 'Black or African American'
        when pfhc.hc_race='5' then 'White'
        when pfhc.hc_race='6' then 'Multi-racial'
        else null
    end as race,
	pfhc.hc_hispanic,
	case															-- Renaming events as visits to facilitate sequencing as per 4/30/2026 request by Jeff
		when casss_merged.event_name like 'baseline%' then '00_baseline'      
		when casss_merged.event_name like 'one_month%' then '01_one_month'
		when casss_merged.event_name like 'six_month%' then '06_six_month'
		when casss_merged.event_name like 'one_year%' then '12_month'
		when casss_merged.event_name like '18_month%' then '18_month'
		when casss_merged.event_name like '24_month%' then '24_month'
	end as visit,

    casch_sec1_q1a,  -- My parent(s) show they are proud of me. - How often 1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q1b,  -- My parent(s) show they are proud of me. - Important 1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q2a,  -- My parent(s) understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q2b,  -- My parent(s) understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q3a,  -- My parent(s) listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q3b,  -- My parent(s) listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q4a,  -- My parent(s) make suggestions when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q4b,  -- My parent(s) make suggestions when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q5a,  -- My parent(s) give me good advice. How often?	1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q5b,  -- My parent(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q6a,  -- My parent(s) help me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q6b,  -- My parent(s) help me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q7a,  -- My parent(s) tell me I did a good job when I do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q7b,  -- My parent(s) tell me I did a good job when I do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q8a,  -- My parent(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q8b,  -- My parent(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q9a,  -- My parent(s) reward me when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q9b,  -- My parent(s) reward me when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q10a, -- My parent(s) help me practice my activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q10b,	-- My parent(s) help me practice my activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q11a,	-- My parent(s) take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q11b,	-- My parent(s) take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec1_q12a,	-- My parent(s) get me many of the things I need. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec1_q12b,	-- My parent(s) get me many of the things I need. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q13, -- 13. How often do you see your family? 1, Daily | 2, Weekly | 3, Monthly | 4, Yearly

    casch_sec2_q1a,	-- My teacher(s) cares about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q1b,	-- My teacher(s) cares about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q2a,	-- My teacher(s) treats me fairly - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q2b,	-- My teacher(s) treats me fairly - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q3a,	-- My teacher(s) makes it okay to ask questions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q3b,	-- My teacher(s) makes it okay to ask questions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q4a,	-- My teacher(s) explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q4b,	-- My teacher(s) explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q5a,	-- My teacher(s) shows me how to do things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q5b,	-- My teacher(s) shows me how to do things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q6a,   -- My teacher(s) helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q6b,	-- My teacher(s) helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q7a,	-- My teacher(s) tells me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q7b,	-- My teacher(s) tells me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q8a,	-- My teacher(s) nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q8b,	-- My teacher(s) nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q9a,	-- My teacher(s) tells me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q9b,	-- My teacher(s) tells me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q10a,	-- My teacher(s) makes sure I have what I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q10b,	-- My teacher(s) makes sure I have what I need for school. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q11a,  -- My teacher(s) takes time to help me learn to do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q11b,	-- My teacher(s) takes time to help me learn to do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec2_q12a,	-- My teacher(s) spends time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec2_q12b,	-- My teacher(s) spends time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable

    casch_sec3_q1a,	-- My classmate(s) treat me nicely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q1b,	-- My classmate(s) treat me nicely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q2a,	-- My classmate(s) like most of my ideas and opinions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q2b,	-- My classmate(s) like most of my ideas and opinions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q3a,	-- My classmate(s) pay attention to me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q3b,	-- My classmate(s) pay attention to me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q4a,	-- My classmate(s) give me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q4b,	-- My classmate(s) give me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q5a,	-- My classmate(s) give me information so I can learn new things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q5b,	-- My classmate(s) give me information so I can learn new things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q6a,	-- My classmate(s) give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q6b,	-- My classmate(s) give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q7a,	-- My classmate(s) tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q7b,	-- My classmate(s) tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q8a,	-- My classmate(s) nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q8b,	-- My classmate(s) nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q9a,	-- My classmate(s) notice when I have worked hard. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q9b,	-- My classmate(s) notice when I have worked hard. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q10a,	-- My classmate(s) ask me to join activities. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q10b,	-- My classmate(s) ask me to join activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q11a,	-- My classmate(s) spend time doing things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q11b,	-- My classmate(s) spend time doing things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec3_q12a,	-- My classmate(s) help me with projects in class. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec3_q12b,	-- My classmate(s) help me with projects in class. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q13,	 -- How often do you see these friends?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable

    casch_sec4_q1a,	-- My close friend understands my feelings. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q1b,	-- My close friend understands my feelings. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q2a,	-- My close friend sticks up for me if others are treating me badly. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q2b,	-- My close friend sticks up for me if others are treating me badly. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q3a,	-- My close friend spends time with me when I'm lonely. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q3b,	-- My close friend spends time with me when I'm lonely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q4a,	-- My close friend gives me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q4b,	-- My close friend gives me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q5a,	-- My close friend gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q5b,	-- My close friend gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q6a,	-- My close friend explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q6b,	-- My close friend explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q7a,	-- My close friend tells me he or she likes what I do. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q7b,	-- My close friend tells me he or she likes what I do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q8a,	-- My close friend nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q8b,	-- My close friend nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q9a,	-- My close friend nicely tells me the truth about how I do on things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q9b,	-- My close friend nicely tells me the truth about how I do on things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q10a,	-- My close friend helps me when I need it. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q10b,	-- My close friend helps me when I need it. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q11a,	-- My close friend shares his or her things with me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q11b,	-- My close friend shares his or her things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec4_q12a,	-- My close friend takes time to help me solve my problems. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec4_q12b,	-- My close friend takes time to help me solve my problems. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q13,	 -- Who were you thinking of when you rated "My Best Friend/Significant Other?"		1, Best Friend | 2, Significant Other | 3, Other | 99, Not Applicable
    cascol_sec2_q14,	 -- How often do you see this person?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
    
    casch_sec5_q1a,	-- People in my school care about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q1b,	-- People in my school care about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q2a,	-- People in my school understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q2b,	-- People in my school understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q3a,	-- People in my school listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q3b,	-- People in my school listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q4a,	-- People in my school give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q4b,	-- People in my school give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q5a,	-- People in my school help me solve my problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q5b,	-- People in my school help me solve my problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q6a,	-- People in my school explain things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q6b,	-- People in my school explain things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q7a,	-- People in my school tell me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q7b,	-- People in my school tell me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q8a,	-- People in my school tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q8b,	-- People in my school tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q9a,	-- People in my school nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q9b,	-- People in my school nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q10a,	-- People in my school take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q10b,	-- People in my school take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q11a,	-- People in my school spend time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q11b,	-- People in my school spend time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    casch_sec5_q12a,	-- People in my school make sure I have the things I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    casch_sec5_q12b	-- People in my school make sure I have the things I need for school. - Important
from casss_child_college_merged_view casss_merged	
inner join subject_alias sa1
    on sa1.source_subject_id = casss_merged.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and casss_merged.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched
    on sched.source_subject_id = casss_merged.source_subject_id
left join rcap_demographics dem
    on dem.source_subject_id = casss_merged.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = casss_merged.source_subject_id
    and pfhc.event_name like 'baseline%'
left join view_pfh_adult_child_parent_union pfha_u
    on pfha_u.source_subject_id = casss_merged.source_subject_id
    and casss_merged.event_name like 'baseline%'
order by sa1.subject_id;
