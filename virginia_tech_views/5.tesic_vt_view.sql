---- TESIC VT View
--- Name of the view: view_vt_tesic (Important: it depends on the view_tesic_union helper view)

-- Query the data from the view
select * from view_vt_tesic
where interview_date is not null;

-- The body of the view (Important: it depends on the view_tesic_union helper view)
create or replace view view_vt_tesic
as
select
    dem.dem_guid
    ,sa1.subject_id
	,case
		when tesic_u.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when tesic_u.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when tesic_u.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when tesic_u.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when tesic_u.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
	,case
		when tesic_u.event_name like 'baseline%' then 'baseline'
		when tesic_u.event_name like 'one_month%' then 'one_month'
		when tesic_u.event_name like 'six_month%' then 'six_month'
		when tesic_u.event_name like 'one_year%' then 'one_year'
		when tesic_u.event_name like '18_month%' then '18_month'
		when tesic_u.event_name like '24_month%' then '24_month'
	end as event_name
    ,tesic_u.tesi_c_1
    ,tesic_u.tcfu_1_1
    ,tesic_u.tc_1_1_crit_a1
    ,tesic_u.tc_1_1_crit_a2
    ,tesic_u.tc_1_1_how_often
    ,tesic_u.tc_1_2
    ,tesic_u.tcfu_1_2
    ,tesic_u.tc_1_2_crit_a1
    ,tesic_u.tc_1_2_crit_a2
    ,tesic_u.tc_1_2_how_often
    ,tesic_u.tc_1_3
    ,tesic_u.tcfu_1_3
    ,tesic_u.tc_1_3_crit_a1
    ,tesic_u.tc_1_3_crit_a2
    ,tesic_u.tc_1_3_how_often
    ,tesic_u.tc_1_4
    ,tesic_u.tcfu_1_4
    ,tesic_u.tc_1_4_crit_a1
    ,tesic_u.tc_1_4_crit_a2
    ,tesic_u.tc_1_4_who__1_mother
    ,tesic_u.tc_1_4_who__2_father
    ,tesic_u.tc_1_4_who__3_sibling
    ,tesic_u.tc_1_4_who__4_grandparent
    ,tesic_u.tc_1_4_who__5_otherrelative
    ,tesic_u.tc_1_4_who__6_kadult
    ,tesic_u.tc_1_4_who__7_kkid
    ,tesic_u.tc_1_4_who__8_else
    ,tesic_u.tc_1_4_how_often
    ,tesic_u.tc_1_5
    ,tesic_u.tcfu_1_5
    ,tesic_u.tc_1_5_crit_a1
    ,tesic_u.tc_1_5_crit_a2
    ,tesic_u.tc_1_5_how_often
    ,tesic_u.tc_1_6
    ,tesic_u.tcfu_1_6
    ,tesic_u.tc_1_6_crit_a1
    ,tesic_u.tc_1_6_crit_a2
    ,tesic_u.tc_1_6_how_often
    ,tesic_u.tc_2_1
    ,tesic_u.tcfu_2_1
    ,tesic_u.tc_2_1_crit_a1
    ,tesic_u.tc_2_1_crit_a2
    ,tesic_u.tc_2_1_who__1_mother
    ,tesic_u.tc_2_1_who__2_father
    ,tesic_u.tc_2_1_who__3_sibling
    ,tesic_u.tc_2_1_who__4_grandparent
    ,tesic_u.tc_2_1_who__5_otherrelative
    ,tesic_u.tc_2_1_who__6_kadult
    ,tesic_u.tc_2_1_who__7_unkadult
    ,tesic_u.tc_2_1_who__8_kkid
    ,tesic_u.tc_2_1_who__9_unkkid
    ,tesic_u.tc_2_1_who__10_else
    ,tesic_u.tc_2_1_how__1_hit_kick_bite
    ,tesic_u.tc_2_1_how__2_choke_smother
    ,tesic_u.tc_2_1_how__3_burn
    ,tesic_u.tc_2_1_how__4_gun_knife
    ,tesic_u.tc_2_1_how__5_bat_club
    ,tesic_u.tc_2_1_how__6_other
    ,tesic_u.tc_2_1_how_often
    ,tesic_u.tc_2_2
    ,tesic_u.tcfu_2_2
    ,tesic_u.tc_2_2_crit_a2
    ,tesic_u.tc_2_2_who__1_mother
    ,tesic_u.tc_2_2_who__2_father
    ,tesic_u.tc_2_2_who__3_sibling
    ,tesic_u.tc_2_2_who__4_grandparent
    ,tesic_u.tc_2_2_who__5_otherrelative
    ,tesic_u.tc_2_2_who__6_kadult
    ,tesic_u.tc_2_2_who__7_unkadult
    ,tesic_u.tc_2_2_who__8_kkid
    ,tesic_u.tc_2_2_who__9_unkkid
    ,tesic_u.tc_2_2_who__10_else
    ,tesic_u.tc_2_2_how__1_hit_kick_bite
    ,tesic_u.tc_2_2_how__2_choke_smother
    ,tesic_u.tc_2_2_how__3_burn
    ,tesic_u.tc_2_2_how__4_gun_knife
    ,tesic_u.tc_2_2_how__5_bat_club
    ,tesic_u.tc_2_2_how__6_other
    ,tesic_u.tc_2_2_how_often
    ,tesic_u.tc_2_3
    ,tesic_u.tcfu_2_3
    ,tesic_u.tc_2_3_crit_a2
    ,tesic_u.tc_2_3_how
    ,tesic_u.tc_2_3_how_often
    ,tesic_u.tc_2_4
    ,tesic_u.tcfu_2_4
    ,tesic_u.tc_2_4_crit_a2
    ,tesic_u.tc_2_4_who__1_mother
    ,tesic_u.tc_2_4_who__2_father
    ,tesic_u.tc_2_4_who__3_sibling
    ,tesic_u.tc_2_4_who__4_grandparent
    ,tesic_u.tc_2_4_who__5_otherrelative
    ,tesic_u.tc_2_4_who__6_kadult
    ,tesic_u.tc_2_4_who__7_unkadult
    ,tesic_u.tc_2_4_who__10_else
    ,tesic_u.tc_2_4_how__1_none
    ,tesic_u.tc_2_4_how__2_gun
    ,tesic_u.tc_2_4_how__3_knife
    ,tesic_u.tc_2_4_how__4_other
    ,tesic_u.tc_2_4_how_often
    ,tesic_u.tc_2_5
    ,tesic_u.tcfu_2_5
    ,tesic_u.tc_2_5_crit_a2
    ,tesic_u.tc_2_5_how_often
    ,tesic_u.tc_3_1
    ,tesic_u.tcfu_3_1
    ,tesic_u.tc_3_1_crit_a2
    ,tesic_u.tc_3_1_who__1_mother
    ,tesic_u.tc_3_1_who__2_father
    ,tesic_u.tc_3_1_who__3_sibling
    ,tesic_u.tc_3_1_who__4_grandparent
    ,tesic_u.tc_3_1_who__5_otherrelative
    ,tesic_u.tc_3_1_who__6_kadult
    ,tesic_u.tc_3_1_who__7_unkadult
    ,tesic_u.tc_3_1_who__8_kkid
    ,tesic_u.tc_3_1_who__9_unkkid
    ,tesic_u.tc_3_1_who__10_else
    ,tesic_u.tc_3_1_how__1_hit_kick_bite
    ,tesic_u.tc_3_1_how__2_choke_smother
    ,tesic_u.tc_3_1_how__3_burn
    ,tesic_u.tc_3_1_how__4_gun_knife
    ,tesic_u.tc_3_1_how__5_bat_club
    ,tesic_u.tc_3_1_how__6_other
    ,tesic_u.tc_3_1_how_often
    ,tesic_u.tc_3_2
    ,tesic_u.tcfu_3_2
    ,tesic_u.tc_3_2_crit_a2
    ,tesic_u.tc_3_2_who__1_mother
    ,tesic_u.tc_3_2_who__2_father
    ,tesic_u.tc_3_2_who__3_sibling
    ,tesic_u.tc_3_2_who__4_grandparent
    ,tesic_u.tc_3_2_who__5_otherrelative
    ,tesic_u.tc_3_2_who__6_kadult
    ,tesic_u.tc_3_2_who__7_unkadult
    ,tesic_u.tc_3_2_who__8_kkid
    ,tesic_u.tc_3_2_who__9_unkkid
    ,tesic_u.tc_3_2_who__10_else
    ,tesic_u.tc_3_2_how__1_hit_kick_bite
    ,tesic_u.tc_3_2_how__2_choke_smother
    ,tesic_u.tc_3_2_how__3_burn
    ,tesic_u.tc_3_2_how__4_gun_knife
    ,tesic_u.tc_3_2_how__5_bat_club
    ,tesic_u.tc_3_2_how__6_other
    ,tesic_u.tc_3_2_how_often
    ,tesic_u.tc_3_3
    ,tesic_u.tcfu_3_3
    ,tesic_u.tc_3_3_crit_a2
    ,tesic_u.tc_3_3_who__1_mother
    ,tesic_u.tc_3_3_who__2_father
    ,tesic_u.tc_3_3_who__3_sibling
    ,tesic_u.tc_3_3_who__4_grandparent
    ,tesic_u.tc_3_3_who__5_otherrelative
    ,tesic_u.tc_3_3_how_often
    ,tesic_u.tc_4_1
    ,tesic_u.tcfu_4_1
    ,tesic_u.tc_4_1_crit_a2
    ,tesic_u.tc_4_1_who__1_mother
    ,tesic_u.tc_4_1_who__2_father
    ,tesic_u.tc_4_1_who__3_sibling
    ,tesic_u.tc_4_1_who__4_grandparent
    ,tesic_u.tc_4_1_who__5_otherrelative
    ,tesic_u.tc_4_1_who__6_kadult
    ,tesic_u.tc_4_1_who__7_unkadult
    ,tesic_u.tc_4_1_who__8_kkid
    ,tesic_u.tc_4_1_who__9_unkkid
    ,tesic_u.tc_4_1_who__10_else
    ,tesic_u.tc_4_1_how__1_hit_kick_bite
    ,tesic_u.tc_4_1_how__2_choke_smother
    ,tesic_u.tc_4_1_how__3_burn
    ,tesic_u.tc_4_1_how__4_gun_knife
    ,tesic_u.tc_4_1_how__5_bat_club
    ,tesic_u.tc_4_1_how__6_other
    ,tesic_u.tc_4_1_how_often
    ,tesic_u.tc_4_2
    ,tesic_u.tcfu_4_2
    ,tesic_u.tc_4_2_crit_a2
    ,tesic_u.tc_4_2_who__1_mother
    ,tesic_u.tc_4_2_who__2_father
    ,tesic_u.tc_4_2_who__3_sibling
    ,tesic_u.tc_4_2_who__4_grandparent
    ,tesic_u.tc_4_2_who__5_otherrelative
    ,tesic_u.tc_4_2_who__6_kadult
    ,tesic_u.tc_4_2_who__7_unkadult
    ,tesic_u.tc_4_2_who__8_kkid
    ,tesic_u.tc_4_2_who__9_unkkid
    ,tesic_u.tc_4_2_who__10_else
    ,tesic_u.tc_4_2_how__1_hit_kick_bite
    ,tesic_u.tc_4_2_how__2_choke_smother
    ,tesic_u.tc_4_2_how__3_burn
    ,tesic_u.tc_4_2_how__4_gun_knife
    ,tesic_u.tc_4_2_how__5_bat_club
    ,tesic_u.tc_4_2_how__6_other
    ,tesic_u.tc_4_2_how_often
    ,tesic_u.tc_4_3
    ,tesic_u.tcfu_4_3
    ,tesic_u.tc_4_3_crit_a2
    ,tesic_u.tc_4_3_how_often
    ,tesic_u.tc_5
    ,tesic_u.tcfu_5
    ,tesic_u.tc_5_crit_a2
    ,tesic_u.tc_5_who__1_mother
    ,tesic_u.tc_5_who__2_father
    ,tesic_u.tc_5_who__3_sibling
    ,tesic_u.tc_5_who__4_grandparent
    ,tesic_u.tc_5_who__5_otherrelative
    ,tesic_u.tc_5_who__6_kadult
    ,tesic_u.tc_5_who__7_unkadult
    ,tesic_u.tc_5_who__8_kkid
    ,tesic_u.tc_5_who__9_unkkid
    ,tesic_u.tc_5_who__10_else
    ,tesic_u.tc_5_how__1_fondled_genitals
    ,tesic_u.tc_5_how__2_oralchild_genit
    ,tesic_u.tc_5_how__3_childoral_genit
    ,tesic_u.tc_5_how__4_digitpenetrate
    ,tesic_u.tc_5_how__5_intercourse
    ,tesic_u.tc_5_how__6_porno_filming
    ,tesic_u.tc_5_how__7_prostitution
    ,tesic_u.tc_5_how__8_other
    ,tesic_u.tc_5_how_often
    ,tesic_u.tc_6_1
    ,tesic_u.tcfu_6_1
    ,tesic_u.tc_6_1_crit_a2
    ,tesic_u.tc_6_1_who__1_older_boy
    ,tesic_u.tc_6_1_who__2_younger_boy
    ,tesic_u.tc_6_1_who__3_boy_same_grade
    ,tesic_u.tc_6_1_who__4_older_girl
    ,tesic_u.tc_6_1_who__5_younger_girl
    ,tesic_u.tc_6_1_who__6_girl_same_grade
    ,tesic_u.tc_6_1_who__7_family
    ,tesic_u.tc_6_1_who__8_adultnotfam
    ,tesic_u.tc_6_1_who__9_unkkid
    ,tesic_u.tc_6_1_who__10_unkadult
    ,tesic_u.tc_6_1_who__99_else
    ,tesic_u.tc_6_2
    ,tesic_u.tcfu_6_2
    ,tesic_u.tc_6_2_who__1_older_boy
    ,tesic_u.tc_6_2_who__2_younger_boy
    ,tesic_u.tc_6_2_who__3_boy_same_grade
    ,tesic_u.tc_6_2_who__4_older_girl
    ,tesic_u.tc_6_2_who__5_younger_girl
    ,tesic_u.tc_6_2_who__6_girl_same_grade
    ,tesic_u.tc_6_2_who__7_family
    ,tesic_u.tc_6_2_who__8_adultnotfam
    ,tesic_u.tc_6_2_who__9_unkkid
    ,tesic_u.tc_6_2_who__10_unkadult
    ,tesic_u.tc_6_2_who__99_else
    ,tesic_u.tc_6_2_how_often
    ,tesic_u.tc_7
    ,tesic_u.tcfu_7
    ,tesic_u.tc_7_crit_a1
    ,tesic_u.tc_7_crit_a2
    ,tesic_u.tc_7_how_often
    ,tesic_u.tc_8_1
    ,tesic_u.tc_8_1_less_than_1mo
    ,tesic_u.tc_8_3
