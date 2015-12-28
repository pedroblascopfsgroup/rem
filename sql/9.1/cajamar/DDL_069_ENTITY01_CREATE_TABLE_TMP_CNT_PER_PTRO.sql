--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-853
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TMP_CNT_PER_PTRO
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

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='TMP_CNT_PER_PTRO'; 
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
 (	"TMP_CNT_PER_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_FECHA_EXTRACCION" DATE NOT NULL ENABLE, 
	"TMP_CNT_PER_FECHA_DATO" DATE NOT NULL ENABLE, 
	"TMP_CNT_PER_COD_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_COD_PERSONA" NUMBER(16,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_COD_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_TIPO_PRODUCTO" VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	"TMP_CNT_PER_NUM_CONTRATO" NUMBER(17,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_EDO_CICLO_VIDA_REL" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"TMP_CNT_PER_FEC_CLO_VIDA_REL" DATE NOT NULL ENABLE, 
	"TMP_CNT_PER_TIPO_INTERVENCION" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"TMP_CNT_PER_ORDEN" NUMBER(4,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_COD_OFICINA" NUMBER(4,0), 
	"TMP_CNT_PER_CHAR_EXTRA1" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA2" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA3" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA4" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA5" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA6" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA7" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA8" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA9" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_CHAR_EXTRA10" VARCHAR2(50 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA1" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA2" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA3" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA4" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA5" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA6" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA7" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA8" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA9" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_FLAG_EXTRA10" VARCHAR2(1 BYTE), 
	"TMP_CNT_PER_DATE_EXTRA1" DATE, 
	"TMP_CNT_PER_DATE_EXTRA2" DATE, 
	"TMP_CNT_PER_DATE_EXTRA3" DATE, 
	"TMP_CNT_PER_DATE_EXTRA4" DATE, 
	"TMP_CNT_PER_DATE_EXTRA5" DATE, 
	"TMP_CNT_PER_DATE_EXTRA6" DATE, 
	"TMP_CNT_PER_DATE_EXTRA7" DATE, 
	"TMP_CNT_PER_DATE_EXTRA8" DATE, 
	"TMP_CNT_PER_DATE_EXTRA9" DATE, 
	"TMP_CNT_PER_DATE_EXTRA10" DATE, 
	"TMP_CNT_PER_NUM_EXTRA1" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA2" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA3" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA4" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA5" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA6" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA7" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA8" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA9" NUMBER(15,2), 
	"TMP_CNT_PER_NUM_EXTRA10" NUMBER(15,2), 
	"TMP_CNT_PER_FECHA_CARGA" DATE NOT NULL ENABLE, 
	"TMP_CNT_PER_FICHERO_CARGA" VARCHAR2(50 CHAR), 
	"VERSION" NUMBER(*,0) NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
	"BORRADO" NUMBER(1,0) NOT NULL ENABLE, 
	"TMP_CNT_PER_NUM_ESPEC" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
';
          

     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE(''||TABLA1||' CREADA');

  



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

