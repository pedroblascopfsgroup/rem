--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150911
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación TABLA FINAL PER_GCL
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='PER_GCL';
TABLA2 VARCHAR(30) :='GCL_GRUPOS_CLIENTES';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
					PER_GCL_DATE_EXTRA3 DATE, 
					PER_GCL_NUM_EXTRA3 NUMBER(16,2)
            )';

 V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
					GCL_DATE_EXTRA3 DATE, 
					GCL_NUM_EXTRA3 NUMBER(16,2)
            )';


  
     
  EXECUTE IMMEDIATE V_MSQL;

	  EXECUTE IMMEDIATE V_MSQL2;	


DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');
DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada');

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
