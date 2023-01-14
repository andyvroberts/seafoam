/* 
 *----------------------------------------------------------------------------
 *  File name     : 02-tables.sql
 *  Author        : DBA
 *  Date Created  : 2023-01-04
 *  Date Changed  : 
 *  Psql Version  : 13.9
 *  State         : Released
 *  Description   : Creates the ebss_af database tables.
 *
 *  Usage         : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 02-tables.sql
 *
 *  Parameters    : -v altebss_pwd='password'
 * 
 *  Notes         : This script must be run as the ebss_af schema owner.
 *
 *  Example       : psql -U ebss_af -d altebss_db -h 127.0.0.1 -f 02-tables.sql
 *
 * ----------------------------------------------------------------------------
*/

\set ON_ERROR_STOP on
\set schema ebss_af


/* 1. Drop all tables in the correct sequence for parent-child relationships. */

DROP TABLE IF EXISTS application_fuel;
DROP TABLE IF EXISTS application_extract_file;

DROP TABLE IF EXISTS custodian;

DROP TABLE IF EXISTS validation;
DROP TABLE IF EXISTS document;

DROP TABLE IF EXISTS application;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS bank_details;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS scheme;

DROP TABLE IF EXISTS extract_file;
DROP TABLE IF EXISTS fuel;



/* 2. Create all tables without any foreign key relationships. */
/* Primary keys defined as "serial" are integers.  bigserial are bigint */

CREATE TABLE address (
    id serial CONSTRAINT address_pk PRIMARY KEY,
    uprn numeric(12),
    address_line_1 varchar(256),
    address_line_2 varchar(256),
    town varchar(128),
    county varchar(128),
    postcode varchar(10),
    custodian_code varchar(10)
);

CREATE TABLE application (
    id serial CONSTRAINT application_pk PRIMARY KEY,
    person_id integer,
    address_id integer,
    scheme_id integer,
    reference varchar(12),
    application_status varchar(24),
    application_substatus varchar(24),
    council_tax_registered char(1),
    name_on_council_tax char(1),
    discount_received char(1) DEFAULT 'N',
    application_for_self char(1),
    application_for_others char(1),
    address_confirmation char(1),
    main_accomodation char(1),
    accomodation_type varchar(32),
    rental_type varchar(64),
    mobile_residence_type varchar(32),
    boat_licence_type varchar(32),
    care_home_funding_type varchar(32),
    CONSTRAINT user_ref UNIQUE (reference)
);

CREATE TABLE bank_details (
    id serial CONSTRAINT bank_details_pk PRIMARY KEY,
    account_name varchar(256),
    sort_code numeric(6),
    account_number numeric(8),
    roll_number varchar(12),
    business_account char(1) DEFAULT 'N'
);

CREATE TABLE custodian (
    id serial CONSTRAINT custodian_code_pk PRIMARY KEY,
    custodian_code varchar(10),
    authority_name varchar(256),
    region varchar(256),
    country varchar(64),
    file_folder varchar(256)
);

CREATE TABLE document (
    id serial CONSTRAINT document_pk PRIMARY KEY,
    application_id integer,
    document_type varchar(64),
    document_location varchar(256),
    document_status varchar(32)
);

CREATE TABLE extract_file (
    id serial CONSTRAINT extract_file_pk PRIMARY KEY,
    file_type varchar(64),
    file_location varchar(256),
    file_status varchar(32),
    custodian_code varchar(10)
);

CREATE TABLE fuel (
    id serial CONSTRAINT fuel_pk PRIMARY KEY,
    fuel_type varchar(64)
);

CREATE TABLE person (
    id serial CONSTRAINT person_pk PRIMARY KEY,
    bank_details_id integer,
    person_name varchar(256),
    date_of_birth varchar(10),
    email varchar(64),
    phone varchar(17),
    mobile varchar(17)
);

CREATE TABLE scheme (
    id serial CONSTRAINT scheme_pk PRIMARY KEY,
    scheme_code varchar(32),
    scheme_description varchar(256),
    payment_value numeric(8,2)
);

CREATE TABLE validation (
    id serial CONSTRAINT validation_pk PRIMARY KEY,
    application_id integer,
    validation_type varchar(32),
    validation_result varchar(12),
    validation_result_text varchar(256),
    dms_batch_id numeric(5)
);

/* 1. Create all many-to-many join tables */

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