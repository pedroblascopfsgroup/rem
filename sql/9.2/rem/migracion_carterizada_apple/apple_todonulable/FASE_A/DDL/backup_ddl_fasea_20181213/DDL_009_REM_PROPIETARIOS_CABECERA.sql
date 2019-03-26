--/*
--######################################### 
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_ACA_CABECERA'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_APC_PROP_CABECERA';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
		PRO_CODIGO                              NUMBER(16,0)                                            NOT NULL,
		LOCALIDAD_PROPIETARIO                   VARCHAR2(20 CHAR),
		PROVINCIA_PROPIETARIO                   VARCHAR2(20 CHAR),
		TIPO_PERSONA                            VARCHAR2(20 CHAR)                                       NOT NULL,
		PRO_NOMBRE                              VARCHAR2(100 CHAR)                                      NOT NULL,
		PRO_APELLIDO1                           VARCHAR2(100 CHAR),
		PRO_APELLIDO2                           VARCHAR2(100 CHAR),
		TIPO_DOCUMENTO                          VARCHAR2(20 CHAR)                                       NOT NULL,
		PRO_NIF                                 VARCHAR2(20 CHAR)                                       NOT NULL,
		PRO_DIR                                 VARCHAR2(250 CHAR),
		PRO_TELF                                VARCHAR2(20 CHAR),
		PRO_EMAIL                               VARCHAR2(50 CHAR),
		PRO_CP                                  NUMBER(8,0),
		LOCALIDAD_CONTACTO                      VARCHAR2(20 CHAR),
		PROVINCIA_CONTACTO                      VARCHAR2(20 CHAR),
		PRO_CONTACTO_NOM                        VARCHAR2(100 CHAR),
		PRO_CONTACTO_TELF1                      VARCHAR2(20 CHAR),
		PRO_CONTACTO_TELF2                      VARCHAR2(20 CHAR),
		PRO_CONTACTO_EMAIL                      VARCHAR2(50 CHAR),
		PRO_CONTACTO_DIR                        VARCHAR2(250 CHAR),
		PRO_CONTACTO_CP                         NUMBER(8,0),
		PRO_OBSERVACIONES                       VARCHAR2(1000 CHAR),
		PRO_PAGA_EJECUTANTE                     NUMBER(1,0),
		PRO_COD_CARTERA                         VARCHAR2(20 CHAR),
		PRO_SOCIEDAD_PAGADORA                   VARCHAR2(200 CHAR)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CODIGO IS ''Identificador único del propietario''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.LOCALIDAD_PROPIETARIO IS ''Localidad del propietario (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PROVINCIA_PROPIETARIO IS ''Provincia del propietario (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.TIPO_PERSONA IS ''Tipo de propietario. (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_NOMBRE IS ''Nombre del propietario del activo o denominación social''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_APELLIDO1 IS ''Apellido 1 del propietario del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_APELLIDO2 IS ''Apellido 2 del propietario del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.TIPO_DOCUMENTO IS ''Tipo documento . (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_NIF IS ''Número de documento identificativo del propietario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_DIR IS ''Dirección del propietario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_TELF IS ''Teléfono del propietario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_EMAIL IS ''Dirección de correo electrónico del propietario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CP IS ''Código postal del propietario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.LOCALIDAD_CONTACTO IS ''Localidad de la persona de contacto (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PROVINCIA_CONTACTO IS ''Provincia de la persona de contacto (código según dicc. datos)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_NOM IS ''Nombre de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_TELF1 IS ''Teléfono 1 de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_TELF2 IS ''Teléfono 2 de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_EMAIL IS ''Dirección de correo electrónico de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_DIR IS ''Dirección de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_CONTACTO_CP IS ''Código postal de la persona de contacto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_OBSERVACIONES IS ''Observaciones referentes al propietario del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_PAGA_EJECUTANTE IS ''Indicador de si el pagador es el ejecutante.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_COD_CARTERA IS ''Cartera del propietario''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG_APC_PROP_CABECERA.PRO_SOCIEDAD_PAGADORA IS ''''';

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
