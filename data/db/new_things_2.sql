create table mii_copra.quantities_conf_var(
  quantities bigint,
  id_conf_var bigint not null,
  name_conf_var varchar not null,
  description_conf_var varchar
);

copy 
  mii_copra.quantities_conf_var 
from '/home/abel/git_repos/CostaPinto/data/csv/variables_more_than_1000_values_decimal.csv'
with delimiter E';' header csv;


create or replace view mii_copra.v_copra_not_units
as
select conf_var_id, conf_var_name, conf_var_description, conf_var_unit 
from mii_copra.mapping_mii_co6_1_filter mmcf 
where conf_var_unit isnull;

select * from mii_copra.v_copra_not_units;

select * from mii_copra.v_not_in_copra; 
   



copy (
select * from mii_copra.v_not_in_copra)
to '/home/abel/git_repos/CostaPinto/data/csv/not_in_copra.csv' with delimiter E';' header csv;

copy (
select * from mii_copra.mapping_mii_co6_1_filter mmcf order by profile_name 
) to '/home/abel/git_repos/CostaPinto/data/csv/mapping_mii_co6_1_filter.csv' with delimiter E';' header csv;

copy (
select conf_var_id, conf_var_name, conf_var_description, conf_var_unit 
from mii_copra.mapping_mii_co6_1_filter mmcf 
where conf_var_unit isnull
) to '/home/abel/git_repos/CostaPinto/data/csv/no_units_in_copra.csv' with delimiter E';' header csv;

create or replace view mii_copra.v_not_in_copra
as
select profile_name, 0 mapped from mii_copra.mii_icu_new where profile_name not in (select profile_name from mii_copra.mapping_mii_co6_1_filter mmcf);



------------------------------------------------------------------
update mii_copra.mapping_mii_co6_1_filter
set conf_var_unit = 'mmol/L' where conf_var_name = 'NEV_CRRT_ES_Multi_CalciumFiltrat';

update mii_copra.co6_config_variables 
set unit = 'mmol/L' where name = 'NEV_CRRT_ES_Multi_CalciumFiltrat';
----------

update mii_copra.mapping_mii_co6_1_filter
set conf_var_unit = 'mm[Hg]' where conf_var_name = 'IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole';

update mii_copra.co6_config_variables 
set unit = 'mm[Hg]' where name = 'IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole';



select * from mii_copra.mapping_mii_co6_1_filter mmcf where conf_var_name = 'IABP_CARDIOSAVE_MS_Systole_Mittel_Diastole';


create table mii_copra.mii_icu_used(
  id_profile serial primary key,
  profile varchar not null unique,
  typ varchar not null
);

create table mii_copra.mii_icu_used_tmp(
  --id_profile serial primary key,
  profile varchar not null unique,
  typ varchar not null
);

truncate mii_copra.mii_icu_used;
copy
  mii_copra.mii_icu_used_tmp
from '/home/abel/git_repos/CostaPinto/data/csv/mii_icu_standard'
with delimiter E';' csv;

insert into mii_copra.mii_icu_used
select row_number() over (), profile, typ  from mii_copra.mii_icu_used_tmp;

select profile, typ from mii_copra.mii_icu_used miu 
where profile not in (select profile_name from mii_copra.mii_icu mi);

drop view mii_copra.v_profiles_matching;
--create view mii_copra.v_profiles_matching
--as
select distinct
  miu.id_profile,
  miu.profile standard,   
  mi.profile_name "matched",
  --mi.profile_type,
  miu.typ typ_standard,
  mi.profile_unit,
  mi.loinc,
  mi.snomed,  
  null iee,
  mi.matching matching_to_control,
  case 
  	when mi.profile_name isnull then 0
  	else 1
  end mathching
  into mii_copra.mii_icu_used_all_info 
from mii_copra.mapping_mii_co6_1_filter mi 
right join mii_copra.mii_icu_used miu 
  on profile_name = profile
;


update mii_copra.mapping_mii_co6_1_filter  
  set profile_name = 'Pulmonalarterieller wedge Blutdruck' where profile_name = 'Pulmonalarterieller Wedge Druck';

select profile_name, profile_type from mii_copra.mii_icu min2;
select distinct profile_name from mii_copra.mapping_mii_co6_1_filter mmcf order by profile_name;

update mii_copra.mii_icu_used_all_info 
set profile_unit = '1'
where id_profile = 29;


select * from mii_copra.v_profiles_matching;

select count(standard) Anzahl, typ_standard typ from mii_copra.v_profiles_matching
group by typ_standard order by Anzahl desc;

create or replace view mii_copra.v_profile_codesystems
as
select 
  count(id_profile) "Anzahl", 
  'LOINC' "Codesystem"
from mii_copra.mii_icu_used_all_info miuai
where loinc notnull
  union 
select 
  count(id_profile) "Anzahl", 
  'SNOMED-CT' "Codesystem"
from mii_copra.mii_icu_used_all_info miuai
where snomed notnull
  union 
select 
  count(id_profile) "Anzahl", 
  'IEEE' "Codesystem"
from mii_copra.mii_icu_used_all_info miuai
where ieee notnull
  union 
select 
  count(id_profile),
  'Gesamt'
from mii_copra.mii_icu_used_all_info
  union
select 
  count(id_profile),
  'no Codesystem'
from mii_copra.mii_icu_used_all_info 
where loinc isnull and snomed isnull and ieee isnull
order by "Anzahl"
;

create or replace view mii_copra.v_profile_no_codesystem
as
select 
  standard, typ_standard  
from mii_copra.mii_icu_used_all_info 
where loinc isnull and snomed isnull and ieee isnull
order by standard;

create or replace view mii_copra.v_observations_units
as
select 
  count(id_profile) "Anzahl",
  case 
  	when profile_unit notnull then 'unit'
  	else 'not unit'
 end "Einheit"
from mii_copra.mii_icu_used_all_info miuai
where typ_standard = 'Observation'
group by "Einheit";

--create or replace view mii_copra.v_orbservations_no_units
--as
select 
  *
