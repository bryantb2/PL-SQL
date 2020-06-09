-- INITIAL SCRIPTS
drop table employee cascade constraints;

create table employee
(employee_id	number primary key,
employee_first	varchar2(20) not null,
employee_last	varchar2(30) not null,
employee_salary	float not null);

insert into employee values
(1,'Pamela','Farr',34000);

insert into employee values
(2,'Ernest','Hemingway',39000);

insert into employee values
(3,'James','Joyce',55000);

insert into employee values
(4,'Ayn','Rand',30000);

insert into employee values
(5,'Ursula','Leguin',68000);

drop table customer cascade constraints;

create table customer
(customer_id	number primary key,
customer_first	varchar2(20) not null,
customer_last	varchar2(30) not null,
customer_credit_rating	number not null);


insert into customer values
(1,'Pamela','Farr',9);

insert into customer values
(2,'Ernest','Hemingway',3);

insert into customer values
(3,'James','Joyce',10);

insert into customer values
(4,'Ayn','Rand',4);

insert into customer values
(5,'Ursula','Leguin',5);

drop table purchase cascade constraints;

create table purchase
(purchase_id    number  primary key,
customer_id     number  not null,
purchase_date   date  not null,
total_purchase_price  float);

drop table purchase_audit cascade constraints;

create table purchase_audit
(audit_id       number primary key,
purchase_id     number  not null,
customer_id     number  not null,
purchase_date   date  not null,
total_purchase_price  float,
who_did_this    varchar2(30));


commit;


-- PROBLEM 1
SET VERIFY on;
CREATE OR REPLACE TRIGGER WARNING_UPDATE_TRIGGER
  BEFORE UPDATE 
  ON EMPLOYEE
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Warning: employee table is being updated.');
  DBMS_OUTPUT.PUT_LINE('Emp ID is: '     || :OLD.EMPLOYEE_ID);
  DBMS_OUTPUT.PUT_LINE('Name is: '       || :OLD.EMPLOYEE_FIRST || ' ' || :OLD.EMPLOYEE_LAST);
  DBMS_OUTPUT.PUT_LINE('Salary was: '    || :OLD.EMPLOYEE_SALARY);
  DBMS_OUTPUT.PUT_LINE('Salary now is: ' || :NEW.EMPLOYEE_SALARY);
END;

set feedback on;
set serveroutput on;
BEGIN
  -- UPDATE WITH ID OF 3
  UPDATE EMPLOYEE
  SET EMPLOYEE_SALARY = 200
  WHERE EMPLOYEE_ID = 3;
  -- 3% INCREASE TO ALL EMPLOYEES
  UPDATE EMPLOYEE
  SET EMPLOYEE_SALARY = EMPLOYEE_SALARY * 1.03;
END;


-- PROBLEM 2
CREATE OR REPLACE TRIGGER NOTIFY_TABLE_CREATION
AFTER CREATE ON SCHEMA
BEGIN
  IF (ORA_DICT_OBJ_TYPE = 'TABLE') THEN
    DBMS_OUTPUT.PUT_LINE('New table has been created with name of ' || ORA_DICT_OBJ_NAME);
  END IF;
END NOTIFY_TABLE_CREATION;

drop table test_table;
create table test_table
(test_id varchar2(1) primary key);



