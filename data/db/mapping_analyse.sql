
-- profile type in mii icu
select count(*) quantity, profile_type 
from mii_copra.mii_icu mi  
group by profile_type order by quantity desc;

truncate table mii_copra.mapping_mii_co6;

-- fine mapping

--insert into mii_copra.mapping_mii_co6
select 
  * 
from mii_copra.mapping_mii_co6_tmp mmct
where profile_name = conf_var_name 
or profile_name = conf_var_description
  union 
select 
  * 
from mii_copra.mapping_mii_co6_tmp mmct
where lower(profile_name) =  lower(conf_var_name) 
or lower(profile_name) = lower(conf_var_description)  ;

--A
-- *Atemfrequenz*
select distinct profile_name  from mii_copra.mapping_mii_co6_tmp mmct where profile_name ~* 'atemfrequenz';
/*
- Spontane Atemfrequenz Beatmet            
- Spontane Mechanische Atemfrequenz Beatmet
- Mechanische Atemfrequenz Beatmet         
- Atemfrequenz                              
 */
select * from mii_copra.mapping_mii_co6_tmp mmct where conf_var_description  ~* 'spont.+enz' ;

--insert into mii_copra.mapping_mii_co6
select distinct 
  'Spontane Mechanische Atemfrequenz Beatmet' profile_name, 
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where conf_var_description  ~* 'spont.+enz'
and mmct.profile_name not like 'Beatmung'
  union 
select distinct 
  'Spontane Atemfrequenz Beatmet' profile_name, 
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where conf_var_description  ~* 'spont.+enz'
and mmct.profile_name not like 'Beatmung'
;

-- *Arteriell*
select distinct profile_name  from mii_copra.mapping_mii_co6_tmp mmct where profile_name ~* 'arteri';
/*
Arterieller Druck                                         
Horowitz In Arteriellem Blut                              
Pulmonalarterieller Blutdruck                             
Pulmonalarterieller Wedge Druck                           
Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Arterieller Druck' profile_name ,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct 
where (conf_var_description  ~* 'arter' 
  or conf_var_name ~* 'arter'
  )
--and conf_var_id not in (select conf_var_id from mii_copra.mapping_mii_co6)
and conf_var_description !~* 'pul';

-- Blutdruck
--insert into mii_copra.mapping_mii_co6
select 
  'Blutdruck' profile_name ,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct 
where (conf_var_description  ~* 'blut' 
  or conf_var_name ~* 'blut'
  )
--and conf_var_id not in (select conf_var_id from mii_copra.mapping_mii_co6)
  union 
select 
  'Blutdruck Generisch' profile_name ,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct 
where (conf_var_description  ~* 'blut' 
  or conf_var_name ~* 'blut'
  )
--and conf_var_id not in (select conf_var_id from mii_copra.mapping_mii_co6)
;


--select * from mii_copra.mapping_mii_co6_tmp mmct where conf_var_name ~* 'ä|ö|ü' or conf_var_description ~* 'ä|ö|ü';

-- *Beatmung* 
select * from mii_copra.mii_icu mi where profile_name ~* 'beatmung';
/*
Beatmung                                               
DeviceMetric eingestellte gemessene Parameter Beatmung 
Parameter von Beatmung                                 
Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung
Atemzugvolumen Waehrend Beatmung                       
Beatmungsvolumen Pro Minute Machineller Beatmung       
-Beatmungszeit Hohem Druck                              
-Beatmungszeit niedriegem Druck                         
Druckdifferenz Beatmung                                
Einstellung Ausatmungszeit Beatmung                    
-Einstellung Einatmungszeit Beatmung                    
-Maximaler Beatmungsdruck                               
-Mittlerer Beatmungsdruck                               
Unterstuzungsdruck Beatmung                            
 */

select * from (
select 
  distinct 
  conf_var_name, 
  conf_var_description,
  conf_var_unit 
from mii_copra.mapping_mii_co6_tmp mmct 
where (conf_var_description ~* 'beatmung' or conf_var_name ~* 'beatmung')
and conf_var_description !~* 'atemfrequenz'
) t
--where (conf_var_name ~* 'ein' or conf_var_description ~* 'ein')
--and (conf_var_name ~* 'aus' or conf_var_description ~* 'aus')
--and conf_var_unit ~ 's'
--and conf_var_unit !~ 'ms';

