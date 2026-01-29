---- TESIC VT View
--- Name of the view: view_vt_tesic (Important: it depends on the view_tesic_union helper view)
-- 12/11/2025 Vlad moved the script for the view_tesic_union to the "general_views/"" directory
--- Currently requires manual curation; needs future enhancement to remove incomplete duplicate records. There should be one record per event per participant.

-- Query the data from the view
select * from view_vt_tesic
where interview_date is not null;

-- The body of the view (Important: it depends on the view_tesic_union helper view)
create or replace view view_vt_tesic
as
select
---    dem.dem_guid
    sa1.subject_id

    ,case -- Attention! Experimental field for flagging duplicate records.
        when tesic_u_duplicates.duplicate is null then 'No'
        else tesic_u_duplicates.duplicate
    end as potential_duplicate

    -- Attention! Experimental field: completness_score !
    ,tesic_u.tc_complete + pfhc.hc_complete as completeness_score

	,case
		when tesic_u.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when tesic_u.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when tesic_u.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date		--- Used for calculations and curation; remove before sharing
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
    ,tesic_u.tc_1_1
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
 ---   ,tesic_u.tc_8_1
    ,tesic_u.tc_8_1_less_than_1mo
 ---   ,tesic_u.tc_8_3
	,tesic_u.tc_8_3_less_than_1mo
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

left join -- Attention! Experimental join for flagging duplicate records.
    (
        select source_subject_id, event_name, 'Yes' as duplicate
        from view_tesic_union
        group by source_subject_id, event_name
        having count(*) > 1
    ) tesic_u_duplicates
    on tesic_u_duplicates.source_subject_id = tesic_u.source_subject_id
    and tesic_u_duplicates.event_name = tesic_u.event_name

order by 
    case
        when tesic_u_duplicates.duplicate is null then 0
        else 1
    end
    ,sa1.subject_id
    ,case 
        when tesic_u.event_name like 'baseline%' then 1
        when tesic_u.event_name like 'six_month%' then 2
        when tesic_u.event_name like 'one_year%' then 3
        when tesic_u.event_name like '18_month%' then 4
        when tesic_u.event_name like '24_month%' then 5
    end
    ,(tesic_u.tc_complete + pfhc.hc_complete) desc
;











-----------------------------------------
select
    sa1.subject_id,
    tesic_u.source_subject_id,
    tesic_u.event_name,
    tesic_u.tc_complete + pfhc.hc_complete as completeness_score,
    case 
        when tesic_u_duplicates.duplicate is null then 'No'
        else tesic_u_duplicates.duplicate
    end as potential_duplicate
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

left join -- Attention! Experimental join for flagging duplicate records.
    (
        select source_subject_id, event_name, 'Yes' as duplicate
        from view_tesic_union
        group by source_subject_id, event_name
        having count(*) > 1
    ) tesic_u_duplicates
    on tesic_u_duplicates.source_subject_id = tesic_u.source_subject_id
    and tesic_u_duplicates.event_name = tesic_u.event_name

order by 
    case
        when tesic_u_duplicates.duplicate is null then 0
        else 1
    end
    ,sa1.subject_id
    ,case 
        when tesic_u.event_name like 'baseline%' then 1
        when tesic_u.event_name like 'six_month%' then 2
        when tesic_u.event_name like 'one_year%' then 3
        when tesic_u.event_name like '18_month%' then 4
        when tesic_u.event_name like '24_month%' then 5
    end
    ,(tesic_u.tc_complete + pfhc.hc_complete) desc
;



--------

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

left join 
    (
        select source_subject_id, event_name, 'Yes' as duplicate
        from view_tesic_union
        group by source_subject_id, event_name
        having count(*) > 1
    ) tesic_u_duplicates
    on tesic_u_duplicates.source_subject_id = tesic_u.source_subject_id
    and tesic_u_duplicates.event_name = tesic_u.event_name

where sa1.subject_id = 23 --1343

order by sa1.subject_id, (tesic_u.tc_complete + pfhc.hc_complete) desc,
    case 
        when tesic_u.event_name like 'baseline%' then 1
        when tesic_u.event_name like 'six_month%' then 2
        when tesic_u.event_name like 'one_year%' then 3
        when tesic_u.event_name like '18_month%' then 4
        when tesic_u.event_name like '24_month' then 5
    end
limit 100;

