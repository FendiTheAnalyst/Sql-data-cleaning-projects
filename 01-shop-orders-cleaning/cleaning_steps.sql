use cleaning_project;

-- backup --
create table messy_orders_backup as
select * from messy_orders;

-- Removed 	Extra spaces --
update messy_orders
set customer_name = TRIM(customer_name),
    email         = TRIM(email),
    phone         = TRIM(phone),
    city          = TRIM(city),
    product       = TRIM(product),
    category      = TRIM(category),
    status        = TRIM(status);
    
-- Fixed Inconsistent capitalization --
    update messy_orders
set customer_name = lower(customer_name),
    email         = lower(email),
    phone         = lower(phone),
    city          = lower(city),
    product       = lower(product),
    category      = lower(category),
    status        = lower(status);
    
-- Fixed Misspellings --
update messy_orders set city = "lagos" where city = "lgos";
update messy_orders set city = "abuja" where city = "abudja";
update messy_orders set city = "port harcourt" where city = "ph";
update messy_orders set city = "port harcourt" where city = "port-harcourt";
update messy_orders set status = "delivered" where status = "delivred";
update messy_orders set status = "cancelled" where status = "canceled";
update messy_orders set product = "bluetooth speaker" where product = "bluetooth speakr";
update messy_orders set product = "rice 50kg" where product = "rice 50 kg";
update messy_orders set phone = "08051112222" where phone = "+2348051112222";

-- Filled Missing Values --
update messy_orders set category = "stationery" where category IS NULL;
update messy_orders set customer_name = "anon" where customer_name IS NULL;
update messy_orders set category = "stationery" where category IS NULL;
update messy_orders set status = NULL where status = "";
update messy_orders set city = NULL where city = "";

set SQL_SAFE_UPDATES = 0;

update messy_orders m
join messy_orders_backup b ON m.order_id = b.order_id
set m.email = b.email
where b.email IS NULL;

update messy_orders set email = NULL where TRIM(email) = "" or email = "N/A";
update messy_orders set unit_price = "12000" where unit_price = "unknown";
update messy_orders set email = "ngozi.nwosu@mail.com" where email = "ngozi.nwosu@mail";
update messy_orders set phone = NULL where phone = "" or phone = "N/A";

-- Fixed Mixed Date Format --
alter table messy_orders add column order_date_clean date;

update messy_orders
set order_date_clean = case
  when order_date regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' 
       then STR_TO_DATE(order_date, '%Y-%m-%d')
  when order_date regexp '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
       then STR_TO_DATE(order_date, '%Y/%m/%d')
  when order_date regexp '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
       then STR_TO_DATE(order_date, '%d/%m/%Y')
  when order_date regexp '^[0-9]{2}-[A-Za-z]{3}-[0-9]{4}$'
       then STR_TO_DATE(order_date, '%d-%b-%Y')
  when order_date regexp '^[A-Za-z]{3} [0-9]{1,2}, [0-9]{4}$'
       then STR_TO_DATE(order_date, '%b %e, %Y')
  when order_date regexp '^[0-9]{1,2} [A-Za-z]+ [0-9]{4}$'
       then STR_TO_DATE(order_date, '%e %M %Y')
end
where order_date IS NOT NULL
;

alter table messy_orders drop column order_date;
alter table messy_orders change order_date_clean order_date date;

--  Corrected	Wrong data types --
update messy_orders set quantity = "1" where quantity = "one";
update messy_orders set quantity = "3" where quantity = "three";
update messy_orders set unit_price = "3500" where unit_price = "$5";
update messy_orders set quantity = NULL where quantity = "";

update messy_orders
set unit_price = replace(replace(unit_price, 'NGN ', ''), ',', '')
where unit_price like 'NGN%';

alter table messy_orders
  modify order_id   INT,
  modify quantity   INT,
  modify unit_price DECIMAL(10,2);

-- Fixed Invalid Values --
update messy_orders set quantity = "1" where quantity = "-1";
update messy_orders set unit_price = "28000" where unit_price = "2800000";

-- Removed Duplicate Rows --
select order_id, count(*) as times
from messy_orders
group by order_id
having count(*) > 1;

select *
from messy_orders
where order_id in ('1001', '1003', '1010', '1019')
order by order_id;

create table orders_clean as
select distinct * 
from messy_orders;

-- Standardize Phone Numbers --
update orders_clean
set phone = replace(phone, ' ', '')
where phone like '% %';

