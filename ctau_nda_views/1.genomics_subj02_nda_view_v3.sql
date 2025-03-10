---------------- Creating genomic_subject02_nda view v2

-- Step 1: Create a helper view with grouped data from rcap_ctau_sample_info.
/* 
The ultimate goal for this view is to extract and store the
first 13 characters (i.e, aud_ptsd_xxxx) from si_tube_id that 
will be eventually used to construct container_ids (or si_tube_ids) 
for urine samples.
*/
create view rcap_ctau_sample_info_grouped_view
as 
select 
    source_subject_id, 
    event_name, 
    substring(si_tube_id,1,13) as si_tube_id_main_part
from rcap_ctau_sample_info
group by source_subject_id, 
    event_name, 
    substring(si_tube_id,1,13);

-- Step 2: create a helper view from rcap_ctau_biosample
/*
For each of the sample types (blood, saliva, urine), there should be a record.
However, the original rcap_ctau_biosample stores the data in columns (horizontaly),
i.e. bs_blood_obtained, bs_saliva_obtained, bs_uds_obtained.
This view should be a vertical representation of the [sample]_obtained data.
Note that container_id column is filled with NULLs for blood and saliva samples,
while for urine samples it is generated from rcap_ctau_sample_info_grouped_view (Step 1)
*/
create view rcap_ctau_biosample_agg_view 
as
(
    select source_subject_id, event_name 
        ,'blood' as general_sample_description
        ,case 
            when bs_blood_obtained = 1 then 'Yes'
            else 'No'
        end as sample_taken
        ,null as container_id
    from rcap_ctau_biosample

    union all

    select source_subject_id, event_name 
        ,'saliva' as general_sample_description
        ,case 
            when bs_saliva_obtained = 1 then 'Yes'
            else 'No'
        end as sample_taken
        ,null as container_id
    from rcap_ctau_biosample

    union all

    select bs.source_subject_id, bs.event_name
        ,'urine' as general_sample_description
        ,case
            when bs.bs_uds_obtained = 1 then 'Yes'
            else 'No'
        end as sample_taken
        ,case
            when bs.bs_uds_obtained = 1 then concat(samp_info_gen.si_tube_id_main_part,'_6_1')
            else null
        end as container_id
    from rcap_ctau_biosample bs
    left join rcap_ctau_sample_info_grouped_view samp_info_gen -- Attention: joining with a view
        on samp_info_gen.source_subject_id = bs.source_subject_id
        and samp_info_gen.event_name = bs.event_name
);

-- Step 3: create a helper view from rcap_ctau_sample_info
/*
The main aim of this view is to extract only relevent data from rcap_ctau_sample_info
table and introduce helper columns. 
Column general_sample_description will be utilized to join this helper view
with rcap_ctau_biosample_agg_view (Step 2); column sample_description is used
to meet the NDA's requirements for data submission.
For reference, si_sample_type's encoding:
1: Buffy coat #1 - Epigenetics
2: Buffy coat #2 - Omics
3: Plasma
4: RNA tube
5: Saliva
*/
create view rcap_ctau_sample_info_agg_view 
as
(
select si_sample_type, si_tube_id, 
    source_subject_id, event_name, instance
    ,case 
        when si_sample_type in ('1','2','3','4') then 'blood'
        when si_sample_type = '5' then 'saliva'
        else null
    end as general_sample_description
    ,case
        when si_sample_type in ('1','2') then 'whole blood'
        when si_sample_type = '3' then 'plasma'
        when si_sample_type = '4' then 'whole blood'
        when si_sample_type = '5' then 'saliva'
    end as sample_description
from rcap_ctau_sample_info
);

