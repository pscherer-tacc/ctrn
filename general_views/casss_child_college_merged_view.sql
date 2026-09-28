create view casss_child_college_merged_view
as
select 
    source_subject_id, 
    event_name,
    'casss_child' as instrument,
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
    null as cascol_sec1_q13, -- 13. How often do you see your family? 1, Daily | 2, Weekly | 3, Monthly | 4, Yearly

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
    null as cascol_sec3_q13,	 -- How often do you see these friends?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable

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
    null as cascol_sec2_q13,	 -- Who were you thinking of when you rated "My Best Friend/Significant Other?"		1, Best Friend | 2, Significant Other | 3, Other | 99, Not Applicable
    null as cascol_sec2_q14,	 -- How often do you see this person?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
    
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
from rcap_casss_child

union all

select 
    source_subject_id, 
    event_name,
    'casss_college' as instrument,
    cascol_sec1_q1a as casch_sec1_q1a, -- My family shows they are proud of me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q1b as casch_sec1_q1b,	-- My family shows they are proud of me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q2a as casch_sec1_q2a,	-- My family understands me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q2b as casch_sec1_q2b,	-- My family understands me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q3a as casch_sec1_q3a,	-- My family listens to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q3b as casch_sec1_q3b,	-- My family listens to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q4a as casch_sec1_q4a,	-- My family makes suggestions when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q4b as casch_sec1_q4b,	-- My family makes suggestions when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q5a as casch_sec1_q5a,	-- My family gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q5b as casch_sec1_q5b,	-- My family gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q6a as casch_sec1_q6a,	-- My family helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q6b as casch_sec1_q6b,	-- My family helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q7a as casch_sec1_q7a,	-- My family tells me I did a good job when I do something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q7b as casch_sec1_q7b,	-- My family tells me I did a good job when I do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q8a as casch_sec1_q8a,	-- My family nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q8b as casch_sec1_q8b,	-- My family nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q9a as casch_sec1_q9a,	-- My family rewards me when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q9b as casch_sec1_q9b,	-- My family rewards me when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q10a as casch_sec1_q10a, -- My family helps me practice my activities. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q10b as casch_sec1_q10b, --	My family helps me practice my activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q11a as casch_sec1_q11a, -- My family takes time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q11b as casch_sec1_q11b, -- My family takes time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q12a as casch_sec1_q12a, -- My family gets me many of the things I need. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec1_q12b as casch_sec1_q12b, -- My family gets me many of the things I need. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec1_q13,	-- 13. How often do you see your family? 1, Daily | 2, Weekly | 3, Monthly | 4, Yearly

    null as casch_sec2_q1a,	-- My teacher(s) cares about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q1b,	-- My teacher(s) cares about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q2a,	-- My teacher(s) treats me fairly - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q2b,	-- My teacher(s) treats me fairly - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q3a,	-- My teacher(s) makes it okay to ask questions. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q3b,	-- My teacher(s) makes it okay to ask questions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q4a,	-- My teacher(s) explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q4b,	-- My teacher(s) explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q5a,	-- My teacher(s) shows me how to do things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q5b,	-- My teacher(s) shows me how to do things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q6a,   -- My teacher(s) helps me solve problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q6b,	-- My teacher(s) helps me solve problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q7a,	-- My teacher(s) tells me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q7b,	-- My teacher(s) tells me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q8a,	-- My teacher(s) nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q8b,	-- My teacher(s) nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q9a,	-- My teacher(s) tells me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q9b,	-- My teacher(s) tells me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q10a,	-- My teacher(s) makes sure I have what I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q10b,	-- My teacher(s) makes sure I have what I need for school. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q11a,  -- My teacher(s) takes time to help me learn to do something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q11b,	-- My teacher(s) takes time to help me learn to do something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec2_q12a,	-- My teacher(s) spends time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec2_q12b,	-- My teacher(s) spends time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable

    cascol_sec3_q1a as casch_sec3_q1a,	 -- My friends treat me nicely. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q1b as casch_sec3_q1b,	 -- My friends treat me nicely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q2a as casch_sec3_q2a,	 -- My friends like most of my ideas and opinions. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q2b as casch_sec3_q2b,	 -- My friends like most of my ideas and opinions. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q3a as casch_sec3_q3a,	 -- My friends pay attention to me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q3b as casch_sec3_q3b,	 -- My friends pay attention to me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q4a as casch_sec3_q4a,	 -- My friends give me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q4b as casch_sec3_q4b,	 -- My friends give me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q5a as casch_sec3_q5a,	 -- My friends give me information so I can learn new things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q5b as casch_sec3_q5b,	 -- My friends give me information so I can learn new things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q6a as casch_sec3_q6a,	 -- My friends give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q6b as casch_sec3_q6b,	 -- My friends give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q7a as casch_sec3_q7a,	 -- My friends tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q7b as casch_sec3_q7b,	 --	My friends tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q8a as casch_sec3_q8a,	 --	My friends nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q8b as casch_sec3_q8b,	 -- My friends nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q9a as casch_sec3_q9a,	 --	My friends notice when I have worked hard. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q9b as casch_sec3_q9b,	 -- My friends notice when I have worked hard. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q10a as casch_sec3_q10a, --	My friends ask me to join activities. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q10b as casch_sec3_q10b, --	My friends ask me to join activities. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q11a as casch_sec3_q11a, --	My friends spend time doing things with me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q11b as casch_sec3_q11b, --	My friends spend time doing things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q12a as casch_sec3_q12a, -- My friends help me with projects in class. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec3_q12b as casch_sec3_q12b, --	My friends help me with projects in class. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec3_q13,	 -- How often do you see these friends?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable

    cascol_sec2_q1a as casch_sec4_q1a,	-- My best friend / significant other understands my feelings. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q1b as casch_sec4_q1b,	-- My best friend / significant other understands my feelings. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q2a as casch_sec4_q2a,	-- My best friend / significant other sticks up for me if others are treating me badly. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q2b as casch_sec4_q2b,	-- My best friend / significant other sticks up for me if others are treating me badly. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q3a as casch_sec4_q3a,	-- My best friend / significant other spends time with me when I'm lonely. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q3b as casch_sec4_q3b,	-- My best friend / significant other spends time with me when I'm lonely. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q4a as casch_sec4_q4a,	-- My best friend / significant other gives me ideas when I don't know what to do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q4b as casch_sec4_q4b,	-- My best friend / significant other gives me ideas when I don't know what to do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q5a as casch_sec4_q5a,	-- My best friend / significant other gives me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q5b as casch_sec4_q5b,	-- My best friend / significant other gives me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q6a as casch_sec4_q6a,	-- My best friend / significant other explains things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q6b as casch_sec4_q6b,	-- My best friend / significant other explains things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q7a as casch_sec4_q7a,	-- My best friend / significant other tells me he or she likes what I do. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q7b as casch_sec4_q7b,	-- My best friend / significant other tells me he or she likes what I do. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q8a as casch_sec4_q8a,	-- My best friend / significant other nicely tells me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q8b as casch_sec4_q8b,	-- My best friend / significant other nicely tells me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q9a as casch_sec4_q9a,	-- My best friend / significant other nicely tells me the truth about how I do on things. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q9b as casch_sec4_q9b,	-- My best friend / significant other nicely tells me the truth about how I do on things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q10a as casch_sec4_q10a, -- My best friend / significant other helps me when I need it. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q10b as casch_sec4_q10b, -- My best friend / significant other helps me when I need it. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q11a as casch_sec4_q11a, -- My best friend / significant other shares his or her things with me. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q11b as casch_sec4_q11b, --	My best friend / significant other shares his or her things with me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q12a as casch_sec4_q12a, -- My best friend / significant other takes time to help me solve my problems. - How often		1, Never | 2, Almost Never | 3, Some of the TIme | 4, Most of the TIme | 5, Almost Always | 6, Always | 99, Not Applicable
    cascol_sec2_q12b as casch_sec4_q12b, -- My best friend / significant other takes time to help me solve my problems. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    cascol_sec2_q13,	 -- Who were you thinking of when you rated "My Best Friend/Significant Other?"		1, Best Friend | 2, Significant Other | 3, Other | 99, Not Applicable
    cascol_sec2_q14,	 -- How often do you see this person?		1, Daily | 2, Weekly | 3, Monthly | 4, Yearly | 5, Never | 99, Not Applicable
    
    null as casch_sec5_q1a,	-- People in my school care about me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q1b,	-- People in my school care about me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q2a,	-- People in my school understand me. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q2b,	-- People in my school understand me. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q3a,	-- People in my school listen to me when I need to talk. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q3b,	-- People in my school listen to me when I need to talk. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q4a,	-- People in my school give me good advice. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q4b,	-- People in my school give me good advice. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q5a,	-- People in my school help me solve my problems by giving me information. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q5b,	-- People in my school help me solve my problems by giving me information. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q6a,	-- People in my school explain things that I don't understand. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q6b,	-- People in my school explain things that I don't understand. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q7a,	-- People in my school tell me how well I do on tasks. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q7b,	-- People in my school tell me how well I do on tasks. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q8a,	-- People in my school tell me I did a good job when I've done something well. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q8b,	-- People in my school tell me I did a good job when I've done something well. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q9a,	-- People in my school nicely tell me when I make mistakes. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q9b,	-- People in my school nicely tell me when I make mistakes. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q10a,	-- People in my school take time to help me decide things. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q10b,	-- People in my school take time to help me decide things. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q11a,	-- People in my school spend time with me when I need help. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q11b,	-- People in my school spend time with me when I need help. - Important		1, Not Important | 2, Important | 3, Very Important | 99, Not Applicable
    null as casch_sec5_q12a,	-- People in my school make sure I have the things I need for school. - How often		1, Never | 2, Almost Never | 3, Some of the time | 4, Most of the time | 5, Almost Always | 6, Always | 99, Not Applicable
    null as casch_sec5_q12b	-- People in my school make sure I have the things I need for school. - Important
from rcap_casss_college;