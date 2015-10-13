--*/
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-739
--## PRODUCTO=NO
--## 
--## Finalidad: Se crea la tabla TMP_ALE_ALERTAS_REJECTS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se ajusta para dejar como NOT NULLABLE lo imprescindible
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := 'CM01';
 V_ESQUEMA_M VARCHAR(25) := 'CMMASTER'; 
 TABLA1 VARCHAR(30) := 'TMP_ALE_ALERTAS';
 TABLA2 VARCHAR(30) := 'ALE_ALERTAS'; 
 TABLE_SPACE VARCHAR(25)  := 'DRECOVERYONL8M';
 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(1500 CHAR);
 V_MSQL2 VARCHAR2(1500 CHAR); 
 V_EXISTE NUMBER (1):=null;


BEGIN 
  
--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';
  
  
       
  
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  MODIFY
             (
               TMP_ALE_COD_CLIENTE_ENTIDAD NOT NULL, 
               TMP_ALE_COD_ENTIDAD NULL, 
               TMP_ALE_COD_PROPIETARIO NULL, 
               TMP_ALE_TIPO_PRODUCTO NULL, 
               TMP_ALE_NUMERO_CONTRATO NULL, 
               TMP_ALE_NUMERO_ESPEC NULL
            )';              
              
  IF V_EXISTE = 1 THEN   
         EXECUTE IMMEDIATE V_MSQL2;
         DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada');         
  END IF;  			  

                  
         
         
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