from mii_copra.mii_icu_used_all_info miuai
where typ_standard = 'Observation'
and profile_unit isnull
;


select 
  distinct conf_var_id
from mii_copra.mapping_mii_co6_1_filter mmcf
where profile_name in (select standard from mii_copra.mii_icu_used_all_info miuai);


SELECT * FROM mii_copra.mapping_mii_co6_1_filter mmcf;
alter table mii_copra.mapping_mii_co6_1_filter 
  add column profile_type varchar default 'Observation';

select * from mii_copra.mii_icu mi;

alter table mii_copra.mapping_mii_co6_1_filter 
rename to mapping_mii_copra;

copy(
  select 
    --table_name, 
    column_name "Spalte", 
    case 
      when data_type = 'character varying' then 'varchar'
      else data_type
    end "Datentyp",
    '... z.B. ...' "Information"
  from information_schema."columns" where table_schema = 'mii_copra' and table_name like 'mapping_mii_copra'
) to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/data/csv/mapping_structure.csv' delimiter E';' csv header;


select * from mii_copra.mii_icu mi where snomed = '250874002';


/*
copy(
select pa.patid, pr.systolic, pr.mean, pr.diastolic, pr.datetimeto from copra.co6_medic_pressure pr
join copra.co6_medic_data_patient pa
  on pr.parent_id = pa.id
)to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/data/fhir/blood_pressure/blood_pressure_generic_data.csv' delimiter E';' csv;
*/



select 
  distinct mi.standard, mi.ieee 
from mii_copra.mapping_mii_copra mmc 
join mii_copra.mii_icu_used_all_info mi
  on mi."matched" = mmc.profile_name 
where mmc.profile_name isnull
;

select 
  mmc.profile_name, mi.ieee 
from mii_copra.mapping_mii_copra mmc 
join mii_copra.mii_icu_used_all_info mi
  on mi.standard = mmc.profile_name  
;


update mii_copra.mapping_mii_copra mmc
  set ieee = mi.ieee
from mii_copra.mii_icu_used_all_info mi
where mi.standard = mmc.profile_name
;


alter table mii_copra.mapping_mii_copra 
  rename to mapping_mii_copra_old;
 
select * from mii_copra.mapping_mii_copra_old mmco limit 1;

select 
  conf_var_id, 
  conf_var_parent_id, 
  conf_var_parent_name, 
  profile_name, 
  conf_var_name,
  conf_var_description,
  conf_var_unit,
  profile_unit,
  conf_var_types_id,
  conf_var_types_name,
  loinc,
  snomed,
  ieee,
  null::boolean matching_valide,
  quantities,
  profile_type
  into mii_copra.mapping_mii_co6
from mii_copra.mapping_mii_copra_old mmco; 

select * from mii_copra.mapping_mii_co6 mmc;



select * into mii_copra.mapping_mii_co6_to_transfer from mii_copra.mapping_mii_co6 mmc where conf_var_id not in (
select conf_var_id
from mii_copra.mapping_mii_co6 mmc
where profile_unit notnull 
and conf_var_unit notnull
and upper(conf_var_unit) <> upper(profile_unit)
and profile_unit not in ('Cel', 'mm[Hg]')
and conf_var_unit !~ 'H2O|AZ|1')
and profile_name not in ('Puls', 
  'Koerpertemperatur Blut', 
  'Koerpertemperatur Generisch', 
  'Koerpertemperatur nasal', 
  'Koerpertemperatur rektal', 
  'Koerpertemperatur Speiseroehre',
  'Koerpertemperatur Trommelfell')
and not (conf_var_unit isnull and profile_unit ~ 'dy|mm') 
order by profile_name ;
--order by conf_var_id ) as t;


select count(distinct conf_var_id) from mii_copra.mapping_mii_co6_to_transfer; 

copy 
  mii_copra.mapping_mii_co6_to_transfer
to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/data/csv/mapping_mii_co6_to_transfer.csv'
delimiter E';' csv header;

copy 
  mii_copra.mapping_mii_co6_to_transfer_medic_pressure
to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/data/csv/mapping_mii_co6_to_transfer_medic_pressure.csv'
delimiter E';' csv header;


-- drop table mii_copra.mapping_mii_co6_to_transfer_medic_pressure;


select 
  *,
  null loinc_diastolic,
  null loinc_mean,
  null loinc_systolic,
  null snomed_diastolic,
  null snomed_mean,
  null snomed_systolic,
  null ieee_diastolic,
  null ieee_mean,
  null ieee_systolic
  into mii_copra.mapping_mii_co6_to_transfer_medic_pressure
from mii_copra.mapping_mii_co6_to_transfer mmctt
where profile_name ~* 'Druck'
and profile_name !~* 'veno|positi|beatm|exsp|intrak|wedg'
and conf_var_types_name ~ 'Medic'
;

select * from mii_copra.co6_config_variables ccv where description ~* 'linksatrial';

select * from mii_copra.mapping_mii_co6_to_transfer_medic_pressure;

update mii_copra.mapping_mii_co6_to_transfer_medic_pressure
  set loinc_systolic = '8480-6',
      loinc_mean = '8478-0',
      loinc_diastolic = '8462-4',
      ieee_systolic = '150045',
      ieee_mean = '150047',
      ieee_diastolic = '150046'
where profile_name like 'Pulmo%'

copy 
(
  select 
    distinct profile_name
  from mii_copra.mapping_mii_co6_to_transfer mmctt
  where conf_var_types_name not like 'De%'
  and conf_var_types_name not like 'Stri%'
  --and profile_name not like 'Arteriel%'
  order by profile_name
)
to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/vital_to_fhir/pressure.csv'
delimiter E';' csv;


copy(
  select 
    distinct profile_name,
    case 
    	when conf_var_types_id = 3 then 'co6\_data\_string'
    	else 'co6\_data\_decimal\_6\_3'
    end "table", 
    profile_unit
  from mii_copra.mapping_mii_co6_to_transfer mmctt
  where conf_var_types_name like 'De%'
  or conf_var_types_name like 'Stri%'
  and profile_name not like 'Arteriel%'
  order by profile_name
)to '/home/abel/git_repos/Thesis_AbelHodelinHernandez/vital_to_fhir/decimal.csv'delimiter E';' csv;