from view_tesic_union tesic_u -- Attention! The view (not the table) is utilized
inner join subject_alias sa1
    on sa1.source_subject_id = tesic_u.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
	and tesic_u.event_name not like 'unscheduled%'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = tesic_u.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = tesic_u.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = tesic_u.source_subject_id
order by sa1.subject_id;


-- Create a helper view that unites rcap_tesic and rcap_tesic_followup
create or replace view view_tesic_union
as
select
    source_subject_id
    ,event_name
    ,tc_1_1 as tc_1_1
    ,null as tcfu_1_1
    ,tc_1_1_crit_a1 as tc_1_1_crit_a1
    ,tc_1_1_crit_a2 as tc_1_1_crit_a2
    ,tc_1_1_how_often as tc_1_1_how_often
    ,tc_1_2 as tc_1_2
    ,null as tcfu_1_2
    ,tc_1_2_crit_a1 as tc_1_2_crit_a1
    ,tc_1_2_crit_a2 as tc_1_2_crit_a2
    ,tc_1_2_how_often as tc_1_2_how_often
    ,tc_1_3 as tc_1_3
    ,null as tcfu_1_3
    ,tc_1_3_crit_a1 as tc_1_3_crit_a1
    ,tc_1_3_crit_a2 as tc_1_3_crit_a2
    ,tc_1_3_how_often as tc_1_3_how_often
    ,tc_1_4 as tc_1_4
    ,null as tcfu_1_4
    ,tc_1_4_crit_a1 as tc_1_4_crit_a1
    ,tc_1_4_crit_a2 as tc_1_4_crit_a2
    ,tc_1_4_who__1_mother as tc_1_4_who__1_mother
    ,tc_1_4_who__2_father as tc_1_4_who__2_father
    ,tc_1_4_who__3_sibling as tc_1_4_who__3_sibling
    ,tc_1_4_who__4_grandparent as tc_1_4_who__4_grandparent
    ,tc_1_4_who__5_otherrelative as tc_1_4_who__5_otherrelative
    ,tc_1_4_who__6_kadult as tc_1_4_who__6_kadult
    ,tc_1_4_who__7_kkid as tc_1_4_who__7_kkid
    ,tc_1_4_who__8_else as tc_1_4_who__8_else
    ,tc_1_4_how_often as tc_1_4_how_often
    ,tc_1_5 as tc_1_5
    ,null as tcfu_1_5
    ,tc_1_5_crit_a1 as tc_1_5_crit_a1
    ,tc_1_5_crit_a2 as tc_1_5_crit_a2
    ,tc_1_5_how_often as tc_1_5_how_often
    ,tc_1_6 as tc_1_6
    ,null as tcfu_1_6
    ,tc_1_6_crit_a1 as tc_1_6_crit_a1
    ,tc_1_6_crit_a2 as tc_1_6_crit_a2
    ,tc_1_6_how_often as tc_1_6_how_often
    ,tc_2_1 as tc_2_1
    ,null as tcfu_2_1
    ,tc_2_1_crit_a1 as tc_2_1_crit_a1
    ,tc_2_1_crit_a2 as tc_2_1_crit_a2
    ,tc_2_1_who__1_mother as tc_2_1_who__1_mother
    ,tc_2_1_who__2_father as tc_2_1_who__2_father
    ,tc_2_1_who__3_sibling as tc_2_1_who__3_sibling
    ,tc_2_1_who__4_grandparent as tc_2_1_who__4_grandparent
    ,tc_2_1_who__5_otherrelative as tc_2_1_who__5_otherrelative
    ,tc_2_1_who__6_kadult as tc_2_1_who__6_kadult
    ,tc_2_1_who__7_unkadult as tc_2_1_who__7_unkadult
    ,tc_2_1_who__8_kkid as tc_2_1_who__8_kkid
    ,tc_2_1_who__9_unkkid as tc_2_1_who__9_unkkid
    ,tc_2_1_who__10_else as tc_2_1_who__10_else
    ,tc_2_1_how__1_hit_kick_bite as tc_2_1_how__1_hit_kick_bite
    ,tc_2_1_how__2_choke_smother as tc_2_1_how__2_choke_smother
    ,tc_2_1_how__3_burn as tc_2_1_how__3_burn
    ,tc_2_1_how__4_gun_knife as tc_2_1_how__4_gun_knife
    ,tc_2_1_how__5_bat_club as tc_2_1_how__5_bat_club
    ,tc_2_1_how__6_other as tc_2_1_how__6_other
    ,tc_2_1_how_often as tc_2_1_how_often
    ,tc_2_2 as tc_2_2
    ,null as tcfu_2_2
    ,tc_2_2_crit_a2 as tc_2_2_crit_a2
    ,tc_2_2_who__1_mother as tc_2_2_who__1_mother
    ,tc_2_2_who__2_father as tc_2_2_who__2_father
    ,tc_2_2_who__3_sibling as tc_2_2_who__3_sibling
    ,tc_2_2_who__4_grandparent as tc_2_2_who__4_grandparent
    ,tc_2_2_who__5_otherrelative as tc_2_2_who__5_otherrelative
    ,tc_2_2_who__6_kadult as tc_2_2_who__6_kadult
    ,tc_2_2_who__7_unkadult as tc_2_2_who__7_unkadult
    ,tc_2_2_who__8_kkid as tc_2_2_who__8_kkid
    ,tc_2_2_who__9_unkkid as tc_2_2_who__9_unkkid
    ,tc_2_2_who__10_else as tc_2_2_who__10_else
    ,tc_2_2_how__1_hit_kick_bite as tc_2_2_how__1_hit_kick_bite
    ,tc_2_2_how__2_choke_smother as tc_2_2_how__2_choke_smother
    ,tc_2_2_how__3_burn as tc_2_2_how__3_burn
    ,tc_2_2_how__4_gun_knife as tc_2_2_how__4_gun_knife
    ,tc_2_2_how__5_bat_club as tc_2_2_how__5_bat_club
    ,tc_2_2_how__6_other as tc_2_2_how__6_other
    ,tc_2_2_how_often as tc_2_2_how_often
    ,tc_2_3 as tc_2_3
    ,null as tcfu_2_3
    ,tc_2_3_crit_a2 as tc_2_3_crit_a2
    ,tc_2_3_how as tc_2_3_how
    ,tc_2_3_how_often as tc_2_3_how_often
    ,tc_2_4 as tc_2_4
    ,null as tcfu_2_4
    ,tc_2_4_crit_a2 as tc_2_4_crit_a2
    ,tc_2_4_who__1_mother as tc_2_4_who__1_mother
    ,tc_2_4_who__2_father as tc_2_4_who__2_father
    ,tc_2_4_who__3_sibling as tc_2_4_who__3_sibling
    ,tc_2_4_who__4_grandparent as tc_2_4_who__4_grandparent
    ,tc_2_4_who__5_otherrelative as tc_2_4_who__5_otherrelative
    ,tc_2_4_who__6_kadult as tc_2_4_who__6_kadult
    ,tc_2_4_who__7_unkadult as tc_2_4_who__7_unkadult
    ,tc_2_4_who__10_else as tc_2_4_who__10_else
    ,tc_2_4_how__1_none as tc_2_4_how__1_none
    ,tc_2_4_how__2_gun as tc_2_4_how__2_gun
    ,tc_2_4_how__3_knife as tc_2_4_how__3_knife
    ,tc_2_4_how__4_other as tc_2_4_how__4_other
    ,tc_2_4_how_often as tc_2_4_how_often
    ,tc_2_5 as tc_2_5
    ,null as tcfu_2_5
    ,tc_2_5_crit_a2 as tc_2_5_crit_a2
    ,tc_2_5_how_often as tc_2_5_how_often
    ,tc_3_1 as tc_3_1
    ,null as tcfu_3_1
    ,tc_3_1_crit_a2 as tc_3_1_crit_a2
    ,tc_3_1_who__1_mother as tc_3_1_who__1_mother
    ,tc_3_1_who__2_father as tc_3_1_who__2_father
    ,tc_3_1_who__3_sibling as tc_3_1_who__3_sibling
    ,tc_3_1_who__4_grandparent as tc_3_1_who__4_grandparent
    ,tc_3_1_who__5_otherrelative as tc_3_1_who__5_otherrelative
    ,tc_3_1_who__6_kadult as tc_3_1_who__6_kadult
    ,tc_3_1_who__7_unkadult as tc_3_1_who__7_unkadult
    ,tc_3_1_who__8_kkid as tc_3_1_who__8_kkid
    ,tc_3_1_who__9_unkkid as tc_3_1_who__9_unkkid
    ,tc_3_1_who__10_else as tc_3_1_who__10_else
    ,tc_3_1_how__1_hit_kick_bite as tc_3_1_how__1_hit_kick_bite
    ,tc_3_1_how__2_choke_smother as tc_3_1_how__2_choke_smother
    ,tc_3_1_how__3_burn as tc_3_1_how__3_burn
    ,tc_3_1_how__4_gun_knife as tc_3_1_how__4_gun_knife
    ,tc_3_1_how__5_bat_club as tc_3_1_how__5_bat_club
    ,tc_3_1_how__6_other as tc_3_1_how__6_other
    ,tc_3_1_how_often as tc_3_1_how_often
    ,tc_3_2 as tc_3_2
    ,null as tcfu_3_2
    ,tc_3_2_crit_a2 as tc_3_2_crit_a2
    ,tc_3_2_who__1_mother as tc_3_2_who__1_mother
    ,tc_3_2_who__2_father as tc_3_2_who__2_father
    ,tc_3_2_who__3_sibling as tc_3_2_who__3_sibling
    ,tc_3_2_who__4_grandparent as tc_3_2_who__4_grandparent
    ,tc_3_2_who__5_otherrelative as tc_3_2_who__5_otherrelative
    ,tc_3_2_who__6_kadult as tc_3_2_who__6_kadult
    ,tc_3_2_who__7_unkadult as tc_3_2_who__7_unkadult
    ,tc_3_2_who__8_kkid as tc_3_2_who__8_kkid
    ,tc_3_2_who__9_unkkid as tc_3_2_who__9_unkkid
    ,tc_3_2_who__10_else as tc_3_2_who__10_else
    ,tc_3_2_how__1_hit_kick_bite as tc_3_2_how__1_hit_kick_bite
    ,tc_3_2_how__2_choke_smother as tc_3_2_how__2_choke_smother
    ,tc_3_2_how__3_burn as tc_3_2_how__3_burn
    ,tc_3_2_how__4_gun_knife as tc_3_2_how__4_gun_knife
    ,tc_3_2_how__5_bat_club as tc_3_2_how__5_bat_club
    ,tc_3_2_how__6_other as tc_3_2_how__6_other
    ,tc_3_2_how_often as tc_3_2_how_often
    ,tc_3_3 as tc_3_3
    ,null as tcfu_3_3
    ,tc_3_3_crit_a2 as tc_3_3_crit_a2
    ,tc_3_3_who__1_mother as tc_3_3_who__1_mother
    ,tc_3_3_who__2_father as tc_3_3_who__2_father
    ,tc_3_3_who__3_sibling as tc_3_3_who__3_sibling
    ,tc_3_3_who__4_grandparent as tc_3_3_who__4_grandparent
    ,tc_3_3_who__5_otherrelative as tc_3_3_who__5_otherrelative
    ,tc_3_3_how_often as tc_3_3_how_often
    ,tc_4_1 as tc_4_1
    ,null as tcfu_4_1
    ,tc_4_1_crit_a2 as tc_4_1_crit_a2
    ,tc_4_1_who__1_mother as tc_4_1_who__1_mother
    ,tc_4_1_who__2_father as tc_4_1_who__2_father
    ,tc_4_1_who__3_sibling as tc_4_1_who__3_sibling
    ,tc_4_1_who__4_grandparent as tc_4_1_who__4_grandparent
    ,tc_4_1_who__5_otherrelative as tc_4_1_who__5_otherrelative
    ,tc_4_1_who__6_kadult as tc_4_1_who__6_kadult
    ,tc_4_1_who__7_unkadult as tc_4_1_who__7_unkadult
    ,tc_4_1_who__8_kkid as tc_4_1_who__8_kkid
    ,tc_4_1_who__9_unkkid as tc_4_1_who__9_unkkid
    ,tc_4_1_who__10_else as tc_4_1_who__10_else
    ,tc_4_1_how__1_hit_kick_bite as tc_4_1_how__1_hit_kick_bite
    ,tc_4_1_how__2_choke_smother as tc_4_1_how__2_choke_smother
    ,tc_4_1_how__3_burn as tc_4_1_how__3_burn
    ,tc_4_1_how__4_gun_knife as tc_4_1_how__4_gun_knife
    ,tc_4_1_how__5_bat_club as tc_4_1_how__5_bat_club
    ,tc_4_1_how__6_other as tc_4_1_how__6_other
    ,tc_4_1_how_often as tc_4_1_how_often
    ,tc_4_2 as tc_4_2
    ,null as tcfu_4_2
    ,tc_4_2_crit_a2 as tc_4_2_crit_a2
    ,tc_4_2_who__1_mother as tc_4_2_who__1_mother
    ,tc_4_2_who__2_father as tc_4_2_who__2_father
    ,tc_4_2_who__3_sibling as tc_4_2_who__3_sibling
    ,tc_4_2_who__4_grandparent as tc_4_2_who__4_grandparent
    ,tc_4_2_who__5_otherrelative as tc_4_2_who__5_otherrelative
    ,tc_4_2_who__6_kadult as tc_4_2_who__6_kadult
    ,tc_4_2_who__7_unkadult as tc_4_2_who__7_unkadult
    ,tc_4_2_who__8_kkid as tc_4_2_who__8_kkid
    ,tc_4_2_who__9_unkkid as tc_4_2_who__9_unkkid
    ,tc_4_2_who__10_else as tc_4_2_who__10_else
    ,tc_4_2_how__1_hit_kick_bite as tc_4_2_how__1_hit_kick_bite
    ,tc_4_2_how__2_choke_smother as tc_4_2_how__2_choke_smother
    ,tc_4_2_how__3_burn as tc_4_2_how__3_burn
    ,tc_4_2_how__4_gun_knife as tc_4_2_how__4_gun_knife
    ,tc_4_2_how__5_bat_club as tc_4_2_how__5_bat_club
    ,tc_4_2_how__6_other as tc_4_2_how__6_other
    ,tc_4_2_how_often as tc_4_2_how_often
    ,tc_4_3 as tc_4_3
    ,null as tcfu_4_3
    ,tc_4_3_crit_a2 as tc_4_3_crit_a2
    ,tc_4_3_how_often as tc_4_3_how_often
    ,tc_5 as tc_5
    ,null as tcfu_5
    ,tc_5_crit_a2 as tc_5_crit_a2
    ,tc_5_who__1_mother as tc_5_who__1_mother
    ,tc_5_who__2_father as tc_5_who__2_father
    ,tc_5_who__3_sibling as tc_5_who__3_sibling
    ,tc_5_who__4_grandparent as tc_5_who__4_grandparent
    ,tc_5_who__5_otherrelative as tc_5_who__5_otherrelative
    ,tc_5_who__6_kadult as tc_5_who__6_kadult
    ,tc_5_who__7_unkadult as tc_5_who__7_unkadult
    ,tc_5_who__8_kkid as tc_5_who__8_kkid
    ,tc_5_who__9_unkkid as tc_5_who__9_unkkid
    ,tc_5_who__10_else as tc_5_who__10_else
    ,tc_5_how__1_fondled_genitals as tc_5_how__1_fondled_genitals
    ,tc_5_how__2_oralchild_genit as tc_5_how__2_oralchild_genit
    ,tc_5_how__3_childoral_genit as tc_5_how__3_childoral_genit
    ,tc_5_how__4_digitpenetrate as tc_5_how__4_digitpenetrate
    ,tc_5_how__5_intercourse as tc_5_how__5_intercourse
    ,tc_5_how__6_porno_filming as tc_5_how__6_porno_filming
    ,tc_5_how__7_prostitution as tc_5_how__7_prostitution
    ,tc_5_how__8_other as tc_5_how__8_other
    ,tc_5_how_often as tc_5_how_often
    ,tc_6_1 as tc_6_1
    ,null as tcfu_6_1
    ,tc_6_1_crit_a2 as tc_6_1_crit_a2
    ,tc_6_1_who__1_older_boy as tc_6_1_who__1_older_boy
    ,tc_6_1_who__2_younger_boy as tc_6_1_who__2_younger_boy
    ,tc_6_1_who__3_boy_same_grade as tc_6_1_who__3_boy_same_grade
    ,tc_6_1_who__4_older_girl as tc_6_1_who__4_older_girl
    ,tc_6_1_who__5_younger_girl as tc_6_1_who__5_younger_girl
    ,tc_6_1_who__6_girl_same_grade as tc_6_1_who__6_girl_same_grade
    ,tc_6_1_who__7_family as tc_6_1_who__7_family
    ,tc_6_1_who__8_adultnotfam as tc_6_1_who__8_adultnotfam
    ,tc_6_1_who__9_unkkid as tc_6_1_who__9_unkkid
    ,tc_6_1_who__10_unkadult as tc_6_1_who__10_unkadult
    ,tc_6_1_who__99_else as tc_6_1_who__99_else
    ,tc_6_2 as tc_6_2
    ,null as tcfu_6_2
    ,tc_6_2_who__1_older_boy as tc_6_2_who__1_older_boy
    ,tc_6_2_who__2_younger_boy as tc_6_2_who__2_younger_boy
    ,tc_6_2_who__3_boy_same_grade as tc_6_2_who__3_boy_same_grade
    ,tc_6_2_who__4_older_girl as tc_6_2_who__4_older_girl
    ,tc_6_2_who__5_younger_girl as tc_6_2_who__5_younger_girl
    ,tc_6_2_who__6_girl_same_grade as tc_6_2_who__6_girl_same_grade
    ,tc_6_2_who__7_family as tc_6_2_who__7_family
    ,tc_6_2_who__8_adultnotfam as tc_6_2_who__8_adultnotfam
    ,tc_6_2_who__9_unkkid as tc_6_2_who__9_unkkid
    ,tc_6_2_who__10_unkadult as tc_6_2_who__10_unkadult
    ,tc_6_2_who__99_else as tc_6_2_who__99_else
    ,tc_6_2_how_often as tc_6_2_how_often
    ,tc_7 as tc_7
    ,null as tcfu_7
    ,tc_7_crit_a1 as tc_7_crit_a1
    ,tc_7_crit_a2 as tc_7_crit_a2
    ,tc_7_how_often as tc_7_how_often
    ,tc_8_1 as tc_8_1
    ,tc_8_1_less_than_1mo as tc_8_1_less_than_1mo
    ,tc_8_3 as tc_8_3
