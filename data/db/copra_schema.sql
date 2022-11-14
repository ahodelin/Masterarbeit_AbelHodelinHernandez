 DROP SCHEMA if exists copra cascade;

CREATE SCHEMA copra;
-- copra.co6_config_variable_types definition

-- Drop table

-- DROP TABLE copra.co6_config_variable_types;

CREATE TABLE copra.co6_config_variable_types (
	id int4 NOT NULL,
	"name" varchar NOT NULL,
	tablename varchar NOT null,
	CONSTRAINT co6_config_variable_types_name_key UNIQUE (name),
	CONSTRAINT co6_config_variable_types_pkey PRIMARY KEY (id)
);


-- copra.co6_config_variables definition

-- Drop table

-- DROP TABLE copra.co6_config_variables;

CREATE TABLE copra.co6_config_variables (
	id int8 NOT NULL,
	"name" varchar NULL,
	description varchar NULL,
	unit varchar NULL,
	co6_config_variabletypes_id int4 null references copra.co6_config_variable_types (id),
	parent int4 NULL,
	displayname varchar NULL,
	CONSTRAINT co6_config_variables_pkey PRIMARY KEY (id)
);


CREATE TABLE copra.co6_medic_data_patient (
	id int8 NOT NULL,
	geb timestamp NULL,
	geschlecht varchar(50) NULL,
	patid varchar(50) NULL,
	CONSTRAINT co6_medic_data_patient_pkey PRIMARY KEY (id)
);


-- copra.co6_data_decimal_6_3 definition

-- Drop table

-- DROP TABLE copra.co6_data_decimal_6_3;

CREATE TABLE copra.co6_data_decimal_6_3 (
	id int8 NOT NULL,
	varid int4 NOT null references copra.co6_config_variables(id),	
	deleted bool NOT NULL,
	parent_id int8 NOT null references copra.co6_medic_data_patient(id),
	parent_varid int4 NOT null references copra.co6_config_variables(id),
	val numeric(9, 3) NOT NULL,	
	CONSTRAINT co6_data_decimal_6_3_pkey PRIMARY KEY (id)
);



-- copra.co6_data_object definition

-- Drop table

-- DROP TABLE copra.co6_data_object;

CREATE TABLE copra.co6_data_object (
	id int8 NOT NULL,
	varid int4 NOT null references copra.co6_config_variables(id),
	parent_id int8 NOT null references copra.co6_medic_data_patient(id),
	parent_varid int4 NOT null references copra.co6_config_variables(id),
	flagcurrent bool NOT NULL,
	CONSTRAINT co6_data_object_pkey PRIMARY KEY (id)
);


-- copra.co6_data_string definition

-- Drop table

-- DROP TABLE copra.co6_data_string;

CREATE TABLE copra.co6_data_string (
	id int8 NOT NULL,
	varid int4 NOT null references copra.co6_config_variables(id),
	parent_id int8 NOT null references copra.co6_medic_data_patient(id),
	parent_varid int4 NOT null references copra.co6_config_variables(id),
	CONSTRAINT co6_data_string_pkey PRIMARY KEY (id)
);


-- copra.co6_medic_data_patient definition

-- Drop table

-- DROP TABLE copra.co6_medic_data_patient;




-- copra.co6_medic_pressure definition

-- Drop table

-- DROP TABLE copra.co6_medic_pressure;

CREATE TABLE copra.co6_medic_pressure (
	id int8 NOT NULL,
	varid int4 NOT null references copra.co6_config_variables(id),
	parent_id int8 NOT null references copra.co6_medic_data_patient(id),
	parent_varid int4 NOT null references copra.co6_config_variables(id),
	systolic numeric(9, 3) NULL,
	mean numeric(9, 3) NULL,
	diastolic numeric(9, 3) NULL,
	CONSTRAINT co6_medic_pressure_pkey PRIMARY KEY (id)
);

