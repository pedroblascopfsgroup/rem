
--/*
--#########################################
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración 'MIG_ADD_ADMISION_DOC'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ADD_ADMISION_DOC';

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
TIPO_DOCUMENTO VARCHAR2(20 CHAR) ,
ESTADO_DOCUMENTO VARCHAR2(20 CHAR) ,
ADO_APLICA NUMBER(1,0) ,
ADO_NUM_DOCUMENTO NUMBER(16,0) ,
ADO_FECHA_VERIFICACION DATE ,
ADO_FECHA_SOLICITUD DATE ,
ADO_FECHA_EMISION DATE ,
ADO_FECHA_OBTENCION DATE ,
ADO_FECHA_CADUCIDAD DATE ,
ADO_FECHA_ETIQUETA DATE ,
ADO_FECHA_CALIFICACION DATE ,
ADO_CALIFICACION VARCHAR2(20 CHAR) ,
ADO_REF_DOC VARCHAR2(50 CHAR) ,
VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo..''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.TIPO_DOCUMENTO IS ''Tipo de documento (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ESTADO_DOCUMENTO IS ''Estado de documento (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_APLICA IS ''Indicador si aplica o no obligatoriedad al documento''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_NUM_DOCUMENTO IS ''Número del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_VERIFICACION IS ''Fecha verificación  del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_SOLICITUD IS ''Fecha solicitud del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_EMISION IS ''Fecha emisión del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_OBTENCION IS ''Fecha obtención del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_CADUCIDAD IS ''Fecha caducidad del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_ETIQUETA IS ''Fecha etiqueta del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_FECHA_CALIFICACION IS ''Fecha calificación energética del documento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_CALIFICACION IS ''Calificación energética documento (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_ADD_ADMISION_DOC.ADO_REF_DOC IS ''Referencia del documento''';

    IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

		EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';

		DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||'');

	END IF;
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "REMMASTER" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A REMMASTER');
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
