--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150807
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TEMPORAL CONTRATOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='TMP_APR_AUX_ABI_CIRBE_CONSOL';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);


BEGIN 

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	"FECHA_EXTRACCION" DATE NOT NULL, 
	"FECHA_DATO" DATE NOT NULL, 
	"CODIGO_ENTIDAD" NUMBER(4,0) NOT NULL, 
	"CODIGO_RIESGO" VARCHAR2(1 CHAR), 
	"CODIGO_PRODUCTO_CIRBE" VARCHAR2(1 CHAR), 
	"CODIGO_DIVISA_CIRBE" VARCHAR2(1 CHAR), 
	"CODIGO_VENCIMIENTO_CIRBE" VARCHAR2(1 CHAR), 
	"CODIGO_GARANTIA_CIRBE" VARCHAR2(1 CHAR), 
	"CODIGO_SITUACION_IR_CIRBE" VARCHAR2(1 CHAR), 
	"FECHA_ACTUALIZACION" DATE, 
	"CODIGO_PROPIETARIO" NUMBER(5,0) NOT NULL, 
	"CODIGO_CLIENTE" NUMBER(16,0) NOT NULL, 
	"IMPORTE_DISPUESTO_CIRBE" NUMBER(14,2), 
	"IMPORTE_DISPONIBLE_CIRBE" NUMBER(14,2), 
	"CODIGO_ISO_PAIS" VARCHAR2(2 CHAR), 
	"NUMERO_PARTICIPANTES" NUMBER(3,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  ';
  
     
	 EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE(''||TABLA||' CREADA');

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