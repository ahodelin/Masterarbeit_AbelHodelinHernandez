-- units of mii icu profiles
\c thesis


update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Arterieller Druck';
  
update mii_copra.mii_icu 
  set profile_unit = '/min' where profile_name = 'Atemfrequenz';
  
update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Atemwegsdruck Mittlerem Expiratorischem Gasfluss';
  
update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Atemwegsdruck Null Expiratorischem Gasfluss';
   
update mii_copra.mii_icu 
  set profile_unit = 'mL' where profile_name = 'Atemzugvolumen Einstellung';
  
update mii_copra.mii_icu 
  set profile_unit = 'mL' where profile_name = 'Atemzugvolumen Waehrend Beatmung';

update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Beatmungsvolumen Pro Minute Machineller Beatmung';

update mii_copra.mii_icu 
  set profile_unit = 's' where profile_name = 'Beatmungszeit Hohem Druck';
  
update mii_copra.mii_icu 
  set profile_unit = 's' where profile_name = 'Beatmungszeit niedriegem Druck';
  
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Blutdruck';
  
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Blutdruck Generisch';
  
update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Blutfluss Cardiovasculaeres Geraet';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Blutfluss Extrakorporaler Gasaustausch';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/(min.m2)' where profile_name = 'Blutflussindex Extrakoporaler Gasaustausch';
 
update mii_copra.mii_icu 
  set profile_unit = 'h' where profile_name = 'Dauer extrakoporaler Gasaustausch';
 
update mii_copra.mii_icu 
  set profile_unit = 'h' where profile_name = 'Dauer Haemodialysesitzung';
 
update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Druckdifferenz Beatmung';
 
update mii_copra.mii_icu 
  set profile_unit = 'mL/cm[H2O]' where profile_name = 'Dynamische Kompliance';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Eingestellter Inspiratorischer Gasfluss';
 
update mii_copra.mii_icu 
  set profile_unit = 's' where profile_name = 'Einstellung Ausatmungszeit Beatmung';
 
update mii_copra.mii_icu 
  set profile_unit = 's' where profile_name = 'Einstellung Einatmungszeit Beatmung';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Endexpiratorischer Kohlendioxidpartialdruck';
 
 update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Exspiratorischer Gasfluss';
 
 update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Exspiratorischer Sauerstoffpartialdruck';
 
 update mii_copra.mii_icu 
  set profile_unit = 'ml/h' where profile_name = 'Haemodialyse Blutfluss';
 
 update mii_copra.mii_icu 
  set profile_unit = '/min' where profile_name = 'Herzfrequenz';

update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Herzzeitvolumen';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Horowitz In Arteriellem Blut';

update mii_copra.mii_icu 
  set profile_unit = 'kg' where profile_name = 'Ideales Koerpergewicht';


update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Inspiratorischer Gasfluss';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Intrakranieller Druck';
 
update mii_copra.mii_icu 
  set profile_unit = 'mmol/L' where profile_name = 'Ionisiertes Kalzium Nierenersatzverfahren';
 
update mii_copra.mii_icu 
  set profile_unit = 'kg' where profile_name = 'Koerpergewicht';

update mii_copra.mii_icu 
  set profile_unit = '%' where profile_name = 'Koerpergewicht Percentil Altersabhaengig';

update mii_copra.mii_icu 
  set profile_unit = 'cm' where profile_name = 'Koerpergroesse';

update mii_copra.mii_icu 
  set profile_unit = '%' where profile_name = 'Koerpergroesse Percentil';
 
update mii_copra.mii_icu 
  set profile_unit = 'Cel' where profile_name = 'Koerpertemperatur Kern';

update mii_copra.mii_icu 
 set profile_unit = 'cm' where profile_name = 'Kopfumfang';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Linksatrialer Druck';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Linksventrikulaerer Druck';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/(min.m2)' where profile_name = 'Linksventrikulaerer Herzindex';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/min/m2' where profile_name = 'Linksventrikulaerer Herzindex durch Indikatorverduennung';
 
update mii_copra.mii_icu 
 set profile_unit = '/mL' where profile_name = 'Linksventrikulaerer Schlagvolumenindex durch Indikatorverduennung';

update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Linksventrikulaeres Herzzeitvolumen durch Indikatorverduennung';
 
update mii_copra.mii_icu 
  set profile_unit = '/mL' where profile_name = 'Linksventrikulaeres Schlagvolumen';
 
update mii_copra.mii_icu 
  set profile_unit = '/mL' where profile_name = 'Linksventrikulaeres Schlagvolumen durch Indikatorverduennung';

update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Maximaler Beatmungsdruck';
 
update mii_copra.mii_icu 
  set profile_unit = '{breaths}/min' where profile_name = 'Mechanische Atemfrequenz Beatmet';
 
update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Mittlerer Beatmungsdruck';
 
update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Positv Endexpiratorischer Druck';

update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Pulmonalarterieller Blutdruck';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Pulmonalarterieller Wedge Druck';
 
update mii_copra.mii_icu 
  set profile_unit = 'dyn.s/(cm5.m2)' where profile_name = 'Pulmonalvaskulaerer Widerstandsindex';
 
update mii_copra.mii_icu 
  set profile_unit = 'L/min' where profile_name = 'Sauerstoffgasfluss';
 
update mii_copra.mii_icu 
  set profile_unit = '%' where profile_name = 'Sauerstoffsaettigung im arteriellen Blut Per Pulsoxymetrie';

update mii_copra.mii_icu 
  set profile_unit = '%' where profile_name = 'Sauerstoffsaettigung im Blut postduktal durch Pulsoxymetrie';
 
update mii_copra.mii_icu 
  set profile_unit = '%' where profile_name = 'Sauerstoffsaettigung im Blut preductal durch Pulsoxymetrie';
 
update mii_copra.mii_icu 
  set profile_unit = '/min' where profile_name = 'Spontane Atemfrequenz Beatmet';
 
update mii_copra.mii_icu 
  set profile_unit = '/min' where profile_name = 'Spontane Mechanische Atemfrequenz Beatmet';
 
update mii_copra.mii_icu 
  set profile_unit = 'mL' where profile_name = 'Spontanes Atemzugvolumen';
 
update mii_copra.mii_icu 
  set profile_unit = 'ml/h' where profile_name = 'Substituatfluss';
 
update mii_copra.mii_icu 
  set profile_unit = 'dyn.s/(cm.m2)' where profile_name = 'Systemischer Vaskulaerer Widerstandsindex';

update mii_copra.mii_icu 
  set profile_unit = 'cm[H2O]' where profile_name = 'Unterstuzungsdruck Beatmung';
 
update mii_copra.mii_icu 
  set profile_unit = 'mmHg' where profile_name = 'Venoeser Druck';

update mii_copra.mii_icu 
  set profile_unit = '{ratio}' where profile_name = 'Zeitverhaeltnis Ein Ausatmung';
 
update mii_copra.mii_icu 
  set profile_unit = 'mm[Hg]' where profile_name = 'Zentralvenoeser Blutdruck';

\c postgres
