---- Reference (and metdata) script for VT

select
    map.dw_variable_name as dw_variable_name
    ,met.field_label
    ,met.select_choices_or_calculations
from rcap_metadata met
inner join rcap_field_variable_map map
    on map.original_field_name = met.field_name;