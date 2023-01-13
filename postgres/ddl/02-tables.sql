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
 *  Usage         : sudo -u postgres psql -f 02-tables.sql [-v param=value]
 *                  Or, if remote then use the host flag in the command:
 *                  sudo -u postgres -h <hostname> psql -f 02-tables.sql
 *
 *  Parameters    : -v altebss_pwd='password'
 * 
 *  Notes         : This script must be run as a super-user, the default as 
 *                  shown in the usage comment is the "postgres" user.
 *
 *  Example       : psql -U ebss_af -d altebss_db -h 127.0.0.1 -v altebss_pwd='altebss' -v ebss_af_pwd='ebss_af'
 *
 * ----------------------------------------------------------------------------
*/

\set ON_ERROR_STOP on
\set schema ebss_af

/* 1. Create all tables without any foreign key relationships. */




