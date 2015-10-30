--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151021
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TMP_VEN_VENCIDOS
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE
 
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema #ESQUEMA#
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master  #ESQUEMA_MASTER#
 TABLA1 VARCHAR(30) :='TMP_VEN_VENCIDOS';
 TABLA2 VARCHAR(30) :='TMP_VEN_VENCIDOS_REJECTS'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
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
	"TMP_VEN_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"TMP_VEN_FECHA_EXTRACCION" DATE NOT NULL ENABLE, 
	"TMP_VEN_FECHA_DATO" DATE NOT NULL ENABLE, 
	"TMP_VEN_TIPO_PRODUCTO" VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	"TMP_VEN_NUMERO_CONTRATO" NUMBER(17,0) NOT NULL ENABLE, 
	"TMP_VEN_TIPO_VENCIDO" VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	"TMP_VEN_IMPORTE_INICIAL" NUMBER(14,2), 
	"TMP_VEN_CAPITAL_VIVO" NUMBER(14,2), 
	"TMP_VEN_IMPORTE_PTE_DIFER" NUMBER(14,2), 
	"TMP_VEN_FECHA_BAJA_DUDOSO" DATE, 
	"TMP_VEN_FECHA_ALTA_DUDOSO" DATE, 
	"TMP_VEN_FECHA_CAMBIO_TRAMO" DATE, 
	"TMP_VEN_FECHA_IMPAGO" DATE, 
	"TMP_VEN_TRAMO_PREVIO" VARCHAR2(5 CHAR), 
	"TMP_VEN_ARRASTRE" VARCHAR2(1 CHAR), 
	"TMP_VEN_MOTIVO_ALTA_DUDOSO" VARCHAR2(250 CHAR), 
	"TMP_VEN_MOTIVO_BAJA_DUDOSO" VARCHAR2(250 CHAR), 
	"TMP_VEN_CHAR_EXTRA1" VARCHAR2(50 CHAR), 
	"TMP_VEN_CHAR_EXTRA2" VARCHAR2(50 CHAR), 
	"TMP_VEN_FLAG_EXTRA1" VARCHAR2(1 CHAR), 
	"TMP_VEN_FLAG_EXTRA2" VARCHAR2(1 CHAR), 
	"TMP_VEN_DATE_EXTRA1" DATE, 
	"TMP_VEN_DATE_EXTRA2" DATE, 
	"TMP_VEN_DATE_EXTRA3" DATE, 
	"TMP_VEN_NUM_EXTRA1" NUMBER(14,2), 
	"TMP_VEN_NUM_EXTRA2" NUMBER(14,2), 
	"TMP_VEN_NUM_EXTRA3" NUMBER(14,2),
	"VERSION" NUMBER, 
	"USUARIOCREAR" VARCHAR2(10 BYTE), 
	"FECHACREAR" TIMESTAMP (0), 
	"USUARIOMODIFICAR" VARCHAR2(10 BYTE), 
	"FECHAMODIFICAR" TIMESTAMP (0), 
	"USUARIOBORRAR" VARCHAR2(10 BYTE), 
	"FECHABORRAR" TIMESTAMP (0), 
	"BORRADO" NUMBER(1,0)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  ';
          

     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' CREADA');

  
-- TMP_VEN_VENCIDOS_REJECTS
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA2||'';

 
  IF V_EXISTE = 1 THEN   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA2 );
     DBMS_OUTPUT.PUT_LINE(''||TABLA2||' BORRADA');
  END IF;   
         
  
  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA2||'  
         (	
	"ROWREJECTED" VARCHAR2(2048 CHAR),  
	"ERRORCODE" VARCHAR2(250 CHAR), 
	"ERRORMESSAGE" VARCHAR2(250 CHAR)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  ';
            
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE(''||TABLA2||' CREADA');  
     
     
     V_EXISTE:=0;
     SELECT count(*) INTO V_EXISTE
     FROM all_sequences
     WHERE sequence_name = 'S_'||TABLA1 and sequence_owner= V_ESQUEMA;

     if V_EXISTE is null OR V_EXISTE = 0 then
         EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLA1||'
         START WITH 1
         MAXVALUE 999999999999999999999999999
         MINVALUE 1
         NOCYCLE
         CACHE 20
         NOORDER');
     end if;     

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

