--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-868
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla MIG_PROCS_SUBASTAS_LOTES
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='MIG_PROCS_SUBASTAS_LOTES';
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

  
  V_MSQL := ' CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'(	
	  MIG_ID_PROCS_SUBASTA_LOTE 	NUMBER(16,0) 	  NOT NULL ENABLE, 
	  CD_LOTE                 	VARCHAR2(30 CHAR) NOT NULL,
	  CD_SUBASTA              	NUMBER(16)        NOT NULL,
	  NUMERO_LOTE             	NUMBER(3)         NOT NULL,
	  PUJA_SIN_POSTORES        	NUMBER(16,2),
	  PUJA_CON_POSTORES_DESDE  	NUMBER(16,2),
	  PUJA_CON_POSTORES_HASTA  	NUMBER(16,2),
	  CON_POSTORES             	NUMBER(1),
	  CONSTRAINT "PK_MIG_PROCS_SUB_LOTES" PRIMARY KEY ("MIG_ID_PROCS_SUBASTA_LOTE")
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

