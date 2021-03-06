-- PROBLEM 1
set feedback on;
set serveroutput on;
DECLARE
  TEST_DATE DATE         := TO_DATE('05/10/1990', 'MM/DD/YYYY');
  TEST_NAME VARCHAR2(50) := 'BOB DYLAN';
  TEST_NUMBER NUMBER(20) := 1234;
BEGIN
  DBMS_OUTPUT.PUT_LINE('TEST DATE IS: '   || TEST_DATE);
  DBMS_OUTPUT.PUT_LINE('TEST NAME IS: '   || TEST_NAME);
  DBMS_OUTPUT.PUT_LINE('TEST NUMBER IS: ' || TEST_NUMBER);
END;

-- PROBLEM 3
DECLARE 
  CURRENT_DATE DATE;
BEGIN
  -- SET CURRENT DATE
  SELECT SYSDATE
    INTO CURRENT_DATE
    FROM DUAL;
  DBMS_OUTPUT.PUT_LINE('CURRENT DATE IS: ' || CURRENT_DATE);
END;

-- PROBLEM 4
DECLARE
  current_block	varchar2(10)  := 'OUTER';
  outer_block	varchar2(10)	  := 'OUTER';
BEGIN
	dbms_output.put_line ('[current_block]['||current_block||']');
	DECLARE
		current_block	varchar2(10)	:= 'INNER';
	BEGIN
		dbms_output.put_line('[current_block]['||current_block||']');
		dbms_output.put_line('[outer_block]['||outer_block||']');
	END;
	dbms_output.put_line ('[current_block]['||current_block||']');
END;

-- PROBLEM 5
DECLARE
  RECT_LENGTH_INCHES NUMBER(20) := 5;
  RECT_WIDTH_INCHES NUMBER(20)  := 5;
  RECT_AREA_INCHES NUMBER(20);
BEGIN
  RECT_AREA_INCHES := RECT_WIDTH_INCHES * RECT_LENGTH_INCHES;
  DBMS_OUTPUT.PUT_LINE('RECTANGLE AREA IS: ' || RECT_AREA_INCHES || ' IN^2');
END;

-- PROBLEM 6
DROP TABLE PROGRAMMING_LANGS;
CREATE TABLE PROGRAMMING_LANGS
(LANG_ID NUMBER(10) PRIMARY KEY,
LANG_NAME VARCHAR2(20) NOT NULL,
LANG_TYPE VARCHAR2(20) NOT NULL,
DATE_CREATED VARCHAR2(20) NOT NULL);

INSERT INTO PROGRAMMING_LANGS
VALUES (1, 'JAVASCRIPT', 'DYNAMIC-WEAK', TO_DATE('01/02/1990','MM/DD/YYYY'));
INSERT INTO PROGRAMMING_LANGS
VALUES (2, 'C#', 'STATIC-STRONG', TO_DATE('02/05/2000','MM/DD/YYYY'));

SELECT * FROM PROGRAMMING_LANGS;

DECLARE
  LANG_ONE_NAME VARCHAR2(20);
  LANG_ONE_TYPE VARCHAR2(20);
  LANG_ONE_DATE VARCHAR2(20);
BEGIN
  SELECT LANG_NAME, SUBSTR(LANG_TYPE, 1, INSTR(LANG_TYPE, '-') - 1), DATE_CREATED
    INTO LANG_ONE_NAME, LANG_ONE_TYPE, LANG_ONE_DATE
    FROM PROGRAMMING_LANGS
    WHERE LANG_ID = 2;
  DBMS_OUTPUT.PUT_LINE(LANG_ONE_NAME || ' IS A ' || 
    LANG_ONE_TYPE || 'LY TYPED LANGUAGE, CREATED ON ' 
    || LANG_ONE_DATE);  
END;
