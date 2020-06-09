drop table enrollment cascade constraints;
create table enrollment 
(student_id   varchar2(25) not null,
course_number varchar2(25) not null,
term_code     number  not null,
grade                   varchar2(1));


Insert into enrollment values ('L11111111','WR121',201910,'A');
Insert into enrollment values ('L11111111','CS120',201910,'B');
Insert into enrollment values ('L11111111','CS260',201910,'A');
Insert into enrollment values ('L11111111','BA101',201920,'C');
Insert into enrollment values ('L11111111','FA232',201920,'A');
Insert into enrollment values ('L11111111','HR234',201920,'B');
Insert into enrollment values ('L11111111','MT111',201930,'B');
Insert into enrollment values ('L11111111','CS161',201930,'C');
Insert into enrollment values ('L11111111','CS162',201930,'A');
Insert into enrollment values ('L11111111','MT080',201940,'C');
Insert into enrollment values ('L11111111','ANTH101',201940,'A');
Insert into enrollment values ('L11111111','ART115',201940,'C');
Insert into enrollment values ('L22222222','AM149',201910,'A');
Insert into enrollment values ('L22222222','BA250',201910,'D');
Insert into enrollment values ('L22222222','BI103',201910,'C');
Insert into enrollment values ('L22222222','CS120',201920,'B');
Insert into enrollment values ('L22222222','CA163',201920,'B');
Insert into enrollment values ('L22222222','CG203',201920,'F');
Insert into enrollment values ('L22222222','CS100',201930,'D');
Insert into enrollment values ('L22222222','CH104',201930,'C');
Insert into enrollment values ('L22222222','FT201',201930,'A');
Insert into enrollment values ('L22222222','HIM153',201940,'B');
Insert into enrollment values ('L22222222','PN103',201940,'C');
Insert into enrollment values ('L22222222','CS253',201940,'B');
Insert into enrollment values ('L33333333','WLD242',201910,'A');
Insert into enrollment values ('L33333333','CH221',201910,'A');
Insert into enrollment values ('L33333333','ANTH103',201910,'A');
Insert into enrollment values ('L33333333','DA110',201920,'B');
Insert into enrollment values ('L33333333','CS120',201920,'B');
Insert into enrollment values ('L33333333','ECON200',201920,'A');
Insert into enrollment values ('L33333333','HST201',201930,'A');
Insert into enrollment values ('L33333333','PSY201',201930,'A');
Insert into enrollment values ('L33333333','SPAN201',201930,'B');
Insert into enrollment values ('L33333333','ART131',201940,'B');
Insert into enrollment values ('L33333333','CS260',201940,'B');
Insert into enrollment values ('L33333333','CS120',201940,'B');
Insert into enrollment values ('L44444444','WR121',201910,'B');
Insert into enrollment values ('L44444444','CS120',201910,'C');
Insert into enrollment values ('L44444444','CS260',201910,'B');
Insert into enrollment values ('L44444444','BA101',201920,'C');
Insert into enrollment values ('L44444444','FA232',201920,'D');
Insert into enrollment values ('L44444444','HR234',201920,'D');
Insert into enrollment values ('L44444444','MT111',201930,'D');
Insert into enrollment values ('L44444444','CS161',201930,'B');
Insert into enrollment values ('L44444444','CS162',201930,'A');
Insert into enrollment values ('L44444444','MT080',201940,'A');
Insert into enrollment values ('L44444444','ANTH101',201940,'A');
Insert into enrollment values ('L44444444','ART115',201940,'A');

commit;


drop table student cascade constraints;
create table student
(student_id	varchar2(25)  primary key,
student_first	varchar2(25),
student_last	varchar2(25));

insert into student values
('L11111111','Pamela','Farr');
insert into student values
('L22222222','Ernest','Hemingway');
insert into student values
('L33333333','Ayn','Rand');
insert into student values
('L44444444','James','Joyce');
commit;


drop table credit cascade constraints;
create table credit 
(course_number  varchar2(25) PRIMARY KEY,
course_credit   number);

insert into credit values
('WR121',4);
insert into credit values('CS120',4);
insert into credit values('CS260',4);
insert into credit values('BA101',4);
insert into credit values('FA232',4);
insert into credit values('HR234',4);
insert into credit values('MT111',5);
insert into credit values('CS161',4);
insert into credit values('CS162',4);
insert into credit values('MT080',4);
insert into credit values('ANTH101',4);
insert into credit values('ART115',4);
insert into credit values('AM149',4);
insert into credit values('BA250',4);
insert into credit values('BI103',3);
insert into credit values('CA163',3);
insert into credit values('CG203',4);
insert into credit values('CS100',5);
insert into credit values('CH104',2);
insert into credit values('FT201',4);
insert into credit values('HIM153',4);
insert into credit values('PN103',4);
insert into credit values('CS253',4);
insert into credit values('WLD242',4);
insert into credit values('CH221',4);
insert into credit values('ANTH103',4);
insert into credit values('DA110',5);
insert into credit values('ECON200',3);
insert into credit values('HST201',3);
insert into credit values('PSY201',4);
insert into credit values('SPAN201',4);
insert into credit values('ART131',4);
commit;


