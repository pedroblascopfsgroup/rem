--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-859
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla APR_AUX_ABC_BIECNT_CONSOL_PTRO
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
 TABLA1 VARCHAR(30) :='APR_AUX_ABC_BIECNT_CONSOL_PTRO'; 
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
  (	"FECHA_EXTRACCION" DATE NOT NULL ENABLE, 
	"FECHA_DATO" DATE NOT NULL ENABLE, 
	"CODIGO_ENTIDAD" NUMBER(5,0) NOT NULL ENABLE, 
	"CODIGO_BIEN" NUMBER(16,0) NOT NULL ENABLE, 
	"CODIGO_PROPIETARIO" NUMBER(6,0) NOT NULL ENABLE, 
	"TIPO_PRODUCTO" VARCHAR2(5 CHAR) NOT NULL ENABLE, 
	"NUMERO_CONTRATO" NUMBER(18,0) NOT NULL ENABLE, 
	"NUMERO_ESPEC" NUMBER(16,0) NOT NULL ENABLE, 
	"TIPO_RELACION_CONTRATO_BIEN" VARCHAR2(4 CHAR), 
	"ESTADO_RELACION" VARCHAR2(4 CHAR), 
	"FECHA_INICIO_RELACION" DATE, 
	"FECHA_FIN_RELACION" DATE, 
	"IMPORTE_GARANTIZADO" NUMBER(14,2), 
	"CHAR_EXTRA1" VARCHAR2(50 CHAR), 
	"CHAR_EXTRA2" VARCHAR2(50 CHAR), 
	"FLAG_EXTRA1" VARCHAR2(1 CHAR), 
	"FLAG_EXTRA2" VARCHAR2(1 CHAR), 
	"DATE_EXTRA1" DATE, 
	"DATE_EXTRA2" DATE, 
	"NUM_EXTRA1" NUMBER(14,2), 
	"NUM_EXTRA2" NUMBER(14,2), 
	"DATE_EXTRA3" DATE, 
	"NUM_EXTRA3" NUMBER(14,2)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
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

