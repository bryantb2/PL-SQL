-- PART 1
SELECT * FROM AGENT;
SELECT * FROM HOUSE_SALE;
DESCRIBE HOUSE_SALE;

CREATE OR REPLACE PROCEDURE AGENT_BONUS
(P_AGENT_ID IN NUMBER,
P_SALES_PRICES OUT NUMBER,
P_BONUS OUT NUMBER,
P_COMMISSION OUT NUMBER,
P_TOTAL OUT NUMBER)
IS
  V_AGENT_LEVEL VARCHAR2(1);
  V_SALE_PRICE NUMBER;
  V_BONUS_PRICE NUMBER;
  V_SALE_COMMISSION NUMBER;
BEGIN
   -- GET AGENT INFO BY AGENT ID
  SELECT AGENT.AGENT_LEVEL, HOUSE_SALE.SALE_PRICE
    INTO V_AGENT_LEVEL, V_SALE_PRICE
    FROM AGENT
    JOIN HOUSE_SALE ON AGENT.AGENT_ID = HOUSE_SALE.FK_AGENT_ID
    WHERE AGENT.AGENT_ID = P_AGENT_ID;
  
  -- CALC PRICE BASED ON LEVEL
  IF V_AGENT_LEVEL = 'H' THEN 
    V_BONUS_PRICE := 25000;
    V_SALE_COMMISSION := 1.15;
  ELSIF V_AGENT_LEVEL = 'M' THEN
    V_BONUS_PRICE := 10000;
    V_SALE_COMMISSION := 1.10;
  ELSE
    V_BONUS_PRICE := 5000;
    V_SALE_COMMISSION := 1.05;
  END IF;
  
  -- SET TO OUT VARIABLES
  P_SALES_PRICES := V_SALE_PRICE;
  P_BONUS := V_BONUS_PRICE;
  P_COMMISSION := V_SALE_PRICE * V_SALE_COMMISSION;
  P_TOTAL := (V_SALE_PRICE * V_SALE_COMMISSION) + V_BONUS_PRICE + V_SALE_PRICE;
END;

-- CALL PROCEDURE
set feedback on;
set serveroutput on;

DECLARE
  SALES_PRICE NUMBER;
  BONUS_AMOUNT NUMBER;
  COMMISSION_AMOUNT NUMBER;
  GRAND_TOTAL NUMBER;
  AGENT_ID NUMBER := 205;
BEGIN
  AGENT_BONUS(AGENT_ID, SALES_PRICE, BONUS_AMOUNT, COMMISSION_AMOUNT, GRAND_TOTAL);
  DBMS_OUTPUT.PUT_LINE('AGENT ID IS: '          || AGENT_ID);
  DBMS_OUTPUT.PUT_LINE('SALES PRICE IS: '       || TO_CHAR(SALES_PRICE,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('BONUS AMOUNT IS: '      || TO_CHAR(BONUS_AMOUNT,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('COMMISSION AMOUNT IS: ' || TO_CHAR(COMMISSION_AMOUNT,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('GRAND TOTAL IS: '       || TO_CHAR(GRAND_TOTAL,'L999G999D99'));
END;


-- PART 2
CREATE OR REPLACE PROCEDURE AGENT_BONUS
(P_AGENT_ID IN NUMBER,
P_SALES_PRICES OUT NUMBER,
P_BONUS OUT NUMBER,
P_COMMISSION OUT NUMBER,
P_TOTAL OUT NUMBER)
IS
  NO_AGENT_LEVEL EXCEPTION;
  V_AGENT_LEVEL VARCHAR2(1);
  V_SALE_PRICE NUMBER;
  V_BONUS_PRICE NUMBER;
  V_SALE_COMMISSION NUMBER;
BEGIN
   -- GET AGENT INFO BY AGENT ID
  SELECT AGENT.AGENT_LEVEL, HOUSE_SALE.SALE_PRICE
    INTO V_AGENT_LEVEL, V_SALE_PRICE
    FROM AGENT
    JOIN HOUSE_SALE ON AGENT.AGENT_ID = HOUSE_SALE.FK_AGENT_ID
    WHERE AGENT.AGENT_ID = P_AGENT_ID;
  
  -- CALC PRICE BASED ON LEVEL
  IF V_AGENT_LEVEL != 'H' AND V_AGENT_LEVEL != 'M' AND V_AGENT_LEVEL != 'L' THEN
    RAISE NO_AGENT_LEVEL;
  ELSIF V_AGENT_LEVEL = 'H' THEN 
    V_BONUS_PRICE := 25000;
    V_SALE_COMMISSION := 1.15;
  ELSIF V_AGENT_LEVEL = 'M' THEN
    V_BONUS_PRICE := 10000;
    V_SALE_COMMISSION := 1.10;
  ELSE
    V_BONUS_PRICE := 5000;
    V_SALE_COMMISSION := 1.05;
  END IF;
  
  -- SET TO OUT VARIABLES
  P_SALES_PRICES := V_SALE_PRICE;
  P_BONUS := V_BONUS_PRICE;
  P_COMMISSION := V_SALE_PRICE * V_SALE_COMMISSION;
  P_TOTAL := (V_SALE_PRICE * V_SALE_COMMISSION) + V_BONUS_PRICE + V_SALE_PRICE;
EXCEPTION
  WHEN NO_AGENT_LEVEL THEN
    DBMS_OUTPUT.PUT_LINE('AGENT LEVEL DOES NOT EXIST');
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('A NO DATA ERROR HAS OCCURED IN THE AGENT BONUS. MOST LIKELY BECAUSE AGENT ID DOES NOT EXIST IN DATABASE.');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('AGENT ID IS NOT UNIQUE, AND RETURNED MULTIPLE ROWS.');
END;

-- CALL PROCEDURE
set feedback on;
set serveroutput on;

UPDATE AGENT
SET AGENT_LEVEL = 'M'
WHERE AGENT_ID = 201;

DECLARE
  SALES_PRICE NUMBER;
  BONUS_AMOUNT NUMBER;
  COMMISSION_AMOUNT NUMBER;
  GRAND_TOTAL NUMBER;
  AGENT_ID NUMBER := 201;
BEGIN
  AGENT_BONUS(AGENT_ID, SALES_PRICE, BONUS_AMOUNT, COMMISSION_AMOUNT, GRAND_TOTAL);
  DBMS_OUTPUT.PUT_LINE('AGENT ID IS: '          || AGENT_ID);
  DBMS_OUTPUT.PUT_LINE('SALES PRICE IS: '       || TO_CHAR(SALES_PRICE,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('BONUS AMOUNT IS: '      || TO_CHAR(BONUS_AMOUNT,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('COMMISSION AMOUNT IS: ' || TO_CHAR(COMMISSION_AMOUNT,'L999G999D99'));
  DBMS_OUTPUT.PUT_LINE('GRAND TOTAL IS: '       || TO_CHAR(GRAND_TOTAL,'L999G999D99'));
END;