SELECT mmctt.profile_type AS "resourceType",
    mmctt.profile_name || cast(cdd.id as varchar) AS id,
    'http://snomed.info/sct'::text AS system_snomed,
    mmctt.snomed AS code_snomed,
    'http://loinc.org'::text AS system_loinc,
    mmctt.loinc AS code_loinc,
    'urn:iso:std:iso:11073:10101'::text AS system_ieee,
    mmctt.ieee AS code_ieee,
    cmdp.patid AS reference,
    cdd.datetimeto AS start_end,
    cdd.val AS value,
    'http://unitsofmeasure.org'::text AS system_unit,
    mmctt.profile_unit AS code_unit
   FROM copra.co6_data_decimal_6_3 cdd
     JOIN copra.mapping_mii_co6_to_transfer mmctt ON mmctt.conf_var_id = cdd.varid
     JOIN copra.co6_medic_data_patient cmdp ON cmdp.id = cdd.parent_id
  WHERE NOT cdd.deleted AND NOT cmdp.deleted AND cdd.validated AND cdd.flagcurrent;
  
 
 
 select * from mii_copra.mapping_mii_co6_to_transfer mmctt;

select generate_series(1, 37) into mii_copra.fhir_profile;
 
select distinct on (profile_name) profile_name, generate_series(1,37)  from mii_copra.mapping_mii_co6_to_transfer mmctt order by profile_name ;

drop table mii_copra.fhir_profile_observations;
alter table mii_copra.fhir_profile

create table mii_copra.fhir_profile_observations(
  profile_id serial primary key,
  profile_name varchar unique not null,
  category_coding_system text, --url
  category_coding_code varchar, --name
  code_coding_system_snomed text,
  code_coding_code_snomed varchar,
  code_coding_system_loinc text,
  code_coding_code_loinc varchar,
  code_coding_system_ieee text,
  code_coding_code_ieee varchar,
  valuequantity_system text,
  valuequantity_code varchar,
  device_reference text,
  ------
  code_systolic_coding_system_snomed text,
  code_systolic_coding_code_snomed varchar,
  code_systolic_coding_system_loinc text,
  code_systolic_coding_code_loinc varchar,
  code_systolic_coding_system_ieee text,
  code_systolic_coding_code_ieee varchar,
  -----
  code_mean_coding_system_snomed text,
  code_mean_coding_code_snomed varchar,
  code_mean_coding_system_loinc text,
  code_mean_coding_code_loinc varchar,
  code_mean_coding_system_ieee text,
  code_mean_coding_code_ieee varchar,
  ------
  code_diastolic_coding_system_snomed text,
  code_diastolic_coding_code_snomed varchar,
  code_diastolic_coding_system_loinc text,
  code_diastolic_coding_code_loinc varchar,
  code_diastolic_coding_system_ieee text,
  code_diastolic_coding_code_ieee varchar
);

alter table mii_copra.fhir_profile_observations 
add column meta_prolile text; --url

insert into mii_copra.fhir_profile_observations (profile_name)
select distinct profile_name from mii_copra.mapping_mii_co6_to_transfer order by profile_name;

update mii_copra.fhir_profile_observations fpo
set code_coding_system_snomed = sct.url_snomed, 
code_coding_code_snomed = sct.snomed 
from mii_copra.snomed sct
where sct.profile_name = fpo.profile_name;

update mii_copra.fhir_profile_observations fpo
set code_coding_system_loinc = loi.url_loinc, 
code_coding_code_loinc = loi.loinc 
from mii_copra.loinc loi
where loi.profile_name = fpo.profile_name;

update mii_copra.fhir_profile_observations fpo
set code_coding_code_ieee = ie.ieee 
from mii_copra.ieee ie
where ie.profile_name = fpo.profile_name;

update mii_copra.fhir_profile_observations fpo
set valuequantity_code = mtt.profile_unit
from mii_copra.mapping_mii_co6_to_transfer mtt  
where mtt.profile_name = fpo.profile_name;

update mii_copra.fhir_profile_observations 
set valuequantity_code = '%',
valuequantity_system = 'http://unitsofmeasure.org'
where profile_name like 'Sauer%fff%eing%';


update mii_copra.fhir_profile_observations 
set valuequantity_system = 'http://unitsofmeasure.org'
where valuequantity_code notnull;


update mii_copra.fhir_profile_observations 
set code_coding_system_ieee = 'urn:iso:std:iso:11073:10101'
where code_coding_code_ieee notnull;


update mii_copra.fhir_profile_observations 
set device_reference = 'DeviceMetric/...';

--Arterieller Druck--
select * from mii_copra.fhir_profile_observations fpo where profile_id = 1;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Arterieller-Druck',
    device_reference = 'DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id'    
where profile_id = 1;

-- Atemfrequenz
select * from mii_copra.fhir_profile_observations fpo where profile_id = 2;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemfrequenz',
    device_reference = null
where profile_id = 2;

-- Atemzugvolumen-Waehrend-Beatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 3;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Atemzugvolumen-Waehrend-Beatmung',
    code_coding_system_snomed = 'http://snomed.info/sct',
    code_coding_code_snomed = '250874002',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc  = '76222-9',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '151980',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 3;


-- Beatmungsvolumen-Pro-Minute-Machineller-Beatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 4;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/SBeatmungsvolumen-Pro-Minute-Machineller-Beatmung',
    code_coding_system_snomed = 'http://snomed.info/sct',
    code_coding_code_snomed = '426102006',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc  = '76009-0',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '152004',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 4;

-- Blutdruck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 5;

update mii_copra.fhir_profile_observations 
set  code_coding_system_snomed = category_coding_system,
     code_coding_code_snomed = category_coding_code
where profile_id = 5;

update mii_copra.fhir_profile_observations 
set code_coding_system_snomed = null,
    code_coding_code_snomed = null
