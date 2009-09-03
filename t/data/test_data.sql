--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.tissue DROP CONSTRAINT tissue_organism_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_sequencing_type_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_sequencing_sample_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_sequencing_centre_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_quality_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_multiplexing_type_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_initial_pipeprocess_fkey;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_initial_pipedata_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_treatment_type_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_tissue_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_sample_type_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_protocol_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_processing_requirement_fkey;
ALTER TABLE ONLY public.sample_pipeproject DROP CONSTRAINT sample_pipeproject_sample_fkey;
ALTER TABLE ONLY public.sample_pipeproject DROP CONSTRAINT sample_pipeproject_pipeproject_fkey;
ALTER TABLE ONLY public.sample_pipedata DROP CONSTRAINT sample_pipedata_sample_fkey;
ALTER TABLE ONLY public.sample_pipedata DROP CONSTRAINT sample_pipedata_pipedata_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_molecule_type_fkey;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_fractionation_type_fkey;
ALTER TABLE ONLY public.sample_ecotype DROP CONSTRAINT sample_ecotype_sample_fkey;
ALTER TABLE ONLY public.sample_ecotype DROP CONSTRAINT sample_ecotype_ecotype_fkey;
ALTER TABLE ONLY public.sample_dbxref DROP CONSTRAINT sample_dbxref_sample_fk;
ALTER TABLE ONLY public.sample_dbxref DROP CONSTRAINT sample_dbxref_dbxref_fk;
ALTER TABLE ONLY public.pub DROP CONSTRAINT pub_type_id_fkey;
ALTER TABLE ONLY public.pub_dbxref DROP CONSTRAINT pub_dbxref_pub_id_fkey;
ALTER TABLE ONLY public.pub_dbxref DROP CONSTRAINT pub_dbxref_dbxref_id_fkey;
ALTER TABLE ONLY public.process_conf DROP CONSTRAINT process_conf_type_fkey;
ALTER TABLE ONLY public.process_conf_input DROP CONSTRAINT process_conf_input_process_conf_fkey;
ALTER TABLE ONLY public.process_conf_input DROP CONSTRAINT process_conf_input_format_type_fkey;
ALTER TABLE ONLY public.process_conf_input DROP CONSTRAINT process_conf_input_ecotype_fkey;
ALTER TABLE ONLY public.process_conf_input DROP CONSTRAINT process_conf_input_content_type_fkey;
ALTER TABLE ONLY public.pipeproject DROP CONSTRAINT pipeproject_type_fkey;
ALTER TABLE ONLY public.pipeproject DROP CONSTRAINT pipeproject_owner_fkey;
ALTER TABLE ONLY public.pipeproject DROP CONSTRAINT pipeproject_funder_fkey;
ALTER TABLE ONLY public.pipeprocess DROP CONSTRAINT pipeprocess_status_fkey;
ALTER TABLE ONLY public.pipeprocess_pub DROP CONSTRAINT pipeprocess_pub_pub_fk;
ALTER TABLE ONLY public.pipeprocess_pub DROP CONSTRAINT pipeprocess_pub_pipeprocess_fk;
ALTER TABLE ONLY public.pipeprocess DROP CONSTRAINT pipeprocess_process_conf_fkey;
ALTER TABLE ONLY public.pipeprocess_in_pipedata DROP CONSTRAINT pipeprocess_in_pipedata_pipeprocess_fkey;
ALTER TABLE ONLY public.pipeprocess_in_pipedata DROP CONSTRAINT pipeprocess_in_pipedata_pipedata_fkey;
ALTER TABLE ONLY public.pipedata_property DROP CONSTRAINT pipedata_property_type_fkey;
ALTER TABLE ONLY public.pipedata_property DROP CONSTRAINT pipedata_property_pipedata_fkey;
ALTER TABLE ONLY public.pipedata DROP CONSTRAINT pipedata_generating_pipeprocess_fkey;
ALTER TABLE ONLY public.pipedata DROP CONSTRAINT pipedata_format_type_fkey;
ALTER TABLE ONLY public.pipedata DROP CONSTRAINT pipedata_content_type_fkey;
ALTER TABLE ONLY public.person DROP CONSTRAINT person_role_fkey;
ALTER TABLE ONLY public.person DROP CONSTRAINT person_organisation_fkey;
ALTER TABLE ONLY public.organism_dbxref DROP CONSTRAINT organism_dbxref_organism_id_fkey;
ALTER TABLE ONLY public.organism_dbxref DROP CONSTRAINT organism_dbxref_dbxref_id_fkey;
ALTER TABLE ONLY public.ecotype DROP CONSTRAINT ecotype_organism_fkey;
ALTER TABLE ONLY public.dbxref DROP CONSTRAINT dbxref_db_id_fkey;
ALTER TABLE ONLY public.cvterm DROP CONSTRAINT cvterm_dbxref_id_fkey;
ALTER TABLE ONLY public.cvterm_dbxref DROP CONSTRAINT cvterm_dbxref_dbxref_id_fkey;
ALTER TABLE ONLY public.cvterm_dbxref DROP CONSTRAINT cvterm_dbxref_cvterm_id_fkey;
ALTER TABLE ONLY public.cvterm DROP CONSTRAINT cvterm_cv_id_fkey;
ALTER TABLE ONLY public.coded_sample DROP CONSTRAINT coded_sample_sequencing_sample_fkey;
ALTER TABLE ONLY public.coded_sample DROP CONSTRAINT coded_sample_sample_fkey;
ALTER TABLE ONLY public.coded_sample DROP CONSTRAINT coded_sample_coded_sample_type_fkey;
ALTER TABLE ONLY public.coded_sample DROP CONSTRAINT coded_sample_barcode_fkey;
ALTER TABLE ONLY public.barcode_set DROP CONSTRAINT barcode_set_position_in_read_fkey;
ALTER TABLE ONLY public.barcode DROP CONSTRAINT barcode_barcode_set_fkey;
DROP INDEX public.pub_idx1;
DROP INDEX public.pub_dbxref_idx2;
DROP INDEX public.pub_dbxref_idx1;
DROP INDEX public.organism_dbxref_idx2;
DROP INDEX public.organism_dbxref_idx1;
DROP INDEX public.dbxref_idx3;
DROP INDEX public.dbxref_idx2;
DROP INDEX public.dbxref_idx1;
DROP INDEX public.cvterm_idx3;
DROP INDEX public.cvterm_idx2;
DROP INDEX public.cvterm_idx1;
DROP INDEX public.cvterm_dbxref_idx2;
DROP INDEX public.cvterm_dbxref_idx1;
ALTER TABLE ONLY public.tissue DROP CONSTRAINT tissue_id_pk;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_identifier_key;
ALTER TABLE ONLY public.sequencingrun DROP CONSTRAINT sequencingrun_id_pk;
ALTER TABLE ONLY public.sequencing_sample DROP CONSTRAINT sequencing_sample_name_key;
ALTER TABLE ONLY public.sequencing_sample DROP CONSTRAINT sequencing_sample_id_pk;
ALTER TABLE ONLY public.sample_pipeproject DROP CONSTRAINT sample_pipeproject_id_pk;
ALTER TABLE ONLY public.sample_pipeproject DROP CONSTRAINT sample_pipeproject_constraint;
ALTER TABLE ONLY public.sample_pipedata DROP CONSTRAINT sample_pipedata_id_pk;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_name_key;
ALTER TABLE ONLY public.sample DROP CONSTRAINT sample_id_pk;
ALTER TABLE ONLY public.sample_ecotype DROP CONSTRAINT sample_ecotype_id_pk;
ALTER TABLE ONLY public.sample_ecotype DROP CONSTRAINT sample_ecotype_constraint;
ALTER TABLE ONLY public.pub DROP CONSTRAINT pub_pkey;
ALTER TABLE ONLY public.pub_dbxref DROP CONSTRAINT pub_dbxref_pkey;
ALTER TABLE ONLY public.pub_dbxref DROP CONSTRAINT pub_dbxref_c1;
ALTER TABLE ONLY public.pub DROP CONSTRAINT pub_c1;
ALTER TABLE ONLY public.protocol DROP CONSTRAINT protocol_name_key;
ALTER TABLE ONLY public.protocol DROP CONSTRAINT protocol_id_pk;
ALTER TABLE ONLY public.process_conf_input DROP CONSTRAINT process_conf_input_id_pk;
ALTER TABLE ONLY public.process_conf DROP CONSTRAINT process_conf_id_pk;
ALTER TABLE ONLY public.pipeproject DROP CONSTRAINT pipeproject_id_pk;
ALTER TABLE ONLY public.pipeprocess_pub DROP CONSTRAINT pipeprocess_pub_id_pk;
ALTER TABLE ONLY public.pipeprocess_in_pipedata DROP CONSTRAINT pipeprocess_in_pk_constraint;
ALTER TABLE ONLY public.pipeprocess_in_pipedata DROP CONSTRAINT pipeprocess_in_pipedata_id_pk;
ALTER TABLE ONLY public.pipeprocess DROP CONSTRAINT pipeprocess_id_pk;
ALTER TABLE ONLY public.pipedata_property DROP CONSTRAINT pipedata_property_id_pk;
ALTER TABLE ONLY public.pipedata DROP CONSTRAINT pipedata_id_pk;
ALTER TABLE ONLY public.pipedata DROP CONSTRAINT pipedata_file_name_key;
ALTER TABLE ONLY public.person DROP CONSTRAINT person_username_key;
ALTER TABLE ONLY public.person DROP CONSTRAINT person_id_pk;
ALTER TABLE ONLY public.person DROP CONSTRAINT person_full_name_constraint;
ALTER TABLE ONLY public.organism DROP CONSTRAINT organism_pkey;
ALTER TABLE ONLY public.organism_dbxref DROP CONSTRAINT organism_dbxref_pkey;
ALTER TABLE ONLY public.organism_dbxref DROP CONSTRAINT organism_dbxref_c1;
ALTER TABLE ONLY public.organism DROP CONSTRAINT organism_c1;
ALTER TABLE ONLY public.organisation DROP CONSTRAINT organisation_id_pk;
ALTER TABLE ONLY public.ecotype DROP CONSTRAINT ecotype_id_pk;
ALTER TABLE ONLY public.dbxref DROP CONSTRAINT dbxref_pkey;
ALTER TABLE ONLY public.dbxref DROP CONSTRAINT dbxref_c1;
ALTER TABLE ONLY public.db DROP CONSTRAINT db_pkey;
ALTER TABLE ONLY public.db DROP CONSTRAINT db_c1;
ALTER TABLE ONLY public.cvterm DROP CONSTRAINT cvterm_pkey;
ALTER TABLE ONLY public.cvterm_dbxref DROP CONSTRAINT cvterm_dbxref_pkey;
ALTER TABLE ONLY public.cvterm_dbxref DROP CONSTRAINT cvterm_dbxref_c1;
ALTER TABLE ONLY public.cvterm DROP CONSTRAINT cvterm_c2;
ALTER TABLE ONLY public.cvterm DROP CONSTRAINT cvterm_c1;
ALTER TABLE ONLY public.cv DROP CONSTRAINT cv_pkey;
ALTER TABLE ONLY public.cv DROP CONSTRAINT cv_c1;
ALTER TABLE ONLY public.coded_sample DROP CONSTRAINT coded_sample_id_pk;
ALTER TABLE ONLY public.barcode_set DROP CONSTRAINT barcode_set_name_key;
ALTER TABLE ONLY public.barcode_set DROP CONSTRAINT barcode_set_id_pk;
ALTER TABLE ONLY public.barcode DROP CONSTRAINT barcode_identifier_constraint;
ALTER TABLE ONLY public.barcode DROP CONSTRAINT barcode_id_pk;
ALTER TABLE ONLY public.barcode DROP CONSTRAINT barcode_code_constraint;
ALTER TABLE public.tissue ALTER COLUMN tissue_id DROP DEFAULT;
ALTER TABLE public.sequencingrun ALTER COLUMN sequencingrun_id DROP DEFAULT;
ALTER TABLE public.sequencing_sample ALTER COLUMN sequencing_sample_id DROP DEFAULT;
ALTER TABLE public.sample_pipeproject ALTER COLUMN sample_pipeproject_id DROP DEFAULT;
ALTER TABLE public.sample_pipedata ALTER COLUMN sample_pipedata_id DROP DEFAULT;
ALTER TABLE public.sample_ecotype ALTER COLUMN sample_ecotype_id DROP DEFAULT;
ALTER TABLE public.sample ALTER COLUMN sample_id DROP DEFAULT;
ALTER TABLE public.pub_dbxref ALTER COLUMN pub_dbxref_id DROP DEFAULT;
ALTER TABLE public.pub ALTER COLUMN pub_id DROP DEFAULT;
ALTER TABLE public.protocol ALTER COLUMN protocol_id DROP DEFAULT;
ALTER TABLE public.process_conf_input ALTER COLUMN process_conf_input_id DROP DEFAULT;
ALTER TABLE public.process_conf ALTER COLUMN process_conf_id DROP DEFAULT;
ALTER TABLE public.pipeproject ALTER COLUMN pipeproject_id DROP DEFAULT;
ALTER TABLE public.pipeprocess_pub ALTER COLUMN pipeprocess_pub_id DROP DEFAULT;
ALTER TABLE public.pipeprocess_in_pipedata ALTER COLUMN pipeprocess_in_pipedata_id DROP DEFAULT;
ALTER TABLE public.pipeprocess ALTER COLUMN pipeprocess_id DROP DEFAULT;
ALTER TABLE public.pipedata_property ALTER COLUMN pipedata_property_id DROP DEFAULT;
ALTER TABLE public.pipedata ALTER COLUMN pipedata_id DROP DEFAULT;
ALTER TABLE public.person ALTER COLUMN person_id DROP DEFAULT;
ALTER TABLE public.organism_dbxref ALTER COLUMN organism_dbxref_id DROP DEFAULT;
ALTER TABLE public.organism ALTER COLUMN organism_id DROP DEFAULT;
ALTER TABLE public.organisation ALTER COLUMN organisation_id DROP DEFAULT;
ALTER TABLE public.ecotype ALTER COLUMN ecotype_id DROP DEFAULT;
ALTER TABLE public.dbxref ALTER COLUMN dbxref_id DROP DEFAULT;
ALTER TABLE public.db ALTER COLUMN db_id DROP DEFAULT;
ALTER TABLE public.cvterm_dbxref ALTER COLUMN cvterm_dbxref_id DROP DEFAULT;
ALTER TABLE public.cvterm ALTER COLUMN cvterm_id DROP DEFAULT;
ALTER TABLE public.cv ALTER COLUMN cv_id DROP DEFAULT;
ALTER TABLE public.coded_sample ALTER COLUMN coded_sample_id DROP DEFAULT;
ALTER TABLE public.barcode_set ALTER COLUMN barcode_set_id DROP DEFAULT;
ALTER TABLE public.barcode ALTER COLUMN barcode_id DROP DEFAULT;
DROP SEQUENCE public.tissue_tissue_id_seq;
DROP SEQUENCE public.sequencingrun_sequencingrun_id_seq;
DROP SEQUENCE public.sequencing_sample_sequencing_sample_id_seq;
DROP SEQUENCE public.sample_sample_id_seq;
DROP SEQUENCE public.sample_pipeproject_sample_pipeproject_id_seq;
DROP SEQUENCE public.sample_pipedata_sample_pipedata_id_seq;
DROP SEQUENCE public.sample_ecotype_sample_ecotype_id_seq;
DROP SEQUENCE public.pub_pub_id_seq;
DROP SEQUENCE public.pub_dbxref_pub_dbxref_id_seq;
DROP SEQUENCE public.protocol_protocol_id_seq;
DROP SEQUENCE public.process_conf_process_conf_id_seq;
DROP SEQUENCE public.process_conf_input_process_conf_input_id_seq;
DROP SEQUENCE public.pipeproject_pipeproject_id_seq;
DROP SEQUENCE public.pipeprocess_pub_pipeprocess_pub_id_seq;
DROP SEQUENCE public.pipeprocess_pipeprocess_id_seq;
DROP SEQUENCE public.pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq;
DROP SEQUENCE public.pipedata_property_pipedata_property_id_seq;
DROP SEQUENCE public.pipedata_pipedata_id_seq;
DROP SEQUENCE public.person_person_id_seq;
DROP SEQUENCE public.organism_organism_id_seq;
DROP SEQUENCE public.organism_dbxref_organism_dbxref_id_seq;
DROP SEQUENCE public.organisation_organisation_id_seq;
DROP SEQUENCE public.ecotype_ecotype_id_seq;
DROP SEQUENCE public.dbxref_dbxref_id_seq;
DROP SEQUENCE public.db_db_id_seq;
DROP SEQUENCE public.cvterm_dbxref_cvterm_dbxref_id_seq;
DROP SEQUENCE public.cvterm_cvterm_id_seq;
DROP SEQUENCE public.cv_cv_id_seq;
DROP SEQUENCE public.coded_sample_coded_sample_id_seq;
DROP SEQUENCE public.barcode_set_barcode_set_id_seq;
DROP SEQUENCE public.barcode_barcode_id_seq;
DROP OPERATOR CLASS public.gist_bioseg_ops USING gist;
DROP OPERATOR CLASS public.bioseg_ops USING btree;
DROP OPERATOR public.@> (bioseg, bioseg);
DROP OPERATOR public.>> (bioseg, bioseg);
DROP OPERATOR public.>= (bioseg, bioseg);
DROP OPERATOR public.> (bioseg, bioseg);
DROP OPERATOR public.= (bioseg, bioseg);
DROP OPERATOR public.<@ (bioseg, bioseg);
DROP OPERATOR public.<> (bioseg, bioseg);
DROP OPERATOR public.<= (bioseg, bioseg);
DROP OPERATOR public.<< (bioseg, bioseg);
DROP OPERATOR public.< (bioseg, bioseg);
DROP OPERATOR public.&> (bioseg, bioseg);
DROP OPERATOR public.&< (bioseg, bioseg);
DROP OPERATOR public.&& (bioseg, bioseg);
DROP FUNCTION public.bioseg_upper(bioseg);
DROP FUNCTION public.bioseg_size(bioseg);
DROP FUNCTION public.bioseg_sel(internal, oid, internal, integer);
DROP FUNCTION public.bioseg_same(bioseg, bioseg);
DROP FUNCTION public.bioseg_right(bioseg, bioseg);
DROP FUNCTION public.bioseg_overlap(bioseg, bioseg);
DROP FUNCTION public.bioseg_over_right(bioseg, bioseg);
DROP FUNCTION public.bioseg_over_left(bioseg, bioseg);
DROP FUNCTION public.bioseg_lt(bioseg, bioseg);
DROP FUNCTION public.bioseg_lower(bioseg);
DROP FUNCTION public.bioseg_left(bioseg, bioseg);
DROP FUNCTION public.bioseg_le(bioseg, bioseg);
DROP FUNCTION public.bioseg_joinsel(internal, oid, internal, smallint);
DROP FUNCTION public.bioseg_gt(bioseg, bioseg);
DROP FUNCTION public.bioseg_gist_union(internal, internal);
DROP FUNCTION public.bioseg_gist_same(bioseg, bioseg, internal);
DROP FUNCTION public.bioseg_gist_picksplit(internal, internal);
DROP FUNCTION public.bioseg_gist_penalty(internal, internal, internal);
DROP FUNCTION public.bioseg_gist_decompress(internal);
DROP FUNCTION public.bioseg_gist_consistent(internal, bioseg, integer);
DROP FUNCTION public.bioseg_gist_compress(internal);
DROP FUNCTION public.bioseg_ge(bioseg, bioseg);
DROP FUNCTION public.bioseg_different(bioseg, bioseg);
DROP FUNCTION public.bioseg_create(integer, integer);
DROP FUNCTION public.bioseg_contsel(internal, oid, internal, integer);
DROP FUNCTION public.bioseg_contjoinsel(internal, oid, internal, smallint);
DROP FUNCTION public.bioseg_contains(bioseg, bioseg);
DROP FUNCTION public.bioseg_contained(bioseg, bioseg);
DROP FUNCTION public.bioseg_cmp(bioseg, bioseg);
DROP TABLE public.tissue;
DROP TABLE public.sequencingrun;
DROP TABLE public.sequencing_sample;
DROP TABLE public.sample_pipeproject;
DROP TABLE public.sample_pipedata;
DROP TABLE public.sample_ecotype;
DROP TABLE public.sample_dbxref;
DROP TABLE public.sample;
DROP TABLE public.pub_dbxref;
DROP TABLE public.pub;
DROP TABLE public.protocol;
DROP TABLE public.process_conf_input;
DROP TABLE public.process_conf;
DROP TABLE public.pipeproject;
DROP TABLE public.pipeprocess_pub;
DROP TABLE public.pipeprocess_in_pipedata;
DROP TABLE public.pipeprocess;
DROP TABLE public.pipedata_property;
DROP TABLE public.pipedata;
DROP TABLE public.person;
DROP TABLE public.organism_dbxref;
DROP TABLE public.organism;
DROP TABLE public.organisation;
DROP TABLE public.ecotype;
DROP TABLE public.dbxref;
DROP TABLE public.db;
DROP TABLE public.cvterm_dbxref;
DROP TABLE public.cvterm;
DROP TABLE public.cv;
DROP TABLE public.coded_sample;
DROP TYPE public.bioseg CASCADE;
DROP FUNCTION public.bioseg_out(bioseg);
DROP FUNCTION public.bioseg_in(cstring);
DROP TABLE public.barcode_set;
DROP TABLE public.barcode;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: barcode; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE barcode (
    barcode_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    identifier text NOT NULL,
    barcode_set integer NOT NULL,
    code text NOT NULL
);


