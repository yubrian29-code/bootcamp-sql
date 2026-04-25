
-- Create Database
create database bootcamp_2603;
use bootcamp_2603;

-- Create Table
create table employees (
	id integer,
	first_name varchar(50),
    last_name varchar(50),
    dob date,
    salary decimal(7, 2),
    gender varchar(1)
);

drop table employees;
-- No column sequence
-- Case Insensitive (Table name, column name) -> all database

-- Value -> by default Case sensitive (postgreSQL)
-- Value -> by default Case Insensitive (MYSQL)

select * from employees;

-- delete all data (table still exist)
delete from employees;

insert into employees (id, first_name, last_name, dob, salary, gender) 
	values (1, 'John', 'Lau', '2001-12-31', 23000.50, 'M');
    
-- 2, Sally Lau, 2000-04-30, 30000, F
insert into employees (id, first_name, last_name, gender, salary, dob) 
	values (2, 'Sally', 'Lau', 'F', 30000, '2000-04-30');
    
-- 3, Leo Chan, 1980-01-30, 28000, M
insert into employees (id, first_name, last_name, dob, salary, gender) 
	values (3, 'Leo', 'Chan', '1980-01-30', 28000, 'M');
-- 4, Jenny Chan, 1990-02-28, 19000, F
insert into employees (id, first_name, last_name, dob, salary, gender) 
	values (4, 'Jenny', 'Chan', '1990-02-28', 19000, 'F');
-- 5, Oscar Tam, 1993-04-10, 21000, M
insert into employees (id, first_name, last_name, dob, salary, gender) 
	values (5, 'Oscar', 'Tam', '1993-04-10', 21000, 'M');
    
select * from employees where gender = 'M';
select * from employees where gender = 'F';
-- Lau
select * from employees where last_name = 'Lau';
-- salary > 25000
select * from employees where salary > 25000;
-- dob > 2000-01-01
select * from employees where dob > '2000-01-01';
select * from employees where year(dob) = 2000;

-- Lau and salary > 25000
select * from employees where last_name = 'Lau' and salary > 25000;

-- or
select * from employees where salary < 20000 or last_name = 'Chan';

-- select specific columns
select first_name, salary
from employees
where gender = 'M';

-- age 20 - 25
select id, first_name, last_name
from employees
where year(now()) - year(dob) >= 20 and year(now()) - year(dob) <= 25;

-- update field(s)
select * from employees;
update employees set salary = salary * 1.02 where id = 3;
select * from employees;

update employees set salary = 50000, dob = '1991-02-28' where id = 4;
select * from employees;

-- Agg function
select min(salary), max(salary), avg(salary), count(*), sum(salary) from employees;

-- Cannot put agg function together with column name
-- select min(salary), max(salary), avg(salary), count(*), sum(salary), salary from employees;

-- String Function
select instr(first_name, 'l'), first_name from employees; -- indexOf (SQL: index start from 1, java start from 0)
select replace(first_name, 'l', 'x'), first_name from employees; -- 
select left(first_name, 3), right(first_name, 2) from employees;

-- BETWEEN (date, datetime)
select *
from employees
where dob between '2000-01-01' and '2010-12-31'
and gender = 'M';

-- LIKE (slow performance)
select *
from employees
where first_name like 'J%';

select *
from employees
where first_name like '%ll%';

select *
from employees
where last_name in ('Chan', 'Lau'); -- or

select *
from employees
where last_name not in ('Chan', 'Lau');

select * from employees order by first_name; -- by default asc
select * from employees order by dob desc;

-- select(filter columns)
-- where (filter rows)
-- agg function (max, min, avg, sum, count)

select 1, first_name, last_name, 100, 'hello'
from employees;

select count(100) from employees;

-- Find the number of employees, whose salary > 22000
select count(*), avg(salary)
from employees
where salary > 22000;

-- Runtime Steps:
-- Step 1: where
-- Step 2: group by + having
-- Step 3: order by
-- Step 4: select columns

-- orders (datetime)

-- group by

-- return groups (1 row = 1 group)
-- max, min, sum, avg, count
select gender, count(*), max(dob), min(dob), max(year(now()) - year(dob)), sum(year(now()) - year(dob))
from employees
group by gender;

select gender, last_name, count(*), max(dob), min(dob), max(year(now()) - year(dob)), sum(year(now()) - year(dob))
from employees
where salary < 45000 and salary > 20000 -- not yet start grouping, filter rows first
group by gender, last_name
having max(dob) >= '2000-01-01'; -- filter groups

-- having sum(), having count(), having avg(), having max(), having min()

-- F Chan 2
-- M Lau 2
select * from employees;

insert into employees (id, first_name, last_name, dob, salary, gender) values (6, 'Kelly', 'Chan', '2000-01-01', 18000, 'F');
insert into employees (id, first_name, last_name, dob, salary, gender) values (7, 'Tommy', 'Lau', '2001-02-01', 28000, 'M');

delete from employees where id = 6;

-- Date Functions (MYSQL)

-- date_add, date_sub -> interval
select first_name, last_name, dob, date_sub(dob, interval 1000 day)
from employees
where date_add(dob, interval 3 year) > '2002-01-01';