where profile_id = 5;


update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck',
    -----
    code_systolic_coding_system_snomed  = 'http://snomed.info/sct',
    code_systolic_coding_code_snomed  = '271649006',
    code_systolic_coding_system_loinc  = 'http://loinc.org',
    code_systolic_coding_code_loinc  = '8480-6',
    code_systolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_systolic_coding_code_ieee  = '150017',
    -----
    code_mean_coding_system_snomed  = 'http://snomed.info/sct',
    code_mean_coding_code_snomed  = '6797001',
    code_mean_coding_system_loinc  = 'http://loinc.org',
    code_mean_coding_code_loinc  = '8478-0',
    code_mean_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_mean_coding_code_ieee  = '150019',
    -------
    code_diastolic_coding_system_snomed  = 'http://snomed.info/sct',
    code_diastolic_coding_code_snomed  = '271650006',
    code_diastolic_coding_system_loinc  = 'http://loinc.org',
    code_diastolic_coding_code_loinc  = '8462-4',
    code_diastolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_diastolic_coding_code_ieee  = '150018',
    device_reference = null
where profile_id = 5;


-- Blutdruck Generisch
select * from mii_copra.fhir_profile_observations fpo where profile_id = 6;

update mii_copra.fhir_profile_observations 
set  code_coding_system_snomed = category_coding_system,
     code_coding_code_snomed = category_coding_code
where profile_id = 5;

update mii_copra.fhir_profile_observations 
set code_coding_system_snomed = null,
    code_coding_code_snomed = null
where profile_id = 5;


update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutdruck-Generisch',
    -----
    code_systolic_coding_system_snomed  = 'http://snomed.info/sct',
    code_systolic_coding_code_snomed  = '271649006',
    code_systolic_coding_system_loinc  = 'http://loinc.org',
    code_systolic_coding_code_loinc  = '8480-6',
    code_systolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_systolic_coding_code_ieee  = '150017',
    -----
    code_mean_coding_system_snomed  = 'http://snomed.info/sct',
    code_mean_coding_code_snomed  = '6797001',
    code_mean_coding_system_loinc  = 'http://loinc.org',
    code_mean_coding_code_loinc  = '8478-0',
    code_mean_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_mean_coding_code_ieee  = '150019',
    -------
    code_diastolic_coding_system_snomed  = 'http://snomed.info/sct',
    code_diastolic_coding_code_snomed  = '271650006',
    code_diastolic_coding_system_loinc  = 'http://loinc.org',
    code_diastolic_coding_code_loinc  = '8462-4',
    code_diastolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_diastolic_coding_code_ieee  = '150018',
    device_reference = null
where profile_id = 6;


-- Blutfluss durch cardiovasculäres Gerät
select * from mii_copra.fhir_profile_observations fpo where profile_id = 7;

update mii_copra.fhir_profile_observations 
set profile_name = 'Blutfluss durch cardiovasculäres Gerät',
    category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Blutfluss-Cardiovasculaeres-Geraet',
    code_coding_system_snomed = 'http://snomed.info/sct',
    code_coding_code_snomed = '444479000',
    device_reference = 'DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id'
where profile_id = 7;


-- Druckdifferenz Beatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 8;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Druckdifferenz-Beatmung',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76154-4',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '152720',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 8;


-- Einstellung-Einatmungszeit-Beatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 9;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Einstellung-Einatmungszeit-Beatmung',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76334-2',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '16929632',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_Beatmung_id'
where profile_id = 9;


-- Exspiratorischer Gasfluss
select * from mii_copra.fhir_profile_observations fpo where profile_id = 10;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Gasfluss',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '60792-9',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '151944',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 10;


-- Exspiratorischer Sauerstoffpartialdruck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 11;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Exspiratorischer-Sauerstoffpartialdruck',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '3147-6',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '250775008',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee  = '153132',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 11;


-- Herzfrequenz
select * from mii_copra.fhir_profile_observations fpo where profile_id = 12;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzfrequenz',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '8867-4',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '364075005',
    device_reference = null
where profile_id = 12;


-- Herzzeitvolumen
select * from mii_copra.fhir_profile_observations fpo where profile_id = 13;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Herzzeitvolumen',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '8741-1',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '82799009',
    code_coding_system_ieee  = 'urn:std:iso:11073:10101',
    code_coding_code_ieee  = '150276',
    device_reference = null
where profile_id = 13;


-- Inspiratorischer Gasfluss
select * from mii_copra.fhir_profile_observations fpo where profile_id = 14;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Eingestellter-Inspiratorischer-Gasfluss',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76275-7',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_Beatmung_id'
where profile_id = 14;


-- Intrakranieller Druck (ICP)
select * from mii_copra.fhir_profile_observations fpo where profile_id = 15;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Intrakranieller-Druck-ICP',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '60956-0',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '250844005',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '153608',
    device_reference = null
where profile_id = 15;


-- Ionisiertes Kalzium aus Nierenersatzverfahren
select * from mii_copra.fhir_profile_observations fpo where profile_id = 16;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Ionisiertes-Kalzium-Nierenersatzverfahren',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '83064-6',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Gemessene_Parameter_extrakorporale_Verfahren_id'
where profile_id = 16;


-- Koerpergewicht
select * from mii_copra.fhir_profile_observations fpo where profile_id = 17;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergewicht',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '29463-7',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '27113001',
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = null
where profile_id = 17;



-- Koerpergroesse
select * from mii_copra.fhir_profile_observations fpo where profile_id = 18;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpergroesse',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '8302-2',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '1153637007',
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = null
where profile_id = 18;


-- Koerpertemperatur Kern
select * from mii_copra.fhir_profile_observations fpo where profile_id = 19;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Koerpertemperatur-Kern',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '8329-5',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '276885007',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '150368',
    device_reference = null
where profile_id = 19;


-- Kopfumfang
select * from mii_copra.fhir_profile_observations fpo where profile_id = 20;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Kopfumfang',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '9843-4',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = null
where profile_id = 20;