from rcap_tesic

union all 

select
    source_subject_id
    ,event_name
    ,null as tesi_c_1
    ,tcfu_1_1 as tcfu_1_1
    ,tcfu_1_1_crit_a1 as tc_1_1_crit_a1
    ,tcfu_1_1_crit_a2 as tc_1_1_crit_a2
    ,tcfu_1_1_how_often as tc_1_1_how_often
    ,null as tc_1_2
    ,tcfu_1_2 as tcfu_1_2
    ,tcfu_1_2_crit_a1 as tc_1_2_crit_a1
    ,tcfu_1_2_crit_a2 as tc_1_2_crit_a2
    ,tcfu_1_2_how_often as tc_1_2_how_often
    ,null as tc_1_3
    ,tcfu_1_3 as tcfu_1_3
    ,tcfu_1_3_crit_a1 as tc_1_3_crit_a1
    ,tcfu_1_3_crit_a2 as tc_1_3_crit_a2
    ,tcfu_1_3_how_often as tc_1_3_how_often
    ,null as tc_1_4
    ,tcfu_1_4 as tcfu_1_4
    ,tcfu_1_4_crit_a1 as tc_1_4_crit_a1
    ,tcfu_1_4_crit_a2 as tc_1_4_crit_a2
    ,tcfu_1_4_who__1_mother as tc_1_4_who__1_mother
    ,tcfu_1_4_who__2_father as tc_1_4_who__2_father
    ,tcfu_1_4_who__3_sibling as tc_1_4_who__3_sibling
    ,tcfu_1_4_who__4_grandparent as tc_1_4_who__4_grandparent
    ,tcfu_1_4_who__5_otherrelative as tc_1_4_who__5_otherrelative
    ,tcfu_1_4_who__6_kadult as tc_1_4_who__6_kadult
    ,tcfu_1_4_who__7_kkid as tc_1_4_who__7_kkid
    ,tcfu_1_4_who__8_else as tc_1_4_who__8_else
    ,tcfu_1_4_how_often as tc_1_4_how_often
    ,null as tc_1_5
    ,tcfu_1_5 as tcfu_1_5
    ,tcfu_1_5_crit_a1 as tc_1_5_crit_a1
    ,tcfu_1_5_crit_a2 as tc_1_5_crit_a2
    ,tcfu_1_5_how_often as tc_1_5_how_often
    ,null as tc_1_6
    ,tcfu_1_6 as tcfu_1_6
    ,tcfu_1_6_crit_a1 as tc_1_6_crit_a1
    ,tcfu_1_6_crit_a2 as tc_1_6_crit_a2
    ,tcfu_1_6_how_often as tc_1_6_how_often
    ,null as tc_2_1
    ,tcfu_2_1 as tcfu_2_1
    ,tcfu_2_1_crit_a1 as tc_2_1_crit_a1
    ,tcfu_2_1_crit_a2 as tc_2_1_crit_a2
    ,tcfu_2_1_who__1_mother as tc_2_1_who__1_mother
    ,tcfu_2_1_who__2_father as tc_2_1_who__2_father
    ,tcfu_2_1_who__3_sibling as tc_2_1_who__3_sibling
    ,tcfu_2_1_who__4_grandparent as tc_2_1_who__4_grandparent
    ,tcfu_2_1_who__5_otherrelative as tc_2_1_who__5_otherrelative
    ,tcfu_2_1_who__6_kadult as tc_2_1_who__6_kadult
    ,tcfu_2_1_who__7_unkadult as tc_2_1_who__7_unkadult
    ,tcfu_2_1_who__8_kkid as tc_2_1_who__8_kkid
    ,tcfu_2_1_who__9_unkkid as tc_2_1_who__9_unkkid
    ,tcfu_2_1_who__10_else as tc_2_1_who__10_else
    ,tcfu_2_1_how__1_hit_kick_bite as tc_2_1_how__1_hit_kick_bite
    ,tcfu_2_1_how__2_choke_smother as tc_2_1_how__2_choke_smother
    ,tcfu_2_1_how__3_burn as tc_2_1_how__3_burn
    ,tcfu_2_1_how__4_gun_knife as tc_2_1_how__4_gun_knife
    ,tcfu_2_1_how__5_bat_club as tc_2_1_how__5_bat_club
    ,tcfu_2_1_how__6_other as tc_2_1_how__6_other
    ,tcfu_2_1_how_often as tc_2_1_how_often
    ,null as tc_2_2
    ,tcfu_2_2 as tcfu_2_2
    ,tcfu_2_2_crit_a2 as tc_2_2_crit_a2
    ,tcfu_2_2_who__1_mother as tc_2_2_who__1_mother
    ,tcfu_2_2_who__2_father as tc_2_2_who__2_father
    ,tcfu_2_2_who__3_sibling as tc_2_2_who__3_sibling
    ,tcfu_2_2_who__4_grandparent as tc_2_2_who__4_grandparent
    ,tcfu_2_2_who__5_otherrelative as tc_2_2_who__5_otherrelative
    ,tcfu_2_2_who__6_kadult as tc_2_2_who__6_kadult
    ,tcfu_2_2_who__7_unkadult as tc_2_2_who__7_unkadult
    ,tcfu_2_2_who__8_kkid as tc_2_2_who__8_kkid
    ,tcfu_2_2_who__9_unkkid as tc_2_2_who__9_unkkid
    ,tcfu_2_2_who__10_else as tc_2_2_who__10_else
    ,tcfu_2_2_how__1_hit_kick_bite as tc_2_2_how__1_hit_kick_bite
    ,tcfu_2_2_how__2_choke_smother as tc_2_2_how__2_choke_smother
    ,tcfu_2_2_how__3_burn as tc_2_2_how__3_burn
    ,tcfu_2_2_how__4_gun_knife as tc_2_2_how__4_gun_knife
    ,tcfu_2_2_how__5_bat_club as tc_2_2_how__5_bat_club
    ,tcfu_2_2_how__6_other as tc_2_2_how__6_other
    ,tcfu_2_2_how_often as tc_2_2_how_often
    ,null as tc_2_3
    ,tcfu_2_3 as tcfu_2_3
    ,tcfu_2_3_crit_a2 as tc_2_3_crit_a2
    ,tcfu_2_3_how as tc_2_3_how
    ,tcfu_2_3_how_often as tc_2_3_how_often
    ,null as tc_2_4
    ,tcfu_2_4 as tcfu_2_4
    ,tcfu_2_4_crit_a2 as tc_2_4_crit_a2
    ,tcfu_2_4_who__1_mother as tc_2_4_who__1_mother
    ,tcfu_2_4_who__2_father as tc_2_4_who__2_father
    ,tcfu_2_4_who__3_sibling as tc_2_4_who__3_sibling
    ,tcfu_2_4_who__4_grandparent as tc_2_4_who__4_grandparent
    ,tcfu_2_4_who__5_otherrelative as tc_2_4_who__5_otherrelative
    ,tcfu_2_4_who__6_kadult as tc_2_4_who__6_kadult
    ,tcfu_2_4_who__7_unkadult as tc_2_4_who__7_unkadult
    ,tcfu_2_4_who__10_else as tc_2_4_who__10_else
    ,tcfu_2_4_how__1_none as tc_2_4_how__1_none
    ,tcfu_2_4_how__2_gun as tc_2_4_how__2_gun
    ,tcfu_2_4_how__3_knife as tc_2_4_how__3_knife
    ,tcfu_2_4_how__4_other as tc_2_4_how__4_other
    ,tcfu_2_4_how_often as tc_2_4_how_often
    ,null as tc_2_5
    ,tcfu_2_5 as tcfu_2_5
    ,tcfu_2_5_crit_a2 as tc_2_5_crit_a2
    ,tcfu_2_5_how_often as tc_2_5_how_often
    ,null as tc_3_1
    ,tcfu_3_1 as tcfu_3_1
    ,tcfu_3_1_crit_a2 as tc_3_1_crit_a2
    ,tcfu_3_1_who__1_mother as tc_3_1_who__1_mother
    ,tcfu_3_1_who__2_father as tc_3_1_who__2_father
    ,tcfu_3_1_who__3_sibling as tc_3_1_who__3_sibling
    ,tcfu_3_1_who__4_grandparent as tc_3_1_who__4_grandparent
    ,tcfu_3_1_who__5_otherrelative as tc_3_1_who__5_otherrelative
    ,tcfu_3_1_who__6_kadult as tc_3_1_who__6_kadult
    ,tcfu_3_1_who__7_unkadult as tc_3_1_who__7_unkadult
    ,tcfu_3_1_who__8_kkid as tc_3_1_who__8_kkid
    ,tcfu_3_1_who__9_unkkid as tc_3_1_who__9_unkkid
    ,tcfu_3_1_who__10_else as tc_3_1_who__10_else
    ,tcfu_3_1_how__1_hit_kick_bite as tc_3_1_how__1_hit_kick_bite
    ,tcfu_3_1_how__2_choke_smother as tc_3_1_how__2_choke_smother
    ,tcfu_3_1_how__3_burn as tc_3_1_how__3_burn
    ,tcfu_3_1_how__4_gun_knife as tc_3_1_how__4_gun_knife
    ,tcfu_3_1_how__5_bat_club as tc_3_1_how__5_bat_club
    ,tcfu_3_1_how__6_other as tc_3_1_how__6_other
    ,tcfu_3_1_how_often as tc_3_1_how_often
    ,null as tc_3_2
    ,tcfu_3_2 as tcfu_3_2
    ,tcfu_3_2_crit_a2 as tc_3_2_crit_a2
    ,tcfu_3_2_who__1_mother as tc_3_2_who__1_mother
    ,tcfu_3_2_who__2_father as tc_3_2_who__2_father
    ,tcfu_3_2_who__3_sibling as tc_3_2_who__3_sibling
    ,tcfu_3_2_who__4_grandparent as tc_3_2_who__4_grandparent
    ,tcfu_3_2_who__5_otherrelative as tc_3_2_who__5_otherrelative
    ,tcfu_3_2_who__6_kadult as tc_3_2_who__6_kadult
    ,tcfu_3_2_who__7_unkadult as tc_3_2_who__7_unkadult
    ,tcfu_3_2_who__8_kkid as tc_3_2_who__8_kkid
    ,tcfu_3_2_who__9_unkkid as tc_3_2_who__9_unkkid
    ,tcfu_3_2_who__10_else as tc_3_2_who__10_else
    ,tcfu_3_2_how__1_hit_kick_bite as tc_3_2_how__1_hit_kick_bite
    ,tcfu_3_2_how__2_choke_smother as tc_3_2_how__2_choke_smother
    ,tcfu_3_2_how__3_burn as tc_3_2_how__3_burn
    ,tcfu_3_2_how__4_gun_knife as tc_3_2_how__4_gun_knife
    ,tcfu_3_2_how__5_bat_club as tc_3_2_how__5_bat_club
    ,tcfu_3_2_how__6_other as tc_3_2_how__6_other
    ,tcfu_3_2_how_often as tc_3_2_how_often
    ,null as tc_3_3
    ,tcfu_3_3 as tcfu_3_3
    ,tcfu_3_3_crit_a2 as tc_3_3_crit_a2
    ,tcfu_3_3_who__1_mother as tc_3_3_who__1_mother
    ,tcfu_3_3_who__2_father as tc_3_3_who__2_father
    ,tcfu_3_3_who__3_sibling as tc_3_3_who__3_sibling
    ,tcfu_3_3_who__4_grandparent as tc_3_3_who__4_grandparent
    ,tcfu_3_3_who__5_otherrelative as tc_3_3_who__5_otherrelative
    ,tcfu_3_3_how_often as tc_3_3_how_often
    ,null as tc_4_1
    ,tcfu_4_1 as tcfu_4_1
    ,tcfu_4_1_crit_a2 as tc_4_1_crit_a2
    ,tcfu_4_1_who__1_mother as tc_4_1_who__1_mother
    ,tcfu_4_1_who__2_father as tc_4_1_who__2_father
    ,tcfu_4_1_who__3_sibling as tc_4_1_who__3_sibling
    ,tcfu_4_1_who__4_grandparent as tc_4_1_who__4_grandparent
    ,tcfu_4_1_who__5_otherrelative as tc_4_1_who__5_otherrelative
    ,tcfu_4_1_who__6_kadult as tc_4_1_who__6_kadult
    ,tcfu_4_1_who__7_unkadult as tc_4_1_who__7_unkadult
    ,tcfu_4_1_who__8_kkid as tc_4_1_who__8_kkid
    ,tcfu_4_1_who__9_unkkid as tc_4_1_who__9_unkkid
    ,tcfu_4_1_who__10_else as tc_4_1_who__10_else
    ,tcfu_4_1_how__1_hit_kick_bite as tc_4_1_how__1_hit_kick_bite
    ,tcfu_4_1_how__2_choke_smother as tc_4_1_how__2_choke_smother
    ,tcfu_4_1_how__3_burn as tc_4_1_how__3_burn
    ,tcfu_4_1_how__4_gun_knife as tc_4_1_how__4_gun_knife
    ,tcfu_4_1_how__5_bat_club as tc_4_1_how__5_bat_club
    ,tcfu_4_1_how__6_other as tc_4_1_how__6_other
    ,tcfu_4_1_how_often as tc_4_1_how_often
    ,null as tc_4_2
    ,tcfu_4_2 as tcfu_4_2
    ,tcfu_4_2_crit_a2 as tc_4_2_crit_a2
    ,tcfu_4_2_who__1_mother as tc_4_2_who__1_mother
    ,tcfu_4_2_who__2_father as tc_4_2_who__2_father
    ,tcfu_4_2_who__3_sibling as tc_4_2_who__3_sibling
    ,tcfu_4_2_who__4_grandparent as tc_4_2_who__4_grandparent
    ,tcfu_4_2_who__5_otherrelative as tc_4_2_who__5_otherrelative
    ,tcfu_4_2_who__6_kadult as tc_4_2_who__6_kadult
    ,tcfu_4_2_who__7_unkadult as tc_4_2_who__7_unkadult
    ,tcfu_4_2_who__8_kkid as tc_4_2_who__8_kkid
    ,tcfu_4_2_who__9_unkkid as tc_4_2_who__9_unkkid
    ,tcfu_4_2_who__10_else as tc_4_2_who__10_else
    ,tcfu_4_2_how__1_hit_kick_bite as tc_4_2_how__1_hit_kick_bite
    ,tcfu_4_2_how__2_choke_smother as tc_4_2_how__2_choke_smother
    ,tcfu_4_2_how__3_burn as tc_4_2_how__3_burn
    ,tcfu_4_2_how__4_gun_knife as tc_4_2_how__4_gun_knife
    ,tcfu_4_2_how__5_bat_club as tc_4_2_how__5_bat_club
    ,tcfu_4_2_how__6_other as tc_4_2_how__6_other
    ,tcfu_4_2_how_often as tc_4_2_how_often
    ,null as tc_4_3
    ,tcfu_4_3 as tcfu_4_3
    ,tcfu_4_3_crit_a2 as tc_4_3_crit_a2
    ,tcfu_4_3_how_often as tc_4_3_how_often
    ,null as tc_5
    ,tcfu_5 as tcfu_5
    ,tcfu_5_crit_a2 as tc_5_crit_a2
    ,tcfu_5_who__1_mother as tc_5_who__1_mother
    ,tcfu_5_who__2_father as tc_5_who__2_father
    ,tcfu_5_who__3_sibling as tc_5_who__3_sibling
    ,tcfu_5_who__4_grandparent as tc_5_who__4_grandparent
    ,tcfu_5_who__5_otherrelative as tc_5_who__5_otherrelative
    ,tcfu_5_who__6_kadult as tc_5_who__6_kadult
    ,tcfu_5_who__7_unkadult as tc_5_who__7_unkadult
    ,tcfu_5_who__8_kkid as tc_5_who__8_kkid
    ,tcfu_5_who__9_unkkid as tc_5_who__9_unkkid
    ,tcfu_5_who__10_else as tc_5_who__10_else
    ,tcfu_5_how__1_fondled_genitals as tc_5_how__1_fondled_genitals
    ,tcfu_5_how__2_oralchild_genit as tc_5_how__2_oralchild_genit
    ,tcfu_5_how__3_childoral_genit as tc_5_how__3_childoral_genit
    ,tcfu_5_how__4_digitpenetrate as tc_5_how__4_digitpenetrate
    ,tcfu_5_how__5_intercourse as tc_5_how__5_intercourse
    ,tcfu_5_how__6_porno_filming as tc_5_how__6_porno_filming
    ,tcfu_5_how__7_prostitution as tc_5_how__7_prostitution
    ,tcfu_5_how__8_other as tc_5_how__8_other
    ,tcfu_5_how_often as tc_5_how_often
    ,null as tc_6_1
    ,tcfu_6_1 as tcfu_6_1
    ,tcfu_6_1_crit_a2 as tc_6_1_crit_a2
    ,tcfu_6_1_who__1_older_boy as tc_6_1_who__1_older_boy
    ,tcfu_6_1_who__2_younger_boy as tc_6_1_who__2_younger_boy
    ,tcfu_6_1_who__3_boy_same_grade as tc_6_1_who__3_boy_same_grade
    ,tcfu_6_1_who__4_older_girl as tc_6_1_who__4_older_girl
    ,tcfu_6_1_who__5_younger_girl as tc_6_1_who__5_younger_girl
    ,tcfu_6_1_who__6_girl_same_grade as tc_6_1_who__6_girl_same_grade
    ,tcfu_6_1_who__7_family as tc_6_1_who__7_family
    ,tcfu_6_1_who__8_adultnotfam as tc_6_1_who__8_adultnotfam
    ,tcfu_6_1_who__9_unkkid as tc_6_1_who__9_unkkid
    ,tcfu_6_1_who__10_unkadult as tc_6_1_who__10_unkadult
    ,tcfu_6_1_who__99_else as tc_6_1_who__99_else
    ,null as tc_6_2
    ,tcfu_6_2 as tcfu_6_2
    ,tcfu_6_2_who__1_older_boy as tc_6_2_who__1_older_boy
    ,tcfu_6_2_who__2_younger_boy as tc_6_2_who__2_younger_boy
    ,tcfu_6_2_who__3_boy_same_grade as tc_6_2_who__3_boy_same_grade
    ,tcfu_6_2_who__4_older_girl as tc_6_2_who__4_older_girl
    ,tcfu_6_2_who__5_younger_girl as tc_6_2_who__5_younger_girl
    ,tcfu_6_2_who__6_girl_same_grade as tc_6_2_who__6_girl_same_grade
    ,tcfu_6_2_who__7_family as tc_6_2_who__7_family
    ,tcfu_6_2_who__8_adultnotfam as tc_6_2_who__8_adultnotfam
    ,tcfu_6_2_who__9_unkkid as tc_6_2_who__9_unkkid
    ,tcfu_6_2_who__10_unkadult as tc_6_2_who__10_unkadult
    ,tcfu_6_2_who__99_else as tc_6_2_who__99_else
    ,tcfu_6_2_how_often as tc_6_2_how_often
    ,null as tc_7
    ,tcfu_7 as tcfu_7
    ,tcfu_7_crit_a1 as tc_7_crit_a1
    ,tcfu_7_crit_a2 as tc_7_crit_a2
    ,tcfu_7_how_often as tc_7_how_often
    ,tcfu_8_1 as tc_8_1
    ,tcfu_8_1_less_1mo as tc_8_1_less_than_1mo
    ,tcfu_8_3 as tc_8_3
from rcap_tesic_followup;