--insert into mii_copra.mapping_mii_co6  
select 
  distinct 
  'Mittlerer Beatmungsdruck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where conf_var_name ~* 'mitt.+druck' or conf_var_description ~* 'mitt.+druck';

--insert into mii_copra.mapping_mii_co6  
select 
  distinct 
  'Maximaler Beatmungsdruck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where conf_var_description ~* 'max.+druck';

--insert into mii_copra.mapping_mii_co6 
select 
  distinct 
  'Einstellung Einatmungszeit Beatmung' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where (conf_var_name ~* 'ein.+zeit' or conf_var_description ~* 'ein.+zeit')
and (conf_var_name ~* 'ins' or conf_var_description ~* 'ins')
and conf_var_unit ~ 's'
and conf_var_unit !~ 'ms'
and conf_var_description notnull;

--insert into mii_copra.mapping_mii_co6 
select 
  distinct 
  'Beatmungszeit Hohem Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where (conf_var_name ~* 'ein.+zeitH')
and (conf_var_name ~* 'ins' or conf_var_description ~* 'ins')
and conf_var_unit ~ 's'
and conf_var_unit !~ 'ms'
--and conf_var_description notnull;

--insert into mii_copra.mapping_mii_co6 
select 
  distinct 
  'Beatmungszeit niedriegem Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  profile_unit, 
  matching
from mii_copra.mapping_mii_co6_tmp mmct
where (conf_var_name ~* 'ein.+zeitN')
and (conf_var_name ~* 'ins' or conf_var_description ~* 'ins')
and conf_var_unit ~ 's'
and conf_var_unit !~ 'ms'
--and conf_var_description notnull;


-- *Kopfumfang*
select * from mii_copra.mii_icu mi where profile_name ~* 'umfang';

--insert into mii_copra.mapping_mii_co6
select 
  * 
from mii_copra.mapping_mii_co6_tmp mmct 
where conf_var_name ~* 'umfang' 
or conf_var_description ~* 'umfang'

-- *Venose*
--insert into mii_copra.mapping_mii_co6
select 
  'Venoeser Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'mmHg' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables ccv  
where (conf_var_name ~* 'veno' 
or conf_var_description ~* 'veno'
or conf_var_name ~* 'venö' 
or conf_var_description ~* 'venö')
and conf_var_unit ~ 'mm'


-- *Gasfluss*

select * from mii_copra.mii_icu mi where profile_name ~* 'gasf';
/*
Atemwegsdruck Mittlerem Expiratorischem Gasfluss
Atemwegsdruck Null Expiratorischem Gasfluss     
Eingestellter Inspiratorischer Gasfluss         
Exspiratorischer Gasfluss                       
Inspiratorischer Gasfluss                       
-Sauerstoffgasfluss                              
 */
--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstoffgasfluss' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'gasf' or conf_var_description ~* 'gasf') 
and (conf_var_name ~* 'o2' or conf_var_name ~* 'sauer')
;

-- Volumen
select * from mii_copra.mii_icu mi where profile_name ~* 'volu';
/*
-Linksventrikulaerer Schlagvolumenindex                           
Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung          
Substituatvolumen                                                
Atemzugvolumen Einstellung                                       
Atemzugvolumen Waehrend Beatmung                                 
Beatmungsvolumen Pro Minute Machineller Beatmung                 
-Herzzeitvolumen                                                  
Linksventrikulaerer Schlagvolumenindex durch Indikatorverduennung
Linksventrikulaeres Herzzeitvolumen durch Indikatorverduennung   
-Linksventrikulaeres Schlagvolumen                                
Linksventrikulaeres Schlagvolumen durch Indikatorverduennung     
Spontanes Atemzugvolumen                                                                      
*/

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaeres Schlagvolumen' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  '/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'schlagvo' or conf_var_description ~* 'schlagvo') 
and (conf_var_description  !~* 'ind|wei' or conf_var_description !~* 'ind|wei')
;

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Schlagvolumenindex' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  '/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'schlagvo' or conf_var_description ~* 'schlagvo') 
and (conf_var_description  ~* 'ind' or conf_var_description ~* 'ind')
;

--insert into mii_copra.mapping_mii_co6
select 
  'Herzzeitvolumen' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'herzz' or conf_var_description ~* 'herzz') 
--and (conf_var_description  ~* 'ind' or conf_var_description ~* 'ind')
;

-- Dauer Haemodialysesitzung
--insert into mii_copra.mapping_mii_co6
select 
  'Dauer Haemodialysesitzung' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'h' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'dialyse') 