-- Linksatrialer Druck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 21;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksatrialer-Druck',    
    code_coding_system_snomed = 'http://snomed.info/sct',
    code_coding_code_snomed = '75367002',
    -----    
    code_systolic_coding_system_loinc  = 'http://loinc.org',
    code_systolic_coding_code_loinc  = '60989-1',
    code_systolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_systolic_coding_code_ieee  = '150065',
    -----
    code_mean_coding_system_loinc  = 'http://loinc.org',
    code_mean_coding_code_loinc  = '8399-8',
    code_mean_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_mean_coding_code_ieee  = '150067',
    -------
    code_diastolic_coding_system_loinc  = 'http://loinc.org',
    code_diastolic_coding_code_loinc  = '75933-2',
    code_diastolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_diastolic_coding_code_ieee  = '150066',
    device_reference = null
where profile_id = 21;


-- Linksventrikulaerer Schlagvolumenindex
select * from mii_copra.fhir_profile_observations fpo where profile_id = 22;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Schlagvolumenindex',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76297-1',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '277381004',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '149764',
    device_reference = null
where profile_id = 22;


-- Mechanische-Atemfrequenz-Beatmet
select * from mii_copra.fhir_profile_observations fpo where profile_id = 23;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mechanische-Atemfrequenz-Beatmet',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '33438-3',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '151586',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_Beatmung_id'
where profile_id = 23;


-- Mittlerer Beatmungsdruck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 24;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Mittlerer-Beatmungsdruck',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76530-5',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '151975',
    device_reference = 'DeviceMetric/..._Parameter_Beatmung_id'
where profile_id = 24;



-- Positiv-endexpiratorischer Druck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 25;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Positiv-Endexpiratorischer-Druck',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '76248-4',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '250854009',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '151976',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_Beatmung_id'
where profile_id = 25;


update mii_copra.fhir_profile_observations 
set code_coding_system_snomed = 'http://snomed.info/sct'
where code_coding_system_snomed notnull;


-- Pulmonalarterieller Blutdruck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 26;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Blutdruck',    
    code_coding_system_snomed = 'http://snomed.info/sct',
    code_coding_code_snomed = '75367002',
    -----    
    code_systolic_coding_system_loinc  = 'http://loinc.org',
    code_systolic_coding_code_loinc  = '8440-0',
    code_systolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_systolic_coding_code_ieee  = '150045',
    -----
    code_mean_coding_system_loinc  = 'http://loinc.org',
    code_mean_coding_code_loinc  = '8414-5',
    code_mean_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_mean_coding_code_ieee  = '150047',
    -------
    code_diastolic_coding_system_loinc  = 'http://loinc.org',
    code_diastolic_coding_code_loinc  = '8385-7',
    code_diastolic_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_diastolic_coding_code_ieee  = '150046',
    device_reference = null
where profile_id = 26;


-- Pulmonalarterieller-Wedge-Druck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 27;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Pulmonalarterieller-Wedge-Druck',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '75994-4',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '118433006',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '150052',
    device_reference = null
where profile_id = 27;


-- Sauerstofffraktion
select * from mii_copra.fhir_profile_observations fpo where profile_id = 28;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '71835-3',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 28;

-- Sauerstofffraktion
select * from mii_copra.fhir_profile_observations fpo where profile_id = 29;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstofffraktion',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '71835-3',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 29;


-- Sauerstoffgasfluss
select * from mii_copra.fhir_profile_observations fpo where profile_id = 30;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffgasfluss',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '19941-4',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id'
where profile_id = 30;



-- Sauerstoffsaettigung im art. Blut durch Pulsoxymetrie
select * from mii_copra.fhir_profile_observations fpo where profile_id = 31;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Sauerstoffsaettigung-Im-Arteriellen-Blut-Per-Pulsoxymetrie',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '59408-5',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '150456',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id'
where profile_id = 31;


-- Spontane-Atemfrequenz-Beatmet
select * from mii_copra.fhir_profile_observations fpo where profile_id = 32;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Atemfrequenz-Beatmet',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '19839-0',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '152498',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 32;


-- Spontane-Mechanische-Atemfrequenz-Beatmet
select * from mii_copra.fhir_profile_observations fpo where profile_id = 33;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Spontane-Mechanische-Atemfrequenz-Beatmet',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '19840-8',
    code_coding_system_snomed  = null,
    code_coding_code_snomed  = null,
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '152490',
    device_reference = 'DeviceMetric/Gemessene_Parameter_Beatmung_id'
where profile_id = 33;


-- Spontane-Mechanische-Atemfrequenz-Beatmet
select * from mii_copra.fhir_profile_observations fpo where profile_id = 34;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Substituatfluss',
    code_coding_system_loinc  = null,
    code_coding_code_loinc = null,
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '708513005',
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id'
where profile_id = 34;



-- Venöser Druck
select * from mii_copra.fhir_profile_observations fpo where profile_id = 35;

update mii_copra.fhir_profile_observations 
set profile_name = 'Venöser Druck',
    category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '182744004',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Venoeser-Druck',
    code_coding_system_loinc  = null,
    code_coding_code_loinc = null,
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '252076005',
    code_coding_system_ieee  = null,
    code_coding_code_ieee = null,
    device_reference = 'DeviceMetric/Eingestellte_Parameter_extrakorporale_Verfahren_id'
where profile_id = 35;


-- Zeitverhaeltnis-Ein-Ausatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 36;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://snomed.info/sct',
    category_coding_code = '40617009',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zeitverhaeltnis-Ein-Ausatmung',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '75931-6',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '250822000',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '151832',
    device_reference = 'DeviceMetric/Eingestellte_Parameter_Beatmung_id'
where profile_id = 36;


-- Zeitverhaeltnis-Ein-Ausatmung
select * from mii_copra.fhir_profile_observations fpo where profile_id = 37;

