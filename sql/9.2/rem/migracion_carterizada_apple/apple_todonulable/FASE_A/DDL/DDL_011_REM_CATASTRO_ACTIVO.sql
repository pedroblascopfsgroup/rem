--/*
--#########################################
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración 'MIG_ACA_CATASTRO_ACTIVO'
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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ACA_CATASTRO_ACTIVO';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';

        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
ACT_NUMERO_ACTIVO NUMBER(16,0) ,
CAT_REF_CATASTRAL VARCHAR2(50 CHAR) ,
CAT_POLIGONO VARCHAR2(50 CHAR) ,
CAT_PARCELA VARCHAR2(50 CHAR) ,
CAT_TITULAR_CATASTRAL VARCHAR2(250 CHAR) ,
CAT_SUPERFICIE_CONSTRUIDA NUMBER(16,2) ,
CAT_SUPERFICIE_UTIL NUMBER(16,2) ,
CAT_SUPERFICIE_REPER_COMUN NUMBER(16,2) ,
CAT_SUPERFICIE_PARCELA NUMBER(16,2) ,
CAT_SUPERFICIE_SUELO NUMBER(16,2) ,
CAT_VALOR_CATASTRAL_CONST NUMBER(16,2) ,
CAT_VALOR_CATASTRAL_SUELO NUMBER(16,2) ,
CAT_FECHA_REV_VALOR_CATASTRAL DATE ,
CAT_REFERENCIA_PRINCIPAL VARCHAR2(1 CHAR) ,
CAT_F_ALTA_CATASTRO DATE ,
CAT_F_BAJA_CATASTRO DATE ,
CAT_OBSERVACIONES VARCHAR2(400 CHAR) ,
VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_REF_CATASTRAL IS ''Referencia catastral del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_POLIGONO IS ''Código del polígono del catastro de rústica antiguo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_PARCELA IS ''Código de la parcela del catastro de rústica antiguo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_TITULAR_CATASTRAL IS ''Nombre del titular de la referencia catastral.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_SUPERFICIE_CONSTRUIDA IS ''Superficie construida en metros cuadrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_SUPERFICIE_UTIL IS ''Superficie útil en metros cuadrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_SUPERFICIE_REPER_COMUN IS ''Superficie con repercusión en elementos comunes en metros cuadrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_SUPERFICIE_PARCELA IS ''Superficie parcela en metros cuadrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_SUPERFICIE_SUELO IS ''Superficie suelo en metros cuadrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_VALOR_CATASTRAL_CONST IS ''Valor catastral de construcción.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_VALOR_CATASTRAL_SUELO IS ''Valor catastral de suelo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_FECHA_REV_VALOR_CATASTRAL IS ''Fecha revisión valor catastral.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_REFERENCIA_PRINCIPAL IS ''Indicador de referencia catastral principal''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_F_ALTA_CATASTRO IS ''Fecha de alta en catastro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_F_BAJA_CATASTRO IS ''Fecha de baja en catastro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ACA_CATASTRO_ACTIVO.CAT_OBSERVACIONES IS ''Observaciones''';

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