--and (conf_var_description  ~* 'ind' or conf_var_description ~* 'ind')
;


-- Linksatrialer Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Linksatrialer Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'linksa' or conf_var_description ~* 'linksa') 
--and (conf_var_description  ~* 'ind' or conf_var_description ~* 'ind')
;


--Intrakranieller Druck
--insert into mii_copra.mapping_mii_co6
select 
  'Intrakranieller Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'intra[ck]' or conf_var_description ~* 'intra[ck]') 
--and (conf_var_description  ~* 'ind' or conf_var_description ~* 'ind')
;

-- Koerpertemperatur Kern
--insert into mii_copra.mapping_mii_co6
select 
  'Koerpertemperatur Kern' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'Cel' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'temp' or conf_var_description ~* 'temp') 
and (conf_var_name   ~* 'haut|generic|kern|rekt|tymp|skin|t_k|patient')
and conf_var_name !~* 't_k2'
;

-- *Pulm*
/*
Pulmonalarterieller Blutdruck        
Pulmonalarterieller Wedge Druck      
Pulmonalvaskulaerer Widerstandsindex 
 */

select * from mii_copra.mii_icu mi where profile_name ~* 'pulm';

--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalarterieller Blutdruck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'pulm' or conf_var_description ~* 'pulm') 
and (conf_var_description ~* 'druck')
and conf_var_description  !~* 'wedge'
;

--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalarterieller Wedge Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'pulm' or conf_var_description ~* 'pulm') 
and (conf_var_description ~* 'druck')
and conf_var_description  ~* 'wedge'
;


--insert into mii_copra.mapping_mii_co6
select 
  'Pulmonalvaskulaerer Widerstandsindex' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id, 
  conf_var_unit, 
  'dyn.s/(cm5.m2)' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'pulm' or conf_var_description ~* 'pulm') 
--and (conf_var_description ~* 'druck')
and conf_var_description  ~* 'index'
;


-- *Link*
select * from mii_copra.mii_icu mi where profile_name ~* 'link';
/*
-Linksventrikulaerer Schlagvolumenindex                           
-Linksatrialer Druck                                              
-Linksventrikulaerer Druck                                        
-Linksventrikulaerer Herzindex                                    
Linksventrikulaerer Herzindex durch Indikatorverduennung         
Linksventrikulaerer Schlagvolumenindex durch Indikatorverduennung
Linksventrikulaeres Herzzeitvolumen durch Indikatorverduennung   
-Linksventrikulaeres Schlagvolumen                                
Linksventrikulaeres Schlagvolumen durch Indikatorverduennung     
 */

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'mm[Hg]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'linksv' or conf_var_description ~* 'linksv')
and conf_var_description ~* 'druck'
;

--insert into mii_copra.mapping_mii_co6
select 
  'Linksventrikulaerer Herzindex' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/(min.m2)' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables 
where (conf_var_name ~* 'link' or conf_var_description ~* 'link')
and conf_var_name ~* 'lvsai'
;


-- *Fluss*
select * from mii_copra.mapping_mii_co6 mmc 
where profile_name ~* 'fluss'
or conf_var_name ~* 'fluss'
or conf_var_description ~* 'fluss'
;


select profile_name,profile_unit  from mii_copra.mii_icu mi where profile_name ~* 'fluss'
/*
-Atemwegsdruck Mittlerem Expiratorischem Gasfluss|cm[H2O]     
Atemwegsdruck Null Expiratorischem Gasfluss     |cm[H2O]     
-Blutfluss Cardiovasculaeres Geraet              |L/min       
Blutfluss Extrakorporaler Gasaustausch          |L/min       
Blutflussindex Extrakoporaler Gasaustausch      |L/(min.m2)  
-Eingestellter Inspiratorischer Gasfluss         |L/min       
-Exspiratorischer Gasfluss                       |L/min       
Haemodialyse Blutfluss                          |ml/h        
-Inspiratorischer Gasfluss                       |L/min       
-Sauerstoffgasfluss                             |L/min       
Substituatfluss                                 |ml/h                                        
*/

--insert into mii_copra.mapping_mii_co6
select 
  'Eingestellter Inspiratorischer Gasfluss' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'fluss|flow' or conf_var_description ~* 'fluss|flow')
and conf_var_description !~* 'liste|citra|calc|resistan|trigg'
and conf_var_name ~* 'air$|evita2'
--and conf_var_description 
;

