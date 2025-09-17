---- minikid NDA view

-- The function that coverts '2' values to 0; immutable, run just once 
create function nda_2_to_0_converter (val VARCHAR)
returns integer
as
$$
    select case
            when val='2' then 0
            else val::int
        end;
$$
language sql
immutable
returns null on null input;

-- The main query for the view
select
    dem.dem_guid as subjectkey,
    sa1.subject_id as src_subject_id,
	mini.source_subject_id, -- only for validation; delete before submission
	mini.event_name, -- only for validation; delete before submission
	case	
		when mini.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when mini.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when mini.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when mini.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
	    --when mini.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')   --- no 18 month in ctau
		when mini.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date,
	case
	    when mini.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when mini.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when mini.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when mini.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when mini.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when mini.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age, 
	case
	    when mini.event_name like 'baseline%' then sched_main.sched_base_complete
		when mini.event_name like 'one_month%' then sched_main.sched_1mo_complete
		when mini.event_name like 'six_month%' then sched_main.sched_6mo_complete
		when mini.event_name like 'one_year%' then sched_main.sched_1yr_complete
		--when mini.event_name like '18_month%' then sched.sched_18mo_complete
		when mini.event_name like '24_month%' then sched_main.sched_2yr_complete
	end as complete, -- only for validation; delete before submission
	case
	    when pfhc.hc_sex_birth_cert='1' then 'F'
		when pfhc.hc_sex_birth_cert='2' then 'M'
		else null
	end as sex,
	case
		when mini.event_name like 'baseline%' then 'baseline'
		when mini.event_name like 'one_month%' then 'one_month'
		when mini.event_name like 'six_month%' then 'six_month'
		when mini.event_name like 'one_year%' then 'one_year'
		-- when mini.event_name like '18_month%' then '18_month'
		when mini.event_name like '24_month%' then '24_month'
	end as timepoint_label,
	mini.mini_a1__1_current as mini_a1_current,
    mini.mini_a1__2_past as mini_a1_past,		
	mini.mini_a1__3_recurrent as mini_a1_recurrent,
	mini.mini_a2__1_current as mini_a2_current,
    mini.mini_a2__2_past as mini_a2_past,		
	mini.mini_a2__3_recurrent as mini_a2_recurrent,	
	mini.mini_b1__1_current as mini_kidsum_suic___1,
    mini.mini_b1__2_lifetimeatt as mini_kidsum_suic___2,			
    case
		when mini.mini_b18='1' then '0' 
		when mini.mini_b18='2' then '1'
		when mini.mini_b18='3' then '2'
		else null
	end	as minimodb_b18b,      	 
    mini.mini_b1a as mini_kidsumsuic_curr_sev,	
	case
		when mini_b3__2_early_remission='1' then '2'
		when mini_b3__1_current='1' then '1'
		else null
	end as mini_kidsum_suicdis, 
	mini_c1__1_current as q_minikid_c7_manic_curr,
	mini_c1__2_past as q_minikid_c7_manic_past,
	mini_c2__1_current as mini_kidsum_hypom___1,
	mini_c2__2_past as mini_kidsum_hypom___2,
	mini_c2__3_not_explored as mini_kidsum_hypom___3,
	mini_c3__1_current as mini_kidsum_bipi___1,
	mini_c3__2_past as mini_kidsum_bipi___2,
	mini_c5__1_current as mini_kidsum_bipii___1,
	mini_c5__2_past as mini_kidsum_bipii___2,
	mini_c7__1_current as mini_kidsum_otherbip___1,
	mini_c7__2_past as mini_kidsum_otherbip___2,
	mini_d1__1_current as q_minikid_pd,
	mini_d1__2_lifetime as q_minikid_pd_life,
	mini_e1__1_current as mini_e1_current,
	mini_f1__1_current as mini_f1_current,
	mini_g1__1_current as mini_g1_current,
	mini_h1__1_current as mini_h1_current,
	mini_i1__1_current as mini_i1_current,
	mini_j1__1_current as mini_j1_current,
	mini_k1__1_past_12_mo as mini_k1_past_12_mo,
	mini_l1__1_past_12_mo as mini_l1_past_12_mo,
	mini_m as mini_m,
	mini_n as mini_n,
	nda_2_to_0_converter(mini_n1) as minikid_n1, 
	mini_o1__1_past_12_mo as mini_o1_past_12_mo, 
	nda_2_to_0_converter(mini_o2_a) as minikid_p2a,
	nda_2_to_0_converter(mini_o2_b) as minikid_p2b,
	nda_2_to_0_converter(mini_o2_c) as minikid_p2c,
	nda_2_to_0_converter(mini_o2_d) as minikid_p2d,
	nda_2_to_0_converter(mini_o2_e) as minikid_p2e,
	nda_2_to_0_converter(mini_o2_f) as minikid_p2f,
	nda_2_to_0_converter(mini_o2_g) as minikid_p2g,
	nda_2_to_0_converter(mini_o2_h) as minikid_p2h,
	nda_2_to_0_converter(mini_o2_i) as minikid_p2i,
	nda_2_to_0_converter(mini_o2_j) as minikid_p2j,
	nda_2_to_0_converter(mini_o2_k) as minikid_p2k,
	nda_2_to_0_converter(mini_o2_l) as minikid_p2l,
	nda_2_to_0_converter(mini_o2_m) as minikid_p2m,
	nda_2_to_0_converter(mini_o2_n) as minikid_p2n,
	nda_2_to_0_converter(mini_o2_o) as minikid_p2o,
	mini_o3 as minikid_p3,
	nda_2_to_0_converter(mini_o3_onset) as mini_o3_onset,
	mini_p1__1_past_6_mo as mini_p1_past_6_mo, 
	mini_q1__1_current as mini_q1_current,
	mini_q1__2_lifetime as mini_q1_lifetime, 
	mini_q3__1_current as mini_kidsum_moodispsy___1,
	mini_q3__2_lifetime as mini_q3_lifetime,
	mini_q5__1_current as mini_kidsum_bip1psy___1, 
	mini_q5__2_lifetime as mini_q5_lifetime,
	mini_r1__1_current as mini_r1_current,
	mini_s1__1_current as mini_s1_current,
	mini_t1__1_current as mini_t1_current,
	mini_u1__1_current as mini_u1_current,		
	mini_v1__1_current as mini_v1_current,
	mini_w1 as mini_kidsum_medrulout,
	mini_x1__1_not_ruled_out as mini_x1_not_ruled_out,
	mini_primary_dx
from rcap_miniss_v2 as mini -- attention! rcap_miniss_v2 is NOT a ctau table.
inner join rcap_ctau_scheduling_form as sched -- to keep ctau participants only
	on sched.sched_ctrn_id = mini.source_subject_id
	and sched.event_name like 'baseline%'
	-- and mini.event_name not like 'unscheduled%'-- optional if want to include
inner join subject_alias as sa1
    on sa1.source_subject_id = mini.source_subject_id
left join rcap_scheduling_form as sched_main 
    on sched_main.source_subject_id = mini.source_subject_id 
left join rcap_demographics as dem
    on dem.source_subject_id = mini.source_subject_id
left join rcap_pfh_child as pfhc 
    on pfhc.source_subject_id = mini.source_subject_id
order by sa1.subject_id;