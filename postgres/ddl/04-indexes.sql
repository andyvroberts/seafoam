/* 
 *----------------------------------------------------------------------------
 *  File name     : 04-indexes.sql
 *  Author        : DBA
 *  Date Created  : 2023-01-04
 *  Date Changed  : 
 *  Psql Version  : 13.9
 *  State         : Released
 *  Description   : Creates required indexes on the ebss_af schema tables.
 *
 *  Usage         : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 04-indexes.sql
 *
 *  Parameters    : None.
 * 
 *  Notes         : This script must be run as the ebss_af schema owner.
 *
*  Example       : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 04-indexes.sql
 *
 * ----------------------------------------------------------------------------
*/

\set ON_ERROR_STOP on
\set schema ebss_af

/* 1. Create indexes for foreign key join queries. */

CREATE INDEX IF NOT EXISTS app_person_idx ON application (person_id);

CREATE INDEX IF NOT EXISTS app_address_idx ON application (address_id);

CREATE INDEX IF NOT EXISTS app_scheme_idx ON application (scheme_id);

CREATE INDEX IF NOT EXISTS document_app_idx ON document (application_id);

CREATE INDEX IF NOT EXISTS validation_app_idx ON validation (application_id);

CREATE INDEX IF NOT EXISTS person_bank_idx ON person (bank_details_id);

/* 2. Create indexes for performance. */

/* Create an application index to enable faster querying for an application status. */

CREATE INDEX IF NOT EXISTS app_status_idx ON application (application_status, application_substatus);

/* Create a validation type index for faster scans to retrieve applications by passed or failed validations. */

CREATE INDEX IF NOT EXISTS validation_type_res_idx ON validation (validation_type, validation_result);

/* Create an address index to search for applications belonging to specific local authorities [custodian code]. */

CREATE INDEX IF NOT EXISTS address_cust_code_idx ON address (custodian_code);

/* Create a unique index on the lookup table for custodian code, a query should never return multiple rows. */

CREATE UNIQUE INDEX IF NOT EXISTS custodian_code_ux ON custodian (custodian_code);