ALTER TABLE public.barcode OWNER TO kmr44;

--
-- Name: barcode_set; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE barcode_set (
    barcode_set_id integer NOT NULL,
    position_in_read integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.barcode_set OWNER TO kmr44;

--
-- Name: bioseg; Type: SHELL TYPE; Schema: public; Owner: postgres
--

CREATE TYPE bioseg;


--
-- Name: bioseg_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_in(cstring) RETURNS bioseg
    AS '$libdir/bioseg', 'bioseg_in'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_in(cstring) OWNER TO postgres;

--
-- Name: bioseg_out(bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_out(bioseg) RETURNS cstring
    AS '$libdir/bioseg', 'bioseg_out'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_out(bioseg) OWNER TO postgres;

--
-- Name: bioseg; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE bioseg (
    INTERNALLENGTH = 8,
    INPUT = bioseg_in,
    OUTPUT = bioseg_out,
    ALIGNMENT = int4,
    STORAGE = plain
);


ALTER TYPE public.bioseg OWNER TO postgres;

--
-- Name: TYPE bioseg; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE bioseg IS 'integer point interval ''INT..INT'', ''INT...INT'', or ''INT''';


--
-- Name: coded_sample; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE coded_sample (
    coded_sample_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    description text,
    coded_sample_type integer NOT NULL,
    sample integer NOT NULL,
    sequencing_sample integer,
    barcode integer
);


ALTER TABLE public.coded_sample OWNER TO kmr44;

--
-- Name: TABLE coded_sample; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE coded_sample IS 'This table records the many-to-many relationship between samples and sequencing runs and the type of the run (intial, re-run, replicate etc.)';


--
-- Name: cv; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE cv (
    cv_id integer NOT NULL,
    name character varying(255) NOT NULL,
    definition text
);


ALTER TABLE public.cv OWNER TO kmr44;

--
-- Name: TABLE cv; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE cv IS 'A controlled vocabulary or ontology. A cv is
composed of cvterms (AKA terms, classes, types, universals - relations
and properties are also stored in cvterm) and the relationships
between them.';


--
-- Name: COLUMN cv.name; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cv.name IS 'The name of the ontology. This
corresponds to the obo-format -namespace-. cv names uniquely identify
the cv. In OBO file format, the cv.name is known as the namespace.';


--
-- Name: COLUMN cv.definition; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cv.definition IS 'A text description of the criteria for
membership of this ontology.';


--
-- Name: cvterm; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE cvterm (
    cvterm_id integer NOT NULL,
    cv_id integer NOT NULL,
    name character varying(1024) NOT NULL,
    definition text,
    dbxref_id integer NOT NULL,
    is_obsolete integer DEFAULT 0 NOT NULL,
    is_relationshiptype integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.cvterm OWNER TO kmr44;

--
-- Name: TABLE cvterm; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE cvterm IS 'A term, class, universal or type within an
ontology or controlled vocabulary.  This table is also used for
relations and properties. cvterms constitute nodes in the graph
defined by the collection of cvterms and cvterm_relationships.';


--
-- Name: COLUMN cvterm.cv_id; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.cv_id IS 'The cv or ontology or namespace to which
this cvterm belongs.';


--
-- Name: COLUMN cvterm.name; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.name IS 'A concise human-readable name or
label for the cvterm. Uniquely identifies a cvterm within a cv.';


--
-- Name: COLUMN cvterm.definition; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.definition IS 'A human-readable text
definition.';


--
-- Name: COLUMN cvterm.dbxref_id; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.dbxref_id IS 'Primary identifier dbxref - The
unique global OBO identifier for this cvterm.  Note that a cvterm may
have multiple secondary dbxrefs - see also table: cvterm_dbxref.';


--
-- Name: COLUMN cvterm.is_obsolete; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.is_obsolete IS 'Boolean 0=false,1=true; see
GO documentation for details of obsoletion. Note that two terms with
different primary dbxrefs may exist if one is obsolete.';


--
-- Name: COLUMN cvterm.is_relationshiptype; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm.is_relationshiptype IS 'Boolean
0=false,1=true relations or relationship types (also known as Typedefs
in OBO format, or as properties or slots) form a cv/ontology in
themselves. We use this flag to indicate whether this cvterm is an
actual term/class/universal or a relation. Relations may be drawn from
the OBO Relations ontology, but are not exclusively drawn from there.';


--
-- Name: cvterm_dbxref; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE cvterm_dbxref (
    cvterm_dbxref_id integer NOT NULL,
    cvterm_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    is_for_definition integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.cvterm_dbxref OWNER TO kmr44;

--
-- Name: TABLE cvterm_dbxref; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE cvterm_dbxref IS 'In addition to the primary
identifier (cvterm.dbxref_id) a cvterm can have zero or more secondary
identifiers/dbxrefs, which may refer to records in external
databases. The exact semantics of cvterm_dbxref are not fixed. For
example: the dbxref could be a pubmed ID that is pertinent to the
cvterm, or it could be an equivalent or similar term in another
ontology. For example, GO cvterms are typically linked to InterPro
IDs, even though the nature of the relationship between them is
largely one of statistical association. The dbxref may be have data
records attached in the same database instance, or it could be a
"hanging" dbxref pointing to some external database. NOTE: If the
desired objective is to link two cvterms together, and the nature of
the relation is known and holds for all instances of the subject
cvterm then consider instead using cvterm_relationship together with a
well-defined relation.';


--
-- Name: COLUMN cvterm_dbxref.is_for_definition; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN cvterm_dbxref.is_for_definition IS 'A
cvterm.definition should be supported by one or more references. If
this column is true, the dbxref is not for a term in an external database -
it is a dbxref for provenance information for the definition.';


--
-- Name: db; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE db (
    db_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    urlprefix character varying(255),
    url character varying(255)
);


ALTER TABLE public.db OWNER TO kmr44;

--
-- Name: TABLE db; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE db IS 'A database authority. Typical databases in
bioinformatics are FlyBase, GO, UniProt, NCBI, MGI, etc. The authority
is generally known by this shortened form, which is unique within the
bioinformatics and biomedical realm.  To Do - add support for URIs,
URNs (e.g. LSIDs). We can do this by treating the URL as a URI -
however, some applications may expect this to be resolvable - to be
decided.';


--
-- Name: dbxref; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE dbxref (
    dbxref_id integer NOT NULL,
    db_id integer NOT NULL,
    accession character varying(255) NOT NULL,
    version character varying(255) DEFAULT ''::character varying NOT NULL,
    description text
);


ALTER TABLE public.dbxref OWNER TO kmr44;

--
-- Name: TABLE dbxref; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE dbxref IS 'A unique, global, public, stable identifier. Not necessarily an external reference - can reference data items inside the particular chado instance being used. Typically a row in a table can be uniquely identified with a primary identifier (called dbxref_id); a table may also have secondary identifiers (in a linking table <T>_dbxref). A dbxref is generally written as <DB>:<ACCESSION> or as <DB>:<ACCESSION>:<VERSION>.';


--
-- Name: COLUMN dbxref.accession; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN dbxref.accession IS 'The local part of the identifier. Guaranteed by the db authority to be unique for that db.';


--
-- Name: ecotype; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE ecotype (
    ecotype_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    organism integer NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.ecotype OWNER TO kmr44;

--
-- Name: organisation; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE organisation (
    organisation_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.organisation OWNER TO kmr44;

--
-- Name: organism; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE organism (
    organism_id integer NOT NULL,
    abbreviation character varying(255),
    genus character varying(255) NOT NULL,
    species character varying(255) NOT NULL,
    common_name character varying(255),
    comment text
);


ALTER TABLE public.organism OWNER TO kmr44;

--
-- Name: TABLE organism; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE organism IS 'The organismal taxonomic
classification. Note that phylogenies are represented using the
phylogeny module, and taxonomies can be represented using the cvterm
module or the phylogeny module.';


--
-- Name: COLUMN organism.species; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN organism.species IS 'A type of organism is always
uniquely identified by genus and species. When mapping from the NCBI
taxonomy names.dmp file, this column must be used where it
is present, as the common_name column is not always unique (e.g. environmental
samples). If a particular strain or subspecies is to be represented,
this is appended onto the species name. Follows standard NCBI taxonomy
pattern.';


--
-- Name: organism_dbxref; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE organism_dbxref (
    organism_dbxref_id integer NOT NULL,
    organism_id integer NOT NULL,
    dbxref_id integer NOT NULL
);


ALTER TABLE public.organism_dbxref OWNER TO kmr44;

--
-- Name: person; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE person (
    person_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    username text NOT NULL,
    password text,
    role integer NOT NULL,
    organisation integer NOT NULL
);


ALTER TABLE public.person OWNER TO kmr44;

--
-- Name: pipedata; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipedata (
    pipedata_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    format_type integer NOT NULL,
    content_type integer NOT NULL,
    file_name text NOT NULL,
    file_length bigint NOT NULL,
    generating_pipeprocess integer
);


ALTER TABLE public.pipedata OWNER TO kmr44;

--
-- Name: pipedata_property; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipedata_property (
    pipedata_property_id integer NOT NULL,
    pipedata integer NOT NULL,
    type integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.pipedata_property OWNER TO kmr44;

--
-- Name: pipeprocess; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipeprocess (
    pipeprocess_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    description text NOT NULL,
    process_conf integer NOT NULL,
    status integer NOT NULL,
    job_identifier text,
    time_queued timestamp without time zone,
    time_started timestamp without time zone,
    time_finished timestamp without time zone
);


ALTER TABLE public.pipeprocess OWNER TO kmr44;

--
-- Name: pipeprocess_in_pipedata; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipeprocess_in_pipedata (
    pipeprocess_in_pipedata_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    pipeprocess integer,
    pipedata integer
);


ALTER TABLE public.pipeprocess_in_pipedata OWNER TO kmr44;

--
-- Name: TABLE pipeprocess_in_pipedata; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE pipeprocess_in_pipedata IS 'Join table containing the input pipedatas for a pipeprocess';


--
-- Name: pipeprocess_pub; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipeprocess_pub (
    pipeprocess_pub_id integer NOT NULL,
    pipeprocess_id integer NOT NULL,
    pub_id integer NOT NULL
);


ALTER TABLE public.pipeprocess_pub OWNER TO kmr44;

--
-- Name: pipeproject; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pipeproject (
    pipeproject_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    type integer NOT NULL,
    owner integer NOT NULL,
    funder integer
);


ALTER TABLE public.pipeproject OWNER TO kmr44;

--
-- Name: process_conf; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE process_conf (
    process_conf_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    runable_name text,
    detail text,
    type integer NOT NULL
);


ALTER TABLE public.process_conf OWNER TO kmr44;

--
-- Name: process_conf_input; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE process_conf_input (
    process_conf_input_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    process_conf integer NOT NULL,
    format_type integer,
    content_type integer,
    ecotype integer
);


ALTER TABLE public.process_conf_input OWNER TO kmr44;

--
-- Name: protocol; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE protocol (
    protocol_id integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.protocol OWNER TO kmr44;

--
-- Name: pub; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

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
    uniquename text NOT NULL,
    type_id integer NOT NULL,
    is_obsolete boolean DEFAULT false,
    publisher character varying(255),
    pubplace character varying(255)
);


ALTER TABLE public.pub OWNER TO kmr44;

--
-- Name: TABLE pub; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE pub IS 'A documented provenance artefact - publications,
documents, personal communication.';


--
-- Name: COLUMN pub.title; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN pub.title IS 'Descriptive general heading.';


--
-- Name: COLUMN pub.volumetitle; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN pub.volumetitle IS 'Title of part if one of a series.';


--
-- Name: COLUMN pub.series_name; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN pub.series_name IS 'Full name of (journal) series.';


--
-- Name: COLUMN pub.pages; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN pub.pages IS 'Page number range[s], e.g. 457--459, viii + 664pp, lv--lvii.';


--
-- Name: COLUMN pub.type_id; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON COLUMN pub.type_id IS 'The type of the publication (book, journal, poem, graffiti, etc). Uses pub cv.';


--
-- Name: pub_dbxref; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE pub_dbxref (
    pub_dbxref_id integer NOT NULL,
    pub_id integer NOT NULL,
    dbxref_id integer NOT NULL,
    is_current boolean DEFAULT true NOT NULL
);


ALTER TABLE public.pub_dbxref OWNER TO kmr44;

--
-- Name: TABLE pub_dbxref; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON TABLE pub_dbxref IS 'Handle links to repositories,
e.g. Pubmed, Biosis, zoorec, OCLC, Medline, ISSN, coden...';


--
-- Name: sample; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sample (
    sample_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    name text NOT NULL,
    genotype text,
    description text NOT NULL,
    protocol integer NOT NULL,
    sample_type integer NOT NULL,
    molecule_type integer NOT NULL,
    treatment_type integer,
    fractionation_type integer,
    processing_requirement integer NOT NULL,
    tissue integer
);


ALTER TABLE public.sample OWNER TO kmr44;

--
-- Name: sample_dbxref; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sample_dbxref (
    sample_dbxref_id integer NOT NULL,
    sample_id integer NOT NULL,
    dbxref_id integer NOT NULL
);


ALTER TABLE public.sample_dbxref OWNER TO kmr44;

--
-- Name: sample_ecotype; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sample_ecotype (
    sample_ecotype_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    sample integer NOT NULL,
    ecotype integer NOT NULL
);


ALTER TABLE public.sample_ecotype OWNER TO kmr44;

--
-- Name: sample_pipedata; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sample_pipedata (
    sample_pipedata_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    sample integer NOT NULL,
    pipedata integer NOT NULL
);


ALTER TABLE public.sample_pipedata OWNER TO kmr44;

--
-- Name: sample_pipeproject; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sample_pipeproject (
    sample_pipeproject_id integer NOT NULL,
    sample integer NOT NULL,
    pipeproject integer NOT NULL
);


ALTER TABLE public.sample_pipeproject OWNER TO kmr44;

--
-- Name: sequencing_sample; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sequencing_sample (
    sequencing_sample_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.sequencing_sample OWNER TO kmr44;

--
-- Name: sequencingrun; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE sequencingrun (
    sequencingrun_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    identifier text NOT NULL,
    sequencing_sample integer NOT NULL,
    initial_pipedata integer,
    sequencing_centre integer NOT NULL,
    initial_pipeprocess integer,
    submission_date date,
    run_date date,
    data_received_date date,
    quality integer NOT NULL,
    sequencing_type integer NOT NULL,
    multiplexing_type integer NOT NULL,
    CONSTRAINT sequencingrun_check CHECK (CASE WHEN (run_date IS NULL) THEN (data_received_date IS NULL) ELSE true END)
);


ALTER TABLE public.sequencingrun OWNER TO kmr44;

--
-- Name: tissue; Type: TABLE; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE TABLE tissue (
    tissue_id integer NOT NULL,
    created_stamp timestamp without time zone DEFAULT now() NOT NULL,
    organism integer NOT NULL,
    description text
);


ALTER TABLE public.tissue OWNER TO kmr44;

--
-- Name: bioseg_cmp(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_cmp(bioseg, bioseg) RETURNS integer
    AS '$libdir/bioseg', 'bioseg_cmp'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_cmp(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_cmp(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_cmp(bioseg, bioseg) IS 'btree comparison function';


--
-- Name: bioseg_contained(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_contained(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_contained'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_contained(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_contained(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_contained(bioseg, bioseg) IS 'contained in';


--
-- Name: bioseg_contains(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_contains(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_contains'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_contains(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_contains(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_contains(bioseg, bioseg) IS 'contains';


--
-- Name: bioseg_contjoinsel(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_contjoinsel(internal, oid, internal, smallint) RETURNS double precision
    AS '$libdir/bioseg', 'bioseg_contjoinsel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_contjoinsel(internal, oid, internal, smallint) OWNER TO postgres;

--
-- Name: bioseg_contsel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_contsel(internal, oid, internal, integer) RETURNS double precision
    AS '$libdir/bioseg', 'bioseg_contsel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_contsel(internal, oid, internal, integer) OWNER TO postgres;

--
-- Name: bioseg_create(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_create(integer, integer) RETURNS bioseg
    AS '$libdir/bioseg', 'bioseg_create'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_create(integer, integer) OWNER TO postgres;

--
-- Name: bioseg_different(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_different(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_different'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_different(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_different(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_different(bioseg, bioseg) IS 'different';


--
-- Name: bioseg_ge(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_ge(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_ge'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_ge(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_ge(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_ge(bioseg, bioseg) IS 'greater than or equal';


--
-- Name: bioseg_gist_compress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_compress(internal) RETURNS internal
    AS '$libdir/bioseg', 'bioseg_gist_compress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_compress(internal) OWNER TO postgres;

--
-- Name: bioseg_gist_consistent(internal, bioseg, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_consistent(internal, bioseg, integer) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_gist_consistent'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_consistent(internal, bioseg, integer) OWNER TO postgres;

--
-- Name: bioseg_gist_decompress(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_decompress(internal) RETURNS internal
    AS '$libdir/bioseg', 'bioseg_gist_decompress'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_decompress(internal) OWNER TO postgres;

--
-- Name: bioseg_gist_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_penalty(internal, internal, internal) RETURNS internal
    AS '$libdir/bioseg', 'bioseg_gist_penalty'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_gist_penalty(internal, internal, internal) OWNER TO postgres;

--
-- Name: bioseg_gist_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_picksplit(internal, internal) RETURNS internal
    AS '$libdir/bioseg', 'bioseg_gist_picksplit'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_picksplit(internal, internal) OWNER TO postgres;

--
-- Name: bioseg_gist_same(bioseg, bioseg, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_same(bioseg, bioseg, internal) RETURNS internal
    AS '$libdir/bioseg', 'bioseg_gist_same'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_same(bioseg, bioseg, internal) OWNER TO postgres;

--
-- Name: bioseg_gist_union(internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gist_union(internal, internal) RETURNS bioseg
    AS '$libdir/bioseg', 'bioseg_gist_union'
    LANGUAGE c IMMUTABLE;


ALTER FUNCTION public.bioseg_gist_union(internal, internal) OWNER TO postgres;

--
-- Name: bioseg_gt(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_gt(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_gt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_gt(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_gt(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_gt(bioseg, bioseg) IS 'greater than';


--
-- Name: bioseg_joinsel(internal, oid, internal, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_joinsel(internal, oid, internal, smallint) RETURNS double precision
    AS '$libdir/bioseg', 'bioseg_joinsel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_joinsel(internal, oid, internal, smallint) OWNER TO postgres;

--
-- Name: bioseg_le(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_le(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_le'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_le(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_le(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_le(bioseg, bioseg) IS 'less than or equal';


--
-- Name: bioseg_left(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_left(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_left'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_left(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_left(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_left(bioseg, bioseg) IS 'is left of';


--
-- Name: bioseg_lower(bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_lower(bioseg) RETURNS integer
    AS '$libdir/bioseg', 'bioseg_lower'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_lower(bioseg) OWNER TO postgres;

--
-- Name: bioseg_lt(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_lt(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_lt'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_lt(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_lt(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_lt(bioseg, bioseg) IS 'less than';


--
-- Name: bioseg_over_left(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_over_left(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_over_left'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_over_left(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_over_left(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_over_left(bioseg, bioseg) IS 'overlaps or is left of';


--
-- Name: bioseg_over_right(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_over_right(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_over_right'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_over_right(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_over_right(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_over_right(bioseg, bioseg) IS 'overlaps or is right of';


--
-- Name: bioseg_overlap(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_overlap(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_overlap'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_overlap(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_overlap(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_overlap(bioseg, bioseg) IS 'overlaps';


--
-- Name: bioseg_right(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_right(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_right'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_right(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_right(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_right(bioseg, bioseg) IS 'is right of';


--
-- Name: bioseg_same(bioseg, bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_same(bioseg, bioseg) RETURNS boolean
    AS '$libdir/bioseg', 'bioseg_same'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_same(bioseg, bioseg) OWNER TO postgres;

--
-- Name: FUNCTION bioseg_same(bioseg, bioseg); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION bioseg_same(bioseg, bioseg) IS 'same as';


--
-- Name: bioseg_sel(internal, oid, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_sel(internal, oid, internal, integer) RETURNS double precision
    AS '$libdir/bioseg', 'bioseg_sel'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_sel(internal, oid, internal, integer) OWNER TO postgres;

--
-- Name: bioseg_size(bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_size(bioseg) RETURNS integer
    AS '$libdir/bioseg', 'bioseg_size'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_size(bioseg) OWNER TO postgres;

--
-- Name: bioseg_upper(bioseg); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bioseg_upper(bioseg) RETURNS integer
    AS '$libdir/bioseg', 'bioseg_upper'
    LANGUAGE c IMMUTABLE STRICT;


ALTER FUNCTION public.bioseg_upper(bioseg) OWNER TO postgres;

--
-- Name: &&; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR && (
    PROCEDURE = bioseg_overlap,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = &&,
    RESTRICT = bioseg_sel,
    JOIN = bioseg_joinsel
);


ALTER OPERATOR public.&& (bioseg, bioseg) OWNER TO postgres;

--
-- Name: &<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &< (
    PROCEDURE = bioseg_over_left,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&< (bioseg, bioseg) OWNER TO postgres;

--
-- Name: &>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR &> (
    PROCEDURE = bioseg_over_right,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.&> (bioseg, bioseg) OWNER TO postgres;

--
-- Name: <; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR < (
    PROCEDURE = bioseg_lt,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = >,
    NEGATOR = >=,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.< (bioseg, bioseg) OWNER TO postgres;

--
-- Name: <<; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR << (
    PROCEDURE = bioseg_left,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = >>,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.<< (bioseg, bioseg) OWNER TO postgres;

--
-- Name: <=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <= (
    PROCEDURE = bioseg_le,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = >=,
    NEGATOR = >,
    RESTRICT = scalarltsel,
    JOIN = scalarltjoinsel
);


ALTER OPERATOR public.<= (bioseg, bioseg) OWNER TO postgres;

--
-- Name: <>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <> (
    PROCEDURE = bioseg_different,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = <>,
    NEGATOR = =,
    RESTRICT = neqsel,
    JOIN = neqjoinsel
);


ALTER OPERATOR public.<> (bioseg, bioseg) OWNER TO postgres;

--
-- Name: <@; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR <@ (
    PROCEDURE = bioseg_contained,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = @>,
    RESTRICT = bioseg_contsel,
    JOIN = bioseg_contjoinsel
);


ALTER OPERATOR public.<@ (bioseg, bioseg) OWNER TO postgres;

--
-- Name: =; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR = (
    PROCEDURE = bioseg_same,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = =,
    NEGATOR = <>,
    MERGES,
    RESTRICT = eqsel,
    JOIN = eqjoinsel
);


ALTER OPERATOR public.= (bioseg, bioseg) OWNER TO postgres;

--
-- Name: >; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR > (
    PROCEDURE = bioseg_gt,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = <,
    NEGATOR = <=,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.> (bioseg, bioseg) OWNER TO postgres;

--
-- Name: >=; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >= (
    PROCEDURE = bioseg_ge,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = <=,
    NEGATOR = <,
    RESTRICT = scalargtsel,
    JOIN = scalargtjoinsel
);


ALTER OPERATOR public.>= (bioseg, bioseg) OWNER TO postgres;

--
-- Name: >>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR >> (
    PROCEDURE = bioseg_right,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = <<,
    RESTRICT = positionsel,
    JOIN = positionjoinsel
);


ALTER OPERATOR public.>> (bioseg, bioseg) OWNER TO postgres;

--
-- Name: @>; Type: OPERATOR; Schema: public; Owner: postgres
--

CREATE OPERATOR @> (
    PROCEDURE = bioseg_contains,
    LEFTARG = bioseg,
    RIGHTARG = bioseg,
    COMMUTATOR = <@,
    RESTRICT = bioseg_contsel,
    JOIN = bioseg_contjoinsel
);


ALTER OPERATOR public.@> (bioseg, bioseg) OWNER TO postgres;

--
-- Name: bioseg_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS bioseg_ops
    DEFAULT FOR TYPE bioseg USING btree AS
    OPERATOR 1 <(bioseg,bioseg) ,
    OPERATOR 2 <=(bioseg,bioseg) ,
    OPERATOR 3 =(bioseg,bioseg) ,
    OPERATOR 4 >=(bioseg,bioseg) ,
    OPERATOR 5 >(bioseg,bioseg) ,
    FUNCTION 1 bioseg_cmp(bioseg,bioseg);


ALTER OPERATOR CLASS public.bioseg_ops USING btree OWNER TO postgres;

--
-- Name: gist_bioseg_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS gist_bioseg_ops
    DEFAULT FOR TYPE bioseg USING gist AS
    OPERATOR 1 <<(bioseg,bioseg) ,
    OPERATOR 2 &<(bioseg,bioseg) ,
    OPERATOR 3 &&(bioseg,bioseg) ,
    OPERATOR 4 &>(bioseg,bioseg) ,
    OPERATOR 5 >>(bioseg,bioseg) ,
    OPERATOR 6 =(bioseg,bioseg) ,
    OPERATOR 7 @>(bioseg,bioseg) ,
    OPERATOR 8 <@(bioseg,bioseg) ,
    FUNCTION 1 bioseg_gist_consistent(internal,bioseg,integer) ,
    FUNCTION 2 bioseg_gist_union(internal,internal) ,
    FUNCTION 3 bioseg_gist_compress(internal) ,
    FUNCTION 4 bioseg_gist_decompress(internal) ,
    FUNCTION 5 bioseg_gist_penalty(internal,internal,internal) ,
    FUNCTION 6 bioseg_gist_picksplit(internal,internal) ,
    FUNCTION 7 bioseg_gist_same(bioseg,bioseg,internal);


ALTER OPERATOR CLASS public.gist_bioseg_ops USING gist OWNER TO postgres;

--
-- Name: barcode_barcode_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE barcode_barcode_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.barcode_barcode_id_seq OWNER TO kmr44;

--
-- Name: barcode_barcode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE barcode_barcode_id_seq OWNED BY barcode.barcode_id;


--
-- Name: barcode_barcode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('barcode_barcode_id_seq', 27, true);


--
-- Name: barcode_set_barcode_set_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE barcode_set_barcode_set_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.barcode_set_barcode_set_id_seq OWNER TO kmr44;

--
-- Name: barcode_set_barcode_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE barcode_set_barcode_set_id_seq OWNED BY barcode_set.barcode_set_id;


--
-- Name: barcode_set_barcode_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('barcode_set_barcode_set_id_seq', 2, true);


--
-- Name: coded_sample_coded_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE coded_sample_coded_sample_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.coded_sample_coded_sample_id_seq OWNER TO kmr44;

--
-- Name: coded_sample_coded_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE coded_sample_coded_sample_id_seq OWNED BY coded_sample.coded_sample_id;


--
-- Name: coded_sample_coded_sample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('coded_sample_coded_sample_id_seq', 9, true);


--
-- Name: cv_cv_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE cv_cv_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cv_cv_id_seq OWNER TO kmr44;

--
-- Name: cv_cv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE cv_cv_id_seq OWNED BY cv.cv_id;


--
-- Name: cv_cv_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('cv_cv_id_seq', 18, true);


--
-- Name: cvterm_cvterm_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE cvterm_cvterm_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cvterm_cvterm_id_seq OWNER TO kmr44;

--
-- Name: cvterm_cvterm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE cvterm_cvterm_id_seq OWNED BY cvterm.cvterm_id;


--
-- Name: cvterm_cvterm_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('cvterm_cvterm_id_seq', 93, true);


--
-- Name: cvterm_dbxref_cvterm_dbxref_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE cvterm_dbxref_cvterm_dbxref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.cvterm_dbxref_cvterm_dbxref_id_seq OWNER TO kmr44;

--
-- Name: cvterm_dbxref_cvterm_dbxref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE cvterm_dbxref_cvterm_dbxref_id_seq OWNED BY cvterm_dbxref.cvterm_dbxref_id;


--
-- Name: cvterm_dbxref_cvterm_dbxref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('cvterm_dbxref_cvterm_dbxref_id_seq', 1, false);


--
-- Name: db_db_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE db_db_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.db_db_id_seq OWNER TO kmr44;

--
-- Name: db_db_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE db_db_id_seq OWNED BY db.db_id;


--
-- Name: db_db_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('db_db_id_seq', 1, true);


--
-- Name: dbxref_dbxref_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE dbxref_dbxref_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.dbxref_dbxref_id_seq OWNER TO kmr44;

--
-- Name: dbxref_dbxref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE dbxref_dbxref_id_seq OWNED BY dbxref.dbxref_id;


--
-- Name: dbxref_dbxref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('dbxref_dbxref_id_seq', 93, true);


--
-- Name: ecotype_ecotype_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE ecotype_ecotype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.ecotype_ecotype_id_seq OWNER TO kmr44;

--
-- Name: ecotype_ecotype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE ecotype_ecotype_id_seq OWNED BY ecotype.ecotype_id;


--
-- Name: ecotype_ecotype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('ecotype_ecotype_id_seq', 23, true);


--
-- Name: organisation_organisation_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE organisation_organisation_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.organisation_organisation_id_seq OWNER TO kmr44;

--
-- Name: organisation_organisation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE organisation_organisation_id_seq OWNED BY organisation.organisation_id;


--
-- Name: organisation_organisation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('organisation_organisation_id_seq', 6, true);


--
-- Name: organism_dbxref_organism_dbxref_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE organism_dbxref_organism_dbxref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.organism_dbxref_organism_dbxref_id_seq OWNER TO kmr44;

--
-- Name: organism_dbxref_organism_dbxref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE organism_dbxref_organism_dbxref_id_seq OWNED BY organism_dbxref.organism_dbxref_id;


--
-- Name: organism_dbxref_organism_dbxref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('organism_dbxref_organism_dbxref_id_seq', 1, false);


--
-- Name: organism_organism_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE organism_organism_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.organism_organism_id_seq OWNER TO kmr44;

--
-- Name: organism_organism_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE organism_organism_id_seq OWNED BY organism.organism_id;


--
-- Name: organism_organism_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('organism_organism_id_seq', 14, true);


--
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE person_person_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.person_person_id_seq OWNER TO kmr44;

--
-- Name: person_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE person_person_id_seq OWNED BY person.person_id;


--
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('person_person_id_seq', 22, true);


--
-- Name: pipedata_pipedata_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipedata_pipedata_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipedata_pipedata_id_seq OWNER TO kmr44;

--
-- Name: pipedata_pipedata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipedata_pipedata_id_seq OWNED BY pipedata.pipedata_id;


--
-- Name: pipedata_pipedata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipedata_pipedata_id_seq', 7, true);


--
-- Name: pipedata_property_pipedata_property_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipedata_property_pipedata_property_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipedata_property_pipedata_property_id_seq OWNER TO kmr44;

--
-- Name: pipedata_property_pipedata_property_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipedata_property_pipedata_property_id_seq OWNED BY pipedata_property.pipedata_property_id;


--
-- Name: pipedata_property_pipedata_property_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipedata_property_pipedata_property_id_seq', 1, false);


--
-- Name: pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq OWNER TO kmr44;

--
-- Name: pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq OWNED BY pipeprocess_in_pipedata.pipeprocess_in_pipedata_id;


--
-- Name: pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq', 1, false);


--
-- Name: pipeprocess_pipeprocess_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipeprocess_pipeprocess_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipeprocess_pipeprocess_id_seq OWNER TO kmr44;

--
-- Name: pipeprocess_pipeprocess_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipeprocess_pipeprocess_id_seq OWNED BY pipeprocess.pipeprocess_id;


--
-- Name: pipeprocess_pipeprocess_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipeprocess_pipeprocess_id_seq', 7, true);


--
-- Name: pipeprocess_pub_pipeprocess_pub_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipeprocess_pub_pipeprocess_pub_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipeprocess_pub_pipeprocess_pub_id_seq OWNER TO kmr44;

--
-- Name: pipeprocess_pub_pipeprocess_pub_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipeprocess_pub_pipeprocess_pub_id_seq OWNED BY pipeprocess_pub.pipeprocess_pub_id;


--
-- Name: pipeprocess_pub_pipeprocess_pub_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipeprocess_pub_pipeprocess_pub_id_seq', 1, false);


--
-- Name: pipeproject_pipeproject_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pipeproject_pipeproject_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pipeproject_pipeproject_id_seq OWNER TO kmr44;

--
-- Name: pipeproject_pipeproject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pipeproject_pipeproject_id_seq OWNED BY pipeproject.pipeproject_id;


--
-- Name: pipeproject_pipeproject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pipeproject_pipeproject_id_seq', 7, true);


--
-- Name: process_conf_input_process_conf_input_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE process_conf_input_process_conf_input_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.process_conf_input_process_conf_input_id_seq OWNER TO kmr44;

--
-- Name: process_conf_input_process_conf_input_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE process_conf_input_process_conf_input_id_seq OWNED BY process_conf_input.process_conf_input_id;


--
-- Name: process_conf_input_process_conf_input_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('process_conf_input_process_conf_input_id_seq', 36, true);


--
-- Name: process_conf_process_conf_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE process_conf_process_conf_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.process_conf_process_conf_id_seq OWNER TO kmr44;

--
-- Name: process_conf_process_conf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE process_conf_process_conf_id_seq OWNED BY process_conf.process_conf_id;


--
-- Name: process_conf_process_conf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('process_conf_process_conf_id_seq', 41, true);


--
-- Name: protocol_protocol_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE protocol_protocol_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.protocol_protocol_id_seq OWNER TO kmr44;

--
-- Name: protocol_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE protocol_protocol_id_seq OWNED BY protocol.protocol_id;


--
-- Name: protocol_protocol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('protocol_protocol_id_seq', 1, true);


--
-- Name: pub_dbxref_pub_dbxref_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pub_dbxref_pub_dbxref_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pub_dbxref_pub_dbxref_id_seq OWNER TO kmr44;

--
-- Name: pub_dbxref_pub_dbxref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pub_dbxref_pub_dbxref_id_seq OWNED BY pub_dbxref.pub_dbxref_id;


--
-- Name: pub_dbxref_pub_dbxref_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pub_dbxref_pub_dbxref_id_seq', 1, false);


--
-- Name: pub_pub_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE pub_pub_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.pub_pub_id_seq OWNER TO kmr44;

--
-- Name: pub_pub_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE pub_pub_id_seq OWNED BY pub.pub_id;


--
-- Name: pub_pub_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('pub_pub_id_seq', 1, false);


--
-- Name: sample_ecotype_sample_ecotype_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sample_ecotype_sample_ecotype_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sample_ecotype_sample_ecotype_id_seq OWNER TO kmr44;

--
-- Name: sample_ecotype_sample_ecotype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sample_ecotype_sample_ecotype_id_seq OWNED BY sample_ecotype.sample_ecotype_id;


--
-- Name: sample_ecotype_sample_ecotype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sample_ecotype_sample_ecotype_id_seq', 9, true);


--
-- Name: sample_pipedata_sample_pipedata_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sample_pipedata_sample_pipedata_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sample_pipedata_sample_pipedata_id_seq OWNER TO kmr44;

--
-- Name: sample_pipedata_sample_pipedata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sample_pipedata_sample_pipedata_id_seq OWNED BY sample_pipedata.sample_pipedata_id;


--
-- Name: sample_pipedata_sample_pipedata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sample_pipedata_sample_pipedata_id_seq', 9, true);


--
-- Name: sample_pipeproject_sample_pipeproject_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sample_pipeproject_sample_pipeproject_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sample_pipeproject_sample_pipeproject_id_seq OWNER TO kmr44;

--
-- Name: sample_pipeproject_sample_pipeproject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sample_pipeproject_sample_pipeproject_id_seq OWNED BY sample_pipeproject.sample_pipeproject_id;


--
-- Name: sample_pipeproject_sample_pipeproject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sample_pipeproject_sample_pipeproject_id_seq', 9, true);


--
-- Name: sample_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sample_sample_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sample_sample_id_seq OWNER TO kmr44;

--
-- Name: sample_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sample_sample_id_seq OWNED BY sample.sample_id;


--
-- Name: sample_sample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sample_sample_id_seq', 9, true);


--
-- Name: sequencing_sample_sequencing_sample_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sequencing_sample_sequencing_sample_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sequencing_sample_sequencing_sample_id_seq OWNER TO kmr44;

--
-- Name: sequencing_sample_sequencing_sample_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sequencing_sample_sequencing_sample_id_seq OWNED BY sequencing_sample.sequencing_sample_id;


--
-- Name: sequencing_sample_sequencing_sample_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sequencing_sample_sequencing_sample_id_seq', 7, true);


--
-- Name: sequencingrun_sequencingrun_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE sequencingrun_sequencingrun_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.sequencingrun_sequencingrun_id_seq OWNER TO kmr44;

--
-- Name: sequencingrun_sequencingrun_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE sequencingrun_sequencingrun_id_seq OWNED BY sequencingrun.sequencingrun_id;


--
-- Name: sequencingrun_sequencingrun_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('sequencingrun_sequencingrun_id_seq', 7, true);


--
-- Name: tissue_tissue_id_seq; Type: SEQUENCE; Schema: public; Owner: kmr44
--

CREATE SEQUENCE tissue_tissue_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tissue_tissue_id_seq OWNER TO kmr44;

--
-- Name: tissue_tissue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kmr44
--

ALTER SEQUENCE tissue_tissue_id_seq OWNED BY tissue.tissue_id;


--
-- Name: tissue_tissue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kmr44
--

SELECT pg_catalog.setval('tissue_tissue_id_seq', 28, true);


--
-- Name: barcode_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE barcode ALTER COLUMN barcode_id SET DEFAULT nextval('barcode_barcode_id_seq'::regclass);


--
-- Name: barcode_set_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE barcode_set ALTER COLUMN barcode_set_id SET DEFAULT nextval('barcode_set_barcode_set_id_seq'::regclass);


--
-- Name: coded_sample_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE coded_sample ALTER COLUMN coded_sample_id SET DEFAULT nextval('coded_sample_coded_sample_id_seq'::regclass);


--
-- Name: cv_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE cv ALTER COLUMN cv_id SET DEFAULT nextval('cv_cv_id_seq'::regclass);


--
-- Name: cvterm_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE cvterm ALTER COLUMN cvterm_id SET DEFAULT nextval('cvterm_cvterm_id_seq'::regclass);


--
-- Name: cvterm_dbxref_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE cvterm_dbxref ALTER COLUMN cvterm_dbxref_id SET DEFAULT nextval('cvterm_dbxref_cvterm_dbxref_id_seq'::regclass);


--
-- Name: db_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE db ALTER COLUMN db_id SET DEFAULT nextval('db_db_id_seq'::regclass);


--
-- Name: dbxref_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE dbxref ALTER COLUMN dbxref_id SET DEFAULT nextval('dbxref_dbxref_id_seq'::regclass);


--
-- Name: ecotype_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE ecotype ALTER COLUMN ecotype_id SET DEFAULT nextval('ecotype_ecotype_id_seq'::regclass);


--
-- Name: organisation_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE organisation ALTER COLUMN organisation_id SET DEFAULT nextval('organisation_organisation_id_seq'::regclass);


--
-- Name: organism_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE organism ALTER COLUMN organism_id SET DEFAULT nextval('organism_organism_id_seq'::regclass);


--
-- Name: organism_dbxref_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE organism_dbxref ALTER COLUMN organism_dbxref_id SET DEFAULT nextval('organism_dbxref_organism_dbxref_id_seq'::regclass);


--
-- Name: person_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE person ALTER COLUMN person_id SET DEFAULT nextval('person_person_id_seq'::regclass);


--
-- Name: pipedata_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipedata ALTER COLUMN pipedata_id SET DEFAULT nextval('pipedata_pipedata_id_seq'::regclass);


--
-- Name: pipedata_property_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipedata_property ALTER COLUMN pipedata_property_id SET DEFAULT nextval('pipedata_property_pipedata_property_id_seq'::regclass);


--
-- Name: pipeprocess_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipeprocess ALTER COLUMN pipeprocess_id SET DEFAULT nextval('pipeprocess_pipeprocess_id_seq'::regclass);


--
-- Name: pipeprocess_in_pipedata_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipeprocess_in_pipedata ALTER COLUMN pipeprocess_in_pipedata_id SET DEFAULT nextval('pipeprocess_in_pipedata_pipeprocess_in_pipedata_id_seq'::regclass);


--
-- Name: pipeprocess_pub_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipeprocess_pub ALTER COLUMN pipeprocess_pub_id SET DEFAULT nextval('pipeprocess_pub_pipeprocess_pub_id_seq'::regclass);


--
-- Name: pipeproject_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pipeproject ALTER COLUMN pipeproject_id SET DEFAULT nextval('pipeproject_pipeproject_id_seq'::regclass);


--
-- Name: process_conf_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE process_conf ALTER COLUMN process_conf_id SET DEFAULT nextval('process_conf_process_conf_id_seq'::regclass);


--
-- Name: process_conf_input_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE process_conf_input ALTER COLUMN process_conf_input_id SET DEFAULT nextval('process_conf_input_process_conf_input_id_seq'::regclass);


--
-- Name: protocol_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE protocol ALTER COLUMN protocol_id SET DEFAULT nextval('protocol_protocol_id_seq'::regclass);


--
-- Name: pub_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pub ALTER COLUMN pub_id SET DEFAULT nextval('pub_pub_id_seq'::regclass);


--
-- Name: pub_dbxref_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE pub_dbxref ALTER COLUMN pub_dbxref_id SET DEFAULT nextval('pub_dbxref_pub_dbxref_id_seq'::regclass);


--
-- Name: sample_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sample ALTER COLUMN sample_id SET DEFAULT nextval('sample_sample_id_seq'::regclass);


--
-- Name: sample_ecotype_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sample_ecotype ALTER COLUMN sample_ecotype_id SET DEFAULT nextval('sample_ecotype_sample_ecotype_id_seq'::regclass);


--
-- Name: sample_pipedata_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sample_pipedata ALTER COLUMN sample_pipedata_id SET DEFAULT nextval('sample_pipedata_sample_pipedata_id_seq'::regclass);


--
-- Name: sample_pipeproject_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sample_pipeproject ALTER COLUMN sample_pipeproject_id SET DEFAULT nextval('sample_pipeproject_sample_pipeproject_id_seq'::regclass);


--
-- Name: sequencing_sample_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sequencing_sample ALTER COLUMN sequencing_sample_id SET DEFAULT nextval('sequencing_sample_sequencing_sample_id_seq'::regclass);


--
-- Name: sequencingrun_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE sequencingrun ALTER COLUMN sequencingrun_id SET DEFAULT nextval('sequencingrun_sequencingrun_id_seq'::regclass);


--
-- Name: tissue_id; Type: DEFAULT; Schema: public; Owner: kmr44
--

ALTER TABLE tissue ALTER COLUMN tissue_id SET DEFAULT nextval('tissue_tissue_id_seq'::regclass);


--
-- Data for Name: barcode; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY barcode (barcode_id, created_stamp, identifier, barcode_set, code) FROM stdin;
1	2009-08-28 11:35:07.090841	A	1	TACCT
2	2009-08-28 11:35:07.090841	B	1	TACGA
3	2009-08-28 11:35:07.090841	C	1	TAGCA
4	2009-08-28 11:35:07.090841	D	1	TAGGT
5	2009-08-28 11:35:07.090841	E	1	TCAAG
6	2009-08-28 11:35:07.090841	F	1	TCATC
7	2009-08-28 11:35:07.090841	G	1	TCTAC
8	2009-08-28 11:35:07.090841	H	1	TCTTG
9	2009-08-28 11:35:07.090841	I	1	TGAAC
10	2009-08-28 11:35:07.090841	J	1	TGTTG
11	2009-08-28 11:35:07.090841	K	1	TGTTC
12	2009-08-28 11:35:07.090841	A	2	AAAT
13	2009-08-28 11:35:07.090841	B	2	ATCT
14	2009-08-28 11:35:07.090841	C	2	AGGT
15	2009-08-28 11:35:07.090841	D	2	ACTT
16	2009-08-28 11:35:07.090841	E	2	TACT
17	2009-08-28 11:35:07.090841	F	2	TTGT
18	2009-08-28 11:35:07.090841	G	2	TGTT
19	2009-08-28 11:35:07.090841	H	2	TCAT
20	2009-08-28 11:35:07.090841	I	2	GAGT
21	2009-08-28 11:35:07.090841	J	2	GTTT
22	2009-08-28 11:35:07.090841	K	2	GGAT
23	2009-08-28 11:35:07.090841	L	2	GCCT
24	2009-08-28 11:35:07.090841	M	2	CATT
25	2009-08-28 11:35:07.090841	N	2	CTAT
26	2009-08-28 11:35:07.090841	O	2	CGCT
27	2009-08-28 11:35:07.090841	P	2	CCGT
\.


--
-- Data for Name: barcode_set; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY barcode_set (barcode_set_id, position_in_read, name) FROM stdin;
1	15	DCB small RNA barcode set
2	16	Dmitry's barcode set
\.


--
-- Data for Name: coded_sample; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY coded_sample (coded_sample_id, created_stamp, description, coded_sample_type, sample, sequencing_sample, barcode) FROM stdin;
1	2009-08-28 11:35:09.24115	non-barcoded sample for: SL11	19	1	1	\N
2	2009-08-28 11:35:09.24115	non-barcoded sample for: SL54	19	2	2	\N
3	2009-08-28 11:35:09.24115	non-barcoded sample for: SL55	19	3	3	\N
4	2009-08-28 11:35:09.24115	non-barcoded sample for: SL165_1	19	4	4	\N
5	2009-08-28 11:35:09.24115	barcoded sample for: SL234_B using barcode: B	19	5	5	2
6	2009-08-28 11:35:09.24115	barcoded sample for: SL234_C using barcode: C	19	6	5	3
7	2009-08-28 11:35:09.24115	barcoded sample for: SL234_F using barcode: F	19	7	5	6
8	2009-08-28 11:35:09.24115	non-barcoded sample for: SL236	19	8	6	\N
9	2009-08-28 11:35:09.24115	barcoded sample for: SL285_B using barcode: B	19	9	7	13
\.


--
-- Data for Name: cv; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY cv (cv_id, name, definition) FROM stdin;
1	tracking analysis types	\N
2	tracking bar code position	\N
3	tracking coded sample types	\N
4	tracking file content types	\N
5	tracking file format types	\N
6	tracking fractionation types	\N
7	tracking molecule types	\N
8	tracking multiplexing types	\N
9	tracking pipedata property types	\N
10	tracking pipeprocess status	\N
11	tracking project types	\N
12	tracking publication types	\N
13	tracking quality values	\N
14	tracking sample processing requirements	\N
15	tracking sample types	\N
16	tracking sequencing method	\N
17	tracking treatment types	\N
18	tracking users types	\N
\.


--
-- Data for Name: cvterm; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY cvterm (cvterm_id, cv_id, name, definition, dbxref_id, is_obsolete, is_relationshiptype) FROM stdin;
1	1	bwa alignment	Align reads against a sequence database with BWA	1	0	0
2	1	calculate fasta or fastq file statistics	Get sequence composition statistics from a FASTA or FASTQ file	2	0	0
3	1	fasta index	Create an index of FASTA file	3	0	0
4	1	genome aligned reads filter	Filter a fasta file, creating a file containing only genome aligned reads	4	0	0
5	1	gff3 index	Create an index of GFF3 file	5	0	0
6	1	gff3 to gff2 converter	Convert a GFF3 file into a GFF2 file	6	0	0
7	1	multiplexed sequencing run	This pseudo-analysis generates raw sequence files, with quality scores, and uses multiplexing/barcodes	7	0	0
8	1	non-multiplexed sequencing run	This pseudo-analysis generates raw sequence files, with quality scores, with no multiplexing	8	0	0
9	1	remove adapters	Read FastQ files, process each read to remove the adapter	9	0	0
10	1	remove adapters and de-multiplex	Read FastQ files, process each read to remove the adapter and split the result based on the barcode	10	0	0
11	1	remove redundant reads	Read a fasta file of short sequences, remove redundant reads and add a count to the header	11	0	0
12	1	ssaha alignment	Align reads against a sequence database with SSAHA	12	0	0
13	1	summarise fasta first base	Read a fasta file of short sequences and summarise the first base composition	13	0	0
14	1	trim reads	Read FastQ files, trim each read to a fixed length and then create a fasta file	14	0	0
15	2	3-prime	Bar code will be at 3' end of the read	15	0	0
16	2	5-prime	Bar code will be at 5' end of the read	16	0	0
17	3	biological replicate	biological replicate/re-run	17	0	0
18	3	failure re-run	re-run because of failure	18	0	0
19	3	initial run	intial sequencing run	19	0	0
20	3	technical replicate	technical replicate/re-run	20	0	0
21	4	fasta_index	An index of a fasta file that has the sequence as the key	21	0	0
22	4	fasta_stats	Summary information and statistics about a FASTA file	22	0	0
23	4	fastq_stats	Summary information and statistics about a FASTQ file	23	0	0
24	4	first_base_summary	A summary of the first base composition of sequences from a fasta file	24	0	0
25	4	genome_aligned_genomic_dna_reads	DNA reads that have been aligned against the genome	25	0	0
26	4	genome_aligned_genomic_dna_tags	DNA tags that have been aligned against the genome	26	0	0
27	4	genome_aligned_srna_reads	Small RNA reads that have been aligned against the genome	27	0	0
28	4	genomic_dna_reads	Genomic DNA reads	28	0	0
29	4	genomic_dna_tags	DNA reads that have been trimmed to a fixed number of bases	29	0	0
30	4	gff3_index	An index of a gff3 file that has the read sequence as the key	30	0	0
31	4	multiplexed_srna_reads	Raw small RNA sequence reads from a multiplexed sequencing run, before any processing	31	0	0
32	4	non_redundant_genomic_dna_reads	DNA sequence reads with redundant sequences removed	32	0	0
33	4	non_redundant_genomic_dna_tags	Trimmed DNA sequence reads with redundant sequences removed	33	0	0
34	4	non_redundant_srna_reads	Small RNA sequence reads without adapters with redundant sequences removed	34	0	0
35	4	raw_genomic_dna_reads	Raw DNA sequence reads with quality scores	35	0	0
36	4	raw_srna_reads	Raw small RNA sequence reads from a non-multiplexed sequencing run, before any processing	36	0	0
37	4	remove_adapter_rejects	Small RNA sequence reads that were rejected by the remove adapters step	37	0	0
38	4	remove_adapter_unknown_barcode	Small RNA sequence reads that were rejected by the remove adapters step because they did not match an expected barcode	38	0	0
39	4	srna_reads	Small RNA sequence reads that have been processed to remove adapters	39	0	0
40	4	srna_reads_chloroplast_alignment	Small RNA to chloroplast dna alignments	40	0	0
41	4	srna_reads_mitochondrial_alignment	Small RNA to mitochondrial dna alignments	41	0	0
42	4	srna_reads_nuclear_alignment	Small RNA to genome alignments	42	0	0
43	5	bam	BAM format	43	0	0
44	5	fasta	FASTA format	44	0	0
45	5	fastq	FastQ format file	45	0	0
46	5	fs	FASTA format with an empty description line	46	0	0
47	5	gff2	GFF2 format	47	0	0
48	5	gff3	GFF3 format	48	0	0
49	5	sam	SAM format	49	0	0
50	5	seq_offset_index	An index of a GFF3 or FASTA format file	50	0	0
51	5	text	A human readable text file with summaries or statistics	51	0	0
52	5	tsv	A file containing tab-separated value	52	0	0
53	6	no fractionation	no fractionation	53	0	0
54	7	DNA	Deoxyribonucleic acid	54	0	0
55	7	RNA	Ribonucleic acid	55	0	0
56	8	multiplexed	multiplexed sequencing run using barcodes	56	0	0
57	8	non-multiplexed	One sample per sequencing run	57	0	0
58	9	base count	Total number of bases	58	0	0
59	9	gc content	Total G+C bases	59	0	0
60	9	n content	Total N bases	60	0	0
61	9	sequence count	Total number of sequences	61	0	0
62	10	finished	Processing is done	62	0	0
63	10	not_started	Process has not been queued yet	63	0	0
64	10	queued	A job is queued to run this process	64	0	0
65	10	started	Processing has started	65	0	0
66	11	DNA tag sequencing	Sequencing of fragments of genomic DNA	66	0	0
67	11	small RNA sequencing	Small RNA sequencing	67	0	0
68	12	book	Publication type: book	68	0	0
69	12	book review	Publication type: book review	69	0	0
70	12	conference report	Publication type: conference report	70	0	0
71	12	editorial	Publication type: editorial	71	0	0
72	12	letter	Publication type: letter	72	0	0
73	12	meeting report	Publication type: meeting report	73	0	0
74	12	news article	Publication type: news article	74	0	0
75	12	paper	Publication type: paper	75	0	0
76	12	personal communication	Publication type: personal communication	76	0	0
77	12	review	Publication type: review	77	0	0
78	12	thesis	Publication type: thesis	78	0	0
79	13	high	high quality	79	0	0
80	13	low	low quality	80	0	0
81	13	medium	medium quality	81	0	0
82	13	unknown	unknown quality	82	0	0
83	14	needs processing	 Processing should be performed for this sample	83	0	0
84	14	no processing	Processing should not be performed for this sample	84	0	0
85	15	chip_seq	Chromatin immunoprecipitation (ChIP) and sequencing	85	0	0
86	15	dna_seq	Genomic DNA sequence	86	0	0
87	15	mrna_expression	Expression analysis of mRNA	87	0	0
88	15	small_rna_seq	Small RNA sequences	88	0	0
89	16	Illumina	Illumina sequencing method	89	0	0
90	17	no treatment	no treatment	90	0	0
91	18	admin	Admin user - full privileges	91	0	0
92	18	external	External user - access only to selected data, no delete/edit privileges	92	0	0
93	18	local	Local user - full access to all data but not full delete/edit privileges	93	0	0
\.


--
-- Data for Name: cvterm_dbxref; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY cvterm_dbxref (cvterm_dbxref_id, cvterm_id, dbxref_id, is_for_definition) FROM stdin;
\.


--
-- Data for Name: db; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY db (db_id, name, description, urlprefix, url) FROM stdin;
1	SmallRNA pipeline database	\N	\N	\N
\.


--
-- Data for Name: dbxref; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY dbxref (dbxref_id, db_id, accession, version, description) FROM stdin;
1	1	bwa alignment		\N
2	1	calculate fasta or fastq file statistics		\N
3	1	fasta index		\N
4	1	genome aligned reads filter		\N
5	1	gff3 index		\N
6	1	gff3 to gff2 converter		\N
7	1	multiplexed sequencing run		\N
8	1	non-multiplexed sequencing run		\N
9	1	remove adapters		\N
10	1	remove adapters and de-multiplex		\N
11	1	remove redundant reads		\N
12	1	ssaha alignment		\N
13	1	summarise fasta first base		\N
14	1	trim reads		\N
15	1	3-prime		\N
16	1	5-prime		\N
17	1	biological replicate		\N
18	1	failure re-run		\N
19	1	initial run		\N
20	1	technical replicate		\N
21	1	fasta_index		\N
22	1	fasta_stats		\N
23	1	fastq_stats		\N
24	1	first_base_summary		\N
25	1	genome_aligned_genomic_dna_reads		\N
26	1	genome_aligned_genomic_dna_tags		\N
27	1	genome_aligned_srna_reads		\N
28	1	genomic_dna_reads		\N
29	1	genomic_dna_tags		\N
30	1	gff3_index		\N
31	1	multiplexed_srna_reads		\N
32	1	non_redundant_genomic_dna_reads		\N
33	1	non_redundant_genomic_dna_tags		\N
34	1	non_redundant_srna_reads		\N
35	1	raw_genomic_dna_reads		\N
36	1	raw_srna_reads		\N
37	1	remove_adapter_rejects		\N
38	1	remove_adapter_unknown_barcode		\N
39	1	srna_reads		\N
40	1	srna_reads_chloroplast_alignment		\N
41	1	srna_reads_mitochondrial_alignment		\N
42	1	srna_reads_nuclear_alignment		\N
43	1	bam		\N
44	1	fasta		\N
45	1	fastq		\N
46	1	fs		\N
47	1	gff2		\N
48	1	gff3		\N
49	1	sam		\N
50	1	seq_offset_index		\N
51	1	text		\N
52	1	tsv		\N
53	1	no fractionation		\N
54	1	DNA		\N
55	1	RNA		\N
56	1	multiplexed		\N
57	1	non-multiplexed		\N
58	1	base count		\N
59	1	gc content		\N
60	1	n content		\N
61	1	sequence count		\N
62	1	finished		\N
63	1	not_started		\N
64	1	queued		\N
65	1	started		\N
66	1	DNA tag sequencing		\N
67	1	small RNA sequencing		\N
68	1	book		\N
69	1	book review		\N
70	1	conference report		\N
71	1	editorial		\N
72	1	letter		\N
73	1	meeting report		\N
74	1	news article		\N
75	1	paper		\N
76	1	personal communication		\N
77	1	review		\N
78	1	thesis		\N
79	1	high		\N
80	1	low		\N
81	1	medium		\N
82	1	unknown		\N
83	1	needs processing		\N
84	1	no processing		\N
85	1	chip_seq		\N
86	1	dna_seq		\N
87	1	mrna_expression		\N
88	1	small_rna_seq		\N
89	1	Illumina		\N
90	1	no treatment		\N
91	1	admin		\N
92	1	external		\N
93	1	local		\N
\.


--
-- Data for Name: ecotype; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY ecotype (ecotype_id, created_stamp, organism, description) FROM stdin;
1	2009-08-28 11:35:07.170566	1	unspecified
2	2009-08-28 11:35:07.170566	1	Col
3	2009-08-28 11:35:07.170566	1	WS
4	2009-08-28 11:35:07.170566	1	Ler
5	2009-08-28 11:35:07.170566	1	C24
6	2009-08-28 11:35:07.170566	1	Cvi
7	2009-08-28 11:35:07.170566	2	unspecified
8	2009-08-28 11:35:07.170566	3	unspecified
9	2009-08-28 11:35:07.170566	4	unspecified
10	2009-08-28 11:35:07.170566	5	unspecified
11	2009-08-28 11:35:07.170566	6	unspecified
12	2009-08-28 11:35:07.170566	7	unspecified
13	2009-08-28 11:35:07.170566	8	unspecified
14	2009-08-28 11:35:07.170566	8	B73
15	2009-08-28 11:35:07.170566	8	Mo17
16	2009-08-28 11:35:07.170566	10	unspecified
17	2009-08-28 11:35:07.170566	11	unspecified
18	2009-08-28 11:35:07.170566	9	unspecified
19	2009-08-28 11:35:07.170566	9	indica
20	2009-08-28 11:35:07.170566	9	japonica
21	2009-08-28 11:35:07.170566	12	unspecified
22	2009-08-28 11:35:07.170566	13	unspecified
23	2009-08-28 11:35:07.170566	14	unspecified
\.


--
-- Data for Name: organisation; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY organisation (organisation_id, created_stamp, name, description) FROM stdin;
1	2009-08-28 11:35:07.136472	DCB	David Baulcombe Lab, University of Cambridge, Dept. of Plant Sciences
2	2009-08-28 11:35:07.136472	CRUK CRI	Cancer Research UK, Cambridge Research Institute
3	2009-08-28 11:35:07.136472	Sainsbury	Sainsbury Laboratory
4	2009-08-28 11:35:07.136472	JIC	John Innes Centre
5	2009-08-28 11:35:07.136472	BGI	Beijing Genomics Institute
6	2009-08-28 11:35:07.136472	CSHL	Cold Spring Harbor Laboratory
\.


--
-- Data for Name: organism; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY organism (organism_id, abbreviation, genus, species, common_name, comment) FROM stdin;
1	arath	Arabidopsis	thaliana	thale cress	\N
2	chlre	Chlamydomonas	reinhardtii	chlamy	\N
3		Cardamine	hirsuta	Hairy bittercress	\N
4	caeel	Caenorhabditis	elegans	worm	\N
5	dicdi	Dictyostelium	discoideum	Slime mold	\N
6	human	Homo	sapiens	human	\N
7		Lycopersicon	esculentum	tomato	\N
8	maize	Zea	mays	corn	\N
9	orysa	Oryza	sativa	rice	\N
10	nicbe	Nicotiana	benthamiana	tabaco	\N
11	schpo	Schizosaccharomyces	pombe	pombe	\N
12	tcv	Carmovirus	turnip crinkle virus	tcv	\N
13	rsv	Benyvirus	rice stripe virus	rsv	\N
14	none	Unknown	unknown	none	\N
\.


--
-- Data for Name: organism_dbxref; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY organism_dbxref (organism_dbxref_id, organism_id, dbxref_id) FROM stdin;
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY person (person_id, created_stamp, first_name, last_name, username, password, role, organisation) FROM stdin;
1	2009-08-28 11:35:07.236435	Andy	Bassett	andy_bassett	andy_bassett	93	1
2	2009-08-28 11:35:07.236435	David	Baulcombe	david_baulcombe	david_baulcombe	93	1
3	2009-08-28 11:35:07.236435	Amy	Beeken	amy_beeken	amy_beeken	93	1
4	2009-08-28 11:35:07.236435	Paola	Fedita	paola_fedita	paola_fedita	93	1
5	2009-08-28 11:35:07.236435	Susi	Heimstaedt	susi_heimstaedt	susi_heimstaedt	93	1
6	2009-08-28 11:35:07.236435	Jagger	Harvey	jagger_harvey	jagger_harvey	93	1
7	2009-08-28 11:35:07.236435	Ericka	Havecker	ericka_havecker	ericka_havecker	93	1
8	2009-08-28 11:35:07.236435	Ian	Henderson	ian_henderson	ian_henderson	93	1
9	2009-08-28 11:35:07.236435	Charles	Melnyk	charles_melnyk	charles_melnyk	93	1
10	2009-08-28 11:35:07.236435	Attila	Molnar	attila_molnar	attila_molnar	93	1
11	2009-08-28 11:35:07.236435	Becky	Mosher	becky_mosher	becky_mosher	93	1
12	2009-08-28 11:35:07.236435	Kanu	Patel	kanu_patel	kanu_patel	93	1
13	2009-08-28 11:35:07.236435	Anna	Peters	anna_peters	anna_peters	93	1
14	2009-08-28 11:35:07.236435	Kim	Rutherford	kim_rutherford	kim_rutherford	91	1
15	2009-08-28 11:35:07.236435	Iain	Searle	iain_searle	iain_searle	93	1
16	2009-08-28 11:35:07.236435	Padubidri	Shivaprasad	padubidri_shivaprasad	padubidri_shivaprasad	93	1
17	2009-08-28 11:35:07.236435	Shuoya	Tang	shuoya_tang	shuoya_tang	93	1
18	2009-08-28 11:35:07.236435	Laura	Taylor	laura_taylor	laura_taylor	93	1
19	2009-08-28 11:35:07.236435	Craig	Thompson	craig_thompson	craig_thompson	93	1
20	2009-08-28 11:35:07.236435	Natasha	Elina	natasha_elina	natasha_elina	93	1
21	2009-08-28 11:35:07.236435	Krys	Kelly	krys_kelly	krys_kelly	93	1
22	2009-08-28 11:35:07.236435	Hannes	V	hannes_v	hannes_v	93	1
\.


--
-- Data for Name: pipedata; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipedata (pipedata_id, created_stamp, format_type, content_type, file_name, file_length, generating_pipeprocess) FROM stdin;
1	2009-08-28 11:35:09.24115	44	39	SL11/SL11.ID15_FC5372.lane2.reads.7_5_2008.fa	85196121	1
2	2009-08-28 11:35:09.24115	45	35	fastq/SL54.ID24_171007_FC5359.lane4.fq	308933804	2
3	2009-08-28 11:35:09.24115	45	35	fastq/SL55.ID24_171007_FC5359.lane5.fq	305662338	3
4	2009-08-28 11:35:09.24115	45	36	fastq/SL165.080905.306BFAAXX.s_5.fq	1026029170	4
5	2009-08-28 11:35:09.24115	45	31	fastq/SL234_BCF.090202.30W8NAAXX.s_1.fq	517055794	5
6	2009-08-28 11:35:09.24115	45	36	fastq/SL236.090227.311F6AAXX.s_1.fq	1203596662	6
7	2009-08-28 11:35:09.24115	45	35	fastq/SL285.090720.42L77AAXX.s_7.fq	912823970	7
\.


--
-- Data for Name: pipedata_property; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipedata_property (pipedata_property_id, pipedata, type, value) FROM stdin;
\.


--
-- Data for Name: pipeprocess; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipeprocess (pipeprocess_id, created_stamp, description, process_conf, status, job_identifier, time_queued, time_started, time_finished) FROM stdin;
1	2009-08-28 11:35:09.24115	Sequencing by Sainsbury for: SL11	1	62	\N	\N	\N	\N
2	2009-08-28 11:35:09.24115	Sequencing by Sainsbury for: SL54	1	62	\N	\N	\N	\N
3	2009-08-28 11:35:09.24115	Sequencing by Sainsbury for: SL55	1	62	\N	\N	\N	\N
4	2009-08-28 11:35:09.24115	Sequencing by CRUK CRI for: SL165_1	2	62	\N	\N	\N	\N
5	2009-08-28 11:35:09.24115	Sequencing by CRUK CRI for: SL234_B, SL234_C, SL234_F	2	62	\N	\N	\N	\N
6	2009-08-28 11:35:09.24115	Sequencing by CRUK CRI for: SL236	2	62	\N	\N	\N	\N
7	2009-08-28 11:35:09.24115	Sequencing by CRUK CRI for: SL285_B	2	62	\N	\N	\N	\N
\.


--
-- Data for Name: pipeprocess_in_pipedata; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipeprocess_in_pipedata (pipeprocess_in_pipedata_id, created_stamp, pipeprocess, pipedata) FROM stdin;
\.


--
-- Data for Name: pipeprocess_pub; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipeprocess_pub (pipeprocess_pub_id, pipeprocess_id, pub_id) FROM stdin;
\.


--
-- Data for Name: pipeproject; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pipeproject (pipeproject_id, created_stamp, name, description, type, owner, funder) FROM stdin;
1	2009-08-28 11:35:09.24115	P_SL11	P_SL11	67	7	\N
2	2009-08-28 11:35:09.24115	P_SL54	P_SL54	66	1	\N
3	2009-08-28 11:35:09.24115	P_SL55	P_SL55	66	1	\N
4	2009-08-28 11:35:09.24115	P_SL165_1	P_SL165_1	67	1	\N
5	2009-08-28 11:35:09.24115	P_SL234_BCF	P_SL234_BCF	67	7	\N
6	2009-08-28 11:35:09.24115	P_SL236	P_SL236	67	10	\N
7	2009-08-28 11:35:09.24115	P_SL285	P_SL285	66	1	\N
\.


--
-- Data for Name: process_conf; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY process_conf (process_conf_id, created_stamp, runable_name, detail, type) FROM stdin;
1	2009-08-28 11:35:07.297372	\N	Sainsbury	8
2	2009-08-28 11:35:07.297372	\N	CRI	8
3	2009-08-28 11:35:07.297372	\N	CRI	7
4	2009-08-28 11:35:07.297372	\N	BGI	8
5	2009-08-28 11:35:07.297372	\N	CSHL	8
6	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastqToFastaRunable	action: trim	14
7	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastqToFastaRunable	action: remove_adapters	9
8	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastqToFastaRunable	action: remove_adapters	10
9	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
10	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
11	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
12	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
13	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
14	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
15	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
16	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
17	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
18	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
19	2009-08-28 11:35:07.297372	SmallRNA::Runable::FastStatsRunable	\N	2
20	2009-08-28 11:35:07.297372	SmallRNA::Runable::FirstBaseCompSummaryRunable	\N	13
21	2009-08-28 11:35:07.297372	SmallRNA::Runable::FirstBaseCompSummaryRunable	\N	13
22	2009-08-28 11:35:07.297372	SmallRNA::Runable::FirstBaseCompSummaryRunable	\N	13
23	2009-08-28 11:35:07.297372	SmallRNA::Runable::FirstBaseCompSummaryRunable	\N	13
24	2009-08-28 11:35:07.297372	SmallRNA::Runable::FirstBaseCompSummaryRunable	\N	13
25	2009-08-28 11:35:07.297372	SmallRNA::Runable::NonRedundantFastaRunable	\N	11
26	2009-08-28 11:35:07.297372	SmallRNA::Runable::NonRedundantFastaRunable	\N	11
27	2009-08-28 11:35:07.297372	SmallRNA::Runable::NonRedundantFastaRunable	\N	11
28	2009-08-28 11:35:07.297372	SmallRNA::Runable::CreateIndexRunable	\N	5
29	2009-08-28 11:35:07.297372	SmallRNA::Runable::CreateIndexRunable	\N	3
30	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
31	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
32	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
33	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
34	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
35	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
36	2009-08-28 11:35:07.297372	SmallRNA::Runable::SSAHASearchRunable	component: genome	12
37	2009-08-28 11:35:07.297372	SmallRNA::Runable::BWASearchRunable	component: genome	1
38	2009-08-28 11:35:07.297372	SmallRNA::Runable::GenomeMatchingReadsRunable	\N	4
39	2009-08-28 11:35:07.297372	SmallRNA::Runable::GenomeMatchingReadsRunable	\N	4
40	2009-08-28 11:35:07.297372	SmallRNA::Runable::GenomeMatchingReadsRunable	\N	4
41	2009-08-28 11:35:07.297372	SmallRNA::Runable::GFF3ToGFF2Runable	\N	6
\.


--
-- Data for Name: process_conf_input; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY process_conf_input (process_conf_input_id, created_stamp, process_conf, format_type, content_type, ecotype) FROM stdin;
1	2009-08-28 11:35:07.297372	6	45	35	\N
2	2009-08-28 11:35:07.297372	7	45	36	\N
3	2009-08-28 11:35:07.297372	8	45	31	\N
4	2009-08-28 11:35:07.297372	9	45	36	\N
5	2009-08-28 11:35:07.297372	10	45	35	\N
6	2009-08-28 11:35:07.297372	11	44	39	\N
7	2009-08-28 11:35:07.297372	12	44	34	\N
8	2009-08-28 11:35:07.297372	13	44	27	\N
9	2009-08-28 11:35:07.297372	14	44	28	\N
10	2009-08-28 11:35:07.297372	15	44	32	\N
11	2009-08-28 11:35:07.297372	16	44	25	\N
12	2009-08-28 11:35:07.297372	17	44	29	\N
13	2009-08-28 11:35:07.297372	18	44	33	\N
14	2009-08-28 11:35:07.297372	19	44	26	\N
15	2009-08-28 11:35:07.297372	20	44	39	\N
16	2009-08-28 11:35:07.297372	21	44	34	\N
17	2009-08-28 11:35:07.297372	22	44	36	\N
18	2009-08-28 11:35:07.297372	23	44	31	\N
19	2009-08-28 11:35:07.297372	24	44	27	\N
20	2009-08-28 11:35:07.297372	25	44	29	\N
21	2009-08-28 11:35:07.297372	26	44	28	\N
22	2009-08-28 11:35:07.297372	27	44	39	\N
23	2009-08-28 11:35:07.297372	28	48	27	\N
24	2009-08-28 11:35:07.297372	29	44	34	\N
25	2009-08-28 11:35:07.297372	30	44	34	1
26	2009-08-28 11:35:07.297372	31	44	34	12
27	2009-08-28 11:35:07.297372	32	44	34	21
28	2009-08-28 11:35:07.297372	33	44	34	18
29	2009-08-28 11:35:07.297372	34	44	34	22
30	2009-08-28 11:35:07.297372	35	44	34	7
31	2009-08-28 11:35:07.297372	36	44	33	7
32	2009-08-28 11:35:07.297372	37	44	34	1
33	2009-08-28 11:35:07.297372	38	48	27	\N
34	2009-08-28 11:35:07.297372	39	48	26	\N
35	2009-08-28 11:35:07.297372	40	48	25	\N
36	2009-08-28 11:35:07.297372	41	48	\N	\N
\.


--
-- Data for Name: protocol; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY protocol (protocol_id, name, description) FROM stdin;
1	unknown	
\.


--
-- Data for Name: pub; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pub (pub_id, title, volumetitle, volume, series_name, issue, pyear, pages, miniref, uniquename, type_id, is_obsolete, publisher, pubplace) FROM stdin;
\.


--
-- Data for Name: pub_dbxref; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY pub_dbxref (pub_dbxref_id, pub_id, dbxref_id, is_current) FROM stdin;
\.


--
-- Data for Name: sample; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sample (sample_id, created_stamp, name, genotype, description, protocol, sample_type, molecule_type, treatment_type, fractionation_type, processing_requirement, tissue) FROM stdin;
1	2009-08-28 11:35:09.24115	SL11	\N	AGO9 associated small RNAs Rep1 (mixed Col-0 floral + silique)	1	88	55	\N	\N	83	\N
2	2009-08-28 11:35:09.24115	SL54	\N	Chlamy total DNA (mononuc)	1	85	54	\N	\N	83	\N
3	2009-08-28 11:35:09.24115	SL55	\N	Chlamy methylated DNA IP (mononuc)	1	85	54	\N	\N	83	\N
4	2009-08-28 11:35:09.24115	SL165_1	\N	Total sRNA mono-P	1	88	55	\N	\N	83	\N
5	2009-08-28 11:35:09.24115	SL234_B	\N	B: Ago4p:AGO4 IP C: AGO4p:AGO6 IP F: AGO4p:AGO9 IP  - barcode B	1	88	55	\N	\N	83	\N
6	2009-08-28 11:35:09.24115	SL234_C	\N	B: Ago4p:AGO4 IP C: AGO4p:AGO6 IP F: AGO4p:AGO9 IP  - barcode C	1	88	55	\N	\N	83	\N
7	2009-08-28 11:35:09.24115	SL234_F	\N	B: Ago4p:AGO4 IP C: AGO4p:AGO6 IP F: AGO4p:AGO9 IP  - barcode F	1	88	55	\N	\N	83	\N
8	2009-08-28 11:35:09.24115	SL236	\N	grafting dcl2,3,4 to dcl2,3,4 (root)	1	88	55	\N	\N	83	\N
9	2009-08-28 11:35:09.24115	SL285_B	\N	ChIP - H3K9Me1 - barcode B	1	85	54	\N	\N	83	\N
\.


--
-- Data for Name: sample_dbxref; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sample_dbxref (sample_dbxref_id, sample_id, dbxref_id) FROM stdin;
\.


--
-- Data for Name: sample_ecotype; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sample_ecotype (sample_ecotype_id, created_stamp, sample, ecotype) FROM stdin;
1	2009-08-28 11:35:09.24115	1	1
2	2009-08-28 11:35:09.24115	2	7
3	2009-08-28 11:35:09.24115	3	7
4	2009-08-28 11:35:09.24115	4	7
5	2009-08-28 11:35:09.24115	5	1
6	2009-08-28 11:35:09.24115	6	1
7	2009-08-28 11:35:09.24115	7	1
8	2009-08-28 11:35:09.24115	8	1
9	2009-08-28 11:35:09.24115	9	7
\.


--
-- Data for Name: sample_pipedata; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sample_pipedata (sample_pipedata_id, created_stamp, sample, pipedata) FROM stdin;
1	2009-08-28 11:35:09.24115	1	1
2	2009-08-28 11:35:09.24115	2	2
3	2009-08-28 11:35:09.24115	3	3
4	2009-08-28 11:35:09.24115	4	4
5	2009-08-28 11:35:09.24115	5	5
6	2009-08-28 11:35:09.24115	6	5
7	2009-08-28 11:35:09.24115	7	5
8	2009-08-28 11:35:09.24115	8	6
9	2009-08-28 11:35:09.24115	9	7
\.


--
-- Data for Name: sample_pipeproject; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sample_pipeproject (sample_pipeproject_id, sample, pipeproject) FROM stdin;
1	1	1
2	2	2
3	3	3
4	4	4
5	5	5
6	6	5
7	7	5
8	8	6
9	9	7
\.


--
-- Data for Name: sequencing_sample; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sequencing_sample (sequencing_sample_id, name) FROM stdin;
1	CRI_SL11
2	CRI_SL54
3	CRI_SL55
4	CRI_SL165_1
5	CRI_SL234_BCF
6	CRI_SL236
7	CRI_SL285
\.


--
-- Data for Name: sequencingrun; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY sequencingrun (sequencingrun_id, created_stamp, identifier, sequencing_sample, initial_pipedata, sequencing_centre, initial_pipeprocess, submission_date, run_date, data_received_date, quality, sequencing_type, multiplexing_type) FROM stdin;
1	2009-08-28 11:35:09.24115	RUN_SL11	1	1	3	1	\N	\N	\N	82	89	57
2	2009-08-28 11:35:09.24115	RUN_SL54	2	2	3	2	\N	\N	\N	82	89	57
3	2009-08-28 11:35:09.24115	RUN_SL55	3	3	3	3	\N	\N	\N	82	89	57
4	2009-08-28 11:35:09.24115	RUN_SL165_1	4	4	2	4	2008-08-27	2008-09-11	2008-09-11	82	89	57
5	2009-08-28 11:35:09.24115	RUN_SL234_BCF	5	5	2	5	2009-01-20	2009-02-10	2009-02-10	82	89	56
6	2009-08-28 11:35:09.24115	RUN_SL236	6	6	2	6	2009-02-10	2009-03-09	2009-03-09	82	89	57
7	2009-08-28 11:35:09.24115	RUN_SL285	7	7	2	7	2009-07-14	2009-07-24	2009-07-24	82	89	56
\.


--
-- Data for Name: tissue; Type: TABLE DATA; Schema: public; Owner: kmr44
--

COPY tissue (tissue_id, created_stamp, organism, description) FROM stdin;
1	2009-08-28 11:35:07.201072	1	unspecified
2	2009-08-28 11:35:07.201072	1	unopened flowers (stage 0-12)
3	2009-08-28 11:35:07.201072	1	open flowers (stage 13)
4	2009-08-28 11:35:07.201072	1	young siliques (<7 dpf)
5	2009-08-28 11:35:07.201072	1	mature siliques (>7 dpf)
6	2009-08-28 11:35:07.201072	1	young leaves (<14 days)
7	2009-08-28 11:35:07.201072	1	mature leaves (>14 days)
8	2009-08-28 11:35:07.201072	1	vegetative meristem
9	2009-08-28 11:35:07.201072	1	floral meristem
10	2009-08-28 11:35:07.201072	1	roots (including meristem)
11	2009-08-28 11:35:07.201072	1	seedlings (roots, cotyledons, leaves, and meristem)
12	2009-08-28 11:35:07.201072	1	cauline leaves
13	2009-08-28 11:35:07.201072	1	stem
14	2009-08-28 11:35:07.201072	2	unspecified
15	2009-08-28 11:35:07.201072	2	vegetative cells
16	2009-08-28 11:35:07.201072	2	gametes
17	2009-08-28 11:35:07.201072	3	unspecified
18	2009-08-28 11:35:07.201072	4	unspecified
19	2009-08-28 11:35:07.201072	5	unspecified
20	2009-08-28 11:35:07.201072	6	unspecified
21	2009-08-28 11:35:07.201072	7	unspecified
22	2009-08-28 11:35:07.201072	8	unspecified
23	2009-08-28 11:35:07.201072	10	unspecified
24	2009-08-28 11:35:07.201072	11	unspecified
25	2009-08-28 11:35:07.201072	9	unspecified
26	2009-08-28 11:35:07.201072	12	unspecified
27	2009-08-28 11:35:07.201072	13	unspecified
28	2009-08-28 11:35:07.201072	14	unspecified
\.


--
-- Name: barcode_code_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY barcode
    ADD CONSTRAINT barcode_code_constraint UNIQUE (code, barcode_set);


--
-- Name: barcode_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY barcode
    ADD CONSTRAINT barcode_id_pk PRIMARY KEY (barcode_id);


--
-- Name: barcode_identifier_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY barcode
    ADD CONSTRAINT barcode_identifier_constraint UNIQUE (identifier, barcode_set);


--
-- Name: barcode_set_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY barcode_set
    ADD CONSTRAINT barcode_set_id_pk PRIMARY KEY (barcode_set_id);


--
-- Name: barcode_set_name_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY barcode_set
    ADD CONSTRAINT barcode_set_name_key UNIQUE (name);


--
-- Name: coded_sample_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY coded_sample
    ADD CONSTRAINT coded_sample_id_pk PRIMARY KEY (coded_sample_id);


--
-- Name: cv_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_c1 UNIQUE (name);


--
-- Name: cv_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cv
    ADD CONSTRAINT cv_pkey PRIMARY KEY (cv_id);


--
-- Name: cvterm_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_c1 UNIQUE (name, cv_id, is_obsolete);


--
-- Name: cvterm_c2; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_c2 UNIQUE (dbxref_id);


--
-- Name: cvterm_dbxref_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cvterm_dbxref
    ADD CONSTRAINT cvterm_dbxref_c1 UNIQUE (cvterm_id, dbxref_id);


--
-- Name: cvterm_dbxref_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cvterm_dbxref
    ADD CONSTRAINT cvterm_dbxref_pkey PRIMARY KEY (cvterm_dbxref_id);


--
-- Name: cvterm_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_pkey PRIMARY KEY (cvterm_id);


--
-- Name: db_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY db
    ADD CONSTRAINT db_c1 UNIQUE (name);


--
-- Name: db_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY db
    ADD CONSTRAINT db_pkey PRIMARY KEY (db_id);


--
-- Name: dbxref_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_c1 UNIQUE (db_id, accession, version);


--
-- Name: dbxref_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_pkey PRIMARY KEY (dbxref_id);


--
-- Name: ecotype_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY ecotype
    ADD CONSTRAINT ecotype_id_pk PRIMARY KEY (ecotype_id);


--
-- Name: organisation_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY organisation
    ADD CONSTRAINT organisation_id_pk PRIMARY KEY (organisation_id);


--
-- Name: organism_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY organism
    ADD CONSTRAINT organism_c1 UNIQUE (genus, species);


--
-- Name: organism_dbxref_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY organism_dbxref
    ADD CONSTRAINT organism_dbxref_c1 UNIQUE (organism_id, dbxref_id);


--
-- Name: organism_dbxref_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY organism_dbxref
    ADD CONSTRAINT organism_dbxref_pkey PRIMARY KEY (organism_dbxref_id);


--
-- Name: organism_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY organism
    ADD CONSTRAINT organism_pkey PRIMARY KEY (organism_id);


--
-- Name: person_full_name_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_full_name_constraint UNIQUE (first_name, last_name);


--
-- Name: person_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_id_pk PRIMARY KEY (person_id);


--
-- Name: person_username_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_username_key UNIQUE (username);


--
-- Name: pipedata_file_name_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipedata
    ADD CONSTRAINT pipedata_file_name_key UNIQUE (file_name);


--
-- Name: pipedata_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipedata
    ADD CONSTRAINT pipedata_id_pk PRIMARY KEY (pipedata_id);


--
-- Name: pipedata_property_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipedata_property
    ADD CONSTRAINT pipedata_property_id_pk PRIMARY KEY (pipedata_property_id);


--
-- Name: pipeprocess_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipeprocess
    ADD CONSTRAINT pipeprocess_id_pk PRIMARY KEY (pipeprocess_id);


--
-- Name: pipeprocess_in_pipedata_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipeprocess_in_pipedata
    ADD CONSTRAINT pipeprocess_in_pipedata_id_pk PRIMARY KEY (pipeprocess_in_pipedata_id);


--
-- Name: pipeprocess_in_pk_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipeprocess_in_pipedata
    ADD CONSTRAINT pipeprocess_in_pk_constraint UNIQUE (pipeprocess, pipedata);


--
-- Name: pipeprocess_pub_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipeprocess_pub
    ADD CONSTRAINT pipeprocess_pub_id_pk PRIMARY KEY (pipeprocess_pub_id);


--
-- Name: pipeproject_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pipeproject
    ADD CONSTRAINT pipeproject_id_pk PRIMARY KEY (pipeproject_id);


--
-- Name: process_conf_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY process_conf
    ADD CONSTRAINT process_conf_id_pk PRIMARY KEY (process_conf_id);


--
-- Name: process_conf_input_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY process_conf_input
    ADD CONSTRAINT process_conf_input_id_pk PRIMARY KEY (process_conf_input_id);


--
-- Name: protocol_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_id_pk PRIMARY KEY (protocol_id);


--
-- Name: protocol_name_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_name_key UNIQUE (name);


--
-- Name: pub_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pub
    ADD CONSTRAINT pub_c1 UNIQUE (uniquename);


--
-- Name: pub_dbxref_c1; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT pub_dbxref_c1 UNIQUE (pub_id, dbxref_id);


--
-- Name: pub_dbxref_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT pub_dbxref_pkey PRIMARY KEY (pub_dbxref_id);


--
-- Name: pub_pkey; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY pub
    ADD CONSTRAINT pub_pkey PRIMARY KEY (pub_id);


--
-- Name: sample_ecotype_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample_ecotype
    ADD CONSTRAINT sample_ecotype_constraint UNIQUE (sample, ecotype);


--
-- Name: sample_ecotype_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample_ecotype
    ADD CONSTRAINT sample_ecotype_id_pk PRIMARY KEY (sample_ecotype_id);


--
-- Name: sample_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_id_pk PRIMARY KEY (sample_id);


--
-- Name: sample_name_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_name_key UNIQUE (name);


--
-- Name: sample_pipedata_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample_pipedata
    ADD CONSTRAINT sample_pipedata_id_pk PRIMARY KEY (sample_pipedata_id);


--
-- Name: sample_pipeproject_constraint; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample_pipeproject
    ADD CONSTRAINT sample_pipeproject_constraint UNIQUE (sample, pipeproject);


--
-- Name: sample_pipeproject_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sample_pipeproject
    ADD CONSTRAINT sample_pipeproject_id_pk PRIMARY KEY (sample_pipeproject_id);


--
-- Name: sequencing_sample_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sequencing_sample
    ADD CONSTRAINT sequencing_sample_id_pk PRIMARY KEY (sequencing_sample_id);


--
-- Name: sequencing_sample_name_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sequencing_sample
    ADD CONSTRAINT sequencing_sample_name_key UNIQUE (name);


--
-- Name: sequencingrun_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_id_pk PRIMARY KEY (sequencingrun_id);


--
-- Name: sequencingrun_identifier_key; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_identifier_key UNIQUE (identifier);


--
-- Name: tissue_id_pk; Type: CONSTRAINT; Schema: public; Owner: kmr44; Tablespace: 
--

ALTER TABLE ONLY tissue
    ADD CONSTRAINT tissue_id_pk PRIMARY KEY (tissue_id);


--
-- Name: INDEX cvterm_c1; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON INDEX cvterm_c1 IS 'A name can mean different things in
different contexts; for example "chromosome" in SO and GO. A name
should be unique within an ontology or cv. A name may exist twice in a
cv, in both obsolete and non-obsolete forms - these will be for
different cvterms with different OBO identifiers; so GO documentation
for more details on obsoletion. Note that occasionally multiple
obsolete terms with the same name will exist in the same cv. If this
is a possibility for the ontology under consideration (e.g. GO) then the
ID should be appended to the name to ensure uniqueness.';


--
-- Name: INDEX cvterm_c2; Type: COMMENT; Schema: public; Owner: kmr44
--

COMMENT ON INDEX cvterm_c2 IS 'The OBO identifier is globally unique.';


--
-- Name: cvterm_dbxref_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX cvterm_dbxref_idx1 ON cvterm_dbxref USING btree (cvterm_id);


--
-- Name: cvterm_dbxref_idx2; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX cvterm_dbxref_idx2 ON cvterm_dbxref USING btree (dbxref_id);


--
-- Name: cvterm_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX cvterm_idx1 ON cvterm USING btree (cv_id);


--
-- Name: cvterm_idx2; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX cvterm_idx2 ON cvterm USING btree (name);


--
-- Name: cvterm_idx3; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX cvterm_idx3 ON cvterm USING btree (dbxref_id);


--
-- Name: dbxref_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX dbxref_idx1 ON dbxref USING btree (db_id);


--
-- Name: dbxref_idx2; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX dbxref_idx2 ON dbxref USING btree (accession);


--
-- Name: dbxref_idx3; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX dbxref_idx3 ON dbxref USING btree (version);


--
-- Name: organism_dbxref_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX organism_dbxref_idx1 ON organism_dbxref USING btree (organism_id);


--
-- Name: organism_dbxref_idx2; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX organism_dbxref_idx2 ON organism_dbxref USING btree (dbxref_id);


--
-- Name: pub_dbxref_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX pub_dbxref_idx1 ON pub_dbxref USING btree (pub_id);


--
-- Name: pub_dbxref_idx2; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX pub_dbxref_idx2 ON pub_dbxref USING btree (dbxref_id);


--
-- Name: pub_idx1; Type: INDEX; Schema: public; Owner: kmr44; Tablespace: 
--

CREATE INDEX pub_idx1 ON pub USING btree (type_id);


--
-- Name: barcode_barcode_set_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY barcode
    ADD CONSTRAINT barcode_barcode_set_fkey FOREIGN KEY (barcode_set) REFERENCES barcode_set(barcode_set_id);


--
-- Name: barcode_set_position_in_read_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY barcode_set
    ADD CONSTRAINT barcode_set_position_in_read_fkey FOREIGN KEY (position_in_read) REFERENCES cvterm(cvterm_id);


--
-- Name: coded_sample_barcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY coded_sample
    ADD CONSTRAINT coded_sample_barcode_fkey FOREIGN KEY (barcode) REFERENCES barcode(barcode_id);


--
-- Name: coded_sample_coded_sample_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY coded_sample
    ADD CONSTRAINT coded_sample_coded_sample_type_fkey FOREIGN KEY (coded_sample_type) REFERENCES cvterm(cvterm_id);


--
-- Name: coded_sample_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY coded_sample
    ADD CONSTRAINT coded_sample_sample_fkey FOREIGN KEY (sample) REFERENCES sample(sample_id);


--
-- Name: coded_sample_sequencing_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY coded_sample
    ADD CONSTRAINT coded_sample_sequencing_sample_fkey FOREIGN KEY (sequencing_sample) REFERENCES sequencing_sample(sequencing_sample_id);


--
-- Name: cvterm_cv_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_cv_id_fkey FOREIGN KEY (cv_id) REFERENCES cv(cv_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cvterm_dbxref_cvterm_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY cvterm_dbxref
    ADD CONSTRAINT cvterm_dbxref_cvterm_id_fkey FOREIGN KEY (cvterm_id) REFERENCES cvterm(cvterm_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cvterm_dbxref_dbxref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY cvterm_dbxref
    ADD CONSTRAINT cvterm_dbxref_dbxref_id_fkey FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cvterm_dbxref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY cvterm
    ADD CONSTRAINT cvterm_dbxref_id_fkey FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: dbxref_db_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY dbxref
    ADD CONSTRAINT dbxref_db_id_fkey FOREIGN KEY (db_id) REFERENCES db(db_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ecotype_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY ecotype
    ADD CONSTRAINT ecotype_organism_fkey FOREIGN KEY (organism) REFERENCES organism(organism_id);


--
-- Name: organism_dbxref_dbxref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY organism_dbxref
    ADD CONSTRAINT organism_dbxref_dbxref_id_fkey FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: organism_dbxref_organism_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY organism_dbxref
    ADD CONSTRAINT organism_dbxref_organism_id_fkey FOREIGN KEY (organism_id) REFERENCES organism(organism_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: person_organisation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_organisation_fkey FOREIGN KEY (organisation) REFERENCES organisation(organisation_id);


--
-- Name: person_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_role_fkey FOREIGN KEY (role) REFERENCES cvterm(cvterm_id);


--
-- Name: pipedata_content_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipedata
    ADD CONSTRAINT pipedata_content_type_fkey FOREIGN KEY (content_type) REFERENCES cvterm(cvterm_id);


--
-- Name: pipedata_format_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipedata
    ADD CONSTRAINT pipedata_format_type_fkey FOREIGN KEY (format_type) REFERENCES cvterm(cvterm_id);


--
-- Name: pipedata_generating_pipeprocess_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipedata
    ADD CONSTRAINT pipedata_generating_pipeprocess_fkey FOREIGN KEY (generating_pipeprocess) REFERENCES pipeprocess(pipeprocess_id);


--
-- Name: pipedata_property_pipedata_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipedata_property
    ADD CONSTRAINT pipedata_property_pipedata_fkey FOREIGN KEY (pipedata) REFERENCES pipedata(pipedata_id);


--
-- Name: pipedata_property_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipedata_property
    ADD CONSTRAINT pipedata_property_type_fkey FOREIGN KEY (type) REFERENCES cvterm(cvterm_id);


--
-- Name: pipeprocess_in_pipedata_pipedata_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess_in_pipedata
    ADD CONSTRAINT pipeprocess_in_pipedata_pipedata_fkey FOREIGN KEY (pipedata) REFERENCES pipedata(pipedata_id);


--
-- Name: pipeprocess_in_pipedata_pipeprocess_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess_in_pipedata
    ADD CONSTRAINT pipeprocess_in_pipedata_pipeprocess_fkey FOREIGN KEY (pipeprocess) REFERENCES pipeprocess(pipeprocess_id);


--
-- Name: pipeprocess_process_conf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess
    ADD CONSTRAINT pipeprocess_process_conf_fkey FOREIGN KEY (process_conf) REFERENCES process_conf(process_conf_id);


--
-- Name: pipeprocess_pub_pipeprocess_fk; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess_pub
    ADD CONSTRAINT pipeprocess_pub_pipeprocess_fk FOREIGN KEY (pipeprocess_id) REFERENCES pipeprocess(pipeprocess_id) ON DELETE CASCADE;


--
-- Name: pipeprocess_pub_pub_fk; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess_pub
    ADD CONSTRAINT pipeprocess_pub_pub_fk FOREIGN KEY (pub_id) REFERENCES pub(pub_id) ON DELETE CASCADE;


--
-- Name: pipeprocess_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeprocess
    ADD CONSTRAINT pipeprocess_status_fkey FOREIGN KEY (status) REFERENCES cvterm(cvterm_id);


--
-- Name: pipeproject_funder_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeproject
    ADD CONSTRAINT pipeproject_funder_fkey FOREIGN KEY (funder) REFERENCES organisation(organisation_id);


--
-- Name: pipeproject_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeproject
    ADD CONSTRAINT pipeproject_owner_fkey FOREIGN KEY (owner) REFERENCES person(person_id);


--
-- Name: pipeproject_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pipeproject
    ADD CONSTRAINT pipeproject_type_fkey FOREIGN KEY (type) REFERENCES cvterm(cvterm_id);


--
-- Name: process_conf_input_content_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY process_conf_input
    ADD CONSTRAINT process_conf_input_content_type_fkey FOREIGN KEY (content_type) REFERENCES cvterm(cvterm_id);


--
-- Name: process_conf_input_ecotype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY process_conf_input
    ADD CONSTRAINT process_conf_input_ecotype_fkey FOREIGN KEY (ecotype) REFERENCES ecotype(ecotype_id);


--
-- Name: process_conf_input_format_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY process_conf_input
    ADD CONSTRAINT process_conf_input_format_type_fkey FOREIGN KEY (format_type) REFERENCES cvterm(cvterm_id);


--
-- Name: process_conf_input_process_conf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY process_conf_input
    ADD CONSTRAINT process_conf_input_process_conf_fkey FOREIGN KEY (process_conf) REFERENCES process_conf(process_conf_id);


--
-- Name: process_conf_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY process_conf
    ADD CONSTRAINT process_conf_type_fkey FOREIGN KEY (type) REFERENCES cvterm(cvterm_id);


--
-- Name: pub_dbxref_dbxref_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT pub_dbxref_dbxref_id_fkey FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pub_dbxref_pub_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pub_dbxref
    ADD CONSTRAINT pub_dbxref_pub_id_fkey FOREIGN KEY (pub_id) REFERENCES pub(pub_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pub_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY pub
    ADD CONSTRAINT pub_type_id_fkey FOREIGN KEY (type_id) REFERENCES cvterm(cvterm_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: sample_dbxref_dbxref_fk; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_dbxref
    ADD CONSTRAINT sample_dbxref_dbxref_fk FOREIGN KEY (dbxref_id) REFERENCES dbxref(dbxref_id) ON DELETE CASCADE;


--
-- Name: sample_dbxref_sample_fk; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_dbxref
    ADD CONSTRAINT sample_dbxref_sample_fk FOREIGN KEY (sample_id) REFERENCES sample(sample_id) ON DELETE CASCADE;


--
-- Name: sample_ecotype_ecotype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_ecotype
    ADD CONSTRAINT sample_ecotype_ecotype_fkey FOREIGN KEY (ecotype) REFERENCES ecotype(ecotype_id);


--
-- Name: sample_ecotype_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_ecotype
    ADD CONSTRAINT sample_ecotype_sample_fkey FOREIGN KEY (sample) REFERENCES sample(sample_id);


--
-- Name: sample_fractionation_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_fractionation_type_fkey FOREIGN KEY (fractionation_type) REFERENCES cvterm(cvterm_id);


--
-- Name: sample_molecule_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_molecule_type_fkey FOREIGN KEY (molecule_type) REFERENCES cvterm(cvterm_id);


--
-- Name: sample_pipedata_pipedata_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_pipedata
    ADD CONSTRAINT sample_pipedata_pipedata_fkey FOREIGN KEY (pipedata) REFERENCES pipedata(pipedata_id);


--
-- Name: sample_pipedata_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_pipedata
    ADD CONSTRAINT sample_pipedata_sample_fkey FOREIGN KEY (sample) REFERENCES sample(sample_id);


--
-- Name: sample_pipeproject_pipeproject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_pipeproject
    ADD CONSTRAINT sample_pipeproject_pipeproject_fkey FOREIGN KEY (pipeproject) REFERENCES pipeproject(pipeproject_id);


--
-- Name: sample_pipeproject_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample_pipeproject
    ADD CONSTRAINT sample_pipeproject_sample_fkey FOREIGN KEY (sample) REFERENCES sample(sample_id);


--
-- Name: sample_processing_requirement_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_processing_requirement_fkey FOREIGN KEY (processing_requirement) REFERENCES cvterm(cvterm_id);


--
-- Name: sample_protocol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_protocol_fkey FOREIGN KEY (protocol) REFERENCES protocol(protocol_id);


--
-- Name: sample_sample_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sample_type_fkey FOREIGN KEY (sample_type) REFERENCES cvterm(cvterm_id);


--
-- Name: sample_tissue_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_tissue_fkey FOREIGN KEY (tissue) REFERENCES tissue(tissue_id);


--
-- Name: sample_treatment_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_treatment_type_fkey FOREIGN KEY (treatment_type) REFERENCES cvterm(cvterm_id);


--
-- Name: sequencingrun_initial_pipedata_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_initial_pipedata_fkey FOREIGN KEY (initial_pipedata) REFERENCES pipedata(pipedata_id);


--
-- Name: sequencingrun_initial_pipeprocess_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_initial_pipeprocess_fkey FOREIGN KEY (initial_pipeprocess) REFERENCES pipeprocess(pipeprocess_id);


--
-- Name: sequencingrun_multiplexing_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_multiplexing_type_fkey FOREIGN KEY (multiplexing_type) REFERENCES cvterm(cvterm_id);


--
-- Name: sequencingrun_quality_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_quality_fkey FOREIGN KEY (quality) REFERENCES cvterm(cvterm_id);


--
-- Name: sequencingrun_sequencing_centre_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_sequencing_centre_fkey FOREIGN KEY (sequencing_centre) REFERENCES organisation(organisation_id);


--
-- Name: sequencingrun_sequencing_sample_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_sequencing_sample_fkey FOREIGN KEY (sequencing_sample) REFERENCES sequencing_sample(sequencing_sample_id);


--
-- Name: sequencingrun_sequencing_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY sequencingrun
    ADD CONSTRAINT sequencingrun_sequencing_type_fkey FOREIGN KEY (sequencing_type) REFERENCES cvterm(cvterm_id);


--
-- Name: tissue_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kmr44
--

ALTER TABLE ONLY tissue
    ADD CONSTRAINT tissue_organism_fkey FOREIGN KEY (organism) REFERENCES organism(organism_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

