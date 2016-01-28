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


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 V_TABLESPACE VARCHAR(30) := '#TABLESPACE#' ; 
 TABLA1 VARCHAR(30) :='APR_CJM_ATC_ATIPICOS_CNT';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(2500 CHAR); 
 V_MSQL1 VARCHAR2(2500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 
  
   V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  ADD
             (
                ATC_DATE_EXTRA3 DATE
            )';
            

  --Validamos si existen los campos antes de crearlos
  SELECT COUNT(*) INTO V_EXISTE  
  FROM ALL_TAB_COLUMNS 
  WHERE TABLE_NAME = ''||TABLA1||''
    AND OWNER      = ''||V_ESQUEMA||''
    AND COLUMN_NAME = 'ATC_DATE_EXTRA3';  
  
  IF V_EXISTE = 0 THEN   
       EXECUTE IMMEDIATE V_MSQL;
       DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');
  ELSE   
       DBMS_OUTPUT.PUT_LINE('El campo ATC_DATE_EXTRA3 ya existe en la tabla '||TABLA1);  
  END IF;     


  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  ADD
             (
                   ATC_NUM_EXTRA3 NUMBER(16)
            )';      
  
  --Validamos si existen los campos antes de crearlos  
  SELECT COUNT(*) INTO V_EXISTE  
  FROM ALL_TAB_COLUMNS 
  WHERE TABLE_NAME = ''||TABLA1||''
    AND OWNER      = ''||V_ESQUEMA||''
    AND COLUMN_NAME = 'ATC_NUM_EXTRA3';  
  
  IF V_EXISTE = 0 THEN   
       EXECUTE IMMEDIATE V_MSQL;
       DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');
  ELSE   
       DBMS_OUTPUT.PUT_LINE('El campo ATC_NUM_EXTRA3 ya existe en la tabla '||TABLA1);  
  END IF;      
  
  

  V_MSQL1 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  MODIFY
             (
                ATC_FECHA_EXTRACCION DATE
              , ATC_FECHA_DATO DATE
              , ATC_NUMERO_CONTRATO NUMBER(17) 
              , ATC_NUMERO_SPEC NUMBER(15)
	      , ATC_CODIGO_ATIPICO NUMBER(20)
	      , ATC_IMPORTE_ATIPICO NUMBER(16,2)
	      , ATC_FECHA_VALOR DATE
	      , ATC_FECHA_MOVIMIENTO DATE
	      , ATC_DATE_EXTRA1 DATE 
	      , ATC_DATE_EXTRA2 DATE 
	      , ATC_DATE_EXTRA3 DATE
	      , ATC_NUM_EXTRA1 NUMBER(16)
	      , ATC_NUM_EXTRA2 NUMBER(16)
	      , ATC_NUM_EXTRA3 NUMBER(16)
            )';
            
      
  EXECUTE IMMEDIATE V_MSQL1;

  DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');

  

 
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
