---- Creating clinlabtestsp201_nda_view (Dr. Beural cytokines)
---- This should output just the results and associated records from the labs_ctau_cytokine table harmonized for submission to the NDA.

select
	sa2.source_subject_id as subjectkey
  	,sa2.subject_id as src_subject_id
	,si.source_subject_id as ctau_source_subject_id -- only for validation; DELETE before submission
	,case
		when si.event_name like 'baseline%' then to_char(sched.sched_base_complete_date,'mm/dd/yyyy')
		when si.event_name like 'one_month%' then to_char(sched.sched_1mo_complete_date,'mm/dd/yyyy')
		when si.event_name like 'six_month%' then to_char(sched.sched_6mo_complete_date,'mm/dd/yyyy')
		when si.event_name like 'one_year%' then to_char(sched.sched_1yr_date,'mm/dd/yyyy')
		when si.event_name like '24_month%' then to_char(sched.sched_2yr_complete_date,'mm/dd/yyyy')
	end as interview_date
	,case
		when si.event_name like 'baseline%' then nda_months_between(sched.sched_base_complete_date, ctau_dem.dem_ch_dob)
		when si.event_name like 'one_month%' then nda_months_between(sched.sched_1mo_complete_date, ctau_dem.dem_ch_dob)
		when si.event_name like 'six_month%' then nda_months_between(sched.sched_6mo_complete_date, ctau_dem.dem_ch_dob)
		when si.event_name like 'one_year%' then nda_months_between(sched.sched_1yr_date, ctau_dem.dem_ch_dob)
		when si.event_name like '24_month%' then nda_months_between(sched.sched_2yr_complete_date, ctau_dem.dem_ch_dob)
	end as interview_age
	,case
		when si.event_name like 'baseline%' then sched.sched_base_complete
		when si.event_name like 'one_month%' then sched.sched_1mo_complete
		when si.event_name like 'six_month%' then sched.sched_6mo_complete
		when si.event_name like 'one_year%' then sched.sched_1yr_complete
		when si.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when si.event_name like 'baseline%' then 'baseline'
		when si.event_name like 'one_month%' then 'one_month'
		when si.event_name like 'six_month%' then 'six_month'
		when si.event_name like 'one_year%' then 'one_year'
		when si.event_name like '24_month%' then '24_month'
	end as visit
	,cyto.analysis_ts as assay_date
	,cyto.si_tube_id as sample_id_original   -- samples sent to Dr. Beurel's Lab where si_tube_id = aud_ptsd_????_3_1
	,cyto.basic_fgf
	,cyto.eotaxin
	,cyto."g-csf" as gcsf
	,cyto."gm-csf" as gmcsf
	,cyto.ifng as cytokine_ifn_gamma
	,cyto."il-10" as cytokine_il_10
	,cyto."il-12p70" as il12
	--,cyto.il-12p70 as il12
	,cyto."il-13" as il13_pgml
	,cyto."il-15" as il15_pgml
	,cyto."il-17" as il17
	,cyto."il-1b" as il1b_pgml
	,cyto."il-1ra" as il1ra
	,cyto."il-2" as il2_pgml
	,cyto."il-4" as il_4
	,cyto."il-5" as il5
	,cyto."il-6" as cytokine_il_6
	,cyto."il-7" as il7
	,cyto."il-8" as cytokine_il_8
	,cyto."il-9" as il_9
	,cyto."ip-10" as ip10
	,cyto."mcp-1" as mcp1
	,cyto."mip-1a" as mip_1a
	,cyto."mip-1b" as mip_1b
	,cyto.pdgf as pdgfaa
	,cyto.rantes
	,cyto.tnf as cytokine_tnf_alpha
	,cyto.vegf
	,cyto.extrapolated	
from lab_ctau_cytokines cyto  -- Query based on the analysis vs the sample info as the analysis determines records we should share. 
left join rcap_ctau_sample_info si 
    on si.si_tube_id = cyto.si_tube_id	   -- Should be just Dr. Beurel's Cytokine samples without requiring the next line.
	-- and si_tube_id ilike '%_3_1'  
left join rcap_ctau_scheduling_form sched
    on sched.source_subject_id = si.source_subject_id 
    and sched.event_name like 'baseline%'  -- Samples only taken at baseline visit
inner join subject_alias sa1         -- the subject_alias joins are needed to obtain the subjectkey and src_subject_id
    on sa1.source_subject_id = si.source_subject_id
    and sa1.project_id = 2515 -- only ctau ids
    and sa1.id_type = 'redcap'
inner join subject_alias sa2
    on sa2.subject_id = sa1.subject_id
    and sa2.project_id = 696 -- not necessary, just to be explicit
    and sa2.id_type = 'nimh_guid'
left join rcap_ctau_dem ctau_dem
    on ctau_dem.source_subject_id = sched.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = sched.sched_ctrn_id
order by sa2.subject_id;