--insert into mii_copra.mapping_mii_co6
select 
  'Blutfluss Cardiovasculaeres Geraet' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'fluss|flow' or conf_var_description ~* 'fluss|flow')
and conf_var_name ~* 'blut'
and conf_var_name !~* 'max|eff|activ'
;

--insert into mii_copra.mapping_mii_co6
select 
  'Exspiratorischer Gasfluss' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'fluss|flow' or conf_var_description ~* 'fluss|flow')
and conf_var_description ~* 'exspira'
and conf_var_unit ~* 'min'
;

--insert into mii_copra.mapping_mii_co6
select 
  'Inspiratorischer Gasfluss' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'insp' or conf_var_description ~* 'insp')
and conf_var_unit ~* 'min'
and conf_var_description !~* 'ano|einges|vol|patie'
;


--insert into mii_copra.mapping_mii_co6
select 
  'Positv Endexpiratorischer Druck' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'posi.+end.+druck' or conf_var_description ~* 'posi.+end.+druck')
and conf_var_unit !~* 'mbar|%|l'
order by conf_var_description
;




--insert into mii_copra.mapping_mii_co6
select 
  'Atemwegsdruck Mittlerem Expiratorischem Gasfluss' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'cm[H2O]' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_description ~* '(atemweg.+mit.+dru)|(mitt.+atem.+dru)')
--and conf_var_description !~* '^anor|^arter|trigge|zeit|co2|hfov|^nicht|^[zvtomurp]|^link|^intr|patie|sauer|posi|filt'
and conf_var_unit !~* 'mbar|%|l'
order by conf_var_description
;

--insert into mii_copra.mapping_mii_co6
select 
  'Beatmungsvolumen Pro Minute Machineller Beatmung' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'L/min' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'beatmung' and conf_var_description ~* 'vol')
--and conf_var_description ~* 'vol'
and conf_var_description !~* 'ano|^[tsmeli]|spo|lec'
and conf_var_unit !~* '%|1|bar|l$';
;

/*
Linksventrikulaerer Herzindex durch Indikatorverduennung         |L/min/m2 
Linksventrikulaerer Schlagvolumenindex durch Indikatorverduennung|/mL      
Linksventrikulaeres Herzzeitvolumen durch Indikatorverduennung   |L/min    
Linksventrikulaeres Schlagvolumen durch Indikatorverduennung     |/mL         
 */


/*
-Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie       |%            
-Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie      |%            
-Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie       |%            
*/

--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  '%' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'o2|sauer' or conf_var_description ~* 'o2|sauer')
and conf_var_description ~* 'arte'
--and conf_var_description !~* '^a|'
--and conf_var_unit !~* '%|1|bar|l$';
;


--insert into mii_copra.mapping_mii_co6
select 
  'Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  '%' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'o2|sauer' or conf_var_description ~* 'o2|sauer')
and conf_var_description ~* 'pulso'
  union 
select 
  'Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  '%' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'o2|sauer' or conf_var_description ~* 'o2|sauer')
and conf_var_description ~* 'pulso'

;


-- Ionisiertes Kalzium Nierenersatzverfahren |mmol/L 

--insert into mii_copra.mapping_mii_co6
select 
  'Ionisiertes Kalzium Nierenersatzverfahren' profile_name,
  conf_var_name, 
  conf_var_description, 
  conf_var_id,
  conf_var_unit, 
  'mmol/L' profile_unit, 
  0 matching 
from mii_copra.co6_config_variables
where (conf_var_name ~* 'nieren' and conf_var_description ~* 'Ca')
and conf_var_unit !~* 'h$';
;

/*
update mii_copra.mapping_mii_co6 m
  set profile_unit = p.profile_unit 
  from mii_copra.mii_icu p
where m.profile_name = p.profile_name;
*/

/*
update mii_copra.mapping_mii_co6 m
  set profile_name = 'Zentralvenoeser Blutdruck', 
  profile_unit = 'mm[Hg]'
  where conf_var_name = 'ZVD';
*/

-- fehlt noch

select 
  distinct profile_name, profile_unit 
from mii_copra.mii_icu mi  
where profile_name not in (select profile_name from mii_copra.mapping_mii_co6 mmc)
and profile_unit notnull 
order by profile_name;


-- Beatmungsvolumen Pro Minute Machineller Beatmung  L/min
select * from mii_copra.co6_config_variables ccv;

