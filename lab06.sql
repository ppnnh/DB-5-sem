--1
select sum(value) from v$sga;

--2
select component, current_size from v$sga_dynamic_components 
where component like '%pool%';

--3
select component, granule_size from v$sga_dynamic_components
where component like '%pool%';

--4
select * from v$sgastat where name like 'free memory';

--5
select component, current_size from v$sga_dynamic_components
where component like '%buffer cache';

--6
create table XXX (k int) storage(buffer_pool keep) tablespace users;
insert into XXX values (1);
commit;

--7
create table YYY (k int) storage(buffer_pool default) tablespace users;
insert into YYY values (1);
commit;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name in ('XXX', 'YYY');

--8
select * from v$sga where name like 'Redo%';

--9
select pool, name, bytes from v$sgastat
where pool='shared pool' order by bytes desc
fetch first 10 rows only; 

--10
select pool, name, bytes from v$sgastat where pool='large pool' and name='free memory';

--11
select * from v$session where username is not null;
select  username, service_name from v$session where username is not null;

--12
select username, service_name, server from v$session where username is not null;

--13*
select stats_mode(pool) from v$sgastat;
