-- PROBLEM 1
DROP TABLE PERSON CASCADE CONSTRAINTS;
CREATE TABLE PERSON
(PERSON_ID VARCHAR2(15) PRIMARY KEY,
FIRST_NAME VARCHAR2(25),
MIDDLE_INITIAL VARCHAR2(1),
LAST_NAME VARCHAR2(25));

set feedback on;
set serveroutput on;
DECLARE
  PERSON_RECORD PERSON%ROWTYPE;
  TEST_REC PERSON%ROWTYPE;
BEGIN
  -- FILL RECORD DATA
  PERSON_RECORD.PERSON_ID := 'PERSON_1';
  PERSON_RECORD.FIRST_NAME := 'RACHAEL';
  PERSON_RECORD.MIDDLE_INITIAL := 'B';
  PERSON_RECORD.LAST_NAME := 'PETERSON';
  -- INSERT INTO TABLE
  INSERT INTO PERSON (PERSON_ID, FIRST_NAME, MIDDLE_INITIAL, LAST_NAME)
  VALUES (PERSON_RECORD.PERSON_ID, PERSON_RECORD.FIRST_NAME, PERSON_RECORD.MIDDLE_INITIAL, PERSON_RECORD.LAST_NAME);
  -- CHECK FOR VALUES
  SELECT *
    INTO TEST_REC
    FROM PERSON
    WHERE PERSON_ID = 'PERSON_1';
  -- OUTPUT
  DBMS_OUTPUT.PUT_LINE('PRINTING RESULTS FROM PERSON INSERT:');
  DBMS_OUTPUT.PUT_LINE(TEST_REC.PERSON_ID);
  DBMS_OUTPUT.PUT_LINE(TEST_REC.FIRST_NAME);
  DBMS_OUTPUT.PUT_LINE(TEST_REC.MIDDLE_INITIAL);
  DBMS_OUTPUT.PUT_LINE(TEST_REC.LAST_NAME);
END;


-- PROBLEM 2
SELECT * FROM STUDENT;
CREATE OR REPLACE PACKAGE STUDENT_INFO
IS

  -- student record 
  TYPE STUDENT_DATA_RECORD_T IS RECORD
    (STUDENT_ID         STUDENT.STUDENT_ID%TYPE,
    STUDENT_FIRST_NAME  STUDENT.STUDENT_FIRST_NAME%TYPE,
    STUDENT_LAST_NAME   STUDENT.STUDENT_LAST_NAME%TYPE,
    STUDENT_TYPE        STUDENT.FK_STUDENT_TYPE_ID%TYPE);
    --STUDENT_REC STUDENT_DATA_RECORD_T;
  -- get student grade info
  CURSOR STUDENT_GRADE_CUR IS
      SELECT GRADE, FK_STUDENT_ID
        FROM ENROLLMENT;
  -- get general student data      
  PROCEDURE GET_STUDENT_DATA (STUDENT_ID_ARG VARCHAR2, STUDENT_DATA OUT STUDENT_DATA_RECORD_T);
  -- calculate gpa
  PROCEDURE CALCULATE_STUDENT_GPA (STUDENT_DATA_REC IN STUDENT_DATA_RECORD_T, STUDENT_GPA OUT NUMBER);
  
END STUDENT_INFO;  

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY STUDENT_INFO
IS

  -- get student data
  PROCEDURE GET_STUDENT_DATA (STUDENT_ID_ARG VARCHAR2, STUDENT_DATA OUT STUDENT_DATA_RECORD_T)
  IS
    INVALID_STUDENT_TYPE EXCEPTION;
    PRAGMA EXCEPTION_INIT (INVALID_STUDENT_TYPE, -200004);
  BEGIN
    SELECT * 
      INTO STUDENT_DATA
      FROM STUDENT
      WHERE STUDENT.STUDENT_ID = STUDENT_ID_ARG;
  END GET_STUDENT_DATA;
  
  -- calulate student GPA given record
  PROCEDURE CALCULATE_STUDENT_GPA (STUDENT_DATA_REC IN STUDENT_DATA_RECORD_T, STUDENT_GPA OUT NUMBER)
  IS
    V_STUDENT_GPA_POINTS NUMBER := 0;
    V_STUDENT_GRADE_COUNT NUMBER := 0;
  BEGIN
    -- loop through the grade cursor
    -- use case statement to increment grade point counter based on letter
    FOR GRADE IN STUDENT_GRADE_CUR
    LOOP
      IF GRADE.FK_STUDENT_ID = STUDENT_DATA_REC.STUDENT_ID THEN
        CASE SUBSTR(GRADE.GRADE, 1, 1)
          WHEN 'A' THEN V_STUDENT_GPA_POINTS := 4 + V_STUDENT_GPA_POINTS;
          WHEN 'B' THEN V_STUDENT_GPA_POINTS := 3 + V_STUDENT_GPA_POINTS;
          WHEN 'C' THEN V_STUDENT_GPA_POINTS := 2 + V_STUDENT_GPA_POINTS;
          WHEN 'D' THEN V_STUDENT_GPA_POINTS := 1 + V_STUDENT_GPA_POINTS;
          ELSE NULL;
        END CASE;  
        V_STUDENT_GRADE_COUNT := 1 + V_STUDENT_GRADE_COUNT;
      END IF;
    END LOOP;
    -- return calculated GPA
    STUDENT_GPA := V_STUDENT_GPA_POINTS / V_STUDENT_GRADE_COUNT;
  END CALCULATE_STUDENT_GPA;
  
END STUDENT_INFO;

SELECT * FROM STUDENT;
SELECT * FROM ENROLLMENT;

set feedback on;
set serveroutput on;
DECLARE
  STUDENT_REC STUDENT_INFO.STUDENT_DATA_RECORD_T;
  STUDENT_GPA NUMBER;
BEGIN
  STUDENT_INFO.GET_STUDENT_DATA('L1164156', STUDENT_REC);
  STUDENT_INFO.CALCULATE_STUDENT_GPA(STUDENT_REC, STUDENT_GPA);
  
  DBMS_OUTPUT.PUT_LINE('Student GPA is: ' || STUDENT_GPA);
END;









