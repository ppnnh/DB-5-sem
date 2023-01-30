create table BVD_t(x number(3), s varchar2(50), constraint pr_d primary key (x));

insert into BVD_t values(6, 'one');
insert into BVD_t values(7, 'two');
insert into BVD_t values(3, 'three');
commit;

update BVD_t set x=1 where s='one';
update BVD_t set x=2 where s='two';
commit;

select * from BVD_t where x=3;

delete from BVD_t where s='three';
commit;

create table BVD_tl(x number(3),  d varchar(50), constraint fk_d foreign key(x) references BVD_t(x));
insert into BVD_tl values(1, '1');
insert into BVD_tl values(2, '2');

select * from BVD_t left outer join BVD_tl 
on BVD_t.x=BVD_tl.x;

select * from BVD_t right outer join BVD_tl 
on BVD_t.x=BVD_tl.x;

select * from BVD_t inner join BVD_tl 
on BVD_t.x=BVD_tl.x;

drop table BVD_tl;
drop table BVD_t;