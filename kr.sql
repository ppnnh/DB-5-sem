select * from OFFICES;
select * from SALESREPS;
select * from ORDERS;
select * from PRODUCTS;

select s.name, p.mfr_id, o.office
from salesreps s join offices o
on s.rep_office = o.office
join orders os
on s.empl_num = os.rep
join products p
on os.product = p.product_id
where p.mfr_id != 'REI' and s.rep_office = '22'; 

select s.name, o.office, os.order_date
from salesreps s join offices o
on s.rep_office = o.office
join orders os
on s.empl_num = os.rep
where o.office = 11 and os.order_date between '2008-01-01' and '2008-12-27';

create or replace procedure getSalesreps(date1 orders.order_date%type, date2 orders.order_date%type, office_id offices.office%type)
as
  cursor empls is select s.name, o.office, os.order_date
    from salesreps s join offices o
    on s.rep_office = o.office
    join orders os
    on s.empl_num = os.rep
    where o.office = office_id and os.order_date between date1 and date2;
  empl empls%rowtype;
begin
  open empls;
  loop
    fetch empls into empl;
    exit when empls%notfound;
    dbms_output.put_line(empl.name || '');
  end loop;
  close empls;
  
  exception
    when others then
      dbms_output.put_line(sqlerrm);
end;

begin
  getsalesreps('2008-01-01','2008-12-27', 11);
end;

create or replace function getNotMfr(
  office_code offices.office%type, 
  mfr products.mfr_id%type
)return number
as
  count_pr number;
begin
  select count(*) into count_pr
    from salesreps s join offices o
    on s.rep_office = o.office
    join orders os
    on s.empl_num = os.rep
    join products p
    on os.product = p.product_id
    where p.mfr_id != mfr and o.office = office_code;
    return count_pr;
end;

  select count(*)
    from salesreps s join offices o
    on s.rep_office = o.office
    join orders os
    on s.empl_num = os.rep
    join products p
    on os.product = p.product_id
    where p.mfr_id != 'REI' and o.office = 22;

begin
  dbms_output.put_line(getNotMfr(22, 'REI'));
end;


