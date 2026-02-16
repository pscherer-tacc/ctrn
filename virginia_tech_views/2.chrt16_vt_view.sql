---- CHRT16 VT View
--- Name of the view: view_vt_chrt16

-- Query the data from the view:
select * from view_vt_chrt16
where interview_date is not null;

-- The body of the view
create or replace view view_vt_chrt16
as 
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,chrt.source_subject_id -- only for validation; DELETE before submission
	,chrt.event_name -- only for validation; DELETE before submission
	,case
		when chrt.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when chrt.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when chrt.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		when chrt.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when chrt.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when chrt.event_name like 'baseline%' then sched_main.sched_base_complete
		when chrt.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when chrt.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when chrt.event_name like 'one_year%' then sched_main.sched_1yr_complete
		when chrt.event_name like '18_month%' then sched_main.sched_18mo_complete
		when chrt.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when chrt.event_name like 'baseline%' then 'baseline'
		when chrt.event_name like 'one_month%' then 'one_month'
		when chrt.event_name like 'six_month%' then 'six_month'
		when chrt.event_name like 'one_year%' then 'one_year'
		when chrt.event_name like '18_month%' then '18_month'
		when chrt.event_name like '24_month%' then '24_month'
	end as visit
    ,chrt.chrt_1
    ,chrt.chrt_2
    ,chrt.chrt_3
    ,chrt.chrt_4
    ,chrt.chrt_5
    ,chrt.chrt_6
    ,chrt.chrt_7
    ,chrt.chrt_8
    ,chrt.chrt_9
    ,chrt.chrt_10
    ,chrt.chrt_11
    ,chrt.chrt_12
    ,chrt.chrt_13
    ,chrt.chrt_14
    ,chrt.chrt_15
    ,chrt.chrt_16
from rcap_chrt16 chrt
inner join subject_alias sa1
    on sa1.source_subject_id = chrt.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and chrt.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = chrt.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = chrt.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = chrt.source_subject_id
order by sa1.subject_id;
