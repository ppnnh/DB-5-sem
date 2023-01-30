--1.Создайте процедуру, которая выводит список заказов и их итоговую среднюю стоимость для определенного покупателя. 
--Параметр – наименование покупателя. Обработайте возможные ошибки.
CREATE OR REPLACE PROCEDURE prod_1(name_cus customers.company%TYPE) IS
    cost_orders number;
    not_cust exception;
    cust_not_ord exception;
    count_cus number;
    CURSOR c_order IS 
    SELECT * FROM orders o join customers c on c.cust_num = o.cust where c.company = name_cus;
BEGIN
    select count(*) into count_cus from customers where company = name_cus;
    if count_cus = 0 then raise not_cust; 
    end IF;
    /*open c_order;
    if c_order%FOUND then raise cust_not_ord;
    end if;
    close c_order;*/    
    cost_orders := 0;
    FOR ORDER_N IN c_order LOOP
        cost_orders := cost_orders + ORDER_N.AMOUNT;
        sys.dbms_output.put_line('ORDER_NUM: '  || ORDER_N.ORDER_NUM    || ' ' || 
                                    'PRODUCT: ' || ORDER_N.PRODUCT      || ' ' ||
                                    'QTY: '     || ORDER_N.QTY          || ' ' ||
                                    'AMOUNT: '  || ORDER_N.AMOUNT);
    END LOOP;   
    if cost_orders = 0 then raise cust_not_ord;
    end if;
    sys.dbms_output.put_line('Final cost: '|| cost_orders);
EXCEPTION
    WHEN not_cust
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'Takogo customera no'
        );
    WHEN cust_not_ord
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'This customer has not orders'
        );
    WHEN OTHERS
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'ERROR SQLCODE: ' || sqlcode ||
        ', SQLERRM: ' || sqlerrm
        );
END prod_1;
BEGIN
  prod_1('Acme Mfg.');
END;
BEGIN
  prod_1('Acme g.');
END;
BEGIN
  prod_1('AAA Investments');
END;
--2.Создайте функцию, которая подсчитывает количество заказов покупателя за определенный период. 
--Параметры – покупатель, дата начала периода, дата окончания периода.
create or replace function fun2(
    name_cus customers.company%TYPE,
    before_date orders.order_date%TYPE,
    after_date orders.order_date%TYPE
)return INT is
    count_ord int;
    count_cus int;
    not_cust exception;
    error_date exception;
BEGIN
    select count(*) into count_cus from customers where company = name_cus;
    if count_cus = 0 then raise not_cust; 
    end IF;
    if after_date <= before_date then raise error_date;
    end if;
    SELECT count(o.order_num) into count_ord FROM orders o join customers c on c.cust_num = o.cust where c.company = name_cus 
    and o.order_date > before_date and o.order_date < after_date;
    return count_ord;
EXCEPTION
    WHEN not_cust
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'Takogo customera no'
        );
        return -1;
    WHEN error_date
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'Please, сheck the date'
        );
        return -1;
    WHEN OTHERS
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'ERROR SQLCODE: ' || sqlcode ||
        ', SQLERRM: ' || sqlerrm
        );
END;
BEGIN
    sys.dbms_output.put_line(fun2('First Corp.', to_date('2006-11-11', 'yyyy-mm-dd'), to_date('2008-10-10', 'yyyy-mm-dd')));
END;
BEGIN
    sys.dbms_output.put_line(fun2('Firstrp.', to_date('2006-11-11', 'yyyy-mm-dd'), to_date('2008-10-10', 'yyyy-mm-dd')));
END;
BEGIN
    sys.dbms_output.put_line(fun2('First Corp.', to_date('2008-10-10', 'yyyy-mm-dd'), to_date('2008-10-10', 'yyyy-mm-dd')));
END;

select fun2('First Corp.', to_date('2006-11-11', 'yyyy-mm-dd'), to_date('2008-10-10', 'yyyy-mm-dd')) from dual;
select company, fun2(company, to_date('2006-11-11', 'yyyy-mm-dd'), to_date('2008-10-10', 'yyyy-mm-dd')) from customers;
--3.Создайте процедуру, которая выводит список всех товаров, приобретенных покупателем, с указанием суммы продаж по убыванию. 
--Параметр – наименование покупателя. Обработайте возможные ошибки.
CREATE OR REPLACE PROCEDURE proc_3(
        name_cus customers.company%TYPE
    ) IS
    count_cus int;
    CURSOR c_order IS 
    SELECT * FROM orders o join customers c on c.cust_num = o.cust where c.company = name_cus ORDER BY o.amount desc;
