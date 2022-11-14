-- view for decimal values

create or replace view copra.v_profil_decimal
as
select 
  mmctt.profile_type "resourceType",
  mmctt.profile_name "id",
  'http://snomed.info/sct' "system_snomed",
  mmctt.snomed "code_snomed",
  'http://loinc.org'  "system_loinc",
  mmctt.loinc "code_loinc",
  'urn:iso:std:iso:11073:10101' "system_ieee",
  mmctt.ieee "code_ieee",
  cmdp.patid "subject_reference",
  cdd.datetimeto "start_end",
  cdd.val "value",
  'http://unitsofmeasure.org' "system_unit",
  mmctt.profile_unit "code_unit"
from copra.co6_data_decimal_6_3 cdd 
join copra.mapping_mii_co6_to_transfer mmctt 
  on mmctt.conf_var_id = cdd.varid
join copra.co6_medic_data_patient cmdp
  on cmdp.id = cdd.parent_id
where not cdd.deleted
and not cmdp.deleted 
and validated 
and flagcurrent
;

-- view for string values

create or replace view copra.v_profil_string
as
select 
  mmctt.profile_type "resourceType",
  mmctt.profile_name "id",
  'http://snomed.info/sct' "system_snomed",
  mmctt.snomed "code_snomed",
  'http://loinc.org'  "system_loinc",
  mmctt.loinc "code_loinc",
  'urn:iso:std:iso:11073:10101' "system_ieee",
  mmctt.ieee "code_ieee",
  cmdp.patid "subject_reference",
  cdd.datetimeto "start_end",
  cdd.val "value",
  'http://unitsofmeasure.org' "system_unit",
  mmctt.profile_unit "code_unit"
from copra.co6_data_string cdd 
join copra.mapping_mii_co6_to_transfer mmctt 
  on mmctt.conf_var_id = cdd.varid
join copra.co6_medic_data_patient cmdp
  on cmdp.id = cdd.parent_id
where not cdd.deleted
and not cmdp.deleted 
and validated 
and flagcurrent
;



-- view for pressure values
create or replace view copra.v_profil_pressure
as
select 
  mmctt.profile_type "resourceType",
  mmctt.profile_name "id",
  'http://snomed.info/sct' "system_snomed",
  mmctt.snomed "code_snomed",
  'http://loinc.org'  "system_loinc",
  mmctt.loinc "code_loinc",
  'urn:iso:std:iso:11073:10101' "system_ieee",
  mmctt.ieee "code_ieee",
  cmdp.patid "subject_reference",
  cdd.datetimeto "start_end",
  cdd.systolic,
  cdd.mean,
  cdd.diastolic,
  'http://unitsofmeasure.org' "system_unit",
  mmctt.profile_unit "code_unit"
from copra.co6_medic_pressure cdd 
join copra.mapping_mii_co6_to_transfer mmctt 
  on mmctt.conf_var_id = cdd.varid
join copra.co6_medic_data_patient cmdp
  on cmdp.id = cdd.parent_id
where not cdd.deleted
and not cmdp.deleted 
and validated 
and flagcurrent
;