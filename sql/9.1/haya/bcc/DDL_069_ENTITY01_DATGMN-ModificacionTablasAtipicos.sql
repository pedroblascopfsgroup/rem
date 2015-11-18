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

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA1 VARCHAR(40) :='APR_CJM_ATC_ATIPICOS_CNT';
 TABLA2 VARCHAR(40) :='ATC_ATIPICOS_CNT';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 
 V_MSQL3 VARCHAR2(2500 CHAR); 
 V_EXISTE NUMBER (1);

BEGIN 
  

 V_MSQL2 := q'[select COUNT(1) from ALL_TABLES WHERE TABLE_NAME = ']'||TABLA1||q'[']';

 -- DBMS_OUTPUT.PUT_LINE('Dropeada:> '||V_MSQL2);
 
 EXECUTE IMMEDIATE V_MSQL2 INTO V_EXISTE;

 if V_EXISTE is not null and V_EXISTE = 1 then
    V_MSQL1 := 'DROP TABLE '||V_ESQUEMA||'.'||TABLA1||'';
    EXECUTE IMMEDIATE V_MSQL1;

    DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Dropeada');

    COMMIT;

    V_MSQL2 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||' (
            ATC_FECHA_EXTRACCION DATE, 
            ATC_FECHA_DATO DATE, 
            ATC_TIPO_PRODUCTO VARCHAR2(5 CHAR), 
            ATC_NUMERO_CONTRATO NUMBER(17,0), 
            ATC_NUMERO_SPEC NUMBER(15,0), 
            ATC_CODIGO_ATIPICO NUMBER(20,0), 
            ATC_IMPORTE_ATIPICO NUMBER(16,2), 
            ATC_TIPO_ATIPICO VARCHAR2(4 CHAR), 
            ATC_MOTIVO_ATIPICO VARCHAR2(9 CHAR), 
            ATC_FECHA_VALOR DATE, 
            ATC_FECHA_MOVIMIENTO DATE, 
            ATC_CHAR_EXTRA1 VARCHAR2(50 CHAR), 
            ATC_CHAR_EXTRA2 VARCHAR2(50 CHAR), 
            ATC_FLAG_EXTRA1 VARCHAR2(1 CHAR), 
            ATC_FLAG_EXTRA2 VARCHAR2(1 CHAR), 
            ATC_DATE_EXTRA1 DATE, 
            ATC_DATE_EXTRA2 DATE, 
            ATC_DATE_EXTRA3 DATE, 
            ATC_NUM_EXTRA1 NUMBER(16,0), 
            ATC_NUM_EXTRA2 NUMBER(16,0), 
            ATC_NUM_EXTRA3 NUMBER(16,0)
             ) ';
                
     EXECUTE IMMEDIATE V_MSQL2;
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Creada');

 end if;

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
