--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-18941
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración CONSULTA
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18941] - Alejandra García
--##        0.2 Añadir campo DD_SOA_ID - [HREOS-18941] - Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := 'APR_AUX_HREOS_18797_2_CONSULTA';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';

        END IF;

        V_MSQL :=  '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
            NUM_OFERTA                  VARCHAR2(20 CHAR),
            ACT_ID			NUMBER(16,0),
            ECO_ID			NUMBER(16,0),
            TBJ_ID			NUMBER(16,0),
            TPO_ID			VARCHAR2(40 CHAR),
            TAP_ID			VARCHAR2(40 CHAR),
	    USU_ID			NUMBER(16,0),
            SUP_ID			NUMBER(16,0),
            TAREA_ANTIGUA_TRAMITE       VARCHAR2(40 CHAR),
            TAREA_NUEVA_TRAMITE         VARCHAR2(40 CHAR),
            TRA_ID			NUMBER(16,0),
            TAR_ID_ANTERIOR		NUMBER(16,0),
            TEX_ID_ANTERIOR		NUMBER(16,0),
            TAR_ID			NUMBER(16,0),
            TEX_ID			NUMBER(16,0),
            DD_EEC_CODIGO_ANTIGUO       NUMBER(16,0),
            DD_EEB_CODIGO_ANTIGUO       NUMBER(16,0),
            OFR_NUM_OFERTA_CAIXA        NUMBER(10,0),
            DD_SOA_ID                   NUMBER(16,0)
	)';
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');
            EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.NUM_OFERTA IS ''Número de oferta''';
            EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TAREA_ANTIGUA_TRAMITE IS ''Tarea en la que se encontraba antes la oferta''';
            EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TAREA_NUEVA_TRAMITE IS ''Tarea en la que se encuentra ahora la oferta''';

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
