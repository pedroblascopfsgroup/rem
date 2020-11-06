--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20201015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8123
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas auxiliares
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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; 
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA_ICO VARCHAR2(50 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
V_TABLA_VIV VARCHAR2(50 CHAR) := 'ACT_VIV_VIVIENDA';
V_TABLA_LCO VARCHAR2(50 CHAR) := 'ACT_LCO_LOCAL_COMERCIAL';
V_TABLA_APR VARCHAR2(50 CHAR) := 'ACT_APR_PLAZA_APARCAMIENTO';
V_TABLA_EDI VARCHAR2(50 CHAR) := 'ACT_EDI_EDIFICIO';
V_TABLA_DIS VARCHAR2(50 CHAR) := 'ACT_DIS_DISTRIBUCION';


BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] ');
--INFORME COMERCIAL
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_ICO||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' AS
		(			
			SELECT ICO_ID,
				ACT_ID,
				DD_UAC_ID,
				DD_ECT_ID,
				DD_ECV_ID,
				DD_TIC_ID,
				ICO_MEDIADOR_ID,
				ICO_DESCRIPCION,
				ICO_ANO_CONSTRUCCION,
				ICO_ANO_REHABILITACION,
				ICO_APTO_PUBLICIDAD,
				ICO_ACTIVOS_VINC,
				ICO_FECHA_EMISION_INFORME,
				ICO_FECHA_ULTIMA_VISITA,
				ICO_FECHA_ACEPTACION,
				ICO_FECHA_RECHAZO,
				ICO_CONDICIONES_LEGALES,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				USUARIOMODIFICAR,
				FECHAMODIFICAR,
				USUARIOBORRAR,
				FECHABORRAR,
				BORRADO,
				ICO_AUTORIZACION_WEB,
				ICO_FECHA_AUTORIZ_HASTA,
				ICO_FECHA_RECEP_LLAVES,
				DD_TPA_ID,
				DD_SAC_ID,
				DD_EAC_ID,
				DD_TVI_ID,
				ICO_NOMBRE_VIA,
				ICO_NUM_VIA,
				ICO_ESCALERA,
				ICO_PLANTA,
				ICO_PUERTA,
				ICO_LATITUD,
				ICO_LONGITUD,
				ICO_ZONA,
				ICO_DISTRITO,
				DD_LOC_ID,
				DD_PRV_ID,
				ICO_CODIGO_POSTAL,
				ICO_JUSTIFICACION_VENTA,
				ICO_JUSTIFICACION_RENTA,
				ICO_CUOTACP_ORIENTATIVA,
				ICO_DERRAMACP_ORIENTATIVA,
				ICO_FECHA_ESTIMACION_VENTA,
				ICO_FECHA_ESTIMACION_RENTA,
				DD_UPO_ID,
				ICO_INFO_DESCRIPCION,
				ICO_INFO_DISTRIBUCION_INTERIOR,
				DD_DIS_ID,
				ICO_WEBCOM_ID,
				ICO_POSIBLE_HACER_INF,
				ICO_MOTIVO_NO_HACER_INF,
				ICO_FECHA_RECEP_LLAVES_HAYA,
				ICO_FECHA_ENVIO_LLAVES_API,
				ICO_RECIBIO_IMPORTE_ADM,
				ICO_IBI_IMPORTE_ADM,
				ICO_DERRAMA_IMPORTE_ADM,
				ICO_DET_DERRAMA_IMPORTE_ADM,
				DD_TVP_ID,
				ICO_VALOR_MAX_VPO,
				ICO_VALOR_ESTIMADO_VENTA,
				ICO_VALOR_ESTIMADO_RENTA,
				ICO_OCUPADO,
				ICO_NUM_TERRAZA_DESCUBIERTA,
				ICO_DESC_TERRAZA_DESCUBIERTA,
				ICO_NUM_TERRAZA_CUBIERTA,
				ICO_DESC_TERRAZA_CUBIERTA,
				ICO_DESPENSA_OTRAS_DEP,
				ICO_LAVADERO_OTRAS_DEP,
				ICO_AZOTEA_OTRAS_DEP,
				ICO_OTROS_OTRAS_DEP,
				ICO_PRESIDENTE_NOMBRE,
				ICO_PRESIDENTE_TELF,
				ICO_ADMINISTRADOR_NOMBRE,
				ICO_ADMINISTRADOR_TELF,
				ICO_EXIS_COM_PROP,
				DD_LOC_REGISTRO_ID,
				ICO_MEDIADOR_ESPEJO_ID 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000''
			
		)'
;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_ICO||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_ICO||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_ICO||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_ICO||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;



