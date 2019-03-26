
--/*
--#########################################
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--##
--## Finalidad: Creación de tabla de migración 'MIG_PRESUPUESTO_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_PRESUPUESTO_ACTIVO';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';

        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
ACT_NUMERO_ACTIVO NUMBER(16,0) NOT NULL,
ACT_EJE_EJERCICIO NUMBER(4,0) NOT NULL,
ACT_EJE_FECHA_INI DATE NOT NULL,
ACT_EJE_FECHA_FIN DATE NOT NULL,
ACT_EJE_IMP_PRESUPUESTO NUMBER(16,2) NOT NULL,
ACT_EJE_IMP_DISPUESTO NUMBER(16,2) NOT NULL,
ACT_EJE_FECHA_ASIGNACION DATE NOT NULL,
VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_EJERCICIO IS ''Año del ejercicio del presupuesto   (YYYY)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_FECHA_INI IS ''Fecha inicio del ejercicio del presupuesto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_FECHA_FIN IS ''Fecha fin del ejercicio del presupuesto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_IMP_PRESUPUESTO IS ''Importe del presupuesto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_IMP_DISPUESTO IS ''Importe dispuesto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_PRESUPUESTO_ACTIVO.ACT_EJE_FECHA_ASIGNACION IS ''Fecha asignación del presupuesto al ejercicio''';

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
