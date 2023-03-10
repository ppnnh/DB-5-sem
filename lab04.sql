
--1
select * from  v$pdbs;

 --2
select * from v$instance;

--3
select * from product_component_version;

--6
create tablespace bvd
datafile 'C:\app\Tablespaces\bvd.dbf'
size 10M
offline;

alter tablespace bvd online;

create temporary tablespace bvd_temp
tempfile 'C:\app\Tablespaces\bvd_temp.dbf'
size 5M
autoextend on next 500K
maxsize 30M
extent management local;

alter session set "_oracle_script"=true;
create role bvdrole;

grant create session to bvdrole;
grant create table, create view, create procedure to bvdrole;
grant drop any table, drop any view, drop any procedure to bvdrole;

create profile bvdprofile limit
password_life_time 180
sessions_per_user 3
failed_login_attempts 7
password_lock_time 1
password_reuse_time 10
password_grace_time default
connect_time 180
idle_time 30;

create user bvduser identified by 12345
default tablespace bvd quota unlimited on bvd
temporary tablespace bvd_temp
profile bvdprofile
account unlock
password expire;

alter user bvduser identified by 123456 account unlock;
grant bvdrole to bvduser;

--7
create table bvd_table(
id int,
name varchar(15)
);

insert into bvd_table values (1, 'Lera');
insert into bvd_table values (2, 'Egor');
insert into bvd_table values (3, 'Andrey');
insert into bvd_table values (4, 'Vika');

select * from bvd_table;

 --8
select * from DBA_TABLESPACES;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_roles;
select grantee, privilege from dba_sys_privs;
select * from dba_profiles;
select * from all_users;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       