select
    source_subject_id,
    event_name,
    case
        when tc_1_1_worst = '1' then '1_1'
        when tc_1_2_worst = '1' then '1_2'
        when tc_1_3_worst = '1' then '1_3'
        when tc_1_4_worst = '1' then '1_4'
        when tc_1_5_worst = '1' then '1_5'
        when tc_1_6_worst = '1' then '1_6'
        when tc_2_1_worst = '1' then '2_1'
        when tc_2_2_worst = '1' then '2_2'
        when tc_2_3_worst = '1' then '2_3'
        when tc_2_4_worst = '1' then '2_4'
        when tc_2_5_worst = '1' then '2_5'
        when tc_3_1_worst = '1' then '3_1'
        when tc_3_2_worst = '1' then '3_2'
        when tc_3_3_worst = '1' then '3_3'
        when tc_4_1_worst = '1' then '4_1'
        when tc_4_2_worst = '1' then '4_2'
        when tc_4_3_worst = '1' then '4_3'
        when tc_5_worst = '1' then '5'
        when tc_7_worst = '1' then '7'
        else null 
    end as worst_trauma,
    case
        when tc_1_1_most_recent = '1' then '1_1'
        when tc_1_2_most_recent = '1' then '1_2'
        when tc_1_3_most_recent = '1' then '1_3'
        when tc_1_4_most_recent = '1' then '1_4'
        when tc_1_5_most_recent = '1' then '1_5'
        when tc_1_6_most_recent = '1' then '1_6'
        when tc_2_1_most_recent = '1' then '2_1'
        when tc_2_2_most_recent = '1' then '2_2'
        when tc_2_3_most_recent = '1' then '2_3'
        when tc_2_4_most_recent = '1' then '2_4'
        when tc_2_5_most_recent = '1' then '2_5'
        when tc_3_1_most_recent = '1' then '3_1'
        when tc_3_2_most_recent = '1' then '3_2'
        when tc_3_3_most_recent = '1' then '3_3'
        when tc_4_1_most_recent = '1' then '4_1'
        when tc_4_2_most_recent = '1' then '4_2'
        when tc_4_3_most_recent = '1' then '4_3'
        when tc_5_most_recent = '1' then '5'
        when tc_7_most_recent = '1' then '7'
    end as most_recent_trauma
from view_tesic_union;
