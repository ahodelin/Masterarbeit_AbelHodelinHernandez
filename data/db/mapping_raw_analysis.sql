drop table if exists mii_copra.value_decimal;
create table mii_copra.value_decimal(
  quantity_decimal bigint,
  conf_var_name varchar,
  conf_var_id bigint
);

copy mii_copra.value_decimal from '/home/abel/git_repos/CostaPinto/data/csv/quantity_in_decimal_patient_case.csv' WITH DELIMITER E';' header csv;

drop table if exists mii_copra.value_string;
create table mii_copra.value_string(
  quantity_string bigint,
  conf_var_name varchar,
  conf_var_id bigint
);

copy mii_copra.value_string from '/home/abel/git_repos/CostaPinto/data/csv/quantity_in_string_patient_case.csv' WITH DELIMITER E';' header csv;

drop table if exists mii_copra.value_medic_pressure;
create table mii_copra.value_medic_pressure(
  quantity_medic_pressure bigint,
  conf_var_name varchar,
  conf_var_id bigint
);

copy mii_copra.value_medic_pressure from '/home/abel/git_repos/CostaPinto/data/csv/quantity_in_medic_pressure_patient_case.csv' WITH DELIMITER E';' header csv;


alter table mii_copra.mapping_mii_co6_raw 
  add column quantities bigint;
  
update mii_copra.mapping_mii_co6_raw mr
  set quantities = vd.quantity_decimal
from mii_copra.value_decimal vd
where mr.conf_var_id = vd.conf_var_id;

update mii_copra.mapping_mii_co6_raw mr
  set quantities = vs.quantity_string
from mii_copra.value_string vs
where mr.conf_var_id = vs.conf_var_id;


update mii_copra.mapping_mii_co6_raw mr
  set quantities = vmp.quantity_medic_pressure
from mii_copra.value_medic_pressure vmp
where mr.conf_var_id = vmp.conf_var_id;

drop table mii_copra.value_medic_pressure;
drop table mii_copra.value_string ;
drop table mii_copra.value_decimal ;

--------------------------------------------------------
-- Analyse

-- quantity of values

select count(*) quantity, 'null' variables
from mii_copra.mapping_mii_co6_raw mmcr
where quantities isnull
  union 
select count(*) quantity, '< 1000' variables
from mii_copra.mapping_mii_co6_raw mm
where quantities < 1000
  union
select count(*), '>= 1000' variables
from mii_copra.mapping_mii_co6_raw mmcr
where quantities notnull  
or quantities >= 1000
order by quantity desc;

select 
  distinct conf_var_types_name type_no_decimal_string_midic_pressure 
from mii_copra.mapping_mii_co6_raw mmcr 
where conf_var_types_id not in (6, 3, 12);

select 
  distinct conf_var_parent_name parent_no_patient_case
from mii_copra.mapping_mii_co6_raw mmcr 
where conf_var_parent_id not in (1, 20);

-- unit null
copy(
select 
  distinct conf_var_id id, 
  conf_var_name name
from mii_copra.mapping_mii_co6_raw mmcr 
where conf_var_unit isnull 
and profile_unit notnull
and quantities notnull 
and quantities >= 1000
order by conf_var_id
) to '/home/abel/git_repos/CostaPinto/data/csv/variable_no_units.csv' WITH DELIMITER E';' header csv;


select 
  distinct conf_var_id id, 
  conf_var_name name,
  conf_var_unit 
from mii_copra.mapping_mii_co6_raw mmcr 
where conf_var_unit isnull 
and profile_unit notnull
and quantities notnull 
and quantities >= 1000
order by conf_var_id;


select 
  count(profile_name) quantity,
  mapped
from mii_copra.mii_icu mi 
group by mapped;

select count(distinct conf_var_id)
from mii_copra.mapping_mii_co6_raw mmcr;

select count(distinct id) from mii_copra.co6_config_variables ccv;

select count(distinct conf_var_id) from mii_copra.mapping_mii_co6_raw mmcr where quantities notnull;

select count(distinct conf_var_id) from mii_copra.mapping_mii_co6_raw mmcr where quantities isnull;

select count(distinct conf_var_id) from mii_copra.mapping_mii_co6_raw mmcr where quantities >= 1000;

select count(distinct profile_name) from mii_copra.mapping_mii_co6_raw mmcr;

select profile_name from mii_copra.mii_icu mi 
where profile_name not in (select distinct profile_name from mii_copra.mapping_mii_co6_raw mmcr)
and mapped ;

select distinct profile_name, profile_unit, loinc, snomed from mii_copra.mapping_mii_co6_1_filter mmcf order by profile_name;

select * from mii_copra.co6_config_variables ccv;

copy (
select * from mii_copra.mapping_mii_co6_1_filter mmcf order by profile_name
) to '/home/abel/git_repos/CostaPinto/data/csv/mapping_mii_co6_1_filter.csv' WITH DELIMITER E';' header csv;

/*
select 
  distinct
  conf_var_id,
  conf_var_name,
  conf_var_description,
  conf_var_types_name,
  conf_var_parent_name,
  quantities 
  into mii_copra.conf_var_no_for_analysis
from mii_copra.mapping_mii_co6_raw mmcr 
where conf_var_name ~* 'score'
or conf_var_description ~* 'score'
or quantities isnull 
or quantities < 1000
order by conf_var_id ;

select mmcr.* into mii_copra.mapping_mii_co6_1_filter from mii_copra.mapping_mii_co6_raw mmcr
left join mii_copra.conf_var_no_for_analysis na
on na.conf_var_id = mmcr.conf_var_id 
where na.conf_var_id isnull
order by profile_name ;
;

select 
  distinct conf_var_name,
  profile_name,
  conf_var_unit,
  profile_unit 
from mii_copra.mapping_mii_co6_raw mmcr
where profile_unit notnull 
and conf_var_unit notnull
and (profile_unit ~* conf_var_unit
  or conf_var_unit ~* profile_unit) 
*/