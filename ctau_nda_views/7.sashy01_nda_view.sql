----------- Create NDA sashy01_view

-- Step 1. Create a helper view which will merge the rcap_bash and rcap_bash_parent tables
create view rcap_bash_merged_view
as
select source_subject_id
	,event_name
	,'Child' as respondent
	,bash_3 as sashy_1
	,bash_1 as sashy_3
	,bash_4 as sashy_4
	,bash_2 as sashy_5
	,bash_complete as complete --only for validation; filter on bash_complete = '2' and DELETE before submission	
from rcap_bash
union all
select source_subject_id
	,event_name
	,'Caregiver' as respondent
	,bashp_3 as sashy_1
	,bashp_1 as sashy_3
	,bashp_4 as sashy_4
	,bashp_2 as sashy_5
	,bashp_complete as complete --only for validation; filter on bash_complete = '2' and DELETE before submission
from rcap_bash_parent; 

-- Step 2. Create the body(query) of the NDA sashy01_view
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,bash_m.source_subject_id -- only for validation; DELETE before submission
	,bash_m.event_name -- only for validation; DELETE before submission
	,case
		when bash_m.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when bash_m.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when bash_m.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when bash_m.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when bash_m.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when bash_m.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when bash_m.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when bash_m.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when bash_m.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when bash_m.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when bash_m.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when bash_m.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,bash_m.respondent
	,bash_m.sashy_1
	,bash_m.sashy_3
	,bash_m.sashy_4
	,bash_m.sashy_5
	,bash_m.complete
from rcap_bash_merged_view bash_m
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = bash_m.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = bash_m.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = bash_m.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = bash_m.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = bash_m.source_subject_id
order by sa1.subject_id;




----- Pat Scherer's initial script below
-- Data extracted from rcap_bash and rcap_bash_parent tables 
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,bash.source_subject_id -- only for validation; DELETE before submission
	,bash.event_name -- only for validation; DELETE before submission
	,case
		when bash.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when bash.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when bash.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when bash.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when bash.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when bash.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when bash.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when bash.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when bash.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when bash.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when bash.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when bash.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		,when bash then 'Child' as respondent
			,bash.bash_3 as sashy_1
			,bash.bash_1 as sashy_3
			,bash.bash_4 as sashy_4
			,bash.bash_2 as sashy_5
			,bash.bash_complete -- only for validation; filter on bash_complete = '2' and DELETE before submission	
		end
from rcap_bash bash -- Attention! rcap_bash is not a CTAU table.

union all   --Not sure Union all is appropriate or needed here.
			
-- Need to add the same as above from bashp	
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,bashp.source_subject_id -- only for validation; DELETE before submission
	,bashp.event_name -- only for validation; DELETE before submission
	,case
		when bashp.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when bashp.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when bashp.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when bashp.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when bashp.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when bashp.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when bashp.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when bashp.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when bashp.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when bashp.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when bashp.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when bashp.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case		
		,when bashp then 'Parent' as respondent
			,bashp.bashp_3 as sashy_1
			,bashp.bashp_1 as sashy_3
			,bashp.bashp_4 as sashy_4
			,bashp.bashp_2 as sashy_5
			,bashp.bashp_complete -- only for validation; filter on bash_complete = '2' and DELETE before submission		
	end
from rcap_bash_parent bashp -- Attention! rcap_bashp is not a CTAU table.
	
union all   --Not sure Union all is appropriate or needed here.	

inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = bash.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = bash.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = bash.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = bash.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = bash.source_subject_id
order by sa1.subject_id;

