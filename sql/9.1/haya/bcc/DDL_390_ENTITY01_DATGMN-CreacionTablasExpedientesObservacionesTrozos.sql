--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160310
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_EXPEDIENTES_OBSER_TROZOS
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
 TABLA VARCHAR(30) :='MIG_EXPEDIENTES_OBSER_TROZOS';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (     ID_EXP_OBS_TROZOS    NUMBER(16,0) NOT NULL ENABLE, 
         REF_TIPO_OBSERVACION  VARCHAR2(10 CHAR) , 
         REF_ID_OBSERVACION    NUMBER(16,0) NOT NULL ENABLE, 
         ORDEN                 NUMBER(16,0) NOT NULL ENABLE, 
         TEXTO                 VARCHAR2(3000 CHAR),
         CONSTRAINT PK_MIG_EXP_OBS_TROZOS_ID PRIMARY KEY (ID_EXP_OBS_TROZOS)
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



