---------- Trauma Variety Index

/*
Notes from Luke (Message in Teams from July 7th, 4:31 PM):

tesic_cumload_life_unintentional = tesic_1_1_crit_a1 + tesic_1_2_crit_a1 + tesic_1_3_crit_a1+ tesic_1_4_crit_a1+ tesic_1_5_crit_a1+ tesic_1_6_crit_a1+ tesic_2_5_crit_a1
 
tesic_cumload_life_interpers_direct = tesic_2_1_crit_a1 + tesic_2_2_crit_a1 + tesic_2_3_crit_a1+ tesic_2_4_crit_a1++ tesic_5_crit_a1
 
tesic_cumload_life_interpers_witn_home = tesic_3_1_crit_a1 + tesic_3_2_crit_a1 + tesic_3_3_crit_a1
 
tesic_cumload_life_interpers_witn_comm = tesic_4_1_crit_a1 + tesic_4_2_crit_a1 + tesic_4_3_crit_a1
 
tesic_cumload_life_overall = tesic_cumload_life_unintentional + tesic_cumload_life_interpers_direct + tesic_cumload_life_interpers_witn_home + tesic_cumload_life_interpers tesic_7_crit_a1
 
tesic_cumload_life_bullying = tesic_6_1 + tesic_6_2
*/




