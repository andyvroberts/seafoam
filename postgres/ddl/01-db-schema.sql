/* 
 *----------------------------------------------------------------------------
 *  File name     : 01-db-schema.sql
 *  Author        : DBA
 *  Date Created  : 2023-01-04
 *  Date Changed  : 
 *  Psql Version  : 13.9
 *  State         : Released
 *  Description   : Creates the altebss_db databse and altebss role which is 
 *                  the database container.
 *                  Also creates the ebbs_af schema and ebss_af role with the 
 *                  altebss_db for the application tables.
 *                  The user running the script must be a super-user.
 *
 *  Usage         : sudo -u postgres psql -f 01-db-schema.sql [-v param=value]
 *                  Or, if remote then use the host flag in the command:
 *                  sudo -u postgres -h <hostname> psql -f 01-db-schema.sql
 *
 *  Parameters    : -v altebss_pwd='password'
 *                  -v ebss_af_pwd='password'
 * 
 *  Notes         : This script must be run as a super-user, the default as 
 *                  shown in the usage comment is the "postgres" user.
 *
 *                  In order to create a collation with en_GB, you may have to
 *                  generate it in on your host using the CLI command
 *                  "sudo locale-gen en_GB.utf-8" . You must restart postgres.
 *
 *                  On some linux hosts the locale-gen command will not work 
 *                  and you may have to use the "sudo dpkg-reconfigure locales"
 *                  CLI command to add en_GB.utf-8.  Also, restart postgres 
 *                  afterwards.
 *    
 *                  Connect to a specific database with a specific DB user:
 *                  psql -U altebbs -d altebss_db -h 127.0.0.1
 *
 *  Example       : sudo -u postgres psql -f 01-db-schema.sql -v altebss_pwd='altebss' -v ebss_af_pwd='ebss_af'
 *
 * ----------------------------------------------------------------------------
*/

\set ON_ERROR_STOP on

/* 1. Crate the database.  */

DROP DATABASE IF EXISTS altebss_db;

CREATE DATABASE altebss_db WITH LOCALE 'en_GB.utf-8' ENCODING UTF8 TEMPLATE template0;

/* 2. create the DB owner and assign them the new database. */

DO $$
BEGIN
CREATE ROLE altebss WITH PASSWORD ':altebss_pwd' LOGIN;
EXCEPTION WHEN duplicate_object THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
END
$$;

ALTER DATABASE altebss_db OWNER TO altebss; 

/* connect to the new database */

\connect altebss_db

/* 3. create the application schema and schema owner (they have the same name here) */

DROP SCHEMA IF EXISTS ebss_af;

DROP ROLE IF EXISTS ebss_af;

CREATE ROLE ebss_af WITH PASSWORD ':ebss_af_pwd' LOGIN;

CREATE SCHEMA ebss_af AUTHORIZATION ebss_af;

\quit