update mii_copra.fhir_profile_observations 
set category_coding_system = 'http://terminology.hl7.org/CodeSystem/observation-category',
    category_coding_code = 'vital-signs',
    meta_prolile = 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Zentralvenoeser-Blutdruck',
    code_coding_system_loinc  = 'http://loinc.org',
    code_coding_code_loinc = '60985-9',
    code_coding_system_snomed  = 'http://snomed.info/sct',
    code_coding_code_snomed  = '71420008',
    code_coding_system_ieee  = 'urn:iso:std:iso:11073:10101',
    code_coding_code_ieee = '150084',
    device_reference = null
where profile_id = 37;


select distinct profile_name from mii_copra.fhir_profile_observations fpo 
where profile_name not in (select distinct profile_name from mii_copra.mapping_mii_co6);

select distinct profile_name from mii_copra.mapping_mii_co6 mmc 
where profile_name not in (select distinct profile_name from mii_copra.fhir_profile_observations fpo)
order by profile_name;



/*
  Blutfluss durch cardiovasculäres Gerät
  Venöser Druck                         
*/
select profile_name from mii_copra.mapping_mii_co6_to_transfer mmctt
where profile_name like 'Blutfl%';

update mii_copra.mapping_mii_co6_to_transfer 
set profile_name = 'Blutfluss durch cardiovasculäres Gerät'
where profile_name = 'Blutfluss durch cardiovasculaeres Geraet'
;


select profile_name from mii_copra.mapping_mii_co6_to_transfer mmctt
where profile_name like 'Ven%';

update mii_copra.mapping_mii_co6_to_transfer 
set profile_name = 'Venöser Druck'
where profile_name = 'Venoeser Druck'
;

select distinct conf_var_unit, profile_unit 
from mii_copra.mapping_mii_co6 mmc
where conf_var_unit <> profile_unit 
;

select distinct profile_name from mii_copra.mapping_mii_co6 mmc
where profile_name not in (select profile_name from mii_copra.mapping_mii_co6_to_transfer mmctt);



alter table mii_copra.fhir_profile_observations 
rename meta_prolile to meta_profile;

insert into mii_copra.fhir_profile_observations --https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung
  (profile_name, 
  category_coding_system, 
  category_coding_code, 
  code_coding_system_snomed, 
  code_coding_code_snomed,
  --code_coding_system_loinc,
  --code_coding_code_loinc,
  --code_coding_system_ieee,
  --code_coding_code_ieee,
  valuequantity_system,
  valuequantity_code,
  --device_reference,
  meta_profile,
  device_reference)
  values 
  ('Dauer Haemodialysesitzung', 'http://snomed.info/sct', '182744004', 'http://snomed.info/sct', '445940005', 'http://unitsofmeasure.org', 'h', 'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Dauer-Haemodialysesitzung', 'DeviceMetric/Example_Gemessene_Parameter_extrakorporale_Verfahren_id')
;


insert into mii_copra.fhir_profile_observations 
  (profile_name, 
  category_coding_system, 
  category_coding_code, 
  code_coding_system_snomed, 
  code_coding_code_snomed,
  code_coding_system_loinc,
  code_coding_code_loinc,
  code_coding_system_ieee,
  code_coding_code_ieee,
  valuequantity_system,
  valuequantity_code,
  --device_reference,
  meta_profile
  --,device_reference
  )
  values 
  ('Linksventrikulaeres Schlagvolumen', 'http://terminology.hl7.org/CodeSystem/observation-category', 'vital-signs', 
  'http://snomed.info/sct', '90096001', 
  'http://loinc.org', '20562-5', 
  'urn:iso:std:iso:11073:10101', '150428', 
  'http://unitsofmeasure.org', 'mL', 
  'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaeres-Schlagvolumen' 
  )
;


insert into mii_copra.fhir_profile_observations 
  (profile_name, 
  category_coding_system, 
  category_coding_code, 
  code_coding_system_snomed, 
  code_coding_code_snomed,
  code_coding_system_loinc,
  code_coding_code_loinc,
  code_coding_system_ieee,
  code_coding_code_ieee,
  valuequantity_system,
  valuequantity_code,
  --device_reference,
  meta_profile
  --,device_reference
  )
  values 
  ('Linksventrikulaerer Herzindex', 'http://terminology.hl7.org/CodeSystem/observation-category', 'vital-signs', 
  'http://snomed.info/sct', '54993008', 
  'http://loinc.org', '75919-1', 
  'urn:iso:std:iso:11073:10101', '149772', 
  'http://unitsofmeasure.org', 'L/(min.m2)', 
  'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Linksventrikulaerer-Herzindex' 
  )
;

update mii_copra.mapping_mii_co6 
set profile_name = 'Venöser Druck' where profile_name = 'Venoeser Druck';

update mii_copra.mapping_mii_co6 
set profile_name = 'Blutfluss durch cardiovasculäres Gerät' where profile_name = 'Blutfluss durch cardiovasculaeres Geraet';

--Maximaler Beatmungsdruck
insert into mii_copra.fhir_profile_observations 
  (profile_name, 
  category_coding_system, 
  category_coding_code, 
  --code_coding_system_snomed, 
  --code_coding_code_snomed,
  code_coding_system_loinc,
  code_coding_code_loinc,
  code_coding_system_ieee,
  code_coding_code_ieee,
  valuequantity_system,
  valuequantity_code,
  meta_profile
  ,device_reference
  )
  values 
  ('Maximaler Beatmungsdruck', 'http://snomed.info/sct', '40617009', 
  'http://loinc.org', '76531-3', 
  'urn:iso:std:iso:11073:10101', '151973', 
  'http://unitsofmeasure.org', 'cm[H2O]', 
  'https://medizininformatik-initiative.de/fhir/ext/modul-icu/StructureDefinition/Maximaler-Beatmungsdruck',
  'DeviceMetric/..._Parameter_Beatmung_id'
  )
;

select * from mii_copra.fhir_profile_observations fpo; 
drop table mii_copra.mapping_mii_co6_2;

