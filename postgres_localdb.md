# Linux Install 
Add the linux packages.  The MS instructions to install in WSL are useful.  
https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-postgresql  

Query or stop/start the database.
```
sudo service postgresql status  
sudo service postgresql start  
sudo service postgresql stop  
```
As of December 2022, the debian package is postgres 13.9.  

During installation the default admin user/owner called *postgres* is created as a Linux user and as the default database administrator.  
Connect to the psql shell and display all db users. 
```
sudo -u postgres psql
\du
\q
```

You can also switch user to postgres and run SQL commands without entering the psql shell. If you want to run commands as the postgres super user, or use it remotely or through a GUI, you will first have to assign a password.  
```
sudo passwd postgres
su - postgres 
psql -c "\du"
```

# Databases and Users
The following sections will provide guidance to complete these steps:
1. Create a new Postgres database called altebss_db.
2. Create a system user that is the database owner, called altebss.  In Postgres a user is called a role.
3. Create a database Schema called ebss_af.  
4. Create a Schema owner called ebss_af.  
5. Create a database table to test the ebss_af schema.

The altebss_db is the container, which can house data models for multiple alternate funds.  The first schema being created here is the ebss_af schema.  

## Create a Database
Using the postgres super user, add the altnerate ebss application database:
```
sudo -u postgres psql

create database altebss_db;
```
https://www.postgresql.org/docs/13/sql-createdatabase.html  
  
For interest you can list databases and tablespaces with: 
```
\l 
\db
```

## Create a System User to own the Database
The easiest way to login with a user that is not the postgres super user, is to create the linux account and database user/role with the same name.  The Linux account name will be associated to a database user of the same name by PostgreSQL by using the "peer" connection method.  
In the linux command line:  
```
sudo adduser altebss
```
Note: if you need it you can add altebss as a super user by using the *visudo* command and adding a new entry in the list, but that is not needed here.  
The remove user command is: 
```
sudo userdel -r altebss
``` 
The -r flag will remove the users home directory.  

Next, using the postgres super user, perform the following actions.  
Create a database user/role that will own the database container for all alternate ebss applications.    
```
sudo -u postgres psql

create role altebss with password 'password';
```
https://www.postgresql.org/docs/13/sql-createrole.html  

Add specific priviliges to this role:  
```
alter role altebss WITH LOGIN;
alter role altebss VALID UNTIL 'Dec 31 12:00:00 2023';
```
https://www.postgresql.org/docs/13/sql-alterrole.html  

Ensure that the altebbs role is the owner of the alternative ebss database:
```
alter database altebss_db owner to altebss;  
```
https://www.postgresql.org/docs/13/sql-alterdatabase.html  


### Connect to the database
Switch to the altebss role/user:  
```
su altebss
```
Connect to the database:  
```
psql altebss_db
```
Once in the psql shell, check you are in the right DB:
```
select current_database();
```
This role will never be actively used by the appication.  It provides protection so that the database cannot be deleted accidentally, as a schema owner has no database level privileges.   

## Create a Schema
In Postgres, privilege management is not as sophisticated as in other RDBMS providers such as MS SQL or Oracle.  Because the alternate ebss applications will use entity frameworks to interact with the database, the schema owner will need to perform a wide range of DDL and DML operations.  The best way to achieve this is by:
- restricting access to a single schema within the database
- but allowing full access within the schema

Create the role, then the schema and grant the schema to the role.  Show all schemas and tables.   
```
sudo -u postgres psql altebss_db

create role ebss_af with password 'password' LOGIN;
create schema ebss_af authorization ebss_af;
\dn
\dt
```

The ebss_af role now has full ownership of the schema and can execute DDL as well as perform all DML on database objects it creates and owns.  

Connect to the database as the new role, set ebss_af as the defalt schema and create a table.
```
psql -d altebss_db -U ebss_af -h 127.0.0.1
set schema ebss_af
create table test_1(col1 char(5) primary key, col2 varchar(10), col3 integer);

altebss_db-> \dt
         List of relations
 Schema  |  Name  | Type  |  Owner  
---------+--------+-------+---------
 ebss_af | test_1 | table | ebss_af
(1 row)
```
Note: by specifying the host (-h) when connecting, you bypass the peer connection method and use md5, whcih then prompts for a password without expecting a Linux account (peer) to exist.  

We can insert and delete from the table.
```
insert into test_1(col1, col2, col3) values ('one', 'happy', 1);
insert into test_1(col1, col2, col3) values ('two', 'surprised', 2);

select * from test_1;
 col1  |   col2    | col3 
-------+-----------+------
 one   | happy     |    1
 two   | surprised |    2
(2 rows)

delete from test_1 where col1 = 'one';
```

can we drop the table?
```
drop table test_1;
DROP TABLE

select * from test_1;
ERROR:  relation "test_1" does not exist
LINE 1: select * from test_1;
                      ^
```

can we drop the database?
```
drop database altebss_db;
ERROR:  must be owner of database altebss_db
```

can we drop the schema?
```
altebss_db-> \dn
   List of schemas
   Name   |  Owner   
----------+----------
 ebss_af  | ebss_af
 ebss_afp | altebss
 public   | postgres
(3 rows)

drop schema ebss_af;
DROP SCHEMA

altebss_db-> \dn
   List of schemas
   Name   |  Owner   
----------+----------
 ebss_afp | altebss
 public   | postgres
(2 rows)
```
Yes we can.  However we cannot drop any other schemas.
```
drop schema ebss_afp;
ERROR:  must be owner of schema ebss_afp
```


# Useful Commands
To find out where the database config file is:
```
psql altebss_db -c "show config_file"
psql altebss_db -c "show hba_file"
```
or if in the psql
```
show config_file;
show hba_file;
```

## Enable Table Statistics Collection
These are options that must be made to the configuration file.  
```
sudo -u postgres psql -c "show config_file"

               config_file
-----------------------------------------
 /etc/postgresql/13/main/postgresql.conf
(1 row)
```

The pg_stat_statements package is needed to collect ongoing statistics.  Usually it is now included by default within an installation, but if it must be added them make sure to set the preload libraries.  
```
shared_preload_libraries = 'pg_stat_statements'	# (change requires restart)
```
For table and index statistics, edit the config file and make sure that the tracking you require is un-commented:  
```
#------------------------------------------------------------------------------
# STATISTICS
#------------------------------------------------------------------------------

# - Query and Index Statistics Collector -

track_activities = on
track_counts = on
track_io_timing = off
#track_functions = none                 # none, pl, all
track_activity_query_size = 1024        # (change requires restart)
stats_temp_directory = '/var/run/postgresql/13-main.pg_stat_tmp'
```

Note: For config file settings to take effect, the postgres service must be restarted.
```
sudo postgresql service restart
```

## DB Settings Using Include
See particular settings:
```
psql altebss_db -c "show max_connectons"
psql altebss_db -c "show shared_buffers"
```
To add custom settings whilst not changing the defaults, you can create a postgresql.local.conf file in the same folder as the config_file.  Put your custom settings there, but don't forget to add the include line in the main settings file.  The additional line in postgresql.conf should be at the bottom in the custom section and it should look like this
```
include postgresql.local.conf
```





