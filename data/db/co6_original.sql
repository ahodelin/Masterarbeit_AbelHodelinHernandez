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