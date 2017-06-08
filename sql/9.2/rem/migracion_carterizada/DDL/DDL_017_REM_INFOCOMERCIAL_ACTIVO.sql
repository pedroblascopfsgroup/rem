--/*
--#########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170607
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2202
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_AIA_INFOCOMERCIAL_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_AIA_INFCOMERCIAL_ACT';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO	   				NUMBER(16,0)                NOT NULL,  
	UBICACION_ACTIVO					VARCHAR2(20 CHAR),
	ESTADO_CONSTRUCCION					VARCHAR2(20 CHAR),
	ESTADO_CONSERVACION 					VARCHAR2(20 CHAR),
	ICO_DESCRIPCION						VARCHAR2(512 CHAR),
	TIPO_INFO_COMERCIAL                		        VARCHAR2(20 CHAR),
	ICO_ANO_CONSTRUCCION					NUMBER(8,0),
	ICO_ANO_REHABILITACION					NUMBER(8,0),
	ICO_APTO_PUBLICIDAD         				NUMBER(1,0),
	ICO_ACTIVOS_VINC					VARCHAR2(250 CHAR),
	ICO_FECHA_EMISION_INFORME				DATE,
	ICO_FECHA_ULTIMA_VISITA					DATE,
	ICO_FECHA_ACEPTACION                			DATE, 
	ICO_FECHA_RECHAZO					DATE,
	ICO_FECHA_RECEPCION_LLAVES			DATE,
	ICO_JUSTIFICANTE_IMP_VENTA			VARCHAR2(3000 CHAR),
	ICO_JUSTIFICANTE_IMP_ALQUILER			VARCHAR2(3000 CHAR),
	ICO_ANYO_REHABILITA_EDIFICIO			NUMBER(8,0),
	ICO_DISTRITO						VARCHAR2(20 CHAR),
	PVE_CODIGO							VARCHAR2(50 CHAR),
	ICO_CONDICIONES_LEGALES					VARCHAR2(3000 CHAR),
	ESTADO_CONSERVACION_EDIFICIO				VARCHAR2(20 CHAR),
	TIPO_FACHADA_EDIFICIO					VARCHAR2(20 CHAR),
	EDI_ANO_REHABILITACION					NUMBER(8,0),
	EDI_NUM_PLANTAS						NUMBER(8,0),
	EDI_ASCENSOR						NUMBER(1,0),
	EDI_NUM_ASCENSORES					NUMBER(8,0),
	EDI_REFORMA_FACHADA					NUMBER(1,0),
	EDI_REFORMA_ESCALERA					NUMBER(1,0),
	EDI_REFORMA_PORTAL					NUMBER(1,0),
	EDI_REFORMA_ASCENSOR					NUMBER(1,0),
	EDI_REFORMA_CUBIERTA					NUMBER(1,0),
	EDI_REFORMA_OTRA_ZONA					NUMBER(1,0),
	EDI_REFORMA_OTRO					NUMBER(1,0),
	EDI_REFORMA_OTRO_ZONA_COM_DES		VARCHAR2(250 CHAR),
	EDI_REFORMA_OTRO_DESC					VARCHAR2(250 CHAR),
	EDI_DESCRIPCION						VARCHAR2(3000 CHAR),
	EDI_ENTORNO_INFRAESTRUCTURA				VARCHAR2(1024 CHAR),
	EDI_ENTORNO_COMUNICACION				VARCHAR2(1024 CHAR),
	TIPO_VIVIENDA						VARCHAR2(20 CHAR),
	TIPO_ORIENTACION					VARCHAR2(20 CHAR),
	TIPO_RENTA							VARCHAR2(20 CHAR),
	VIV_ULTIMA_PLANTA					NUMBER(1,0),
	VIV_NUM_PLANTAS_INTERIOR				NUMBER(8,0),
	VIV_REFORMA_CARP_INT					NUMBER(1,0),
	VIV_REFORMA_CARP_EXT					NUMBER(1,0),
	VIV_REFORMA_COCINA					NUMBER(1,0),
	VIV_REFORMA_BANYO					NUMBER(1,0),
	VIV_REFORMA_SUELO					NUMBER(1,0),
	VIV_REFORMA_PINTURA					NUMBER(1,0),
	VIV_REFORMA_INTEGRAL					NUMBER(1,0),
	VIV_REFORMA_OTRO					NUMBER(1,0),
	VIV_REFORMA_OTRO_DESC					VARCHAR2(250 CHAR),
	VIV_REFORMA_PRESUPUESTO					NUMBER(16,2),
	VIV_DISTRIBUCION_TXT					VARCHAR2(1500 CHAR),
	LCO_MTS_FACHADA_PPAL					NUMBER(16,2),
	LCO_MTS_FACHADA_LAT					NUMBER(16,2),
	LCO_MTS_LUZ_LIBRE					NUMBER(16,2),
	LCO_MTS_ALTURA_LIBRE					NUMBER(16,2),
	LCO_MTS_LINEALES_PROF					NUMBER(16,2),
	LCO_DIAFANO						NUMBER(1,0),
	LCO_USO_IDONEO						VARCHAR2(250 CHAR),
	LCO_USO_ANTERIOR					VARCHAR2(250 CHAR),
	LCO_OBSERVACIONES					VARCHAR2(1500 CHAR),
	APR_DESTINO_COCHE					NUMBER(1,0),
	APR_DESTINO_MOTO					NUMBER(1,0),
	APR_DESTINO_DOBLE					NUMBER(1,0),
	TIPO_UBICACION_APARCA				VARCHAR2(20 CHAR),
	TIPO_CALIDAD						VARCHAR2(20 CHAR),
	APR_ANCHURA						NUMBER(16,2),
	APR_PROFUNDIDAD						NUMBER(16,2),
	APR_FORMA_IRREGULAR					NUMBER(16,2)
	
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

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