insert into mii_copra.mapping_mii_co6_2 
select 
f.profile_id, 
f.profile_name, 
f.category_coding_system, 
f.category_coding_code, 
f.code_coding_system_snomed, 
f.code_coding_code_snomed, 
f.code_coding_system_loinc, 
f.code_coding_code_loinc, 
f.code_coding_system_ieee, 
f.code_coding_code_ieee, 
f.valuequantity_system, 
f.valuequantity_code,
m.conf_var_unit,
f.device_reference,  
f.meta_profile , 
m.conf_var_id,
m.conf_var_parent_id,
m.conf_var_parent_name,
m.conf_var_name,
m.conf_var_description,
m.conf_var_types_id,
m.conf_var_types_name,
f.code_systolic_coding_system_snomed, f.code_systolic_coding_code_snomed, 
f.code_systolic_coding_system_loinc, f.code_systolic_coding_code_loinc, 
f.code_systolic_coding_system_ieee, f.code_systolic_coding_code_ieee, 
f.code_mean_coding_system_snomed, f.code_mean_coding_code_snomed, 
f.code_mean_coding_system_loinc, f.code_mean_coding_code_loinc, 
f.code_mean_coding_system_ieee, f.code_mean_coding_code_ieee, 
f.code_diastolic_coding_system_snomed, f.code_diastolic_coding_code_snomed, 
f.code_diastolic_coding_system_loinc, f.code_diastolic_coding_code_loinc, 
f.code_diastolic_coding_system_ieee, f.code_diastolic_coding_code_ieee,
m.matching_valide
--into mii_copra.mapping_mii_co6_2
from mii_copra.fhir_profile_observations f
join mii_copra.mapping_mii_co6 m 
  on m.profile_name = f.profile_name
  where m.conf_var_id = 103010
  order by profile_id
;

select standard, typ_standard
from mii_copra.mii_icu_used_all_info miuai 
where loinc isnull 
and snomed isnull 
and ieee isnull;

select standard from mii_copra.mii_icu_used_all_info
where profile_unit isnull;

select count(standard) 
from mii_copra.mii_icu_used_all_info miuai 
where typ_standard = 'Observation'
and profile_unit isnull
;

update mii_copra.fhir_profile_observations 
set code_coding_system_ieee = 'urn:iso:std:iso:11073:10101' where code_coding_system_ieee = 'urn:std:iso:11073:10101';


select count(distinct conf_var_id) from mii_copra.mapping_mii_co6_2 mmc;
select count(distinct profile_id) from mii_copra.mapping_mii_co6_2 mmc;

select distinct conf_var_name, profile_name, conf_var_description, conf_var_id, conf_var_unit, profile_unit  
from mii_copra.mapping_mii_co6 mmc 
where conf_var_unit <> profile_unit 
order by profile_name; 

select distinct profile_name, conf_var_name, conf_var_description , conf_var_id , valuequantity_code, conf_var_unit, code_coding_code_loinc  
from mii_copra.mapping_mii_co6_2 mmc
where conf_var_unit <> valuequantity_code 
order by conf_var_name;


select count(distinct conf_var_id) from  mii_copra.mapping_mii_co6_2;

select profile_name, conf_var_name  
from mii_copra.mapping_mii_co6_2 mmc
where conf_var_name = 'dPmax';

alter table mii_copra.mapping_mii_co6
rename to mapping_mii_co6_tmp

alter table mii_copra.mapping_mii_co6_2 
rename to mapping_mii_co6


select *
into mii_copra.mapping_mii_co6_2
from mii_copra.mapping_mii_co6 mmc 
where conf_var_id not in (102179, 102039, 102926, 105006)
order by profile_id 
;


 
  mii_copra.mapping_mii_co6_to_transfer

delimiter E';' csv header;

copy(
select 
regexp_replace(column_name, '_', '\_', 'g') "Spalte", 
udt_name "Datentyp", ' \\ \hline' "Information"
from information_schema."columns" c
where table_name = 'mapping_mii_co6'
) to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/structure_mapping_mii_co6.tex'
delimiter E'&' csv header;


alter table mii_copra.mapping_mii_co6_2 
add column unit_transform numeric default 1
;

update mii_copra.mapping_mii_co6_2 
set unit_transform = 1.01972 
where valuequantity_code = 'cm[H2O]' and conf_var_unit = 'mbar'
;

update mii_copra.mapping_mii_co6_2 
set unit_transform = 1.35951 
where valuequantity_code = 'cm[H2O]' and conf_var_unit = 'mmHg'
;

update mii_copra.mapping_mii_co6_2 
set unit_transform = 0.01 
where valuequantity_code = '1' and conf_var_unit = '%'
;


update mii_copra.mapping_mii_co6_2 
set unit_transform = 0.01 
where valuequantity_code = '1' and conf_var_unit ~ 'Vol%'


select * from mii_copra.mapping_mii_co6_2 mmc where conf_var_id = 110772; --in (110802, 103146, 103254);
;

update mii_copra.mapping_mii_co6_2  
set conf_var_id = 110772,
conf_var_name = 'P_NEV_HD_MS_5008onl_Rest_Zeit_min',
conf_var_unit = 'min'
where conf_var_id = 103254;


update mii_copra.mapping_mii_co6_2  
set unit_transform = 0.016666667
where conf_var_id = 110772;


delete from mii_copra.mapping_mii_co6_2  where conf_var_id = 103146;

select * from mii_copra.co6_config_variables ccv 
where id = 110772;


select count(distinct profile_id) from mii_copra.mapping_mii_co6_2 mmc; 
/*
 * id    |name                             |description|unit|co6_config_variabletypes_id|parent|deleted|loinc|displayname|
------+---------------------------------+-----------+----+---------------------------+------+-------+-----+-----------+
110772|P_NEV_HD_MS_5008onl_Rest_Zeit_min|           |min |                          6|     1|       |     |           |
 */

select * from mii_copra.co6_config_variables ccv where "name" like '%5008%';



copy 
 mii_copra.mapping_mii_co6_2
to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/data/csv/mapping_mii_co6_2.csv'
delimiter E';' csv header;


select count(distinct profile_id) from mii_copra.mapping_mii_co6 mmc where conf_var_id <> 101322; 

alter table mii_copra.mii_icu 
rename to mii_icu_changed_provi;