-- Step 4: create genomic_subject02_nda view
select
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
	,case
		when bs.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
		when bs.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
		when bs.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date,'mm/dd/yyyy')
		when bs.event_name like 'one_year%' then to_char(sched.sched_1yr_date,'mm/dd/yyyy')
		when bs.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as interview_date
	,case
		when bs.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
		when bs.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
		when bs.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
		when bs.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
		when bs.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
	end as interview_age
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
        when pfhc.hc_race in (null,'0') then 'Unknown or not reported'
    end as race
    ,case
        when pfhc.hc_hispanic = '0' then 'Not Hispanic'
        when pfhc.hc_hispanic = '1' then 'Hispanic'
        else null
    end as ethnic_group
    ,'DSM-5 Criterion A Trauma' as phenotype
    --,'Children that have experienced a trauma that meets PTSD diagnostic criterion A, as defined by DSM-5 and determined by administration of the Traumatic Events Screening Inventory – Child (TESI-C) during the TX-CTRN baseline visit.' as phenotype_description
    ,'No' as twins_study
    ,'No' as sibling_study
    ,'No' as family_study
    ,bs.sample_taken
    ,case 
        when bs.general_sample_description = 'urine' then bs.container_id
        else samp_info.si_tube_id 
    end as sample_id_original
    ,case 
        when bs.general_sample_description = 'urine' and bs.sample_taken = 'Yes' then 'urine'
        else samp_info.sample_description
    end as sample_description
    , 'UT Austin Dell Medical School' as biorepository
    , sa2.source_subject_id as patient_id_biorepository ---------- ???????????
    ,case 
        when bs.general_sample_description = 'urine' then bs.container_id
        else samp_info.si_tube_id
    end as sample_id_biorepository
    ,case
		when bs.event_name like 'baseline%' then 'baseline'
		when bs.event_name like 'one_month%' then 'one_month'
		when bs.event_name like 'six_month%' then 'six_month'
		when bs.event_name like 'one_year%' then 'one_year'
		when bs.event_name like '18_month%' then '18_month'
		when bs.event_name like '24_month%' then '24_month'
	end as visit
from rcap_ctau_biosample_agg_view bs
inner join subject_alias sa1
    on sa1.source_subject_id = bs.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = bs.source_subject_id 
    and sched.event_name like 'baseline%'
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id
left join rcap_ctau_sample_info_agg_view samp_info
    on samp_info.source_subject_id = bs.source_subject_id
    and samp_info.event_name = bs.event_name
    and samp_info.general_sample_description = bs.general_sample_description
;










-- Additional queries
----- !Attention to these cases!
-- !!!!!! Same event_name, two different 4-digit signature in si_tube_id
select * from rcap_ctau_sample_info_grouped_view 
where source_subject_id in ('908-25', '908-2') 
order by source_subject_id;

-- 
select si_sample_type, si_tube_id, source_subject_id, event_name 
from rcap_ctau_sample_info 
where si_tube_id like 'aud_ptsd_5001%' or si_tube_id like 'aud_ptsd_5005%';


select
    source_subject_id
    ,event_name
    ,si_sample_type
    ,si_tube_id
from rcap_ctau_sample_info
where source_subject_id in ('908-2', '908-25')
    and event_name like 'baseline%'
order by source_subject_id, event_name, si_tube_id;



select
    source_subject_id
    ,event_name
    ,si_sample_type
    ,si_tube_id
from rcap_ctau_sample_info
where source_subject_id = '908-2'
    and event_name like 'baseline%'
order by source_subject_id, event_name, si_tube_id;


select
    source_subject_id
    ,event_name
    ,si_sample_type
    ,si_tube_id
from rcap_ctau_sample_info
where source_subject_id = '908-25'
    and event_name like 'baseline%'
order by source_subject_id, event_name, si_tube_id;




----- checking the nda_months_between (used to be months_between) function
select
    sa2.source_subject_id as subjectkey
    ,sa2.subject_id as src_subject_id
    ,sched.interview_date as interview_date
    ,ctau_dem.dem_ch_dob
    ,nda_months_between(sched.interview_date, ctau_dem.dem_ch_dob) as interview_age
from rcap_ctau_biosample_agg_view bs
inner join subject_alias sa1
    on sa1.source_subject_id = bs.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_scheduling_form_agg_view sched
    on sched.source_subject_id = bs.source_subject_id 
    and sched.event_name = bs.event_name
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sa1.source_subject_id
left join subject_alias sa3
    on sa3.subject_id = sa1.subject_id
    and sa3.project_id = 696
    and sa3.id_type = 'redcap'
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sa3.source_subject_id
left join rcap_ctau_sample_info_agg_view samp_info
    on samp_info.source_subject_id = bs.source_subject_id
    and samp_info.event_name = bs.event_name
    and samp_info.general_sample_description = bs.general_sample_description
;