--/*
--##########################################
--## AUTOR=DANIEL ALBERT PÉREZ
--## FECHA_CREACION=20160229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2051
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_EXPEDIENTES_CABECERA
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
 TABLA VARCHAR(30) :='MIG_EXPEDIENTES_CABECERA';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 S_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 SECUENCIA VARCHAR(30) :='S_MIG_EXPEDIENTES_CABECERA';


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	  MIG_EXP_CAB_ID NUMBER(16,0) , 
	  CD_EXPEDIENTE  NUMBER(16,0) , 
	  ESTADO VARCHAR2(20 CHAR)    , 
	  CD_EDP VARCHAR2(20 CHAR)    , 
	  FECHA_ASIGNACION DATE, 
	  TIPO_PROCEDIMIENTO VARCHAR2(20 CHAR), 
	  FECHA_ENVIO_LETRADO DATE, 
	  FECHA_ACEPTACION_LETRADO DATE, 
	  FECHA_PARALIZACION DATE, 
	  MOTIVO_PARALIZACION VARCHAR2(20 CHAR),
    OPERACION_PARALIZACION_VINC NUMBER(17,0),
    FECHA_BAJA DATE, 
    MOTIVO_BAJA VARCHAR2(500 CHAR), 
    WORKFLOW NUMBER(20,0),
	  CONSTRAINT "PK_MIG_EXP_CAB_ID" PRIMARY KEY ("MIG_EXP_CAB_ID")
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