--VIVIENDA
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_VIV||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' AS
		(			
			SELECT ICO_ID,
				DD_TPV_ID,
				DD_TPO_ID,
				DD_TPR_ID,
				VIV_ULTIMA_PLANTA,
				VIV_NUM_PLANTAS_INTERIOR,
				VIV_REFORMA_CARP_INT,
				VIV_REFORMA_CARP_EXT,
				VIV_REFORMA_COCINA,
				VIV_REFORMA_BANYO,
				VIV_REFORMA_SUELO,
				VIV_REFORMA_PINTURA,
				VIV_REFORMA_INTEGRAL,
				VIV_REFORMA_OTRO,
				VIV_REFORMA_OTRO_DESC,
				VIV_REFORMA_PRESUPUESTO,
				VIV_DISTRIBUCION_TXT 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_VIV||' WHERE ICO_ID IN (SELECT ICO_ID FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000'')
			
		)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_VIV||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_VIV||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_VIV||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_VIV||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;


--LOCAL COMERCIAL
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_LCO||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' AS
		(			
			SELECT ICO_ID,
				LCO_MTS_FACHADA_PPAL,
				LCO_MTS_FACHADA_LAT,
				LCO_MTS_LUZ_LIBRE,
				LCO_MTS_ALTURA_LIBRE,
				LCO_MTS_LINEALES_PROF,
				LCO_DIAFANO,
				LCO_USO_IDONEO,
				LCO_USO_ANTERIOR,
				LCO_OBSERVACIONES,
				LCO_NUMERO_ESTANCIAS,
				LCO_NUMERO_BANYOS,
				LCO_NUMERO_ASEOS,
				LCO_SALIDA_HUMOS,
				LCO_SALIDA_EMERGENCIA,
				LCO_ACCESO_MINUSVALIDOS,
				LCO_OTROS_OTRAS_CARACT 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_LCO||' WHERE ICO_ID IN (SELECT ICO_ID FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000'')
			
		)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_LCO||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_LCO||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_LCO||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_LCO||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;


--PLAZA APARCAMIENTO
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_APR||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' AS
		(			
			SELECT ICO_ID,
				APR_DESTINO_COCHE,
				APR_DESTINO_MOTO,
				APR_DESTINO_DOBLE,
				DD_TUA_ID,
				DD_TCA_ID,
				APR_ANCHURA,
				APR_PROFUNDIDAD,
				APR_FORMA_IRREGULAR,
				DD_TPV_ID,
				APR_ALTURA,
				DD_SPG_ID,
				APR_LICENCIA,
				APR_SERVIDUMBRE,
				APR_ASCENSOR_MONTACARGA,
				APR_COLUMNAS,
				APR_SEGURIDAD 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_APR||' WHERE ICO_ID IN (SELECT ICO_ID FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000'')
			
		)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_APR||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_APR||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_APR||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_APR||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;


--DISTRIBUCION
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_DIS||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' AS
		(			
			SELECT DIS_ID,
				DIS_NUM_PLANTA,
				DD_TPH_ID,
				DIS_CANTIDAD,
				DIS_SUPERFICIE,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				USUARIOMODIFICAR,
				FECHAMODIFICAR,
				USUARIOBORRAR,
				FECHABORRAR,
				BORRADO,
				DIS_DESCRIPCION,
				ICO_ID 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_DIS||' WHERE ICO_ID IN (SELECT ICO_ID FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000'')
			
		)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_DIS||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_DIS||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_DIS||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_DIS||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;


--EDIFICIO
SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'AUX_'||V_TABLA_EDI||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||'';
    
END IF;

EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' AS
		(			
			SELECT EDI_ID,
				ICO_ID,
				DD_ECV_ID,
				DD_TPF_ID,
				EDI_ANO_REHABILITACION,
				EDI_NUM_PLANTAS,
				EDI_ASCENSOR,
				EDI_NUM_ASCENSORES,
				EDI_REFORMA_FACHADA,
				EDI_REFORMA_ESCALERA,
				EDI_REFORMA_PORTAL,
				EDI_REFORMA_ASCENSOR,
				EDI_REFORMA_CUBIERTA,
				EDI_REFORMA_OTRA_ZONA,
				EDI_REFORMA_OTRO,
				EDI_REFORMA_OTRO_DESC,
				EDI_DESCRIPCION,
				EDI_ENTORNO_INFRAESTRUCTURA,
				EDI_ENTORNO_COMUNICACION,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				USUARIOMODIFICAR,
				FECHAMODIFICAR,
				USUARIOBORRAR,
				FECHABORRAR,
				BORRADO,
				EDI_REFORMA_OTRO_ZONA_COM_DES,
				EDI_DIVISIBLE,
				EDI_DESC_PLANTAS,
				EDI_OTRAS_CARACTERISTICAS 
			FROM '||V_ESQUEMA_1||'.'||V_TABLA_EDI||' WHERE ICO_ID IN (SELECT ICO_ID FROM '||V_ESQUEMA_1||'.'||V_TABLA_ICO||' WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-0000'')
			
		)'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_EDI||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_EDI||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."AUX_'||V_TABLA_EDI||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.AUX_'||V_TABLA_EDI||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;
DBMS_OUTPUT.PUT_LINE('[FIN] ');
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

/

EXIT;

