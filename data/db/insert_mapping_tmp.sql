-- insert in temprary table of mapping

\c thesis

insert into mii_copra.mapping_mii_co6_tmp
select 
  profile_name,
  conf_var_name,
  conf_var_description,
  conf_var_id,
  conf_var_unit,
  profile_unit,
  0 matching
from mii_copra.mii_icu mi
left join mii_copra.co6_config_variables ccv
  on ccv.conf_var_name ~* profile_name 
  or ccv.conf_var_description ~* profile_name
order by profile_name, conf_var_description; 

\c postgres