BEGIN
    select count(*) into count_cus from customers where company = name_cus;
    FOR ORDER_N IN c_order LOOP
        sys.dbms_output.put_line('ORDER_NUM: '  || ORDER_N.ORDER_NUM    || ' ' || 
                                    'PRODUCT: ' || ORDER_N.PRODUCT      || ' ' ||
                                    'QTY: '     || ORDER_N.QTY          || ' ' ||
                                    'AMOUNT: '  || ORDER_N.AMOUNT);
    END LOOP;   
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN SYS.DBMS_OUTPUT.PUT_LINE
        (
        'No orders'
        );
    WHEN OTHERS
      THEN SYS.DBMS_OUTPUT.PUT_LINE
          (
          'ERROR SQLCODE: ' || sqlcode ||
          ', SQLERRM: ' || sqlerrm
          );
END proc_3;
BEGIN
  proc_3('Acme Mfg.');
END;
--4.Создайте функцию, которая подсчитывает количество заказов за определенный период. 
--Параметры – дата начала периода, дата окончания периода.
create or replace function fun4(
    before_date orders.order_date%TYPE,
    after_date orders.order_date%TYPE
)return INT is
    count_ord int;
    BEGIN
    SELECT count(order_num) into count_ord FROM orders where order_date BETWEEN before_date and after_date;
    return count_ord;
    EXCEPTION
        WHEN OTHERS
          THEN SYS.DBMS_OUTPUT.PUT_LINE
              (
              'ERROR SQLCODE: ' || sqlcode ||
              ', SQLERRM: '     || sqlerrm
              );
    END;
BEGIN
    sys.dbms_output.put_line(fun4('2007-11-11', '2008-10-10'));
END;
--5.Создайте процедуру, которая выводит список покупателей, в порядке убывания общей стоимости заказов. 
--Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки.
create or replace procedure proc5 (date1 varchar, date2 varchar)
is 
cursor c_orders is   
select c.company, sum(o.amount) as sumO from ORDERS o join CUSTOMERS c on o.cust = c.CUST_NUM 
where order_date >= to_date(date1, 'yyyy-mm-dd') and order_date <= to_date(date2, 'yyyy-mm-dd') 
group by c.company order by sum(o.amount) desc;
begin
    for row_order in c_orders
      loop
            SYS.DBMS_OUTPUT.PUT_LINE
                (
                    row_order.sumO || ' ' || 
                    row_order.company
                );
        end loop;
  EXCEPTION
    when others
        then
            SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || 'msg oracle: ' || sqlerrm);
end;
 DECLARE
    l_date1 varchar(20);
    l_date2 varchar(20);

BEGIN
    l_date1 := '2007-12-17';
    l_date2 := '2008-01-22';
    
    proc5(l_date1, l_date2);
END;
--6.Создайте функцию, которая подсчитывает количество заказанных товаров за определенный период. 
--Параметры – дата начала периода, дата окончания периода. Общее количество продуктов, каких
create or replace function fun6(
    before_date varchar,
    after_date varchar
)return INT is
    count_prod int;
    BEGIN
    select count(*) into count_prod from (SELECT product, count(product) FROM orders 
        where order_date >= to_date(before_date, 'yyyy-mm-dd') and order_date <= to_date(after_date, 'yyyy-mm-dd') group by product);
    return count_prod;
    EXCEPTION
        WHEN OTHERS
          THEN SYS.DBMS_OUTPUT.PUT_LINE
              (
              'ERROR SQLCODE: ' || sqlcode ||
              ', SQLERRM: '     || sqlerrm
              );
    END;
DECLARE
    l_date1 varchar(20);
    l_date2 varchar(20);

BEGIN
    l_date1 := '2007-10-11';
    l_date2 := '2008-12-12';
    
    sys.dbms_output.put_line(fun6(l_date1, l_date2));
END;

--Общее количество продуктов, сколько каждого
create or replace function task6 (date1 varchar, date2 varchar)
return number
is 
COUNTER number := 0;
begin
    select sum (QTY) into COUNTER from ORDERS 
        where order_date >= to_date(date1, 'yyyy-mm-dd') and order_date <=to_date(date2, 'yyyy-mm-dd');
  return COUNTER;
  EXCEPTION
    when others
        then
            SYS.DBMS_OUTPUT.PUT_LINE('code error: ' || sqlcode || 'msg oracle: ' || sqlerrm);
