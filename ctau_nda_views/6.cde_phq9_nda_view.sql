----------- Create NDA cde_phqa9_view

select
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,phqa.source_subject_id -- only for validation; DELETE before submission
	,phqa.event_name -- only for validation; DELETE before submission
	,case
		when phqa.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when phqa.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when phqa.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when phqa.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when phqa.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,phqa.phq_2_val as phq9_1
	,phqa.phq_1_val as phq9_2
	,phqa.phq_3_val as phq9_3
	,phqa.phq_4_val as phq9_4
	,phqa.phq_5_val as phq9_5
	,phqa.phq_6_val as phq9_6
	,phqa.phq_7_val as phq9_7	
	,phqa.phq_8_val as phq9_8
	,phqa.phq_9_val as phq9_9
	,case 
		when phqa.language = 'sp' then '70' -- Spanish for the United States
		else '1' -- English
	end as phqa9_10
from rcap_phqa phqa -- Attention! rcap_phqa is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = phqa.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = phqa.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = phqa.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = phqa.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = phqa.source_subject_id
order by sa2.subject_id;




/* 
!!! Pat Scherer's original script below!!!!
!!! See the updated one above !!!
*/

-- Step 2: Create NDA cde_phqa9_view itself

select 
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
    ,to_char(sched.interview_date,'mm/dd/yyyy') as interview_date
    ,nda_months_between(sched.interview_date, ctau_dem.dem_ch_dob) as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
/* The NDA cde_phqa9 template does not include a timepoint label, visit orevent name, but we will include this for phqa views outside the NDA.
	,case
		when phqa.event_name like 'baseline%' then 'baseline'
		when phqa.event_name like 'one_month%' then 'one_month'
		when phqa.event_name like 'six_month%' then 'six_month'
		when phqa.event_name like 'one_year%' then 'one_year'
		when phqa.event_name like '18_month%' then '18_month'
		when phqa.event_name like '24_month%' then '24_month'
	end as visit
*/
-- The flipped fieldnames for the next 2 lines isn't a mistake; it corrects a misalignment between our REDCap data and the NDA. 	
	,phqa.phq_2_val as phq9_1
	,phqa.phq_1_val as phq9_2
	,phqa.phq_3_val as phq9_3
	,phqa.phq_4_val as phq9_4
	,phqa.phq_5_val as phq9_5
	,phqa.phq_6_val as phq9_6
	,phqa.phq_7_val as phq9_7	
	,phqa.phq_8_val as phq9_8
	,phqa.phq_9_val as phq9_9
	,case 
		when phqa.language = 'sp' then '70' -- Spanish for the United States
		else '1' -- English
	end as phqa9_10
	,phqa.language --If "en" then "1"; if "sp" then "70" as value for phq9_10 ("In what language did you collect the data?")
from rcap_phqa phqa
inner join subject_alias sa1
    on sa1.source_subject_id = phqa.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form_agg_view sched
    on sched.source_subject_id = phqa.source_subject_id 
    and sched.event_name = phqa.event_name
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id;



--- use rcap_ctau_scheduling_form_agg_view
select 
	source_subject_id
	,event_name
	,interview_date
	,sched_base_complete_date
	,sched_1mo_complete_date
	,sched_6mo_complete_date
	-- ,sch1.sched_1yr_date
	-- ,sch1.sched_18mo_complete_date
	-- ,sch1.sched_2yr_complete_date
from rcap_ctau_scheduling_form_agg_view;