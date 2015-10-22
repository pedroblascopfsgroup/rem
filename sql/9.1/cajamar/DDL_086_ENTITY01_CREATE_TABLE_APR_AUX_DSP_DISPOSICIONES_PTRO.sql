--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-867
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_DSP_DISPOSICIONES_PTRO
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
 TABLA1 VARCHAR(30) :='APR_AUX_DSP_DISPOSICIONES_PTRO'; 
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
    (	"DSP_FECHA_EXTRACCION" DATE NOT NULL ENABLE, 
	"DSP_FECHA_DATO" DATE NOT NULL ENABLE, 
	"DSP_CODIGO_ENTIDAD" NUMBER(4,0) NOT NULL ENABLE, 
	"DSP_CODIGO_PROPIETARIO" NUMBER(5,0) NOT NULL ENABLE, 
	"DD_TIPO_PRODUCTO" VARCHAR2(5 BYTE) NOT NULL ENABLE, 
	"DSP_NUMERO_CONTRATO" NUMBER(17,0) NOT NULL ENABLE, 
	"DSP_NUM_ESPEC" NUMBER(15,0) NOT NULL ENABLE, 
	"DSP_CODIGO_DISPOSICION" NUMBER(20,0) NOT NULL ENABLE, 
	"DD_TIPO_DISPOSICION" VARCHAR2(4 BYTE) NOT NULL ENABLE, 
	"DD_SUBTIPO_DISPOSICION" VARCHAR2(4 BYTE), 
	"DD_SITUACION_DISPOSICION" VARCHAR2(4 BYTE) NOT NULL ENABLE, 
	"DD_MONEDA" NUMBER(4,0) NOT NULL ENABLE, 
	"DSP_IMPORTE" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_CAPITAL" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_INT_ORDINARIOS" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_INT_MORATORIOS" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_COMISIONES" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_GASTOS_NO_COBRADOS" NUMBER(14,2) NOT NULL ENABLE, 
	"DSP_IMPUESTOS" NUMBER(14,2), 
	"DSP_FECHA_VENCIMIENTO" DATE NOT NULL ENABLE, 
	"DSP_CHAR_EXTRA1" VARCHAR2(50 BYTE), 
	"DSP_CHAR_EXTRA2" VARCHAR2(50 BYTE), 
	"DSP_FLAG_EXTRA1" VARCHAR2(1 BYTE), 
	"DSP_FLAG_EXTRA2" VARCHAR2(1 BYTE), 
	"DSP_DATE_EXTRA1" DATE, 
	"DSP_DATE_EXTRA2" DATE, 
	"DSP_DATE_EXTRA3" DATE, 
	"DSP_NUM_EXTRA1" NUMBER(14,2), 
	"DSP_NUM_EXTRA2" NUMBER(14,2), 
	"DSP_NUM_EXTRA3" NUMBER(14,2)
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

