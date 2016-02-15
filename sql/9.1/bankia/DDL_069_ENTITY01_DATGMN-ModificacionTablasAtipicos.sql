--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación tablas carga ATIPICOS para cajamar
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Toque abs6 

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA2 VARCHAR(40) :='ATC_ATIPICOS_CNT';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 
 V_MSQL3 VARCHAR2(2500 CHAR); 
 V_EXISTE NUMBER (1);

BEGIN 
  

 V_EXISTE :=0;
 V_MSQL3 := q'[select COUNT(1) from ALL_TAB_COLUMNS WHERE TABLE_NAME = ']'||TABLA2||q'[' AND COLUMN_NAME ='ATC_DATE_EXTRA3']';
--  DBMS_OUTPUT.PUT_LINE('V_MSQL3:> '||V_MSQL3); 
 EXECUTE IMMEDIATE V_MSQL3 INTO V_EXISTE;
 

 if V_EXISTE is null or V_EXISTE = 0 then
      V_MSQL3 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
                ATC_DATE_EXTRA3 DATE
            )';
	EXECUTE IMMEDIATE V_MSQL3;            
	DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada con ATC_DATE_EXTRA3'); 
 end if;   

 V_EXISTE :=0;
 V_MSQL3 := q'[select COUNT(1) from ALL_TAB_COLUMNS WHERE TABLE_NAME = ']'||TABLA2||q'[' AND COLUMN_NAME ='ATC_NUM_EXTRA3']';
 EXECUTE IMMEDIATE V_MSQL3 INTO V_EXISTE;

 if V_EXISTE is null or V_EXISTE = 0 then
      V_MSQL3 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
                ATC_NUM_EXTRA3 NUMBER(16)
            )';

      EXECUTE IMMEDIATE V_MSQL3;            
      DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada con ATC_NUM_EXTRA3'); 
 end if;   

 
 
 
EXCEPTION
WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;  
