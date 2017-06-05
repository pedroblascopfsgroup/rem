--/*
--######################################### 
--## AUTOR=CLV
--## FECHA_CREACION=201600802
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_ADA_DATOS_ADI'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ADA_DATOS_ADI';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER=''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO	   				NUMBER(16,0)                NOT NULL,   
	TIPO_VPO							VARCHAR2(20 CHAR),
	ADM_SUELO_VPO						NUMBER(1,0),
	ADM_PROMOCION_VPO					NUMBER(1,0),
	ADM_NUM_EXPEDIENTE					VARCHAR2(50 CHAR),
	ADM_FECHA_CALIFICACION				DATE,
	ADM_OBLIGATORIO_SOL_DEV_AYUDA		NUMBER(1,0),
	ADM_OBLIG_AUT_ADM_VENTA				NUMBER(1,0),
	ADM_DESCALIFICADO					NUMBER(1,0),
	ADM_MAX_PRECIO_VENTA				NUMBER(16,2),
	ADM_OBSERVACIONES					VARCHAR2(2000 CHAR),
	SPS_FECHA_REVISION_ESTADO			DATE,
	SPS_FECHA_TOMA_POSESION				DATE,
	SPS_OCUPADO							NUMBER(1,0),
	SPS_CON_TITULO						NUMBER(1,0),
	SPS_ACC_TAPIADO						NUMBER(1,0),
	SPS_FECHA_ACC_TAPIADO				DATE,
	SPS_ACC_ANTIOCUPA					NUMBER(1,0),
	SPS_FECHA_ACC_ANTIOCUPA				DATE,
	SPS_RIESGO_OCUPACION				NUMBER(1,0),
	TIPO_TITULO_POSESORIO				VARCHAR2(20 CHAR),
	SPS_FECHA_TITULO					DATE,
	SPS_FECHA_VENC_TITULO				DATE,
	SPS_RENTA_MENSUAL					NUMBER(16,2),
	SPS_FECHA_SOL_DESAHUCIO				DATE,
	SPS_FECHA_LANZAMIENTO				DATE,
	SPS_FECHA_LANZAMIENTO_EFECTIVO		DATE,
	MUNICIPIO_REGISTRO					VARCHAR2(20 CHAR),
	REG_NUM_REGISTRO					VARCHAR2(50 CHAR),   
	REG_TOMO							VARCHAR2(50 CHAR),   
	REG_LIBRO							VARCHAR2(50 CHAR),   
	REG_FOLIO							VARCHAR2(50 CHAR),   
	REG_NUM_FINCA						VARCHAR2(50 CHAR),   
	REG_NUM_DEPARTAMENTO				NUMBER(16,0),   
	REG_IDUFIR							VARCHAR2(50 CHAR),   
	REG_HAN_CAMBIADO					NUMBER(1,0),
	MUNICIPIO_REG_ANTERIOR				VARCHAR2(20 CHAR),
	REG_NUM_ANTERIOR					VARCHAR2(50 CHAR),   
	REG_NUM_FINCA_ANTERIOR				VARCHAR2(50 CHAR),   
	REG_SUPERFICIE						NUMBER(16,2),
	REG_SUPERFICIE_CONSTRUIDA			NUMBER(16,2),
	REG_SUPERFICIE_UTIL					NUMBER(16,2),
	REG_SUPERFICIE_ELEM_COMUN			NUMBER(16,2),
	REG_SUPERFICIE_PARCELA				NUMBER(16,2),
	REG_SUPERFICIE_BAJO_RASANTE			NUMBER(16,2),
	REG_SUPERFICIE_SOBRE_RASANTE		NUMBER(16,2),
	REG_DIV_HOR_INSCRITO				NUMBER(1,0),
	ESTADO_DIVISION_HORIZONTAL			VARCHAR2(20 CHAR),
	ESTADO_OBRA_NUEVA					VARCHAR2(20 CHAR),
	REG_FECHA_CFO						DATE,
	TIPO_UBICACION						VARCHAR2(20 CHAR),
	TIPO_VIA							VARCHAR2(20 CHAR),
	LOC_NOMBRE_VIA						VARCHAR2(100 CHAR),
	LOC_NUMERO_DOMICILIO				VARCHAR2(100 CHAR),
	LOC_ESCALERA						VARCHAR2(10 CHAR),
	LOC_PISO							VARCHAR2(11 CHAR),
	LOC_PUERTA							VARCHAR2(17 CHAR),
	LOC_COD_POST						VARCHAR2(20 CHAR),
	UNIDAD_INFERIOR_MUNICIPIO			VARCHAR2(20 CHAR),
	MUNICIPIO							VARCHAR2(20 CHAR),
	PROVINCIA							VARCHAR2(20 CHAR),
	PAIS								VARCHAR2(20 CHAR),
	LOC_LONGITUD						NUMBER(21,15),
	LOC_LATITUD							NUMBER(21,15),
	LOC_DIST_PLAYA						NUMBER(16,2),
	CPR_COD_COM_PROP_UVEM				VARCHAR2(10 CHAR),
	ACT_LLV_NECESARIAS					NUMBER(1,0),
	ACT_LLV_LLAVES_HRE					NUMBER(1,0),
	ACT_LLV_NUM_JUEGOS					NUMBER(8,0),
	ACT_LLV_FECHA_RECEPCION				DATE,
	ACT_IND_CONDICIONADO_OTROS			VARCHAR2(255 CHAR),
	REG_ID								NUMBER(16,0),
	BIE_DREG_ID							NUMBER(16,0),
	LOC_ID								NUMBER(16,0),
	BIE_LOC_ID							NUMBER(16,0)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';

DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||'');  

END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
