# Linux Install 
Add the linux packages.  The MS instructions to install in WSL are useful.  
https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-postgresql  

Query or stop/start the database.
```
sudo service postgresql status  
sudo service postgresql start  
sudo service postgresql stop  
```

During installation the default admin user/owner called *postgres* is created as a Linux user and as the default database administrator.  
Connect to the psql shell and display all db users. 
```
sudo -u postgres psql
\du
\q
```

You can also switch user to postgres and run SQL commands without entering the psql shell, but you will first have to assign a password, then you can switch users.  
```
sudo passwd postgres
su - postgres
psql -c "\du"
```

## Create a Database
Using the postgres super user, add the ebss application database:
```
create database ebss_af;
```
https://www.postgresql.org/docs/13/sql-createdatabase.html  
  
For interest you can list databases with *\l* and list tablespaces with the *\db* command.  

## Add A Different Owner/User for the Database
The easiest way to login with a different user (from postgres) is to create the linux account and the database and role with the same name.  The Linux account name will be associated to a database of the same name by PostgreSQL.  
In the linux command line:
``
adduser ebss_af
``

Again, using the postgres super user, perform the following actions.  

Create a database user/role that will be used by the ebss-af application and which has enough privilges for full DML operations, and that can also run migrations by dropping and re-recreating tables.  
```
create role ebss_af with password 'ebss_owner';
```
https://www.postgresql.org/docs/13/sql-createrole.html  

Add specific priviliges to this role:  
```
alter role ebss_af WITH LOGIN;
alter role ebss_af VALID UNTIL 'Dec 31 12:00:00 2023';
```
https://www.postgresql.org/docs/13/sql-alterrole.html  

Ensure that the ebss-owner is the owner of the ebss database:
```
alter database ebss_af owner to ebss_af;  
```
https://www.postgresql.org/docs/13/sql-alterdatabase.html  


### Connect to the database
Switch to the ebss_af user:  
```
su ebss_af
```
Connect to the database:  
```
psql ebss_af
```
Once in the psql shell, check you are in the right DB:
```
select current_database();
```

## Add a Schema


