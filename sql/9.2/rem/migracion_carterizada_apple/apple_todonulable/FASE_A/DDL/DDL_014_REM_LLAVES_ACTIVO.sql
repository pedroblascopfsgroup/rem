--/*
--#########################################
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración 'MIG_ALA_LLAVES_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';

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
LLV_CODIGO NUMBER(16,0) ,
MLV_COD_CENTRO VARCHAR2(20 CHAR) ,
MLV_NOMBRE_CENTRO VARCHAR2(100 CHAR) ,
MLV_ARCHIVO1 VARCHAR2(50 CHAR) ,
MLV_ARCHIVO2 VARCHAR2(50 CHAR) ,
MLV_ARCHIVO3 VARCHAR2(50 CHAR) ,
MLV_COMPLETO NUMBER(1,0) ,
MLV_MOTIVO_INCOMPLETO VARCHAR2(100 CHAR) ,
VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.LLV_CODIGO IS ''Código identificador del manojo de  llaves''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_COD_CENTRO IS ''Código del centro de llaves donde se ubica el manojo de llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_NOMBRE_CENTRO IS ''Nombre del centro de llaves donde se ubica el manojo de llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_ARCHIVO1 IS ''Código o número de la posición1 en la que se encuentra el manojo de las llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_ARCHIVO2 IS ''Código o número de la posición2 en la que se encuentra el manojo de las llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_ARCHIVO3 IS ''Código o número de la posición3 en la que se encuentra el manojo de las llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_COMPLETO IS ''Indicador si tiene llaves''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ALA_LLAVES_ACTIVO.MLV_MOTIVO_INCOMPLETO IS ''Indicar motivo por el que el manojo no está completo.''';

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
