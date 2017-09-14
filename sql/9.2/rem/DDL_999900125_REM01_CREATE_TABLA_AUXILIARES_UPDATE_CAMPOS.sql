--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=p2.0.6-170728
--## INCIDENCIA_LINK=HREOS-2841
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
  V_TABLA VARCHAR(30) :='MIG_UPDATE_CAMPOS';
  err_num NUMBER;
  err_msg VARCHAR2(2048);
  V_EXISTE NUMBER (1);
  V_MSQL VARCHAR2(4000 CHAR);

BEGIN

  --TABLA ACTIVOS_A_BORRAR
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  IF V_EXISTE = 1 THEN
    V_MSQL := 'DROP TABLE '||V_TABLA||' PURGE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' BORRADA.');
  END IF;

  V_MSQL := '  CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
   (  "ACT_NUMERO_PRINEX" NUMBER(16,0), 
  "ACT_NUMERO_ACTIVO" NUMBER(16,0), 
  "ACT_NUMERO_UVEM" NUMBER(16,0), 
  "PRO_CODIGO_UVEM" NUMBER(16,0), 
  "ACT_DESCRIPCION" VARCHAR2(250 CHAR), 
  "SPS_CON_TITULO" NUMBER(1,0), 
  "SPS_ACC_TAPIADO" NUMBER(1,0), 
  "ACT_RATING" VARCHAR2(20 CHAR), 
  "ESTADO_ADMISION" NUMBER(1,0), 
  "ESTADO_GESTION" NUMBER(1,0), 
  "SITUACION_COMERCIAL" VARCHAR2(20 CHAR), 
  "SPS_RIESGO_OCUPACION" NUMBER(1,0), 
  "ESTADO_OBRA_NUEVA" VARCHAR2(20 CHAR), 
  "LOC_LONGITUD" NUMBER(21,15), 
  "LOC_LATITUD" NUMBER(21,15), 
  "ACT_LLV_NECESARIAS" NUMBER(1,0), 
  "ACT_COD_SUBCARTERA" VARCHAR2(20 CHAR), 
  "ACT_COD_TIPO_COMERCIALIZACION" VARCHAR2(20 CHAR), 
  "ACT_COD_TIPO_ALQUILER" VARCHAR2(20 CHAR), 
  "ACT_FECHA_VENTA" DATE, 
  "ACT_IMPORTE_VENTA" NUMBER(16,2), 
  "SELLO_CALIDAD" NUMBER(1,0), 
  "GESTOR_CALIDAD" VARCHAR2(50 CHAR), 
  "FECHA_CALIDAD" DATE, 
  "GRADO_PROPIEDAD" VARCHAR2(20 CHAR), 
  "PORCENTAJE" NUMBER(5,2), 
  "ADJ_FECHA_SEN_POSESION" DATE, 
  "TIT_FECHA_INSC_REG" DATE
   ) TABLESPACE '||ITABLE_SPACE||' ';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' CREADA.');

--DAMOS GRANTS
  V_MSQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''PFSREM'' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
  IF V_EXISTE = 1 THEN
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||V_TABLA||' TO PFSREM';
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
EXIT
