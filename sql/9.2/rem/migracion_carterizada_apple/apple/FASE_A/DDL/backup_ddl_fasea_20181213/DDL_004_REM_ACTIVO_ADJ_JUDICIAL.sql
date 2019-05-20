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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ADJ_JUDICIAL';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO               NUMBER(16,0)                                         NOT NULL,
ENTIDAD_EJECUTANTE                      VARCHAR2(20 CHAR),
ESTADO_ADJUDICACION                     VARCHAR2(20 CHAR),
AJD_FECHA_ADJUDICACION                  DATE,
AJD_FECHA_DECRETO_FIRME                 DATE,
AJD_FECHA_REA_POSESION                  DATE,
AJD_IMPORTE_ADJUDICACION                NUMBER(16,2),
JUZGADO                                 VARCHAR2(50 CHAR),
PLAZA_JUZGADO                           VARCHAR2(30 CHAR),
AJD_NUM_AUTO                            VARCHAR2(50 CHAR),
AJD_PROCURADOR                          VARCHAR2(100 CHAR),
AJD_LETRADO                             VARCHAR2(100 CHAR),
AJD_ID_ASUNTO                           NUMBER(16,0),
AJD_EXP_DEF_TESTI                       NUMBER(4,0),
BIE_ADJ_F_DECRETO_N_FIRME               DATE,
BIE_ADJ_F_INSCRIP_TITULO                DATE,
BIE_ADJ_F_ENVIO_ADICION                 DATE,
BIE_ADJ_F_SOL_POSESION                  DATE,
BIE_ADJ_F_SEN_POSESION                  DATE,
BIE_ADJ_F_REA_POSESION                  DATE,
BIE_ADJ_F_SOL_LANZAMIENTO               DATE,
BIE_ADJ_F_SEN_LANZAMIENTO               DATE,
BIE_ADJ_F_REA_LANZAMIENTO               DATE,
BIE_ADJ_F_SOL_MORATORIA                 DATE,
BIE_ADJ_F_RES_MORATORIA                 DATE,
BIE_ADJ_F_CONTRATO_ARREN                DATE,
BIE_ADJ_F_CAMBIO_CERRADURA              DATE,
BIE_ADJ_F_ENVIO_LLAVES                  DATE,
BIE_ADJ_F_RECEP_DEPOSITARIO             DATE,
BIE_ADJ_F_ENVIO_DEPOSITARIO             DATE,
BIE_ADJ_OCUPADO                         NUMBER(1,0),
BIE_ADJ_POSIBLE_POSESION                NUMBER(1,0),
BIE_ADJ_OCUPANTES_DILIGENCIA            NUMBER(1,0),
BIE_ADJ_LANZAMIENTO_NECES               NUMBER(1,0),
BIE_ADJ_ENTREGA_VOLUNTARIA              NUMBER(1,0),
BIE_ADJ_NECESARIA_FUERA_PUB             NUMBER(1,0),
BIE_ADJ_EXISTE_INQUILINO                NUMBER(1,0),
BIE_ADJ_LLAVES_NECESARIAS               NUMBER(1,0),
BIE_ADJ_GESTORIA_ADJUDIC                NUMBER(16,0),
BIE_ADJ_NOMBRE_ARRENDATARIO             VARCHAR2(50 CHAR),
BIE_ADJ_NOMBRE_DEPOSITARIO              VARCHAR2(50 CHAR),
BIE_ADJ_NOMBRE_DEPOSITARIO_F            VARCHAR2(50 CHAR),
DD_EAD_ID                               VARCHAR2(20 CHAR),
DD_SIT_ID                               VARCHAR2(20 CHAR),
DD_FAV_ID                               VARCHAR2(20 CHAR),
BIE_ADJ_F_RECEP_DEPOSITARIO_F           DATE,
DD_TFO_ID                               VARCHAR2(20 CHAR),
BIE_ADJ_REQ_SUBSANACION                 NUMBER(1,0),
BIE_ADJ_NOTIF_DEMANDADOS                NUMBER(1,0),
BIE_ADJ_F_REV_PROP_CAN                  DATE,
BIE_ADJ_F_PROP_CAN                      DATE,
BIE_ADJ_F_REV_CARGAS                    DATE,
BIE_ADJ_F_PRES_INS_ECO                  DATE,
BIE_ADJ_F_PRES_INS                      DATE,
BIE_ADJ_F_CAN_REG_ECO                   DATE,
BIE_ADJ_F_CAN_REG                       DATE,
BIE_ADJ_F_CAN_ECO                       DATE,
BIE_ADJ_F_LIQUIDACION                   DATE,
BIE_ADJ_F_RECEPCION                     DATE,
BIE_ADJ_F_CANCELACION                   DATE,
BIE_ADJ_IMPORTE_ADJUDICACION            NUMBER(16,2),
BIE_ADJ_CESION_REMATE                   NUMBER(1,0),
BIE_ADJ_CESION_REMATE_IMP               NUMBER(16,2),
DD_DAD_ID                               VARCHAR2(20 CHAR),
BIE_ADJ_F_CONTABILIDAD                  DATE,
BIE_ADJ_POSTORES                        NUMBER(1,0)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ENTIDAD_EJECUTANTE IS ''Entidad ejecutante de la hipoteca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ESTADO_ADJUDICACION IS ''Estado de adjudicación el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_FECHA_ADJUDICACION IS ''Fecha de adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_FECHA_DECRETO_FIRME IS ''Fecha firmeza auto adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_FECHA_REA_POSESION IS ''Fecha toma de realización posesión del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_IMPORTE_ADJUDICACION IS ''Importe de adjudicación del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.JUZGADO IS ''Juzgado que adjudicó el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PLAZA_JUZGADO IS ''Plaza del juzgado que adjudicó el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_NUM_AUTO IS ''Número de auto en el que se adjudicó el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_PROCURADOR IS ''Nombre del procurador que intervino en el proceso de adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_LETRADO IS ''Nombre del letrado que intervino en el proceso de adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_ID_ASUNTO IS ''Código identificador único del asunto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.AJD_EXP_DEF_TESTI IS ''Expedientes con Defectos Testimonio''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_DECRETO_N_FIRME IS ''Fecha auto adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_INSCRIP_TITULO IS ''Fecha de inscripción en el registro.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_ENVIO_ADICION IS ''Fecha envío auto para adición.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_REA_POSESION IS ''Fecha toma de posesión del activo voluntaria.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_REA_LANZAMIENTO IS ''Fecha toma de posesión inicial del activo forzada.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_CONTRATO_ARREN IS ''Fecha título posesorio de arrendamiento del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_OCUPADO IS ''Indica si el activo esta ocupado o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_EXISTE_INQUILINO IS ''Indica si el activo esta ocupado con titulo arrendamiento o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_LLAVES_NECESARIAS IS ''Indica si son necesarias llaves para acceder al activo o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_NOMBRE_ARRENDATARIO IS ''Indica el nombre del arrendatario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_SIT_ID IS ''Situación titulo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_RECEP_DEPOSITARIO_F IS ''Fecha recepción de las llaves del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_TFO_ID IS ''Tipo de fondo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_CAN_REG_ECO IS ''Fecha de cancelación económica de una carga registral.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_CAN_REG IS ''Fecha de cancelación registral.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_F_CAN_ECO IS ''Fecha de cancelación económica de una carga economica.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BIE_ADJ_IMPORTE_ADJUDICACION IS ''Importe de adjudicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_DAD_ID IS ''Documento de adjudicación.''';


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
