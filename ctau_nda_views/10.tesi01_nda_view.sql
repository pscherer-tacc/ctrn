----- tesi01 NDA View

-- The function that coverts '-99' values to 2 
create function nda_m99_to_2_converter (val VARCHAR)
returns integer
as
$$
    select case
            when val='-99' then 2
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
	,tesip.source_subject_id -- only for validation; DELETE before submission
	,tesip.event_name -- only for validation; DELETE before submission
	,case
		when tesip.event_name like 'baseline%' then to_char(sched_main.sched_base_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'one_month%' then to_char(sched_main.sched_1mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'six_month%' then to_char(sched_main.sched_6mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like 'one_year%' then to_char(sched_main.sched_1yr_complete_date, 'mm/dd/yyyy')
		--when tesip.event_name like '18_month%' then to_char(sched_main.sched_18mo_complete_date, 'mm/dd/yyyy')
		when tesip.event_name like '24_month%' then to_char(sched_main.sched_2yr_complete_date, 'mm/dd/yyyy')
	end as interview_date
	,case 
		when tesip.event_name like 'baseline%' then nda_months_between(sched_main.sched_base_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'one_month%' then nda_months_between(sched_main.sched_1mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'six_month%' then nda_months_between(sched_main.sched_6mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like 'one_year%' then nda_months_between(sched_main.sched_1yr_complete_date, dem.dem_ch_dob)
		--when tesip.event_name like '18_month%' then nda_months_between(sched_main.sched_18mo_complete_date, dem.dem_ch_dob)
		when tesip.event_name like '24_month%' then nda_months_between(sched_main.sched_2yr_complete_date, dem.dem_ch_dob)
	end as interview_age
	,case
		when tesip.event_name like 'baseline%' then sched.sched_base_complete
		when tesip.event_name like 'one_month%' then sched.sched_1mo_complete
		when tesip.event_name like 'six_month%' then sched.sched_6mo_complete
		when tesip.event_name like 'one_year%' then sched.sched_1yr_complete
		--when tesip.event_name like '18_month%' then sched.sched_18mo_complete
		when tesip.event_name like '24_month%' then sched.sched_2yr_complete
	end as complete -- only for validation; DELETE before submission
    ,case 
        when pfhc.hc_sex_birth_cert='1' then 'F'
        when pfhc.hc_sex_birth_cert='2' then 'M'
        else null
    end as sex
    ,case
        when pfhp.hp_parent1_relationship='0' or pfhp.hp_parent1_relationship is null then -999
        when pfhp.hp_parent1_relationship='1' then 89 -- Biological parent
        when pfhp.hp_parent1_relationship='2' then 92 -- Adoptive parent
        when pfhp.hp_parent1_relationship='3' then 93 -- Foster parent
        when pfhp.hp_parent1_relationship='4' then 91 -- Stepparent
        when pfhp.hp_parent1_relationship='5' then 90 -- Other legal guardian
    end as relationship -- ??? Carefully check all values
    ,tesip.event_name -- ??? So, SHOULD WE OMIT THIS FIELD?
    ,nda_m99_to_2_converter(tp_1_1_stem) as tesi_1
    --,tp_1_1_accident_type as tesi_2 -- omitted 
    --,tp_1_1_victim as tesi_3 -- omitted
    ,nda_m99_to_2_converter(tp_1_1_any_deaths) as tesi_4
    ,tp_1_1_age_first as tesi_5
    ,tp_1_1_age_last as tesi_6
    ,tp_1_1_age_most_stressful as tesi_7
    ,nda_m99_to_2_converter(tp_1_1_strongly_affected) as tesi_8
    ,nda_m99_to_2_converter(tp_1_2_stem) as tesi_9
    --,tp_1_2_accident_type as tesi_10 -- omitted
    --,tp_1_2_victim as tesi_11 -- omitted
    ,nda_m99_to_2_converter(tp_1_2_any_deaths) as tesi_12
    ,tp_1_2_age_first as tesi_13
    ,tp_1_2_age_last as tesi_14
    ,tp_1_2_age_most_stressful as tesi_15
    ,nda_m99_to_2_converter(tp_1_2_strongly_affected) as tesi_16
    ,nda_m99_to_2_converter(tp_1_3_stem) as tesi_17
    --,tp_1_3_disaster_type as tesi_18 -- omitted
    ,nda_m99_to_2_converter(tp_1_3_any_deaths) as tesi_20
    ,tp_1_3_age_first as tesi_21
    ,tp_1_3_age_last as tesi_22
    ,tp_1_3_age_most_stressful as tesi_23
    ,nda_m99_to_2_converter(tp_1_3_strongly_affected) as tesi_24
    ,nda_m99_to_2_converter(tp_1_4a_stem) as tesi_25
    --,tp_1_4a_victim as tesi_26 -- omitted 
    ,tp_1_4a_age_first as tesi_27
    ,tp_1_4a_age_last as tesi_28
    ,tp_1_4a_age_most_stressful as tesi_29
    ,nda_m99_to_2_converter(tp_1_4a_strongly_affected) as tesi_30
    ,nda_m99_to_2_converter(tp_1_4b_stem) as tesi_31
    --,tp_1_4b_victim as tesi_32 -- omitted
    ,tp_1_4b_age_first as tesi_33
    ,tp_1_4b_age_last as tesi_34
    ,tp_1_4b_age_most_stressful as tesi_35
    ,nda_m99_to_2_converter(tp_1_4b_strongly_affected) as tesi_37
    ,case
        when tp_1_4b_death_reason__0_natural='1' then 1
        when tp_1_4b_death_reason__1_illness='1' then 2
        when tp_1_4b_death_reason__2_accident='1' then 3
        when tp_1_4b_death_reason__3_violence='1' then 4
        when tp_1_4b_death_reason__4_unknown='1' then 5
        else null
    end as tesi_36
    ,nda_m99_to_2_converter(tp_1_5_stem) as tesi_38
    --,tp_1_5_describe as tesi_39 -- omitted
    ,tp_1_5_age_first as tesi_40
    ,tp_1_5_age_last as tesi_41
    ,tp_1_5_age_most_stressful as tesi_42
    ,nda_m99_to_2_converter(tp_1_5_strongly_affected) as tesi_43
    ,nda_m99_to_2_converter(tp_1_6_stem) as tesi_44
    --,tp_1_6_relationship as tesi_45 -- omitted
    ,tp_1_6_age_first as tesi_46
    ,tp_1_6_age_last as tesi_47
    ,tp_1_6_age_most_stressful as tesi_48
    ,nda_m99_to_2_converter(tp_1_6_strongly_affected) as tesi_49
    ,nda_m99_to_2_converter(tp_1_7_stem) as tesi_50
    --,tp_1_7_relationship as tesi_51 -- omitted
    ,tp_1_7_age_first as tesi_52
    ,tp_1_7_age_last as tesi_53
    ,tp_1_7_age_most_stressful as tesi_54
    ,nda_m99_to_2_converter(tp_1_7_strongly_affected) as tesi_55
    ,nda_m99_to_2_converter(tp_2_1_stem) as tesi_56
    --,tp_2_1_relationship as tesi_57 -- omitted
    ,nda_m99_to_2_converter(tp_2_1_weapon) as tesi_58
    --,tp_2_1_weapon_type -- omitted
    ,tp_2_1_age_first as tesi_59
    ,tp_2_1_age_last as tesi_60
    ,tp_2_1_age_most_stressful as tesi_61
    ,nda_m99_to_2_converter(tp_2_1_strongly_affected) as tesi_62
    ,nda_m99_to_2_converter(tp_2_2_stem) as tesi_63
    --,tp_2_2_relationship as tesi_64 -- omitted
    ,nda_m99_to_2_converter(tp_2_2_weapon) as tesi_65
    --,tp_2_2_weapon_text -- omitted
    ,tp_2_2_age_first as tesi_66
    ,tp_2_2_age_last as tesi_67
    ,tp_2_2_age_most_stressful as tesi_68
    ,nda_m99_to_2_converter(tp_2_2_strongly_affected) as tesi_69
    ,nda_m99_to_2_converter(tp_2_3_stem) as tesi_70
    --,tp_2_3_relationship -- omitted
    ,nda_m99_to_2_converter(tp_2_3_weapon) as tesi_71
    --,tp_2_3_weapon_text -- omitted
    ,tp_2_3_age_first as tesi_72
    ,tp_2_3_age_last as tesi_73
    ,tp_2_3_age_most_stressful as tesi_74
    ,nda_m99_to_2_converter(tp_2_3_strongly_affected) as tesi_75
    ,nda_m99_to_2_converter(tp_2_4_stem) as tesi_76
    --,tp_2_4_relationship as tesi_77 -- omitted
    --,tp_2_4_kidnapper	tesi_78 -- omitted
    ,tp_2_4_age_first as tesi_79
    ,tp_2_4_age_last as tesi_80
    ,tp_2_4_age_most_stressful as tesi_81
    ,nda_m99_to_2_converter(tp_2_4_strongly_affected) as tesi_82
    ,nda_m99_to_2_converter(tp_2_5_stem) as tesi_83
    --,tp_2_5_describe -- omitted
    ,tp_2_5_age_first as tesi_84
    ,tp_2_5_age_last as tesi_85
    ,tp_2_5_age_most_stressful as tesi_86
    ,nda_m99_to_2_converter(tp_2_5_seriously_hurt) as tesi_87
    ,nda_m99_to_2_converter(tp_2_5_strongly_affected) as tesi_88
    ,nda_m99_to_2_converter(tp_3_1_stem) as tesi_89
    --,tp_3_1_relationship as tesi_90 -- omitted
    ,nda_m99_to_2_converter(tp_3_1_weapon) as tesi_91
    --,tp_3_1_weapon_text as tesi_92
    ,tp_3_1_age_first as tesi_93
    ,tp_3_1_age_last as tesi_94
    ,tp_3_1_age_most_stressful as tesi_95
    ,nda_m99_to_2_converter(tp_3_1_strongly_affected) as tesi_96
    ,nda_m99_to_2_converter(tp_3_2_stem) as tesi_97
    --,tp_3_2_relationship as tesi_98 -- omitted
    ,nda_m99_to_2_converter(tp_3_2_weapon) as tesi_99
    --,tp_3_2_weapon_text -- omitted
    ,tp_3_2_age_first as tesi_100
    ,tp_3_2_age_last as tesi_101
    ,tp_3_2_age_most_stressful as tesi_102
    ,nda_m99_to_2_converter(tp_3_2_child_present) as tesi_103
    ,nda_m99_to_2_converter(tp_3_2_strongly_affected) as tesi_104
    ,nda_m99_to_2_converter(tp_3_3_stem) as tesi_105
    --,tp_3_3_relationship as tesi_106 -- omitted
    ,tp_3_3_age_first as tesi_108
    ,tp_3_3_age_last as tesi_109
    ,tp_3_3_age_most_stressful as tesi_110
    ,nda_m99_to_2_converter(tp_3_3_witness_arrest) as tesi_111
    ,nda_m99_to_2_converter(tp_3_3_strongly_affected) as tesi_112
    ,nda_m99_to_2_converter(tp_4_1_stem) as tesi_113
    --,tp_4_1_describe -- omitted
    --,tp_4_1_relationship -- omitted
    ,nda_m99_to_2_converter(tp_4_1_weapon) as tesi_114
    --,tp_4_1_weapon_text -- omitted	
    --,tp_4_1_where as tesi_115 -- omitted
    ,tp_4_1_age_first as tesi_116
    ,tp_4_1_age_last as tesi_117
    ,tp_4_1_age_most_stressful as tesi_118
    ,nda_m99_to_2_converter(tp_4_1_witness) as tesi_119
    ,nda_m99_to_2_converter(tp_4_1_strongly_affected) as tesi_120
    ,nda_m99_to_2_converter(tp_4_2_stem) as tesi_121
    ,tp_4_2_describe -- omitted
    ,tp_4_2_age_first as tesi_122
    ,tp_4_2_age_last as tesi_123
    ,tp_4_2_age_most_stressful as tesi_124
    ,nda_m99_to_2_converter(tp_4_2_strongly_affected) as tesi_125
    ,nda_m99_to_2_converter(tp_4_3_stem) as tesi_126
    --,tp_4_3_describe -- omitted
    ,tp_4_3_age_first as tesi_127
    ,tp_4_3_age_last as tesi_128
    ,tp_4_3_age_most_stressful as tesi_129
    ,nda_m99_to_2_converter(tp_4_3_strongly_affected) as tesi_130
    ,nda_m99_to_2_converter(tp_5_1_stem) as tesi_131
    --,tp_5_1_relationship as tesi_132 -- omitted
    ,nda_m99_to_2_converter(tp_5_1_violence) as tesi_133
    --,nda_m99_to_2_converter(tp_5_1_weapon) -- omitted
    --, tp_5_1_weapon_text -- omitted
    ,tp_5_1_age_first as tesi_134
    ,tp_5_1_age_last as tesi_135
    ,tp_5_1_age_most_stressful as tesi_136
    --,nda_m99_to_2_converter(tp_5_1_witness) -- omitted
    ,nda_m99_to_2_converter(tp_5_1_strongly_affected) as tesi_137
    ,nda_m99_to_2_converter(tp_5_2_stem) as tesi_138
    --,tp_5_2_relationship as tesi_139 -- omitted
    --,tp_5_2_aggressor -- omitted
    ,nda_m99_to_2_converter(tp_5_2_violence) as tesi_140
    --,nda_m99_to_2_converter(tp_5_2_weapon) -- omitted
    --,tp_5_2_weapon_text -- omitted
    ,tp_5_2_age_first as tesi_141
    ,tp_5_2_age_last as tesi_142
    ,tp_5_2_age_most_stressful as tesi_143
    ,nda_m99_to_2_converter(tp_5_2_strongly_affected) as tesi_144
    ,nda_m99_to_2_converter(tp_6_1_stem) as tesi_145
    --,tp_6_1_relationship as tesi_146 -- omitted
    ,tp_6_1_age_first as tesi_147
    ,tp_6_1_age_last as tesi_148
    ,tp_6_1_age_most_stressful as tesi_149
    ,nda_m99_to_2_converter(tp_6_1_strongly_affected) as tesi_150
    ,nda_m99_to_2_converter(tp_6_2_stem) as tesi_151
    --,tp_6_2_describe -- omitted
    ,tp_6_2_age_first as tesi_152
    ,tp_6_2_age_last as tesi_153
    ,tp_6_2_age_most_stressful as tesi_154
    ,nda_m99_to_2_converter(tp_6_2_strongly_affected) as tesi_155
    ,nda_m99_to_2_converter(tp_7_1_stem) as tesi_156
    --,tp_7_1_describe as tesi_157 -- omitted
    ,tp_7_1_age_first as tesi_158
    ,tp_7_1_age_last as tesi_159
    ,tp_7_1_age_most_stressful as tesi_160
    ,nda_m99_to_2_converter(tp_7_1_strongly_affected) as tesi_161
from rcap_tesip tesip -- Attention! rcap_tesip is not a CTAU table.
inner join rcap_ctau_scheduling_form sched -- to keep CTAU participants only
	on sched.sched_ctrn_id = tesip.source_subject_id
	and sched.event_name like 'baseline%'
inner join subject_alias sa1
    on sa1.source_subject_id = tesip.source_subject_id
    and sa1.project_id = 696
    and sa1.id_type = 'redcap'
left join rcap_scheduling_form sched_main 
    on sched_main.source_subject_id = tesip.source_subject_id 
left join rcap_demographics dem
    on dem.source_subject_id = tesip.source_subject_id
left join rcap_pfh_child pfhc 
    on pfhc.source_subject_id = tesip.source_subject_id
left join rcap_pfh_parent pfhp -- ??? Doublecheck the fields on which the tables are joined
    on pfhp.source_subject_id = tesip.source_subject_id 
order by sa1.subject_id;







--------------------------------------- For Checks
select
    ( tp_1_4b_death_reason__0_natural::int 
        + tp_1_4b_death_reason__1_illness::int 
        + tp_1_4b_death_reason__2_accident::int 
        + tp_1_4b_death_reason__3_violence::int 
        + tp_1_4b_death_reason__4_unknown::int )
    ,tp_1_4b_death_reason__0_natural
    ,tp_1_4b_death_reason__1_illness
    ,tp_1_4b_death_reason__2_accident
    ,tp_1_4b_death_reason__3_violence
    ,tp_1_4b_death_reason__4_unknown
from rcap_tesip
where 
    ( tp_1_4b_death_reason__0_natural::int
        + tp_1_4b_death_reason__1_illness::int 
        + tp_1_4b_death_reason__2_accident::int 
        + tp_1_4b_death_reason__3_violence::int 
        + tp_1_4b_death_reason__4_unknown::int ) >= 2;


update rcap_field_variable_map
set dw_variable_name='tp_1_2_stem'
where export_field_name in ('tesip_1_2_stem', 'tesip_1_2_stem_sp');