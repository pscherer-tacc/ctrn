---- CREATING VIEW
create view tesic_test_view
as
select
    sa1.subject_id,
    tesic_u.source_subject_id,
    tesic_u.event_name,
    case 
        when dim_dem_lang.dem_ch_lang_language is null
            then '1. no preferred language provided'
        when dim_dem_lang.dem_ch_lang_language = 'other'
            then '2. the preferred language is NOT English or Spanish'
        when dim_dem_lang.dem_ch_lang_language != 'other' 
            and dim_dem_lang.dem_ch_lang_language != tesic_u.language
            then '3. the preferred language does NOT match tesic''s language'
        when dim_dem_lang.dem_ch_lang_language != 'other'
            and dim_dem_lang.dem_ch_lang_language != pfhc.language
            then '4. the preferred language does NOT match pfhc''s language'
        when dim_dem_lang.dem_ch_lang_language != 'other'
            and dim_dem_lang.dem_ch_lang_language != tesic_u.language
            and dim_dem_lang.dem_ch_lang_language != pfhc.language
            then '5. the preferred language matches neither tesic''s nor pfhc''s ones'
        else 'OK'
    end as language_discrepancy_flag,
    dim_dem_lang.dem_ch_lang_language as preferred_language,
    tesic_u.language as tesic_language,
    pfhc.language as pfhc_language, -- Need this to see when duplicates are coming from the pfh_child table
    tesic_u.tc_1_1,
    -- tesic_u.tc_8_1,
    -- tesic_u.tc_8_2,
    tesic_u.tc_interview_date,
    dem.dem_ch_dob,
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
    end as sex
from view_tesic_union tesic_u -- Attention! The view (not the table) is utilized
inner join subject_alias sa1
    on sa1.source_subject_id = tesic_u.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
    and tesic_u.event_name not like 'unscheduled%'
left join rcap_demographics dem
    on dem.source_subject_id = tesic_u.source_subject_id
left join dim_dem_ch_lang dim_dem_lang -- Joining the dimension table
    on dim_dem_lang.dem_ch_lang_value = dem.dem_ch_lang
left join rcap_scheduling_form sched_main
    on sched_main.source_subject_id = tesic_u.source_subject_id 
left join rcap_pfh_child pfhc
    on pfhc.source_subject_id = tesic_u.source_subject_id
    and pfhc.event_name like 'baseline%'
;



---- MAIN QUERY
with cte as (
    select 
        subject_id as subject_id_cte, 
        event_name as event_name_cte
    from tesic_test_view
    group by subject_id, event_name
    having count(*) > 1
)

select
    case 
        when cte.subject_id_cte is not null then 'YES'
        else 'NO'
    end as potential_duplicate,
    *
from tesic_test_view tesic
left join cte
    on cte.subject_id_cte = tesic.subject_id
    and cte.event_name_cte = tesic.event_name

where cte.subject_id_cte is not null -- !!!! To show only duplicated records

order by
    case 
        when cte.subject_id_cte is not null then 'YES'
        else 'NO'
    end, -- potential duplicates
    subject_id, 
    event_name,
    language_discrepancy_flag
;