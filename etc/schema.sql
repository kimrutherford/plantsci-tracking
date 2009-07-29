DROP TABLE sequencingrun CASCADE;
DROP TABLE process_conf_input CASCADE;
DROP TABLE process_conf CASCADE;
DROP TABLE pipeprocess CASCADE;
DROP TABLE pipedata CASCADE;
DROP TABLE sample CASCADE;
DROP TABLE sample_pipeproject CASCADE;
DROP TABLE pipeprocess_in_pipedata CASCADE;
DROP TABLE pipeproject CASCADE;
DROP TABLE person CASCADE;
DROP TABLE organisation CASCADE;
DROP TABLE cvterm CASCADE;
DROP TABLE cv CASCADE;
DROP TABLE db CASCADE;
DROP TABLE pub_dbxref CASCADE;
DROP TABLE cvterm_dbxref CASCADE;
DROP TABLE dbxref CASCADE;
DROP TABLE pub CASCADE;
DROP TABLE barcode CASCADE;
DROP TABLE tissue CASCADE;
DROP TABLE ecotype CASCADE;
DROP TABLE genotype CASCADE;
DROP TABLE organism CASCADE;
DROP TABLE organism_dbxref CASCADE;
DROP TABLE sample_pipedata CASCADE;
DROP TABLE sample_ecotype CASCADE;
DROP TABLE coded_sample CASCADE;
DROP TABLE sequencing_sample CASCADE;
DROP TABLE protocol CASCADE;
DROP SEQUENCE cvterm_cvterm_id_seq CASCADE;
DROP SEQUENCE cv_cv_id_seq CASCADE;

\set ON_ERROR_STOP true


-- From chado:
CREATE TABLE organism (
       organism_id serial CONSTRAINT organism_id_pk PRIMARY KEY,
       abbreviation character varying(255),
       genus character varying(255) NOT NULL,
       species character varying(255) NOT NULL,
       common_name character varying(255),
       comment text,
       CONSTRAINT organism_full_name_constraint UNIQUE(genus, species)
);

CREATE TABLE db (
    db_id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_id integer,
    description character varying(255),
    urlprefix character varying(255),
    url character varying(255)
);

CREATE TABLE dbxref (
    dbxref_id integer NOT NULL,
    db_id integer NOT NULL,
    accession character varying(255) NOT NULL,
    version character varying(255) DEFAULT ''::character varying NOT NULL,
    description text
);

CREATE SEQUENCE cv_cv_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE cv (
    cv_id integer NOT NULL,
    name character varying(255) NOT NULL,
    definition text
);
ALTER TABLE cv ALTER COLUMN cv_id SET DEFAULT nextval('cv_cv_id_seq'::regclass);
ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_c1 UNIQUE (name);
ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_pkey PRIMARY KEY (cv_id);

-- cvterm table comes from chado
CREATE SEQUENCE cvterm_cvterm_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE cvterm (
    cvterm_id integer NOT NULL,
    cv_id integer NOT NULL,
    name character varying(1024) NOT NULL,
    definition text,
    dbxref_id integer,
    is_obsolete integer DEFAULT 0 NOT NULL,
    is_relationshiptype integer DEFAULT 0 NOT NULL
);

CREATE TABLE pub_dbxref (
    pub_dbxref_id integer NOT NULL,
    pub_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    is_current boolean DEFAULT true NOT NULL
);

CREATE TABLE cvterm_dbxref (
    cvterm_dbxref_id integer NOT NULL,
    cvterm_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    is_for_definition integer DEFAULT 0 NOT NULL
);

CREATE TABLE pub (
    pub_id integer NOT NULL,
    title text,
    volumetitle text,
    volume character varying(255),
    series_name character varying(255),
    issue character varying(255),
    pyear character varying(255),
    pages character varying(255),
    miniref character varying(255),
    type_id integer,
    is_obsolete boolean DEFAULT false,
    publisher character varying(255),
    pubplace character varying(255),
    uniquename text NOT NULL
);