-- alias
select e.*, datediff(dob, '2000-01-01') as super_column
from employees e
order by datediff(dob, '2000-01-01') desc;

select gender, count(*) as count, round(avg(salary),2) as average_salary
from employees
group by gender
order by gender;

select e.id, e.first_name, e.last_name, e.*, STR_TO_DATE('30/06/2020', '%d/%m/%Y') as special_day
from employees e;

update employees set salary = null where id in ('3', '5');
select * from employees;

select e.id, e.first_name, e.last_name, e.dob, ifnull(e.salary, 'N/A'), e.gender
from employees e;

select 
	CASE
        WHEN e.salary >= 28000 THEN 'High_Salary'
        WHEN e.salary >= 15000 THEN 'Normal Salary'
        ELSE 'Low Salary'
    END AS salary_category,
    avg(ifnull(e.salary, 0)) as avg_salary,
    max(ifnull(e.salary, 0)) as max_salary
from employees e
group by salary_category
order by salary_category;

-- employees

-- Record employee AL/SL application
create table apply_leaves (
	id integer,
    employee_id integer,
    leave_type varchar(1),
    apply_datetime datetime,
    leave_date date,
    status varchar(1)
);
drop table apply_leaves;

insert into apply_leaves (id, employee_id, leave_type, apply_datetime, leave_date, status) 
	values (1, 1, 'A', '2026-04-21 23:04:01', '2026-05-20', 'P');
insert into apply_leaves (id, employee_id, leave_type, apply_datetime, leave_date, status) 
	values (2, 1, 'S', '2026-04-22 23:04:01', '2026-05-01', 'A');

insert into apply_leaves (id, employee_id, leave_type, apply_datetime, leave_date, status) 
	values (3, 3, 'A', '2026-04-23 23:04:01', '2026-05-01', 'A');

insert into apply_leaves (id, employee_id, leave_type, apply_datetime, leave_date, status) 
	values (4, 5, 'A', '2026-05-01 23:04:01', '2026-05-01', 'A');
    
-- employee_id, first_name, last_name
-- inner join (x), left join


-- inner join (by default table A x table B)
select e.gender, count(*) as apply_annual_leave_count
from employees e inner join apply_leaves a on e.id = a.employee_id
where a.leave_type = 'A'
group by e.gender;

-- left join (table A x table B) -> on
-- count -> ignore null field 
select e.gender, count(a.id)
from employees e left join apply_leaves a on e.id = a.employee_id
where leave_type = 'A' or leave_type is null
group by e.gender;

-- find those employees, who had applied leave, not yet approved
select e.*
from employees e inner join apply_leaves a on e.id = a.employee_id
where a.status = 'P';

-- exists: read table a (inner join: read table A and table B data)
select e.*
from employees e
where exists (
	select * from apply_leaves a where a.employee_id = e.id
);

-- not exists
select e.*
from employees e
where not exists (
	select * from apply_leaves a where a.employee_id = e.id
);

select 0/0, null/0, 0/null from dual; -- MYSQL

select * from employees;

-- With Primary key
drop table employees;
create table employees (
	id integer primary key auto_increment,
	first_name varchar(50),
    last_name varchar(50),
    dob date,
    salary decimal(7, 2),
    gender varchar(1)
);
select * from employees;
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('John','Lau','2001-12-31',23000.50,'M');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Sally','Lau','2000-04-30',30000.00,'F');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Leo','Chan','1980-01-30',NULL,'M');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Jenny','Chan','1991-02-28',50000.00,'F');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Oscar','Tam','1993-04-10',NULL,'M');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Kelly','Chan','2000-01-01',18000.00,'F');
INSERT INTO employees (`first_name`,`last_name`,`dob`,`salary`,`gender`) VALUES ('Tommy','Lau','2001-02-01',28000.00,'M');

drop table apply_leaves;
select * from apply_leaves;

create table apply_leaves (
	id integer primary key auto_increment,
    employee_id integer,
    leave_type varchar(1),
    apply_datetime datetime,
    leave_date date,
    status varchar(1),
    foreign key (employee_id) references employees(id)
);

INSERT INTO `apply_leaves` (`employee_id`,`leave_type`,`apply_datetime`,`leave_date`,`status`) VALUES (1,'A','2026-04-21 23:04:01','2026-05-20','P');
INSERT INTO `apply_leaves` (`employee_id`,`leave_type`,`apply_datetime`,`leave_date`,`status`) VALUES (1,'S','2026-04-22 23:04:01','2026-05-01','A');
INSERT INTO `apply_leaves` (`employee_id`,`leave_type`,`apply_datetime`,`leave_date`,`status`) VALUES (3,'A','2026-04-23 23:04:01','2026-05-01','A');
INSERT INTO `apply_leaves` (`employee_id`,`leave_type`,`apply_datetime`,`leave_date`,`status`) VALUES (5,'A','2026-05-01 23:04:01','2026-05-01','A');

-- Violate FK rule (we didn't have employee id 9)
-- INSERT INTO `apply_leaves` (`employee_id`,`leave_type`,`apply_datetime`,`leave_date`,`status`) VALUES (9,'A','2026-04-21 23:04:01','2026-05-20','P');














 