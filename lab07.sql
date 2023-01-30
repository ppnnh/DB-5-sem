--1
select name, description from v$bgprocess;

--2
select name, description, paddr from v$bgprocess where paddr!=hextoraw('00');

--3
--select * from v$bgprocess where name='DBWn';
select count(*) from v$bgprocess where paddr!=hextoraw('00') and name='DBWn';

--4
select * from v$session where username is not null;

--5
select username, status, server from v$session where username is not null;

--6
select name, network_name, pdb from  v$services;

--7
show parameter dispatcher;

--9
select username, sid, serial#, server, status from v$session where username is not null;
