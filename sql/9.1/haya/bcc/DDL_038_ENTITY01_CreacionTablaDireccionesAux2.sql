--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150901
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-475
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_ABI_DIRECC_CONSOL2
--##                               , esquema #ESQUEMA#.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='APR_AUX_ABI_DIRECC_CONSOL2';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);


BEGIN 

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA||'';

  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	"FECHA_EXTRACCION" DATE, 
	"FECHA_DATO" DATE, 
	"CODIGO_ENTIDAD" NUMBER(4,0), 
	"CODIGO_PROPIETARIO" NUMBER(5,0), 
	"CODIGO_PERSONA" NUMBER(17,0), 
	"CODIGO_DIRECCION" VARCHAR2(33 BYTE), 
	"TIPO_VIA" VARCHAR2(100 CHAR), 
	"NOMBRE_VIA" VARCHAR2(100 CHAR), 
	"NUM_DOMICILIO" VARCHAR2(10 CHAR), 
	"PORTAL" VARCHAR2(15 CHAR), 
	"PISO" VARCHAR2(10 CHAR), 
	"ESCALERA" VARCHAR2(10 CHAR), 
	"PUERTA" VARCHAR2(10 CHAR), 
	"CODIGO_POSTAL" VARCHAR2(10 CHAR), 
	"PROVINCIA" VARCHAR2(100 CHAR), 
	"POBLACION" VARCHAR2(100 CHAR), 
	"MUNICIPIO" VARCHAR2(100 CHAR), 
	"PAIS" VARCHAR2(100 CHAR), 
	"CODIGO_INE_PROVINCIA" NUMBER(10,0), 
	"CODIGO_INE_POBLACION" NUMBER(10,0), 
	"CODIGO_INE_MUNICIPIO" NUMBER(10,0), 
	"CODIGO_INE_VIA" NUMBER(10,0), 
	"TIPO_DIRECCION" VARCHAR2(10 BYTE), 
	"CHAR_EXTRA1" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA2" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA3" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA4" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA5" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA6" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA7" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA8" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA9" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA10" VARCHAR2(50 BYTE), 
	"FLAG_EXTRA1" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA2" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA3" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA4" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA5" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA6" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA7" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA8" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA9" VARCHAR2(1 BYTE), 
	"FLAG_EXTRA10" VARCHAR2(1 BYTE), 
	"DATE_EXTRA1" DATE, 
	"DATE_EXTRA2" DATE, 
	"DATE_EXTRA3" DATE, 
	"DATE_EXTRA4" DATE, 
	"DATE_EXTRA5" DATE, 
	"DATE_EXTRA6" DATE, 
	"DATE_EXTRA7" DATE, 
	"DATE_EXTRA8" DATE, 
	"DATE_EXTRA9" DATE, 
	"DATE_EXTRA10" DATE, 
	"NUM_EXTRA1" NUMBER(14,2), 
	"NUM_EXTRA2" NUMBER(14,2), 
	"NUM_EXTRA3" NUMBER(14,2), 
	"NUM_EXTRA4" NUMBER(14,2), 
	"NUM_EXTRA5" NUMBER(14,2), 
	"NUM_EXTRA6" NUMBER(14,2), 
	"NUM_EXTRA7" NUMBER(14,2), 
	"NUM_EXTRA8" NUMBER(14,2), 
	"NUM_EXTRA9" NUMBER(14,2), 
	"NUM_EXTRA10" NUMBER(14,2)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  ';
 
 
  IF V_EXISTE = 0 THEN   
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA );
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');     
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



