set serveroutput on;

--1 
BEGIN
    null;
END;

--2
begin
  dbms_output.put_line('Hello world!'); 
end;

--3
declare
   x number(3) := 3;
   y number(3) := 0;
   z number (10,2);
begin
    z:=x/y;
    exception when others
    then dbms_output.put_line(sqlcode||': error = '||sqlerrm);
end;

--4
    declare
        x number(3) := 3;
    begin
        begin
            declare x number(3) :=1;
            begin dbms_output.put_line('x = '||x); end;
        end;
        dbms_output.put_line('x = '||x);
    end;
    
--5 all, perfomance, informational, severe, specific error
select name, value from v$parameter where name = 'plsql_warnings';

--6
select keyword from v$reserved_words where length = 1 and keyword != 'A';

--7
select keyword from v$reserved_words where length > 1 and keyword!='A' order by keyword;

--8
select name,value from v$parameter where name like 'plsql%';

--9-17
declare
        c1 number(3)        := 25;
        c2 number(3)        := 10;
        div number(10,2);
        fix number(10,2)    := 3.12;
        otr number(4, -5)   := 32.12345;
        en number(32,10)    := 12345E-10;
        bf binary_float     := 123456789.12345678911;
        bd binary_double    := 123456789.12345678911;
        b1 boolean          := true;
    
    begin
        div := mod(c1,c2);
        dbms_output.put_line('c1 = '||c1);
        dbms_output.put_line('c2 = '||c2);
        dbms_output.put_line('c1%c2 = '||div);
        
        dbms_output.put_line('fix = '||fix);
        dbms_output.put_line('otr = '||otr);
        dbms_output.put_line('en = '||en);
        dbms_output.put_line('bf = '||bf);
        dbms_output.put_line('bd = '||bd);
        if b1 then dbms_output.put_line('b1 = '||'true'); end if;
    end;
    
--18
declare
        n1 constant number(5) := 5; 
        vc constant varchar(25) := 'Hello world'; --up to 4000 b
        c constant char(7) := 'Yulia';            --up to 2000 b
    begin
        dbms_output.put_line('vc = '||vc);
        dbms_output.put_line('n1 = '||n1);
        dbms_output.put_line('c = '||c);
        
      -- n1:=10;
        exception when others
            then dbms_output.put_line('error = '||n1);
    end;
    
--19-20
declare
        name varchar(25) := 'Smith';
        surname name%TYPE := 'Jones'; 
        x  dual%ROWTYPE;
    begin
        select 'J' into x from dual;
        dbms_output.put_line('name = '||name);
        dbms_output.put_line(x.dummy);
    end;
    
--21
declare
        x pls_integer := 17;
    begin
        if 8>x then dbms_output.put_line('8>'||x);
        elsif 8=x then dbms_output.put_line('8='||x);
        else dbms_output.put_line('8<'||x);
        end if;
    end;
    
--22
declare
        x pls_integer := 17;
    begin
        case x
            when 17 then dbms_output.put_line('17');
        end case;
        case
            when 8>x then dbms_output.put_line('8>'||x);
            when x between 13 and 20 then dbms_output.put_line('yes');
            else dbms_output.put_line('else');
        end case;
    end;

--23-25
declare
        x pls_integer :=0;
    begin
        loop x:=x+1;
             dbms_output.put(x);
            exit when x>5;
            end loop;
        for k in 1..5
            loop dbms_output.put_line(k); end loop;
        while (x>0)
            loop x:=x-1;
            dbms_output.put_line(x);
            end loop;
end;
