--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150923
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación TABLA FINAL EFP_EFECTOS_PER
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='EFP_EFECTOS_PER';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
					EFP_DATE_EXTRA3 DATE, 
					EFP_NUM_EXTRA3 NUMBER(16,2)
            )';


  
     
  EXECUTE IMMEDIATE V_MSQL;

	
DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');


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
