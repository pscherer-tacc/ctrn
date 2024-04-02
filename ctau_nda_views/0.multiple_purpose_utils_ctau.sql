---- This file contains utility tools (helper views, functions, etc) that are
---- utilized by multiple views. 


-- month_between function
-- calculates the difference between two dates in month (adjusted for NDA sumission standards)
-- (https://stackoverflow.com/questions/11012629/count-months-between-two-timestamp-on-postgresql)

create function months_between (sch timestamp, dob timestamp)
returns integer
as
$$
    select 
        ((extract('years' from $1)::int - extract('years' from $2)::int) * 12) 
        + extract('month' from $1)::int - extract('month' from $2)::int
        + case
            when (extract('day' from $1)::int - extract('day' from $2)::int) < 0 then -1
            when 
                (extract('day' from $1)::int - extract('day' from $2)::int) >= 0
                and (extract('day' from $1)::int - extract('day' from $2)::int) < 16 
                then 0
            else 1
        end
    ;
$$
language sql
immutable
returns null on null input;


-- a helper view based on rcap_ctau_scheduling_form
create view rcap_ctau_scheduling_form_agg_view 
as 
select 
	sch1.source_subject_id
	,sch1.event_name
	, case
		when sch1.event_name like 'baseline%' then sch1.sched_base_complete_date
		when sch1.event_name like 'one_month%' then sch2.sched_1mo_complete_date
		when sch1.event_name like 'six_month%' then sch2.sched_6mo_complete_date
		when sch1.event_name like 'one_year%' then sch2.sched_1yr_date
		when sch1.event_name like '18_month%' then sch2.sched_18mo_complete_date
		when sch1.event_name like '24_month%' then sch2.sched_2yr_complete_date
	end as interview_date
	,sch1.sched_base_complete_date
	,sch1.sched_1mo_complete_date
	,sch1.sched_6mo_complete_date
	,sch1.sched_1yr_date
	,sch1.sched_18mo_complete_date
	,sch1.sched_2yr_complete_date
from rcap_ctau_scheduling_form sch1
inner join rcap_ctau_scheduling_form sch2
	on sch2.source_subject_id = sch1.source_subject_id
	and sch2.event_name like 'baseline%'
order by sch1.source_subject_id, sch1.event_name;