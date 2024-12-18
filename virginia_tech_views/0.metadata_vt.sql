---- Reference (and metdata) view for VT
--- Name of the view: view_vt_metadata

-- Query the data from the view
select * from view_vt_metadata;

-- The body of the view
create or replace view view_vt_metadata
as
select
    map.dw_variable_name as dw_variable_name
    ,met.field_label
    ,met.select_choices_or_calculations
from rcap_metadata met
inner join rcap_field_variable_map map
    on map.original_field_name = met.field_name;