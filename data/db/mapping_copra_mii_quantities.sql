select 
  count(cdd.val) quantity_in_decimal, 
  conf_var_name,
  conf_var_id
from mii_copra.mapping_mii_co6_raw mmcr 
join copra.co6_data_decimal_6_3 cdd 
  on cdd.varid = mmcr.conf_var_id
where mmcr.conf_var_types_id = 6
and not cdd.deleted
and mmcr.conf_var_parent_id in (1, 20)
and cdd.flagcurrent
group by conf_var_name, conf_var_id
order by quantity_in_decimal desc;


select 
  count(cds.val) quantity_in_string, 
  conf_var_name,
  conf_var_id 
from mii_copra.mapping_mii_co6_raw mmcr 
join copra.co6_data_string cds 
  on cds.varid = mmcr.conf_var_id
where mmcr.conf_var_types_id = 3
and not cds.deleted
and cds.flagcurrent
and mmcr.conf_var_parent_id in (1, 20)
group by conf_var_name, conf_var_id
order by quantity_in_string desc;


select 
  count(cmp.id) quantity_in_medic_pressure, 
  conf_var_name,
  conf_var_id 
from mii_copra.mapping_mii_co6_raw mmcr 
join copra.co6_medic_pressure cmp  
  on cmp.varid = mmcr.conf_var_id
where mmcr.conf_var_types_id = 12
and not cmp.deleted
and cmp.flagcurrent
and mmcr.conf_var_parent_id in (1, 20)
group by conf_var_name, conf_var_id
order by quantity_in_medic_pressure desc;
