select displayname, description, unit from mii_copra.co6_config_variables_original ccvo where displayname not like 'NULL' order by displayname ;

select count(*) from mii_copra.co6_config_variables_original ccvo;

select description, name, unit from mii_copra.co6_config_variables_original ccvo where description ~* 'gew'

alter table mii_copra.mii_icu 
  --add column ops varchar,
  --add column snomed varchar,
  --add column loinc varchar,
  --add column ieee varchar
   drop column snomend;
;

update mii_copra.mii_icu
  set 
    snomed = '386534000' where profile_name = 'Arterieller Druck';

update mii_copra.mii_icu
  set 
    snomed = '86290005',
    loinc = '9279-1' 
where profile_name = 'Atemfrequenz';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '20056-8'
    --ieee = '10101'
where profile_name = 'Atemwegsdruck Mittlerem Expiratorischem Gasfluss';

update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '20060-0'
    --ieee = ''
where profile_name = 'Atemwegsdruck Null Expiratorischem Gasfluss';


update mii_copra.mii_icu
  set 
    snomed = '250874002',
    loinc = '76222-9',
    ieee = '151980'
where profile_name = 'Atemzugvolumen Waehrend Beatmung';


update mii_copra.mii_icu
  set 
    --snomed = '',
    --loinc = '',
    --ieee = '',
    ops = '5-470'
where profile_name = 'Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '426102006',
    loinc = '76009-0',
    ieee = '152004'
    --ops = ''
where profile_name = 'Beatmungsvolumen Pro Minute Maschineller Beatmung';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '76190-8',
    ieee = '16929860'
    --ops = ''
where profile_name = 'Beatmungszeit Hohem Druck';

update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '76229-4',
    ieee = '16929864'
    --ops = ''
where profile_name = 'Beatmungszeit Niedrigem Druck';

update mii_copra.mii_icu
  set 
    snomed = '75367002'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Blutdruck';

update mii_copra.mii_icu
  set 
    snomed = '75367002'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Blutdruck Generisch';

update mii_copra.mii_icu
  set 
    snomed = '444479000'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Blutfluss Cardiovasculaeres Geraet';

update mii_copra.mii_icu
  set 
    snomed = '251288004'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Blutfluss Extrakorporaler Gasaustausch';

update mii_copra.mii_icu
  set 
    snomed = '251289007'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Blutflussindex Extrakoporaler Gasaustausch';

update mii_copra.mii_icu
  set 
    snomed = '251286000'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Dauer Extrakoporaler Gasaustausch';


update mii_copra.mii_icu
  set 
    snomed = '445940005'
    --loinc = '',
    --ieee = ''
    --ops = ''
where profile_name = 'Dauer Haemodialysesitzung';


update mii_copra.mii_icu
  set 
    --snomed = ''
    loinc = '76154-4',
    ieee = '152720'
    --ops = ''
where profile_name = 'Druckdifferenz Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '250823005',
    loinc = '60827-3',
    ieee = '151692'
    --ops = ''
where profile_name = 'Dynamische Kompliance';

update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '76275-7'
    --ieee = ''
    --ops = ''
where profile_name = 'Eingestellter Inspiratorischer Gasfluss';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '76187-4'
    --ieee = ''
    --ops = ''
where profile_name = 'Einstellung Ausatmungszeit Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '76334-2',
    loinc = null,
    ieee = '16929632',
    ops = null
where profile_name = 'Einstellung Einatmungszeit Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '250784008',
    loinc = '19891-1',
    ieee = '151708',
    ops = null
where profile_name = 'Endexpiratorischer Kohlendioxidpartialdruck';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '60792-9',
    ieee = '151944'
    --ops = ''
where profile_name = 'Exspiratorischer Gasfluss';


update mii_copra.mii_icu
  set 
    snomed = '250775008',
    loinc = '3147-6',
    ieee = '153132'
    --ops = ''
where profile_name = 'Exspiratorischer Sauerstoffpartialdruck';


