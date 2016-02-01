--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-859
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_ABI_BIENES_CONSOL_PTRO
--##                   
--##                               , esquema #ESQUEMA#. Con estructura correcta
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
 TABLA1 VARCHAR(30) :='APR_AUX_ABI_BIENES_CONSOL_PTRO'; 
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
    (	"FECHA_EXTRACCION" DATE, 
	"FECHA_DATO" DATE, 
	"CODIGO_ENTIDAD" NUMBER(4,0), 
	"CODIGO_PROPIETARIO" NUMBER(5,0), 
	"CODIGO_BIEN" NUMBER(16,0), 
	"TIPO_BIEN" VARCHAR2(20 CHAR), 
	"TIPO_INMUEBLE" VARCHAR2(4 CHAR), 
	"TIPO_PROD_BANCARIO" VARCHAR2(4 CHAR), 
	"DESCRIPCION_BIEN" VARCHAR2(250 CHAR), 
	"VALOR_ACTUAL" NUMBER(14,2), 
	"VALOR_TASACION" NUMBER(14,2), 
	"BIE_FECHA_VALOR_TASACION" DATE, 
	"VALOR_SUBJETIVO" NUMBER(14,2), 
	"FECHA_VALORACION_SUBJETIVA" DATE, 
	"VALOR_APRECIACION" NUMBER(14,2), 
	"FECHA_VALORACION_APRECIACION" DATE, 
	"IMPORTE_CARGAS_ANTERIORES" NUMBER(14,2), 
	"SUPERFICIE" NUMBER(11,2), 
	"SUPERFICIE_CONSTRUIDA" NUMBER(11,2), 
	"DIRECCION" VARCHAR2(250 CHAR), 
	"POBLACION" VARCHAR2(100 CHAR), 
	"CODIGO_POSTAL" VARCHAR2(10 CHAR), 
	"REFERENCIA_CATASTRAL" VARCHAR2(50 CHAR), 
	"MUNICIPIO_LIBRO" VARCHAR2(50 CHAR), 
	"NUMERO_REGISTRO" VARCHAR2(50 CHAR), 
	"TOMO" VARCHAR2(50 CHAR), 
	"FOLIO" VARCHAR2(50 CHAR), 
	"NUMERO_FINCA" VARCHAR2(50 CHAR), 
	"INSCRIPCION" VARCHAR2(50 CHAR), 
	"FECHA_INSCRIPCION" DATE, 
	"NOMBRE_EMPRESA" VARCHAR2(250 CHAR), 
	"CIF_EMPRESA" VARCHAR2(20 CHAR), 
	"CNAE_EMPRESA" VARCHAR2(50 CHAR), 
	"ENTIDAD" VARCHAR2(150 CHAR), 
	"NUM_CUENTA" VARCHAR2(150 CHAR), 
	"MARCA" VARCHAR2(50 CHAR), 
	"MODELO" VARCHAR2(50 CHAR), 
	"BASTIDOR" VARCHAR2(50 CHAR), 
	"MATRICULA" VARCHAR2(50 CHAR), 
	"FECHA_MATRICULA" DATE, 
	"CHAR_EXTRA1" VARCHAR2(50 CHAR), 
	"CHAR_EXTRA2" VARCHAR2(50 CHAR), 
	"FLAG_EXTRA1" VARCHAR2(1 CHAR), 
	"FLAG_EXTRA2" VARCHAR2(1 CHAR), 
	"DATE_EXTRA1" DATE, 
	"DATE_EXTRA2" DATE, 
	"NUM_EXTRA1" NUMBER(14,2), 
	"NUM_EXTRA2" NUMBER(14,2), 
	"LIBRO" VARCHAR2(50 BYTE), 
	"CHAR_EXTRA3" VARCHAR2(50 BYTE), 
	"DATE_EXTRA3" DATE, 
	"NUM_EXTRA3" NUMBER(14,2)
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

