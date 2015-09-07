--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150907
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación TABLA FINAL TEL_TELEFONOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := 'CM01';
 TABLA VARCHAR(30) :='TEL_TELEFONOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
                    			TEL_CODIGO_ENTIDAD NUMBER(4,0) NOT NULL ENABLE, 	
					TEL_CODIGO_PERSONA NUMBER(16,0) NOT NULL ENABLE,
					TEL_CODIGO_PROPIETARIO NUMBER(5,0) NOT NULL ENABLE,
					TEL_CHAR_EXTRA3 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA4 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA5 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA6 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA7 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA8 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA9 VARCHAR2(50 BYTE), 
					TEL_CHAR_EXTRA10 VARCHAR2(50 BYTE), 
					TEL_FLAG_EXTRA3 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA4 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA5 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA6 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA7 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA8 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA9 VARCHAR2(1 BYTE),
					TEL_FLAG_EXTRA10 VARCHAR2(1 BYTE),
					TEL_DATE_EXTRA3 DATE, 
					TEL_DATE_EXTRA4 DATE, 
					TEL_DATE_EXTRA5 DATE, 
					TEL_DATE_EXTRA6 DATE, 
					TEL_DATE_EXTRA7 DATE, 
					TEL_DATE_EXTRA8 DATE, 
					TEL_DATE_EXTRA9 DATE, 
					TEL_DATE_EXTRA10 DATE, 
					TEL_NUM_EXTRA3 NUMBER(16,2),
					TEL_NUM_EXTRA4 NUMBER(16,2),
					TEL_NUM_EXTRA5 NUMBER(16,2),
					TEL_NUM_EXTRA6 NUMBER(16,2),
					TEL_NUM_EXTRA7 NUMBER(16,2),
					TEL_NUM_EXTRA8 NUMBER(16,2),
					TEL_NUM_EXTRA9 NUMBER(16,2),
					TEL_NUM_EXTRA10 NUMBER(16,2)
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
