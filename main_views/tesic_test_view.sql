---- CREATING VIEW
create view tesic_test_view
as
select
    sa1.subject_id,
    tesic_u.source_subject_id,
    tesic_u.event_name,
    tesic_u.language,
    dim_dem_lang.dem_ch_lang_language,
    case 
        when dim_dem_lang.dem_ch_lang_language is null
            then 'no preferred language provided'
        when dim_dem_lang.dem_ch_lang_language = 'other'
            then 'the preferred language is NOT English or Spanish'
        when dim_dem_lang.dem_ch_lang_language != 'other' and dim_dem_lang.dem_ch_lang_language != tesic_u.language
            then 'the preferred language does NOT match the instrument''s language'
        else 'OK'
    end as language_discrepancy_flag
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
    --and dim_dem_lang.dem_ch_lang_language = tesic_u.language
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = tesic_u.source_subject_id 
left join rcap_pfh_child pfhc
    on pfhc.source_subject_id = tesic_u.source_subject_id
    --and pfhc.language = dim_dem_lang.dem_ch_lang_language -- the dimension table
    and pfhc.event_name like 'baseline%'
    and pfhc.language = tesic_u.language -- !!!! experimental condition 
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

select *,
    case 
        when cte.subject_id_cte is not null then 'YES'
        else 'NO'
    end as potential_duplicate
from tesic_test_view tesic
left join cte
    on cte.subject_id_cte = tesic.subject_id
    and cte.event_name_cte = tesic.event_name

where cte.subject_id_cte is not null -- !!!! To show only duplicated records
order by subject_id, event_name
;