end;
DECLARE
    l_date1 varchar(20);
    l_date2 varchar(20);
BEGIN
    l_date1 := '2007-10-10';
    l_date2 := '2008-12-12';
    
    SYS.DBMS_OUTPUT.PUT_LINE('count()= ' || task6(l_date1, l_date2));
END;

--7.Создайте процедуру, которая выводит список покупателей, у которых есть заказы в этом временном периоде. 
--Параметры – дата начала периода, дата окончания периода. Обработайте возможные ошибки
create or replace procedure proc7( before_date varchar, after_date varchar) is
cursor c_customers is
select c.company from customers c join orders o on c.cust_num = o.cust 
where o.order_date >= to_date(before_date, 'yyyy-mm-dd') and o.order_date <= to_date(after_date, 'yyyy-mm-dd') group by c.company;
BEGIN
    FOR ORDER_N IN c_customers LOOP
        sys.dbms_output.put_line('Company: '     || ORDER_N.company);
    END LOOP;   
        EXCEPTION
            WHEN NO_DATA_FOUND
                THEN SYS.DBMS_OUTPUT.PUT_LINE
                (
                'No orders'
                );
            WHEN OTHERS
              THEN SYS.DBMS_OUTPUT.PUT_LINE
                  (
                  'ERROR SQLCODE: ' || sqlcode ||
                  ', SQLERRM: ' || sqlerrm
                  );
    END proc7;
DECLARE
    l_date1 varchar(20);
    l_date2 varchar(20);
BEGIN
    l_date1 := '2007-10-10';
    l_date2 := '2008-12-12';
    
    proc7(l_date1, l_date2);
END;

select c.company from customers c join orders o on c.cust_num = o.cust where o.order_date >= to_date('2007-10-10', 'yyyy-mm-dd') and o.order_date <= to_date('2008-12-12', 'yyyy-mm-dd') group by c.company;

--8.Создайте функцию, которая подсчитывает количество покупателей определенного товара. Параметры – наименование товара.
create or replace function fun8(name_product products.description%TYPE)return int is
count_cus int;
BEGIN
    select count(*) into count_cus from 
        (select o.cust from orders o join products p on 
        p.product_id=o.product where p.description = name_product 
        group by o.cust);
    return count_cus;
EXCEPTION
    WHEN OTHERS
      THEN SYS.DBMS_OUTPUT.PUT_LINE
          (
          'ERROR SQLCODE: ' || sqlcode ||
          ', SQLERRM: '     || sqlerrm
          );
END;
BEGIN
    sys.dbms_output.put_line(fun8('Ratchet Link'));
END;

--9.Создайте процедуру, которая увеличивает на 10% стоимость определенного товара. 
--Параметр – наименование товара. Обработайте возможные ошибки
create or replace procedure proc9(name_product products.description%TYPE) is
old_price products.price%TYPE;
new_price products.price%TYPE;
begin
    select price into old_price from products where description = name_product;
    new_price := old_price * 1.1;
    UPDATE products SET price = new_price 
    WHERE description = name_product;
    SYS.DBMS_OUTPUT.PUT_LINE('Old price: ' || old_price || ', new price: ' || new_price);
end proc9;
EXCEPTION
    WHEN OTHERS
      THEN SYS.DBMS_OUTPUT.PUT_LINE
          (
          'ERROR SQLCODE: ' || sqlcode ||
          ', SQLERRM: '     || sqlerrm
          );
END;
BEGIN
    proc9('Plate');
END;

--10.Создайте функцию, которая вычисляет количество заказов, выполненных в определенном году для определенного покупателя. 
--Параметры – покупатель, год. товара.
create or replace function fun10(customer customers.company%TYPE, er varchar)return int is
count_ord int := 0 ;
begin
select count(*) into count_ord from orders o join customers c on c.cust_num = o.cust where to_char(o.order_date, 'YYYY') = er;
return count_ord;
EXCEPTION
    WHEN OTHERS
      THEN SYS.DBMS_OUTPUT.PUT_LINE
          (
          'ERROR SQLCODE: ' || sqlcode ||
          ', SQLERRM: '     || sqlerrm
          );
end;
BEGIN
    sys.dbms_output.put_line(fun10('Acme Mfg.', '2008'));
END;