update mii_copra.mii_icu
  set 
    --snomed = '',
    --loinc = ''
    --ieee = ''
    ops = '5-470'
where profile_name = 'Extrakorporales Verfahren';


update mii_copra.mii_icu
  set 
    snomed = '401000124105',
    loinc = '83064-6',
    ieee = '_83064-6'
    --ops = ''
where profile_name = 'Haemodialyse Blutfluss';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '8867-4'
    --ieee = ''
    --ops = ''
where profile_name = 'Herzfrequenz';


update mii_copra.mii_icu
  set 
    snomed = '82799009',
    loinc = '8741-1',
    ieee = '150276'
    --ops = ''
where profile_name = 'Herzzeitvolumen';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '50984-4',
    ieee = '150656'
    --ops = ''
where profile_name = 'Horowitz In Arteriellem Blut';


update mii_copra.mii_icu
  set 
    snomed = '170804003',
    loinc = '50064-5'
    --ieee = ''
    --ops = ''
where profile_name = 'Ideales Koerpergewicht';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '60794-5',
    ieee = '151948',
    ops = null
where profile_name = 'Inspiratorischer Gasfluss';

update mii_copra.mii_icu
  set 
    snomed = '250844005',
    loinc = '60956-0',
    ieee = '153608',
    ops = null
where profile_name = 'Intrakranieller Druck';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '83064-6',
    ieee = null,
    ops = null
where profile_name = 'Ionisiertes Kalzium Nierenersatzverfahren';

update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '29463-7',
    ieee = null,
    ops = null
where profile_name = 'Koerpergewicht';

update mii_copra.mii_icu
  set 
    snomed = '1153592008',
    loinc = '8336-0',
    ieee = null,
    ops = null
where profile_name = 'Koerpergewicht Percentil Altersabhaengig';

update mii_copra.mii_icu
  set 
    snomed = '50373000',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Koerpergroesse';

update mii_copra.mii_icu
  set 
    snomed = '1153605006',
    loinc = '8303-0',
    ieee = null,
    ops = null
where profile_name = 'Koerpergroesse Percentil';

update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '8329-5',
    ieee = '150368',
    ops = null
where profile_name = 'Koerpertemperatur Kern';

update mii_copra.mii_icu
  set 
    snomed = '363811000',
    loinc = '9843-4',
    ieee = null,
    ops = null
where profile_name = 'Kopfumfang';

update mii_copra.mii_icu
  set 
    snomed = '75367002',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Linksatrialer Druck';

update mii_copra.mii_icu
  set 
    snomed = '75367002',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Linksventrikulaerer Druck';

update mii_copra.mii_icu
  set 
    snomed = '54993008',
    loinc = '75919-1',
    ieee = '149772',
    ops = null
where profile_name = 'Linksventrikulaerer Herzindex';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '8751-0',
    ieee = '149772',
    ops = null
where profile_name = 'Linksventrikulaerer Herzindex Durch Indikatorverduennung';


update mii_copra.mii_icu
  set 
    snomed = '277381004',
    loinc = '76297-1',
    ieee = '149764',
    ops = null
where profile_name = 'Linksventrikulaerer Schlagvolumenindex';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '8791-6',
    ieee = null,
    ops = null
where profile_name = 'Linksventrikulaerer Schlagvolumenindex Durch Indikatorverduennung';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '8737-9',
    ieee = '150276',
    ops = null
where profile_name = 'Linksventrikulaeres Herzzeitvolumen Durch Indikatorverduennung';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '20562-5',
    ieee = '150428',
    ops = null
where profile_name = 'Linksventrikulaeres Schlagvolumen';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '8771-8',
    ieee = null,
    ops = null
where profile_name = 'Linksventrikulaeres Schlagvolumen Durch Indikatorverduennung';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '76531-3',
    ieee = '151973'
    --ops = ''
where profile_name = 'Maximaler Beatmungsdruck';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = ''
    --ieee = ''
    --ops = ''
where profile_name = '';


