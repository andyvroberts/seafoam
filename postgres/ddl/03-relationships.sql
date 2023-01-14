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

/* 2. Create all FK relationships on the many-to-many join tables */

DO $$
BEGIN
    ALTER TABLE application_fuel ADD CONSTRAINT appfuel_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
    RAISE NOTICE 'Created appfuel_app_fk ON TABLE application_fuel';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_fuel ADD CONSTRAINT appfuel_fuel_fk FOREIGN KEY (fuel_id) REFERENCES fuel (id);
    RAISE NOTICE 'Created appfuel_fuel_fk ON TABLE application_fuel';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_extract_file ADD CONSTRAINT appextfile_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
    RAISE NOTICE 'Created appextfile_app_fk ON TABLE application_extract_file';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

DO $$
BEGIN
    ALTER TABLE application_extract_file ADD CONSTRAINT appextfile_file_fk FOREIGN KEY (extract_file_id) REFERENCES extract_file (id);
    RAISE NOTICE 'Created appextfile_file_fk ON TABLE application_extract_file';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* 3. Create all FK relationships on one-to-many tables. */

/* The person table is the parent.  A person can have many applications. */
DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_person_fk FOREIGN KEY (person_id) REFERENCES person (id);
    RAISE NOTICE 'Created app_person_fk ON TABLE application';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* The address table is the parent.  An address can be used for more than one application. */
DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_address_fk FOREIGN KEY (address_id) REFERENCES address (id);
    RAISE NOTICE 'Created app_address_fk ON TABLE application';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* The scheme table is the parent.  A scheme can have many applications. */
DO $$
BEGIN
    ALTER TABLE application ADD CONSTRAINT app_scheme_fk FOREIGN KEY (scheme_id) REFERENCES scheme (id);
    RAISE NOTICE 'Created app_scheme_fk ON TABLE application';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* The application table is the parent.  An application can have more than one uploaded document. */
DO $$
BEGIN
    ALTER TABLE document ADD CONSTRAINT document_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
    RAISE NOTICE 'Created document_app_fk ON TABLE document';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* The application table is the parent.  An application can be subject to many validations. */
DO $$
BEGIN
    ALTER TABLE validation ADD CONSTRAINT validation_app_fk FOREIGN KEY (application_id) REFERENCES application (id);
    RAISE NOTICE 'Created validation_app_fk ON TABLE validation';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

/* The bank details table is the parent.  The same bank details can apply to more than one person. */
DO $$
BEGIN
    ALTER TABLE person ADD CONSTRAINT person_bank_fk FOREIGN KEY (bank_details_id) REFERENCES bank_details (id);
    RAISE NOTICE 'Created person_bank_fk ON TABLE person';
EXCEPTION 
    WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

\quit