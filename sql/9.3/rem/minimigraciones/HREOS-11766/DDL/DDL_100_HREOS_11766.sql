--/*
--#########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201020
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11766
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de la tabla 'TMP_ACT_ART_ADMISION_REV_TITULO'
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
V_TABLA VARCHAR2(40 CHAR) := 'TMP_ACT_ART_ADMISION_REV_TITULO';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER = ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE 
'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||
'(
    ACT_ID VARCHAR2(100 CHAR)
    , ART_REVISADO VARCHAR2(100 CHAR)
    , ART_FECHA_REVISION_TITULO DATE
	, TIPO_TIT_ACT_ENT_REF VARCHAR2(100 CHAR)
    , SUBTIPO_TIT_ACT_ENT_REF VARCHAR2(100 CHAR)
    , ART_RATIFICACION VARCHAR2(100 CHAR)
    , TIPO_TITULO_ACTIVO_ENTRADA VARCHAR2(100 CHAR)
    , SUBTIPO_TITULO_ACTIVO_ENTRADA VARCHAR2(100 CHAR)
    , ART_INST_LIB_ARRENDATARIA VARCHAR2(100 CHAR)
    , ART_SIT_INI_INSCRIPCION VARCHAR2(100 CHAR)
    , ART_POSESORIA_INI VARCHAR2(100 CHAR)
    , ART_SIT_INI_CARGAS VARCHAR2(100 CHAR)
    , DD_SNR_ID VARCHAR2(100 CHAR)
    , ART_PORC_PROPIEDAD VARCHAR2(100 CHAR)
    , ART_TIPO_TITULARIDAD VARCHAR2(100 CHAR)
    , DD_PTO_ID VARCHAR2(100 CHAR)
    --, ART_OBSERVACIONES VARCHAR2(1000 CHAR)
    , ART_AUTORIZ_TRANSMISION VARCHAR2(100 CHAR)
    , ART_ANOTACION_CONCURSO VARCHAR2(100 CHAR)
    , ART_EST_GES_CA VARCHAR2(100 CHAR)
    , ART_CONS_FISICA VARCHAR2(100 CHAR)
    , ART_PORC_CONS_TASACION_CF VARCHAR2(100 CHAR)
    , ART_CONS_JURIDICA VARCHAR2(100 CHAR)
    , ART_PORC_CONS_TASACION_CJ VARCHAR2(100 CHAR)
    , ART_CERTIFICADO_FIN_OBRA VARCHAR2(100 CHAR)
    , ART_AFO_ACTA_FIN_OBRA VARCHAR2(100 CHAR)
    , ART_LIC_PRIMERA_OCIPACION VARCHAR2(100 CHAR)
    , ART_BOLETINES VARCHAR2(100 CHAR)
    , ART_SEGURO_DECENAL VARCHAR2(100 CHAR)
    , ART_CEDULA_HABITABILIDAD VARCHAR2(100 CHAR)
    , ART_FECHA_CONTRATO_ALQ DATE
    , ART_LEGISLACION_APLICABLE_ALQ VARCHAR2(250 CHAR)
    , ART_DURACION_CONTRATO_ALQ VARCHAR2(250 CHAR)
    , ART_TIPO_ARRENDAMIENTO VARCHAR2(100 CHAR)
    , ART_NOTIF_ARRENDATARIOS VARCHAR2(100 CHAR)
    , ART_TIPO_EXP_ADM VARCHAR2(100 CHAR)
    , ART_EST_GES_EA VARCHAR2(100 CHAR)
    , ART_TIPO_INCI_REGISTRAL VARCHAR2(100 CHAR)
    , ART_EST_GES_CR VARCHAR2(100 CHAR)
    , ART_TIPO_OCUPACION_LEGAL VARCHAR2(100 CHAR)
    , ART_TIPO_INCI_ILOC VARCHAR2(250 CHAR)
    , ART_EST_GES_IL VARCHAR2(100 CHAR)
    , ART_DETERIORO_GRAVE VARCHAR2(250 CHAR)
    , ART_TIPO_INCI_OTROS VARCHAR2(250 CHAR)
    , ART_EST_GES_OT VARCHAR2(100 CHAR)
)';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

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