update mii_copra.mii_icu
  set 
    --snomed = '',
    loinc = '33438-3',
    ieee = '151586'
    --ops = ''
where profile_name = 'Mechanische Atemfrequenz Beatmet';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '76530-5',
    ieee = '151975',
    ops = null
where profile_name = 'Mittlerer Beatmungsdruck';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '2708-6',
    ieee = null,
    ops = null
where profile_name = 'Periphere Artierielle Sauerstoffsaettigung ICU';


update mii_copra.mii_icu
  set 
    snomed = '250854009',
    loinc = '76248-4',
    ieee = '151976',
    ops = null
where profile_name = 'Positv Endexpiratorischer Druck';


update mii_copra.mii_icu
  set 
    snomed = '75367002',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Pulmonalarterieller Blutdruck';


update mii_copra.mii_icu
  set 
    snomed = '118433006',
    loinc = '75994-4',
    ieee = '150052',
    ops = null
where profile_name = 'Pulmonalarterieller Wedge Druck';


update mii_copra.mii_icu
  set 
    snomed = '276902009',
    loinc = '8834-4',
    ieee = '152852',
    ops = null
where profile_name = 'Pulmonalvaskulaerer Widerstandsindex';


update mii_copra.mii_icu
  set 
    snomed = '75367002',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Rechtsatrialer Druck';


update mii_copra.mii_icu
  set 
    snomed = '75367002',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Rechtsventrikulaerer Druck';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '71835-3',
    ieee = null,
    ops = null
where profile_name = 'Sauerstofffraktion';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '19994-3',
    ieee = null,
    ops = null
where profile_name = 'Sauerstofffraktion Eingestellt';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '19941-4',
    ieee = null,
    ops = null
where profile_name = 'Sauerstoffgasfluss';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '59408-5',
    ieee = '150456',
    ops = null
where profile_name = 'Sauerstoffsaettigung Im Arteriellen Blut Per Pulsoxymetrie';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '59418-4',
    ieee = '160300',
    ops = null
where profile_name = 'Sauerstoffsaettigung Im Blut Postduktal Durch Pulsoxymetrie';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '59407-7',
    ieee = '160296',
    ops = null
where profile_name = 'Sauerstoffsaettigung Im Blut Preductal Durch Pulsoxymetrie';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = null,
    ieee = '152498',
    ops = null
where profile_name = 'Spontane Atemfrequenz Beatmet';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '19840-8',
    ieee = '152490',
    ops = null
where profile_name = 'Spontane Mechanische Atemfrequenz Beatmet';


update mii_copra.mii_icu
  set 
    snomed = '250816009',
    loinc = '20116-0',
    ieee = null,
    ops = null
where profile_name = 'Spontanes Atemzugvolumen';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '20118-6',
    ieee = null,
    ops = null
where profile_name = 'Spontanes Mechanisches Atemzugvolumen Waehrend Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '708513005',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Substituatfluss';


update mii_copra.mii_icu
  set 
    snomed = '708514004',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Substituatvolumen';


update mii_copra.mii_icu
  set 
    snomed = '276900001',
    loinc = '8837-7',
    ieee = '149760',
    ops = null
where profile_name = 'Systemischer Vaskulaerer Widerstandsindex';


update mii_copra.mii_icu
  set 
    snomed = null,
    loinc = '20079-0',
    ieee = null,
    ops = null
where profile_name = 'Unterstuzungsdruck Beatmung';


update mii_copra.mii_icu
  set 
    snomed = '252076005',
    loinc = null,
    ieee = null,
    ops = null
where profile_name = 'Venoeser Druck';


update mii_copra.mii_icu
  set 
    snomed = '250822000',
    loinc = '75931-6',
    ieee = '151832',
    ops = null
where profile_name = 'Zeitverhaeltnis Ein Ausatmung';


update mii_copra.mii_icu
  set 
    snomed = '71420008',
    loinc = '60985-9',
    ieee = '150084',
    ops = null
where profile_name = 'Zentralvenoeser Blutdruck';
