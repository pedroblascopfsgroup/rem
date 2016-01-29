--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-475
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PARAM_HITOS_VALORES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='MIG_PARAM_HITOS_VALORES';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	MIG_PHV_ID                NUMBER               NOT NULL ENABLE, 
	MIG_PARAM_HITO_ID         NUMBER               NOT NULL ENABLE, 
	TABLA_MIG                 VARCHAR2(30 BYTE)    NOT NULL ENABLE, 
	CAMPO_INTERFAZ            VARCHAR2(100 BYTE)   NOT NULL ENABLE, 
	ORDEN                     NUMBER               NOT NULL ENABLE, 
	FLAG_ES_FECHA             NUMBER               NOT NULL ENABLE, 
	TAP_CODIGO                VARCHAR2(100 BYTE)   NOT NULL ENABLE, 
	TEV_NOMBRE                VARCHAR2(50 BYTE)    NOT NULL ENABLE, 
	CONSTRAINT "PK_MIG_PARAM_HITOS_VALOR" PRIMARY KEY ("MIG_PHV_ID")
                USING INDEX TABLESPACE '||ITABLE_SPACE||'  ENABLE, 
	CONSTRAINT "FK_A_MIG_PARAM_HITOS" FOREIGN KEY ("MIG_PARAM_HITO_ID")
	        REFERENCES '||V_ESQUEMA||'."MIG_PARAM_HITOS" ("MIG_PARAM_HITO_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE';

 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE( TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE( TABLA||' CREADA');     
  END IF;   
          
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