CREATE TABLE organism_dbxref (
    organism_dbxref_id integer NOT NULL,
    organism_id integer NOT NULL,
    dbxref_id integer NOT NULL
);

ALTER TABLE ONLY pub
    ADD CONSTRAINT pub_pkey PRIMARY KEY (pub_id);

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_db_id_key UNIQUE (db_id, accession, version);

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_pkey PRIMARY KEY (dbxref_id);

ALTER TABLE ONLY cvterm ALTER COLUMN cvterm_id
    SET DEFAULT nextval('cvterm_cvterm_id_seq'::regclass);

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_pkey PRIMARY KEY (cvterm_id);

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_cv_id_fkey FOREIGN KEY (cv_id) REFERENCES cv(cv_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_dbxref_id_fkey FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT "$2" FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


ALTER TABLE ONLY cvterm_dbxref
    ADD CONSTRAINT "$2" FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT "$1" FOREIGN KEY (pub_id) REFERENCES pub(pub_id) ON DELETE CASCADE;


ALTER TABLE ONLY organism_dbxref
    ADD CONSTRAINT "$1" FOREIGN KEY (organism_id) REFERENCES organism(organism_id) ON DELETE CASCADE;



CREATE TABLE organisation (
       organisation_id serial CONSTRAINT organisation_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       name text NOT NULL,
       description text
);
CREATE TABLE person (
       person_id serial CONSTRAINT person_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       first_name text NOT NULL,
       last_name text NOT NULL,
       user_name text UNIQUE NOT NULL,
       password text,
       organisation integer REFERENCES organisation(organisation_id) NOT NULL,
       CONSTRAINT person_full_name_constraint UNIQUE(first_name, last_name)
);
CREATE TABLE ecotype (
       ecotype_id serial CONSTRAINT ecotype_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       organism integer REFERENCES organism(organism_id) NOT NULL,
       description text NOT NULL
);
CREATE TABLE tissue (
       tissue_id SERIAL CONSTRAINT tissue_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       organism integer REFERENCES organism(organism_id) NOT NULL,
       description text
);
CREATE TABLE pipeproject (
       pipeproject_id serial CONSTRAINT pipeproject_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       name text NOT NULL,
       description text NOT NULL,
       type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       owner integer REFERENCES person(person_id) NOT NULL,
       funder integer REFERENCES organisation(organisation_id)
);
CREATE TABLE process_conf (
       process_conf_id serial CONSTRAINT process_conf_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       runable_name text,
       detail text,
       type integer REFERENCES cvterm(cvterm_id) NOT NULL
);
CREATE TABLE process_conf_input (
       process_conf_input_id serial CONSTRAINT process_conf_input_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       process_conf integer REFERENCES process_conf(process_conf_id) NOT NULL,
       format_type integer REFERENCES cvterm(cvterm_id),
       content_type integer REFERENCES cvterm(cvterm_id),
       ecotype integer REFERENCES ecotype(ecotype_id)
);
CREATE TABLE pipeprocess (
       pipeprocess_id serial CONSTRAINT pipeprocess_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       description text NOT NULL,
       process_conf integer REFERENCES process_conf(process_conf_id) NOT NULL,
       status integer REFERENCES cvterm(cvterm_id) NOT NULL,
       job_identifier text,
       time_queued timestamp,
       time_started timestamp,
       time_finished timestamp
);
CREATE TABLE barcode (
       barcode_id serial CONSTRAINT barcode_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       identifier text NOT NULL UNIQUE,
       code text NOT NULL UNIQUE
);
CREATE TABLE protocol (
       protocol_id serial CONSTRAINT protocol_id_pk PRIMARY KEY,
       name text UNIQUE NOT NULL,
       description text NOT NULL
);
CREATE TABLE sample (
       sample_id serial CONSTRAINT sample_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       name text NOT NULL UNIQUE,
       genotype text,
       description text NOT NULL,
       protocol integer NOT NULL REFERENCES protocol(protocol_id),
       molecule_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       treatment_type integer REFERENCES cvterm(cvterm_id),
       fractionation_type integer REFERENCES cvterm(cvterm_id),
       processing_requirement integer REFERENCES cvterm(cvterm_id) NOT NULL,
       tissue integer REFERENCES tissue(tissue_id)
);
CREATE TABLE sample_pipeproject (
       sample_pipeproject_id serial CONSTRAINT sample_pipeproject_id_pk PRIMARY KEY,
       sample integer REFERENCES sample(sample_id) NOT NULL,
       pipeproject integer REFERENCES pipeproject(pipeproject_id) NOT NULL,
       CONSTRAINT sample_pipeproject_constraint UNIQUE(sample, pipeproject)
);
CREATE TABLE pipedata (
       pipedata_id serial CONSTRAINT pipedata_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       format_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       content_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       file_name text UNIQUE NOT NULL,
       file_length bigint NOT NULL,
       generating_pipeprocess integer REFERENCES pipeprocess(pipeprocess_id)
);
CREATE TABLE pipeprocess_in_pipedata (
       pipeprocess_in_pipedata_id serial CONSTRAINT pipeprocess_in_pipedata_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       pipeprocess integer REFERENCES pipeprocess(pipeprocess_id),
       pipedata integer REFERENCES pipedata(pipedata_id),
       CONSTRAINT pipeprocess_in_pk_constraint UNIQUE(pipeprocess, pipedata)
);
COMMENT ON TABLE pipeprocess_in_pipedata IS
        'Join table containing the input pipedatas for a pipeprocess';
CREATE TABLE sample_pipedata (
       sample_pipedata_id serial CONSTRAINT sample_pipedata_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       sample integer REFERENCES sample(sample_id) NOT NULL,
       pipedata integer REFERENCES pipedata(pipedata_id) NOT NULL
);
CREATE TABLE sample_ecotype (
       sample_ecotype_id serial CONSTRAINT sample_ecotype_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       sample integer REFERENCES sample(sample_id) NOT NULL,
       ecotype integer REFERENCES ecotype(ecotype_id) NOT NULL,
       CONSTRAINT sample_ecotype_constraint UNIQUE(sample, ecotype)
);
CREATE TABLE sequencing_sample (
       sequencing_sample_id serial CONSTRAINT sequencing_sample_id_pk PRIMARY KEY,
       name text NOT NULL UNIQUE
);
CREATE TABLE sequencingrun (
       sequencingrun_id serial CONSTRAINT sequencingrun_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       identifier text NOT NULL UNIQUE,
       sequencing_sample integer NOT NULL REFERENCES sequencing_sample(sequencing_sample_id),
       -- set when fastq arrives:
       initial_pipedata integer REFERENCES pipedata(pipedata_id),
       sequencing_centre integer REFERENCES organisation(organisation_id) NOT NULL,
       -- set when fastq arrives:
       initial_pipeprocess integer REFERENCES pipeprocess(pipeprocess_id),
       submission_date date,
       run_date date,
       data_received_date date,
       quality integer REFERENCES cvterm(cvterm_id) NOT NULL,
       sequencing_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       multiplexing_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       -- set when analysis starts:
       CHECK (CASE WHEN run_date IS NULL THEN data_received_date IS NULL ELSE TRUE END)
);
CREATE TABLE coded_sample (
       coded_sample_id serial CONSTRAINT coded_sample_id_pk PRIMARY KEY,
       created_stamp timestamp NOT NULL DEFAULT now(),
       description text NOT NULL,
       coded_sample_type integer REFERENCES cvterm(cvterm_id) NOT NULL,
       sample integer REFERENCES sample(sample_id) NOT NULL,
       sequencing_sample integer REFERENCES sequencing_sample(sequencing_sample_id) NOT NULL,
       barcode integer REFERENCES barcode(barcode_id)
);
COMMENT ON TABLE coded_sample IS
  'This table records the many-to-many relationship between samples and '
  'sequencing runs and the type of the run (intial, re-run, replicate etc.)';
