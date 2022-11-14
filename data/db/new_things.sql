-- profile_name;profile_type;profile_unit;profile_status;mapped;ops;loinc;ieee;snomed
--insert into mii_copra.mii_icu 
  values
  ('Puls', 'Observation', null, 'Active', true, null, null, '149514', '8499008');

 
-- NO 'Sauerstoffsaettigung Im Blut Preduktal Durch Pulsoxymetrie'
-- NO 'Dauer Extrakorporaler Gasaustausch'
select 
  ccv.id conf_var_id, 
  ccv.parent conf_var_parent_id, 
  ccvt."name" conf_var_parent_name, 
  'Dauer Extrakorporaler Gasaustausch' profile_name, 
  ccv.name conf_var_name , 
  ccv.description conf_var_description, 
  ccv.unit conf_var_unit ,
  null profile_unit,
  ccv.co6_config_variabletypes_id config_var_types_id,
  ccvt2.name conf_var_types_name,
  --null loinc,
  --null url_loinc,
  --'8499008' snomed,
  --'https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008' url_snomed,
  0 matching
from mii_copra.co6_config_variables ccv 
join mii_copra.co6_config_variables ccvt 
  on ccvt.id = ccv.parent
join mii_copra.co6_config_variable_types ccvt2 
  on ccvt2.id = ccv.co6_config_variabletypes_id::varchar 
where ccv."name" ~* 'ecmo|gas' or ccv.description ~* 'ecmo|gas'; --and ccv.parent = 1 and ccv.co6_config_variabletypes_id = 6;

-- 101408



--insert into mii_copra.mapping_mii_co6_raw 
select 
  ccv.id conf_var_id, 
  ccv.parent conf_var_parent_id, 
  ccvt."name" conf_var_parent_name, 
  'Puls' profile_name, 
  ccv.name conf_var_name , 
  ccv.description conf_var_description, 
  ccv.unit conf_var_unit ,
  null profile_unit,
  ccv.co6_config_variabletypes_id config_var_types_id,
  ccvt2.name conf_var_types_name,
  null loinc,
  null url_loinc,
  '8499008' snomed,
  'https://bioportal.bioontology.org/ontologies/SNOMEDCT?p=classes&conceptid=8499008' url_snomed,
  0 matching
from mii_copra.co6_config_variables ccv 
join mii_copra.co6_config_variables ccvt 
  on ccvt.id = ccv.parent
join mii_copra.co6_config_variable_types ccvt2 
  on ccvt2.id = ccv.co6_config_variabletypes_id::varchar 
where ccv."name" ~* '^puls|^pls|_puls' and ccv.parent = 1 and ccv.co6_config_variabletypes_id = 6;

select * from mii_copra.mapping_mii_co6_raw mmcr where conf_var_id in (1268, 102011);

--insert into mii_copra.mapping_mii_co6_1_filter 
select * from mii_copra.mapping_mii_co6_raw mmcr where conf_var_id in (1268, 102011);
update mii_copra.mapping_mii_co6_raw 
  set quantities = 68448
  where conf_var_id = 1268;

--------------------------------------
/*create table mii_copra.mii_icu_new(
  profile_name varchar primary key,
  profile_type varchar not null,
  profile_status varchar not null,
  profile_datum varchar
);
truncate mii_copra.mii_icu_new;
copy 
  mii_copra.mii_icu_new
from '/home/abel/git_repos/CostaPinto/data/csv/mii_icu_new.csv' with delimiter E';' csv;

create or replace view mii_copra.v_mii_icu_new_old
as
select n.profile_name new_profile, o.profile_name old_profile 
from mii_copra.mii_icu_new n
full outer join mii_copra.mii_icu o 
  on o.profile_name = n.profile_name
order by new_profile
*/
 
 select distinct profile_name from mii_copra.snomed s
 where profile_name not in (select profile_name from mii_copra.mii_icu mi);

select * from mii_copra.mapping_mii_co6_1_filter mmcf where profile_name = 'Linksventrikulaerer Schlagvolumenindex';

update mii_copra.ieee
  set profile_name = 'Linksventrikulaeres Schlagvolumenindex'
where profile_name = 'Linksventrikulaerer Schlagvolumenindex';

select * from mii_copra.v_mii_icu_new_old;



