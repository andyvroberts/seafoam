/* 
 *----------------------------------------------------------------------------
 *  File name     : 03-relationships.sql
 *  Author        : DBA
 *  Date Created  : 2023-01-04
 *  Date Changed  : 
 *  Psql Version  : 13.9
 *  State         : Released
 *  Description   : Creates the foreign keys on the ebss_af tables.
 *
 *  Usage         : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 03-relationships.sql
 *
 *  Parameters    : None.
 * 
 *  Notes         : This script must be run as the ebss_af schema owner.
 *
 *  Example       : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 03-relationships.sql
 *
 * ----------------------------------------------------------------------------
*/

\set ON_ERROR_STOP on
\set schema ebss_af

/* 1. Create all many-to-many join tables */

DROP TABLE IF EXISTS application_fuel;
DROP TABLE IF EXISTS application_extract_file;

CREATE TABLE application_fuel (
    application_id integer,
    fuel_id integer,
    CONSTRAINT app_fuels_pk PRIMARY KEY (application_id, fuel_id)
);

CREATE TABLE application_extract_file (
    application_id integer,
    extract_file_id integer,
    CONSTRAINT app_extracts_pk PRIMARY KEY (application_id, extract_file_id)
);

/* 2. Create all FK relationships on the many-to-many join tables */

DO $$
BEGIN
    ALTER TABLE application_fuel ADD CONSTRAINT appfuel_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_fuel ADD CONSTRAINT appfuel_fuel_fk FOREIGN KEY (fuel_id) REFERENCES fuel (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_extract_file ADD CONSTRAINT appextfile_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_extract_file ADD CONSTRAINT appextfile_file_fk FOREIGN KEY (extract_file_id) REFERENCES extract_file (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* 3. Create all FK relationships on one-to-many tables. */

DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_person_fk FOREIGN KEY (person_id) REFERENCES person (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_address_fk FOREIGN KEY (address_id) REFERENCES address (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_scheme_fk FOREIGN KEY (scheme_id) REFERENCES scheme (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE document ADD CONSTRAINT document_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE validation ADD CONSTRAINT validation_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE person ADD CONSTRAINT person_bank_fk FOREIGN KEY (bank_details_id) REFERENCES bank_details (id);
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

\q