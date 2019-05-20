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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_CPC_PROP_CABECERA';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
CPR_COD_COM_PROP_EXTERNO                VARCHAR2(10 CHAR)                             NOT NULL,
CPR_CONSTITUIDA                         NUMBER(1,0),
CPR_NOMBRE                              VARCHAR2(100 CHAR),
CPR_NIF                                 VARCHAR2(20 CHAR),
CPR_DIRECCION                           VARCHAR2(250 CHAR),
CPR_NUM_CUENTA                          VARCHAR2(50 CHAR),
CPR_PRESIDENTE_NOMBRE                   VARCHAR2(100 CHAR),
CPR_PRESIDENTE_TELF                     VARCHAR2(20 CHAR),
CPR_PRESIDENTE_TELF2                    VARCHAR2(20 CHAR),
CPR_PRESIDENTE_EMAIL                    VARCHAR2(100 CHAR),
CPR_PRESIDENTE_DIR                      VARCHAR2(250 CHAR),
CPR_FECHA_INI                           DATE,
CPR_FECHA_FIN                           DATE,
CPR_ADMINISTRADOR_NOMBRE                VARCHAR2(100 CHAR),
CPR_ADMINISTRADOR_TELF                  VARCHAR2(20 CHAR),
CPR_ADMINISTRADOR_TELF2                 VARCHAR2(20 CHAR),
CPR_ADMINISTRADOR_DIR                   VARCHAR2(250 CHAR),
CPR_ADMINISTRADOR_EMAIL                 VARCHAR2(100 CHAR),
CPR_IMPORTEMEDIO                        NUMBER(16,2),
CPR_ESTATUTOS                           NUMBER(1,0),
CPR_LIBRO_EDIFICIO                      NUMBER(1,0),
CPR_CERTIFICADO_ITE                     NUMBER(1,0),
CPR_OBSERVACIONES                       VARCHAR2(512 CHAR),
CPR_FECHA_COMUNICACION                  DATE,
CPR_ENVIO_CARTAS                        NUMBER(1,0),
CPR_NUMERO_CARTAS                       NUMBER(1,0),
CPR_CONTACTO_TELF                       NUMBER(1,0),
CPR_VISITA                              NUMBER(1,0),
CPR_BUROFAX                             NUMBER(1,0),
CPR_NO_CORRESPONDE                      NUMBER(1,0),
CPR_CERRADO_SIN_LOCALIZAR               NUMBER(1,0),
CPR_ENVIO_CARTA_VENTA                   NUMBER(1,0),
CPR_NO_CONSTITUIDA                      NUMBER(1,0),
CPR_SOLICITUD_901                       DATE,
CPR_CATASTRO                            NUMBER(1,0),
CPR_CATASTRO_OBSERVACIONES              VARCHAR2(512 CHAR),
CPR_PLUSVALIA_EXENTO                    NUMBER(1,0),
CPR_AUTOLIQUIDACION                     NUMBER(1,0),
CPR_F_ESCRITO_AYTO                      NUMBER(1,0),
CPR_VENTA_OBSERVACIONES                 VARCHAR2(512 CHAR)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_COD_COM_PROP_EXTERNO IS ''Código identificador único de la comunidad de propietarios en EXTERNO''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CONSTITUIDA IS ''Indicador de si la comunidad de propietarios está constituida o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NOMBRE IS ''Nombre de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NIF IS ''Documento identificativo de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_DIRECCION IS ''Dirección de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NUM_CUENTA IS ''Número de cuenta completo de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PRESIDENTE_NOMBRE IS ''Nombre del presidente de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PRESIDENTE_TELF IS ''Número de teléfono del presidente de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PRESIDENTE_TELF2 IS ''Número de teléfono 2 del presidente de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PRESIDENTE_EMAIL IS ''Email del presidente de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PRESIDENTE_DIR IS ''Dirección del presidente de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_FECHA_INI IS ''Fecha inicio de presidencia de la comunidad de propietarios''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_FECHA_FIN IS ''Fecha fin de presidencia de la comunidad de propietarios''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ADMINISTRADOR_NOMBRE IS ''Nombre del administrador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ADMINISTRADOR_TELF IS ''Número de teléfono del administrador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ADMINISTRADOR_TELF2 IS ''Número de teléfono 2 del administrador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ADMINISTRADOR_DIR IS ''Dirección del administrador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ADMINISTRADOR_EMAIL IS ''Email del administrador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_IMPORTEMEDIO IS ''Importe medio de cuota a aportar a la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ESTATUTOS IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada a los estatutos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_LIBRO_EDIFICIO IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada al libro del edificio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CERTIFICADO_ITE IS ''Indicador de si la comunidad de propietarios dispone o no de la documentación asociada al certificado de Inspección Técnica del Edificio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_OBSERVACIONES IS ''Observaciones sobre la comunidad de propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_FECHA_COMUNICACION IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ENVIO_CARTAS IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NUMERO_CARTAS IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CONTACTO_TELF IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_VISITA IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_BUROFAX IS ''''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NO_CORRESPONDE IS ''No corresponde por tipología''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CERRADO_SIN_LOCALIZAR IS ''Cerrado proceso localización sin resultado positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_ENVIO_CARTA_VENTA IS ''Fecha envío carta comunicando venta a comunidad''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_NO_CONSTITUIDA IS ''No constituida''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_SOLICITUD_901 IS ''Fecha solicitud 901''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CATASTRO IS ''Resultado del catastro (S/N)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_CATASTRO_OBSERVACIONES IS ''Observaciones del catastro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_PLUSVALIA_EXENTO IS ''Plusvalía venta-exento (S/N)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_AUTOLIQUIDACION IS ''Plusvalía venta-autoliquidación (S/N)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_F_ESCRITO_AYTO IS ''Plusvalía venta-f escrito ayuntamiento (S/N)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CPR_VENTA_OBSERVACIONES IS ''Plusvalía venta-observaciones''';


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
