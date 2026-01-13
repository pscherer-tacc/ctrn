--- Construct a view to generate output from the DW for Dr. Beurel's Cytokine Lab as per the following rqmts:
--- 	Pull data (all events) for samples sent to Dr. Beurel's lab (si.si_tube_id ilike '%_3_1'):
---			DOB
---			Date of blood collection
---			Calculated age (in days) at date of blood collection
---			tube_id
---			Sex
---			Mini PTSD (mini_j1__1_current='1')
---			Mini AUD (mini_k1__1_past_12_mo='1')
---			Mini Primary diagnosis
---			AUDIT score
---			
---		Categorize participants into 4 categories: PTSD, AUD, both or none
--- 	Remove any duplicates, pii/phi, and fields not specifically required by the lab

select si_tube_id,
       source_subject_id,
       event_name,
       sched_ctrn_id,
       subject_id,
       project_id,
       id_type,
       case
        when event_name like 'baseline%' then sched_base_complete_date
        when event_name like 'one_year%' then sched_1yr_date
        when event_name like '24_month%' then sched_2yr_complete_date
       end as sched_visit_complete_date,
       dem_ch_dob,
       case 
        when event_name like 'baseline%' then age_days_between(dem_ch_dob::date, sched_base_complete_date)
        when event_name like 'one_year%' then age_days_between(dem_ch_dob::date, sched_1yr_date)
        when event_name like '24_month%' then age_days_between(dem_ch_dob::date, sched_2yr_complete_date)
       end as age_days, -- NEW FIELD
       sex,
	   mini_j1__1_current AS 'PTSD',
	   mini_k1__1_past_12_mo AS 'AUD',
       mini_primary_dx,
       audit_score 
from rcap_ctau_sample_info_joined_view
---where si_tube_id ilike '%_1_1' -- Samples sent to Dr. Champagne's Epigenomics Lab
---where si_tube_id ilike '%_2_1'	-- Samples sent to Dr. Ressler's Genetics Lab
where si_tube_id ilike '%_3_1'	-- Samples sent to Dr. Beurel's Cytokines Lab	 			
order by source_subject_id
;
