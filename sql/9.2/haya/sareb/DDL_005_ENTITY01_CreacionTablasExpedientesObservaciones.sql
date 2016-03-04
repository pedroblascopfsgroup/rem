--/*
--##########################################
--## AUTOR=DANIEL ALBERT
--## FECHA_CREACION=20160225
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2023
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_EXPEDIENTES_OBSERVACIONES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 TABLA VARCHAR(30) :='MIG_EXPEDIENTES_OBSERVACIONES';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 SECUENCIA VARCHAR(30) :='S_MIG_EXP_OBSERVACIONES';

BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
      MIG_EXP_OBS_ID 		NUMBER(16,0) NOT NULL	  , 
      CD_EXPEDIENTE  		NUMBER(16,0) 	  , 
      FECHA_ANOTACION   DATE,
      TEXTO_ANOTACION		VARCHAR2(2000 CHAR)	  , 
      SECUENCIA_ANOTACION	NUMBER(2,0)  , 
      USUARIO_ANOTACION   VARCHAR2(20 CHAR) 	  ,
      CONSTRAINT "PK_MIG_EXP_OBS_ID" PRIMARY KEY ("MIG_EXP_OBS_ID")
      USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 NOCOMPRESS LOGGING
      TABLESPACE '||ITABLE_SPACE||'  ENABLE
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');     
  END IF;   

--Fin crear tabla

--Validamos si la tabla existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

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
     DBMS_OUTPUT.PUT_LINE(''||SECUENCIA||' CREADA');
ELSE 
     DBMS_OUTPUT.PUT_LINE('YA EXISTE LA SECUENCIA '||SECUENCIA||'');
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
