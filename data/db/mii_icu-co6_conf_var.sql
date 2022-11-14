drop database thesis;

create database thesis;
\c thesis

create schema mii_copra;


-- mii kerndatensatz icu
CREATE TABLE mii_copra.mii_icu(
  profile_name varchar not null,
  profile_type varchar not null,
  profile_unit varchar,
  profile_status varchar not null
);

-- insert into table of mii icu modul
copy mii_copra.mii_icu from '/home/ahodelin/git_repos/CostaPinto/data/csv/mii_icu.csv' WITH DELIMITER E';' header csv;

-- copra original
CREATE TABLE mii_copra.co6_config_variables_original(
  id bigint,
  EntryTime varchar,
  EntryUser varchar,
  Name varchar,
  Description varchar,
  Unit varchar,
  CO6_Config_VariableTypes_ID int,
  Parent bigint,
  deleted varchar,
  LOINC varchar,
  PersistenceAssembly varchar,
  PersistenceClass varchar,
  "Timestamp" varchar,
  DisplayName varchar
);

-- insert into table of copra config variables
copy mii_copra.co6_config_variables_original  from '/home/ahodelin/git_repos/CostaPinto/data/csv/CO6_Config_Variables_original.csv' WITH DELIMITER E';' header csv;

-- insert into table co6 config variable types
create table mii_copra.co6_config_variable_types(
  id varchar,
  Name varchar, 
  TableName varchar,
  StorageType varchar
);
-- insert into table of copra config variable types
copy mii_copra.co6_config_variable_types  from '/home/ahodelin/git_repos/CostaPinto/data/csv/CO6_Config_Variable_Types.csv' WITH DELIMITER E';' header csv;


-- copra config variables
CREATE TABLE mii_copra.co6_config_variables(
  conf_var_id bigint not null,
  conf_var_name varchar not null,
  conf_var_description varchar,
  conf_var_unit varchar
);

insert into mii_copra.co6_config_variables
  select   
    id, 
    name, 
    description, 
    unit
  from mii_copra.co6_config_variables_original ccv
  where parent in (1, 20)
  and unit notnull 
  and co6_config_variabletypes_id in (1, 2, 3, 5, 6, 12, 18)
  and (name !~* 'therapie|hausar|wertsach|einweisen|anamn|brief|angeho|betreu|mail|efon|versic|stras|rede|chrift|fax|atzi|geber|nym|geburt')
  and deleted like 'NULL'
  order by name
;

drop table if exists mii_copra.co6_config_variables_original;


-- mapping
CREATE TABLE mii_copra.mapping_mii_co6_tmp(
  profile_name varchar,
  conf_var_name varchar,
  conf_var_description varchar,
  conf_var_id bigint,
  conf_var_unit varchar,
  profile_unit varchar,
  matching int not null default 0
);

-- mapping
CREATE TABLE mii_copra.mapping_mii_co6(
  profile_name varchar,
  conf_var_name varchar,
  conf_var_description varchar,
  conf_var_id bigint,
  conf_var_unit varchar,
  profile_unit varchar,
  matching int not null default 0
);


\c postgres
-- to run this script
-- /usr/local/pgtde/bin/psql -p 5433 -d postgres -U clinicuser -f /home/ahodelin/git_repos/CostaPinto/data/db/mii_icu-co6_conf_var.sql
