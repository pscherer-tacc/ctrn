CREATE VIEW ctau_scheduling_form_view 
AS 
SELECT
    source_subject_id
    ,event_name
    ,MAX(sched_ctrn_id) OVER (PARTITION BY source_subject_id) as sched_ctrn_id
    ,sched_base_complete
    ,sched_base_complete_date
    ,sched_1yr_date
    ,sched_2yr_complete_date
FROM rcap_ctau_scheduling_form;
