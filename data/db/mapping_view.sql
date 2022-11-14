drop view mii_copra.v_mapping_mii_co6;
create or replace view mii_copra.v_mapping_mii_co6
as
  select 
    conf_var_id,
    v.parent conf_var_parent_id,
    p.name conf_var_parent_name,
    m.profile_name, 
    conf_var_name, 
    conf_var_description, 
    conf_var_unit, profile_unit, 
    v.co6_config_variabletypes_id conf_var_types_id,
    vt.name conf_var_types_name,
    l.loinc, 
    url_loinc, 
    snomed, 
    url_snomed,
    m.matching
  from mii_copra.mapping_mii_co6 m
  left join mii_copra.loinc l 
    on l.profile_name = m.profile_name 
  left join mii_copra.snomed s 
    on s.profile_name = m.profile_name
  join mii_copra.co6_config_variables v 
    on v.id = m.conf_var_id 
  join mii_copra.co6_config_variable_types vt 
    on vt.id::bigint = v.co6_config_variabletypes_id
  join mii_copra.co6_config_variables p 
    on v.parent  = p.id 
order by m.profile_name, conf_var_id;

copy (select * from mii_copra.v_mapping_mii_co6) to '/home/abel/git_repos/CostaPinto/data/csv/mapping.csv' WITH DELIMITER E';' header csv;

select 
 * into mii_copra.mapping_mii_co6_raw
from mii_copra.v_mapping_mii_co6 vmmc;

select
  * 
from mii_copra.mapping_mii_co6_raw ;

select 
  distinct conf_var_types_name 
from mii_copra.mapping_mii_co6_raw;

select 
  distinct conf_var_parent_name  
from mii_copra.mapping_mii_co6_raw;