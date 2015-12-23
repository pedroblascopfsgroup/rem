--/*
--##########################################
--## AUTOR=DANIEL ALBERT
--## FECHA_CREACION=20151217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK= HR-1500
--## PRODUCTO=NO
--## 
--## Finalidad: CreaciÃ³n de tablas AUX_ALTA_ASUNTOS_LITIGIOS y AUX_ALTA_ASUNTOS_CONCURSOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 VersiÃ³n inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';                   -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';            -- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
 TABLA VARCHAR(30 CHAR) :='AUX_ALTA_ASUNTOS_LITIGIOS';
 TABLA2 VARCHAR(30 CHAR) :='AUX_ALTA_ASUNTOS_CONCURSOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_MSQL2 VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 V_EXISTE2 NUMBER (1);
 SECUENCIA VARCHAR(30 CHAR) :='S_AUX_ALTA_ASUNTOS_LITIGIOS';
 SECUENCIA2 VARCHAR(30 CHAR) :='S_AUX_ALTA_ASUNTOS_CONCURSOS';

BEGIN 

--Validamos si la tabla 1 existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (    
                ASU_LIT_ID NUMBER(*,0), 
                CNT_ID NUMBER(16,0) NOT NULL ENABLE, 
                MOTIVO_GESTION_ESPECIAL NUMBER(16,0) NOT NULL ENABLE, 
                OFI_ID NUMBER(16,0) NOT NULL ENABLE, 
                EXP_ID NUMBER(16,0), 
                DD_EEX_ID NUMBER(16,0), 
                SYS_GUID VARCHAR2(32 BYTE), 
                PER_ID NUMBER(16,0) NOT NULL ENABLE, 
                PER_DOC_ID VARCHAR2(20 CHAR), 
                PER_NOM50 VARCHAR2(1200 BYTE), 
                PRC_ID NUMBER(16,0), 
                ASU_ID NUMBER(16,0), 
                DD_EAS_ID NUMBER(16,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');     
  END IF;   

--Fin crear tabla 1
          
--Validamos si la tabla 1 existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE 
  FROM user_sequences 
  WHERE sequence_name = ''||SECUENCIA||'';


 S_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||SECUENCIA||' 
 INCREMENT BY 1 
 START WITH 1 
 MINVALUE 1 
 MAXVALUE 999999999999999999999999999 
 CACHE 100 NOORDER  
 NOCYCLE ';


IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE(SECUENCIA||' CREADA');
ELSE 
     DBMS_OUTPUT.PUT_LINE('YA EXISTE LA SECUENCIA '||SECUENCIA||'');
END IF; 

--Fin crear secuencia

--Validamos si la tabla 2 existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE2
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA2;

  
  V_MSQL2 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA2||' 
   (    
                ASU_CON_ID NUMBER, 
                PER_ID NUMBER(16,0), 
                PER_DOC_ID VARCHAR2(20 CHAR), 
                PER_NOM50 VARCHAR2(1200 BYTE), 
                OFI_ID NUMBER(16,0), 
                CNT_ID NUMBER(16,0), 
                CLI_ID NUMBER, 
                PRC_ID NUMBER(16,0), 
                ASU_ID NUMBER(16,0), 
                DD_EAS_ID NUMBER(16,0), 
                EXP_ID NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE2 = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL2;
     DBMS_OUTPUT.PUT_LINE(TABLA2||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA2 );
     DBMS_OUTPUT.PUT_LINE(TABLA2||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL2;
     DBMS_OUTPUT.PUT_LINE(TABLA2||' CREADA');     
  END IF;   

--Fin crear tabla 2

--Validamos si la tabla 2 existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE2 
  FROM user_sequences 
  WHERE sequence_name = ''||SECUENCIA2||'';


 S_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||SECUENCIA2||' 
 INCREMENT BY 1 
 START WITH 1 
 MINVALUE 1 
 MAXVALUE 999999999999999999999999999 
 CACHE 100 NOORDER  
 NOCYCLE ';


IF V_EXISTE2 = 0 THEN   
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE(SECUENCIA2||' CREADA');
ELSE 
     DBMS_OUTPUT.PUT_LINE('YA EXISTE LA SECUENCIA '||SECUENCIA2||'');
END IF; 

--Fin crear secuencia

--Excepciones

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