DESCRIBE ENROLLMENT;
SELECT * FROM ENROLLMENT;
SELECT * FROM CREDIT;
SELECT * FROM STUDENT;


-- PROBLEM 1
set feedback on;
set serveroutput on;
CREATE OR REPLACE FUNCTION NUM_CREDITS
(TERM_ID_ARG IN NUMBER,
STUDENT_ID_ARG IN VARCHAR2)
RETURN NUMBER
IS
  CREDIT_TOTAL NUMBER;
BEGIN
  SELECT SUM(CREDIT.COURSE_CREDIT)
    INTO CREDIT_TOTAL
    FROM ENROLLMENT
    JOIN CREDIT ON CREDIT.COURSE_NUMBER = ENROLLMENT.COURSE_NUMBER
    WHERE ENROLLMENT.STUDENT_ID = STUDENT_ID_ARG AND ENROLLMENT.TERM_CODE = TERM_ID_ARG;
  RETURN CREDIT_TOTAL;  
END;

DECLARE
  TEST_STUDENT_ID VARCHAR2(20) := 'L22222222' ;
  TEST_TERM_ID NUMBER := 201940;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Number of credits for student ' || TEST_STUDENT_ID || ' in term ' || TEST_TERM_ID || ' is: ' || NUM_CREDITS(TEST_TERM_ID, TEST_STUDENT_ID));
END;


-- PROBLEM 2
select * from student;
CREATE OR REPLACE PROCEDURE CALC_TUITION 
(TERM_CODE_ARG IN NUMBER)
IS
  -- GET STUDENT DATA
  CURSOR STUDENT_CUR IS
    SELECT * FROM STUDENT;
  -- TUITION COUNTERS
  ALL_STUDENT_TUITION     NUMBER := 0;
  CURRENT_STUDENT_TUITION NUMBER := 0;
BEGIN
  FOR STUDENT_REC IN STUDENT_CUR
  LOOP
    -- CALCULATE TUITION VALUES
    CURRENT_STUDENT_TUITION := NUM_CREDITS(TERM_CODE_ARG,STUDENT_REC.STUDENT_ID) * 130;
    ALL_STUDENT_TUITION := ALL_STUDENT_TUITION + CURRENT_STUDENT_TUITION;
    -- PRINT VALUES
    DBMS_OUTPUT.PUT_LINE('---------');
    DBMS_OUTPUT.PUT_LINE('Student ID: ' || STUDENT_REC.STUDENT_ID);
    DBMS_OUTPUT.PUT_LINE('Full name: '  || STUDENT_REC.STUDENT_FIRST || ' ' || STUDENT_REC.STUDENT_LAST);
    DBMS_OUTPUT.PUT_LINE('Total student term tuition: ' || '$' || CURRENT_STUDENT_TUITION);
    -- RESET CURRENT TUITION COUNTER
    CURRENT_STUDENT_TUITION := 0;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Tuition total from all students is: ' || '$' || ALL_STUDENT_TUITION);
END CALC_TUITION;

DECLARE 
  TEST_TERM_ID NUMBER := 201940;
BEGIN
  CALC_TUITION(TEST_TERM_ID);
END;
 

-- PROBLEM 3
SET VERIFY on;
CREATE OR REPLACE TRIGGER ENROLLMENT_CHANGE_TRIGGER
  AFTER UPDATE
  OF GRADE ON ENROLLMENT
  FOR EACH ROW
DECLARE
  STUDENT_REC_DATA STUDENT%ROWTYPE;
BEGIN
  -- GET STUDENT DATA
  SELECT * 
    INTO STUDENT_REC_DATA
    FROM STUDENT
    WHERE STUDENT.STUDENT_ID = :OLD.STUDENT_ID;
  -- PRINT STUDENT DATA    
  DBMS_OUTPUT.PUT_LINE('Enrollment grade update triggered');
  DBMS_OUTPUT.PUT_LINE('Student ID: ' || :OLD.STUDENT_ID);
  DBMS_OUTPUT.PUT_LINE('First name: ' || STUDENT_REC_DATA.STUDENT_FIRST);
  DBMS_OUTPUT.PUT_LINE('Last name: '  || STUDENT_REC_DATA.STUDENT_LAST);
  DBMS_OUTPUT.PUT_LINE('Old grade: '  || :OLD.GRADE);
  DBMS_OUTPUT.PUT_LINE('New grade: '  || :NEW.GRADE);
END ENROLLMENT_CHANGE_TRIGGER;

BEGIN
  UPDATE ENROLLMENT
  SET ENROLLMENT.GRADE = 'A'
  WHERE ENROLLMENT.STUDENT_ID = 'L11111111' AND ENROLLMENT.COURSE_NUMBER = 'CS120';
END;


SELECT * FROM ENROLLMENT;














