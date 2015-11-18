--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150917
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-705
--## PRODUCTO=NO
--## 
--## Finalidad: Se incluyen campos para ING_INGRESOS, ING_INGRESOS_DUB
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#'; 
 TABLA1 VARCHAR(30):='ING_INGRESOS_DUB'; 
 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(500 CHAR);
 V_MSQL2 VARCHAR2(500 CHAR);


BEGIN 
  

  V_MSQL1 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  RENAME COLUMN ING_DATE_EXTRA3 TO ING_DATE_EXTRA_3';
  
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  RENAME COLUMN ING_NUM_EXTRA3 TO ING_NUM_EXTRA_3';
                  
        
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');
         EXECUTE IMMEDIATE V_MSQL2;	 
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