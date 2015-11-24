--*/
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150909
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-739
--## PRODUCTO=NO
--## 
--## Finalidad: Se crea la tabla TMP_ALE_ALERTAS_REJECTS
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
 TABLA1 VARCHAR(30) := 'TMP_ALE_ALERTAS_REJECTS';
 TABLA2 VARCHAR(30) := 'ALE_ALERTAS'; 
 
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
  
  
    IF V_EXISTE = 1 THEN   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA1 );
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' BORRADA');
  END IF;   
          
  
  
  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||'  
              (     
                    ROWREJECTED VARCHAR2(1024 CHAR), 
                    ERRORCODE VARCHAR2(255 CHAR), 
                    ERRORMESSAGE VARCHAR2(255 CHAR)
              ) SEGMENT CREATION IMMEDIATE 
              PCTFREE 10 PCTUSED 0 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
              STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
              PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
              ';


  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
               ALE_CHAR_EXTRA1 VARCHAR2(50 BYTE), 
               ALE_CHAR_EXTRA2 VARCHAR2(50 BYTE), 
               ALE_FLAG_EXTRA1 VARCHAR2(1 BYTE), 
               ALE_FLAG_EXTRA2 VARCHAR2(1 BYTE), 
               ALE_DATE_EXTRA1 DATE, 
               ALE_DATE_EXTRA2 DATE, 
               ALE_DATE_EXTRA3 DATE, 
               ALE_NUM_EXTRA1 NUMBER(14,2), 
               ALE_NUM_EXTRA2 NUMBER(14,2), 
               ALE_NUM_EXTRA3 NUMBER(14,2)
            )';              
              
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Creada');
                  
         
         EXECUTE IMMEDIATE V_MSQL2;
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
