---- CD-RISC NDA View

-- The function that coverts NULL values to 99
create function nda_null_to_99_converter (val VARCHAR)
returns integer
as
$$
    select case
            when val is null then 99
            else val::int
        end;
$$
language sql
immutable
returns null on null input;

-- The main query for the view
select
    dem.dem_guid as subjectkey
    ,sa1.subject_id as src_subject_id
	,risc.source_subject_id -- only for validation; DELETE before submission
	,risc.event_name -- only for validation; DELETE before submission
	,case
		when risc.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when risc.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when risc.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when risc.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when risc.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when risc.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when risc.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when risc.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when risc.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when risc.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when risc.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when risc.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when risc.event_name like 'baseline%' then sched.sched_base_complete
		when risc.event_name like 'one_month%' then sched.sched_1mo_complete
		when risc.event_name like 'six_month%' then sched.sched_6mo_complete
		when risc.event_name like 'one_year%' then sched.sched_1yr_complete
		--when risc.event_name like '18_month%' then sched.sched_18mo_complete
		when risc.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when risc.event_name like 'baseline%' then 'baseline'
		when risc.event_name like 'one_month%' then 'one_month'
		when risc.event_name like 'six_month%' then 'six_month'
		when risc.event_name like 'one_year%' then 'one_year'
		when risc.event_name like '18_month%' then '18_month'
		when risc.event_name like '24_month%' then '24_month'
	end as timepoint_label
    ,nda_null_to_99_converter(cdrisc_1_mtx) as cdrisc01
    ,nda_null_to_99_converter(cdrisc_2_mtx) as cdrisc02
    ,nda_null_to_99_converter(cdrisc_3_mtx) as cdrisc03
    ,nda_null_to_99_converter(cdrisc_4_mtx) as cdrisc04
    ,nda_null_to_99_converter(cdrisc_5_mtx) as cdrisc05
    ,nda_null_to_99_converter(cdrisc_6_mtx) as cdrisc06
    ,nda_null_to_99_converter(cdrisc_7_mtx) as cdrisc07
    ,nda_null_to_99_converter(cdrisc_8_mtx) as cdrs16
    ,nda_null_to_99_converter(cdrisc_9_mtx) as cdrisc09
    ,nda_null_to_99_converter(cdrisc_10_mtx) as cdrisc10
from rcap_cdrisc risc -- Attention! rcap_cdrisc is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = risc.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = risc.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = risc.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = risc.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = risc.source_subject_id
order by sa1.subject_id;