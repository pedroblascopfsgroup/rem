--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-863
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_REC_RECIBOS_PTRO
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
 TABLA1 VARCHAR(30) :='APR_AUX_REC_RECIBOS_PTRO'; 
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
    (	"ARC_FECHA_EXTRACCION" DATE, 
	"ARC_FECHA_DATO" DATE, 
	"ARC_CODIGO_ENTIDAD" NUMBER(4,0), 
	"ARC_CODIGO_PROPIETARIO" NUMBER(5,0), 
	"DD_TIPO_PRODUCTO" VARCHAR2(5 BYTE), 
	"ARC_NUMERO_CONTRATO" VARCHAR2(17 BYTE), 
	"ARC_NUMERO_SPEC" NUMBER(15,0), 
	"ARC_CODIGO_RECIBO" NUMBER(20,0) NOT NULL ENABLE, 
	"ARC_FECHA_VENCIMIENTO" DATE, 
	"ARC_FECHA_FACTURACION" DATE, 
	"ARC_CCC_DOMICILIACION" VARCHAR2(20 BYTE), 
	"DD_TIPO_RECIBO" VARCHAR2(7 CHAR), 
	"DD_TIPO_INTERES" NUMBER(7,5), 
	"ARC_IMPORTE_RECIBO" NUMBER(16,2), 
	"ARC_IMPORTE_IMPAGADO_RECIBO" NUMBER(16,2), 
	"ARC_CAPITAL" NUMBER(16,2), 
	"ARC_INT_ORDINARIOS" NUMBER(16,2), 
	"ARC_INT_MORATORIOS" NUMBER(16,2), 
	"ARC_COMISIONES" NUMBER(16,2), 
	"ARC_GASTOS_NO_COBRADOS" NUMBER(16,2), 
	"ARC_IMPUESTOS" NUMBER(16,2), 
	"DD_SITUACION_RECIBO" VARCHAR2(4 BYTE), 
	"DD_MOTIVO_DEVOLUCION" VARCHAR2(4 BYTE), 
	"DD_MOTIVO_RECHAZO" VARCHAR2(4 BYTE), 
	"ARC_CHAR_EXTRA1" VARCHAR2(50 BYTE), 
	"ARC_CHAR_EXTRA2" VARCHAR2(50 BYTE), 
	"ARC_FLAG_EXTRA1" VARCHAR2(1 BYTE), 
	"ARC_FLAG_EXTRA2" VARCHAR2(1 BYTE), 
	"ARC_DATE_EXTRA1" DATE, 
	"ARC_DATE_EXTRA2" DATE, 
	"ARC_NUM_EXTRA1" NUMBER(16,2), 
	"ARC_NUM_EXTRA2" NUMBER(16,2), 
	"ARC_CNT_CONTRATO" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"ARC_DATE_EXTRA3" DATE, 
	"ARC_NUM_EXTRA3" NUMBER(16,2)
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