alter table mii_copra.fhir_profile_observations 
rename to mii_icu;


alter table copra.co6_data_decimal_6_3 
add column datetimeto timestamp;


alter table copra.co6_data_string 
add column datetimeto timestamp;

alter table copra.co6_medic_pressure 
add column datetimeto timestamp;

alter table copra.co6_data_string 
add column val varchar;

alter table copra.co6_data_string 
add column validated boolean;

alter table copra.co6_data_decimal_6_3  
add column validated boolean;

alter table copra.co6_medic_pressure  
add column validated boolean;




alter table copra.co6_data_string 
add column deleted boolean;

alter table copra.co6_data_decimal_6_3  
add column deleted boolean;

alter table copra.co6_medic_pressure  
add column deleted boolean;



alter table copra.co6_data_string 
add column flagcurrent boolean;

alter table copra.co6_data_decimal_6_3  
add column flagcurrent boolean;

alter table copra.co6_medic_pressure  
add column flagcurrent boolean;



-- copra.v_profil_string source

CREATE OR REPLACE VIEW copra.v_profil_string
AS SELECT 's_'::text || md5(((( SELECT tables.table_name
           FROM information_schema.tables
          WHERE tables.table_schema::name = 'copra'::name AND tables.table_name::name = 'co6_data_string'::name))::text || cdd.id) || mmc.profile_name::text) AS id,
    mmc.meta_profile,
    'final'::text AS status,
    mmc.category_coding_system,
    mmc.category_coding_code,
    mmc.code_coding_system_snomed,
    mmc.code_coding_code_snomed,
    mmc.code_coding_system_loinc,
    mmc.code_coding_code_loinc,
    mmc.code_coding_system_ieee,
    mmc.code_coding_code_ieee,
    'p_'::text || md5(cmdp.id::character varying::text) AS subject_reference,
    cdd.val::numeric * mmc.unit_transform AS "valueQuantity_value",
    mmc.valuequantity_system AS "valueQuantity_system",
    mmc.valuequantity_code AS "valueQuantity_code",
    cdd.datetimeto AS "effectiveDataTime"
   FROM copra.co6_data_string cdd
     JOIN copra.co6_config_variables ccv ON cdd.varid = ccv.id
     JOIN copra.mapping_mii_co6_2 mmc ON mmc.conf_var_id = ccv.id
     JOIN copra.co6_medic_data_patient cmdp ON cmdp.id = cdd.parent_id
  WHERE NOT cdd.deleted AND cdd.flagcurrent AND cdd.val::text ~ '^\d+$|^\d+\.\d+$'::text;
 
 
 
 select * from mii_copra.mapping_mii_co6 mmc 
 where conf_var_unit = 'mmHg/s';


select count (distinct conf_var_id)  from mii_copra.mapping_mii_co6_2 mmc where conf_var_parent_id <> 20;
select count (distinct profile_name)  from mii_copra.mapping_mii_co6_2 mmc where conf_var_parent_id <> 20;

copy 
  mii_copra.mapping_mii_co6_2_result 
to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/data/csv/mapping_mii_co6_2.csv'
with delimiter E';' header csv;

drop table mii_copra.mapping_mii_co6_2_result;

select * into mii_copra.mapping_mii_co6_2_result from mii_copra.mapping_mii_co6_2 mmc
where conf_var_parent_id <> 20; 

alter table mii_copra.mapping_mii_co6_2_result
add column profil_generic varchar;

alter table mii_copra.mapping_mii_co6_2_result
add column profil_generic_id int;

update mii_copra.mapping_mii_co6_2_result
set profil_generic = 'Monitoring und Vitaldaten',
profil_generic_id = 3
where conf_var_types_id = 12;

update mii_copra.mapping_mii_co6_2_result
set profil_generic = 'Monitoring und Vitaldaten',
profil_generic_id = 3
where profile_name ~* 'link|^k';


update mii_copra.mapping_mii_co6_2_result
set profil_generic = 'Parameter von Beatmung',
profil_generic_id = 2
where profile_name ~* 'Beatm|Atemzug|frakt';


update mii_copra.mapping_mii_co6_2_result
set profil_generic = 'Parameter von Beatmung',
profil_generic_id = 2
where profile_name in (select distinct profile_name from mii_copra.mapping_mii_co6_2_result where profil_generic_id isnull);


select distinct profile_name from mii_copra.mapping_mii_co6_2_result where profil_generic_id isnull;

select count(*) from mii_copra.quantities_conf_var qcv;

select profile 
from mii_copra.mii_icu_used miu 
where profile not in 
  (select profile_name from mii_copra.mapping_mii_co6_2_result mmcr)
order by profile ;



CREATE TABLE mii_copra.config_var (
	quantity int8 NULL,
	id int8 NULL,
	"name" varchar NULL,
	description varchar NULL
);


copy mii_copra.config_var
from '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/data/csv/config_var.csv'
with delimiter E';' csv header;

select * from mii_copra.config_var cv;



copy 
 (select standard from mii_copra.mii_icu_used_all_info miuai)
to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/python_scripts/profils_name.csv'
delimiter E';' csv;

copy(
select name || 
case 
  when description isnull then ''
  else ' ' || description 
end description 
from mii_copra.config_var cv
)
to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/python_scripts/config_vars_names.csv'
delimiter E';' csv;


/*copy(
select name || 
case 
  when description isnull then ''
  else ' ' || description 
end description 
from mii_copra.co6_config_variables ccv 
where parent = 1
and co6_config_variabletypes_id in (6,12)
)
to '/home/ahodelin/git_repos/Thesis_AbelHodelinHernandez/python_scripts/config_var_name.csv'
delimiter E';' csv;
*/


select * from mii_copra.profile_config_vars_python pcvp 
where score < 72
order by profil;

select * from mii_copra.profile_config_vars_python pcvp 
where score >= 72
order by profil;


select distinct profil from mii_copra.profile_config_vars_python pcvp
where profil not in (select distinct profile_name from mii_copra.mapping_mii_co6_2_result mmcr);