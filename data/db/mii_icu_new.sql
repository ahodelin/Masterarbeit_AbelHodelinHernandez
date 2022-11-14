create table mii_copra.mii_icu_new(
  profile_name varchar,
  profile_type varchar,
  profile_status varchar,
  profile_unit varchar,
  mapped boolean
);

-- new and old mii_icu
select o.profile_name old_value, n.profile_name new_value
from mii_copra.mii_icu o 
join mii_copra.mii_icu_new n 
  on lower(regexp_replace(o.profile_name, ' ', '')) = lower(regexp_replace(n.profile_name, ' ', ''))
  order by o.profile_name;

-- only old 
select 
  o.profile_name 
from mii_copra.mii_icu o 
left join mii_copra.mii_icu_new n 
  on lower(regexp_replace(o.profile_name, ' ', '')) = lower(regexp_replace(n.profile_name, ' ', ''))
where lower(regexp_replace(n.profile_name, ' ', '')) isnull
order by o.profile_name;


-- only new 
select 
  n.profile_name 
from mii_copra.mii_icu o 
right join mii_copra.mii_icu_new n 
  on lower(regexp_replace(o.profile_name, ' ', '')) = lower(regexp_replace(n.profile_name, ' ', ''))
where lower(regexp_replace(o.profile_name, ' ', '')) isnull
order by n.profile_name;

select profile_name, 'new' status from mii_copra.mii_icu_new n where profile_name ~* 'maschin'
  union 
select profile_name, 'old'  from mii_copra.mii_icu o where profile_name ~* 'machin'
;

update mii_copra.mii_icu  
  set profile_name = 'Beatmungsvolumen Pro Minute Maschineller Beatmung' where profile_name = 'Beatmungsvolumen Pro Minute Machineller Beatmung';
--Beatmungszeit Niedrigem Druck

select o.profile_name old_value, n.profile_name new_value
from mii_copra.mii_icu o 
join mii_copra.mii_icu_new n 
  on lower(regexp_replace(o.profile_name, ' ', '')) = lower(regexp_replace(n.profile_name, ' ', ''))
  order by o.profile_name;

 
update mii_copra.mii_icu_new n
  set mapped = o.mapped
  from mii_copra.mii_icu o
  where n.profile_name = o.profile_name;
  
update mii_copra.mii_icu_new n
  set profile_unit  = o.profile_unit
  from mii_copra.mii_icu o
  where n.profile_name = o.profile_name;
 
update mii_copra.mii_icu m
  set profile_name = n.profile_name 
from mii_copra.mii_icu_new n
where lower(regexp_replace(m.profile_name, ' ', '')) = lower(regexp_replace(n.profile_name, ' ', ''))

update mii_copra.mii_icu
set profile_unit = 'l' where profile_name = 'Substituatvolumen';
select 
  profile_name, mcn.profile_unit  
from mii_copra.mii_icu_new mcn
  join mii_copra.mii_icu_units miu 
  on mcn.profile_unit = miu.profile_unit 
where not miu.checked 
order by profile_unit, profile_name;

update mii_copra.mii_icu_units 
  set checked = true where profile_unit = 'mm[Hg]';
 


 

delete from  mii_copra.mii_icu_units where profile_unit = 'mm[Hg]';
insert into mii_copra.mii_icu_units
values ('mm[Hg]', false);
update mii_copra.mii_icu_units
  set profile_unit = 'mm[Hg]' where profile_unit = 'mmHg';

update mii_copra.mii_icu_new
  set profile_unit = 'mm[Hg]' where profile_unit = 'mmHg';
 
 
select name, description, unit  from mii_copra.co6_config_variables_original ccvo
where name ~* 'systo|diasto|mitt' or description ~* 'systo|diasto|mitt'
;

drop table if exists mii_copra.mapping_mii_co6_tmp;