-- Step 1: Calculate all [type_of_trauma]_exp_ever variables
with crit_a1_exp_ever 
as (
    select
        tcu.source_subject_id,
        tcu.event_name,
        dim_event_name.event_id,

        -- Unintentional: tc_1_x_crit_a1 (x in [1,6]) and tc_2_5_crit_a1 variables
        tc_1_1_crit_a1,
        max(coalesce(tc_1_1_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_1_a1_exp_ever,
        tc_1_2_crit_a1,
        max(coalesce(tc_1_2_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_2_a1_exp_ever,
        tc_1_3_crit_a1,
        max(coalesce(tc_1_3_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_3_a1_exp_ever,
        tc_1_4_crit_a1,
        max(coalesce(tc_1_4_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_4_a1_exp_ever,
        tc_1_5_crit_a1,
        max(coalesce(tc_1_5_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_5_a1_exp_ever,
        tc_1_6_crit_a1,
        max(coalesce(tc_1_6_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_6_a1_exp_ever,
        tc_2_5_crit_a1,
        max(coalesce(tc_2_5_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_5_a1_exp_ever,
        
        -- Inerpersonal Direct: tc_2_x_crit_a1 (x in [1, 4]) and tc_5_crit_a1
        tc_2_1_crit_a1,
        max(coalesce(tc_2_1_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_1_a1_exp_ever,
        tc_2_2_crit_a1,
        max(coalesce(tc_2_2_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_2_a1_exp_ever,
        tc_2_3_crit_a1,
        max(coalesce(tc_2_3_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_3_a1_exp_ever,
        tc_2_4_crit_a1,
        max(coalesce(tc_2_4_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_4_a1_exp_ever,
        tc_5_crit_a1,
        max(coalesce(tc_5_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_5_a1_exp_ever,
        
        -- Interpersonal within Home: tc_3_x_crit_a1 (x in [1,3])
        tc_3_1_crit_a1,
        max(coalesce(tc_3_1_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_3_1_a1_exp_ever,
        tc_3_2_crit_a1,
        max(coalesce(tc_3_2_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_3_2_a1_exp_ever,
        tc_3_3_crit_a1,
        max(coalesce(tc_3_3_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_3_3_a1_exp_ever,

        -- Interpersonal within Community(?): tc_4_x_crit_a1 (x in [1,3])
        tc_4_1_crit_a1,
        max(coalesce(tc_4_1_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_4_1_a1_exp_ever,
        tc_4_2_crit_a1,
        max(coalesce(tc_4_2_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_4_2_a1_exp_ever,
        tc_4_3_crit_a1,
        max(coalesce(tc_4_3_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_4_3_a1_exp_ever,

        -- Bullying: tc_6_1 and tc_6_2
        tc_6_1,
        max(coalesce(tc_6_1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_6_1_exp_ever,
        tc_6_2,
        max(coalesce(tc_6_2::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_6_2_exp_ever,

        -- For overall
        coalesce(tc_7_crit_a1::int, 0) as tc_7_crit_a1
    from view_tesic_union tcu
    left join dim_ctrn_event_name dim_event_name
        on dim_event_name.event_name = tcu.event_name
    order by tcu.source_subject_id, dim_event_name.event_id
),

-- Step 2: Calculate Lifetime Trauma Variety Index for each Type Domain
lifetime_trauma_variety_index_type_domain
as (
    select *,
        
        (
            tc_1_1_a1_exp_ever + tc_1_2_a1_exp_ever + tc_1_3_a1_exp_ever +
            tc_1_4_a1_exp_ever + tc_1_5_a1_exp_ever + tc_1_6_a1_exp_ever +
            tc_2_5_a1_exp_ever
        ) as tc_cumload_life_unintentional,

        (
            tc_2_1_a1_exp_ever + tc_2_2_a1_exp_ever + tc_2_3_a1_exp_ever +
            tc_2_4_a1_exp_ever + tc_5_a1_exp_ever
        ) as tc_cumload_life_interpers_direct,

        (
            tc_3_1_a1_exp_ever + tc_3_2_a1_exp_ever + tc_3_3_a1_exp_ever
        ) as tc_cumload_life_interpers_witn_home,

        (
            tc_4_1_a1_exp_ever + tc_4_2_a1_exp_ever + tc_4_3_a1_exp_ever
        ) as tc_cumload_life_interpers_witn_comm,

        (
            tc_6_1_exp_ever + tc_6_2_exp_ever
        ) as tc_cumload_life_bullying

    from crit_a1_exp_ever
),

-- Step 3: Calculate Overall Lifetime Trauma Variety Index
lifetime_trauma_variety_index_overall
as
(
    select *,
    (
        tc_cumload_life_unintentional + tc_cumload_life_interpers_direct +
        tc_cumload_life_interpers_witn_home + tc_cumload_life_interpers_witn_comm +
        tc_7_crit_a1
    ) as tesic_cumload_life_overall
    from lifetime_trauma_variety_index_type_domain
)

select count(*) from lifetime_trauma_variety_index_overall --crit_a1_trauma_domains
;



------------------------------ OLD CODE BELOW


-- Step 1: Calculate all [type_of_trauma]_exp_ever variables
with crit_a1_exp_ever 
as (
    select 
        tcu.source_subject_id,
        tcu.event_name,
        dim_event_name.event_id,
        tc_1_1_crit_a1,
        max(coalesce(tc_1_1_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_1_a1_exp_ever,
        tc_1_2_crit_a1,
        max(coalesce(tc_1_2_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_2_a1_exp_ever,
        tc_1_3_crit_a1,
        max(coalesce(tc_1_3_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_3_a1_exp_ever,
        tc_1_4_crit_a1,
        max(coalesce(tc_1_4_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_4_a1_exp_ever,
        tc_1_5_crit_a1,
        max(coalesce(tc_1_5_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_5_a1_exp_ever,
        tc_1_6_crit_a1,
        max(coalesce(tc_1_6_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_1_6_a1_exp_ever,
        tc_2_5_crit_a1,
        max(coalesce(tc_2_5_crit_a1::int, 0)) over (partition by tcu.source_subject_id order by dim_event_name.event_id) as tc_2_5_a1_exp_ever
    from view_tesic_union tcu
    left join dim_ctrn_event_name dim_event_name
        on dim_event_name.event_name = tcu.event_name
),

-- Step 2: Calculate cumulative Type Domains
crit_a1_trauma_domains
as (
    select *,
        (
            tc_1_1_a1_exp_ever + tc_1_2_a1_exp_ever + tc_1_3_a1_exp_ever +
            tc_1_4_a1_exp_ever + tc_1_5_a1_exp_ever + tc_1_6_a1_exp_ever +
            tc_2_5_a1_exp_ever
        ) as unintentional
    from crit_a1_exp_ever
)

select count(*) from crit_a1_trauma_domains
;