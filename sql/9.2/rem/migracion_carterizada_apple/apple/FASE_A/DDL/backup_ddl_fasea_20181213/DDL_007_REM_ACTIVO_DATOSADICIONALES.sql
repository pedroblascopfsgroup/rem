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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ADA_DATOS_ADI';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER=''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;
			
EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
    ACT_NUMERO_ACTIVO             NUMBER(16,0)                     		NOT NULL,
    TIPO_VPO                      VARCHAR2(20 CHAR),
    ADM_SUELO_VPO                 NUMBER(1,0),
    ADM_PROMOCION_VPO             NUMBER(1,0),
    ADM_NUM_EXPEDIENTE            VARCHAR2(50 CHAR),
    ADM_FECHA_CALIFICACION        DATE,
    ADM_OBLIGATORIO_SOL_DEV_AYUDA NUMBER(1,0),
    ADM_OBLIG_AUT_ADM_VENTA       NUMBER(1,0),
    ADM_DESCALIFICADO             NUMBER(1,0),
    ADM_MAX_PRECIO_VENTA          NUMBER(16,2),
    ADM_OBSERVACIONES             VARCHAR2(2000 CHAR),
    ADM_SUJETO_A_EXPEDIENTE       NUMBER(1,0),
    ADM_ORGANISMO_EXPROPIANTE     VARCHAR2(100 CHAR),
    ADM_FECHA_INI_EXPEDIENTE      DATE,
    ADM_REF_EXPDTE_ADMIN          VARCHAR2(50 CHAR),
    ADM_REF_EXPDTE_INTERNO        VARCHAR2(50 CHAR),
    ADM_OBS_EXPROPIACION          VARCHAR2(512 CHAR),
    SPS_FECHA_REVISION_ESTADO     DATE,
    SPS_FECHA_TOMA_POSESION       DATE,
    SPS_OCUPADO                   NUMBER(1,0),
    SPS_CON_TITULO                NUMBER(1,0),
    SPS_ACC_TAPIADO               NUMBER(1,0),
    SPS_FECHA_ACC_TAPIADO         DATE,
    SPS_ACC_ANTIOCUPA             NUMBER(1,0),
    SPS_FECHA_ACC_ANTIOCUPA       DATE,
    SPS_RIESGO_OCUPACION          NUMBER(1,0),
    TIPO_TITULO_POSESORIO         VARCHAR2(20 CHAR),
    SPS_FECHA_TITULO              DATE,
    SPS_FECHA_VENC_TITULO         DATE,
    SPS_RENTA_MENSUAL             NUMBER(16,2),
    SPS_FECHA_SOL_DESAHUCIO       DATE,
    SPS_FECHA_LANZAMIENTO         DATE,
    SPS_FECHA_LANZAMIENTO_EFECTIVO DATE,
    SPS_OTRO                      VARCHAR2(255 CHAR),
    SPS_ESTADO_PORTAL_EXTERNO     NUMBER(1,0),
    SPS_NUMERO_CONTRATO_ALQUILER  NUMBER(16,0),
    SPS_FECHA_RESOLUCION_CONTRATO DATE,
    SPS_LOTE_COMERCIAL            NUMBER(16,0),
    DD_SIJ_ID                     VARCHAR2(20 CHAR),
    SPS_EDITA_FECHA_TOMA_POSESION NUMBER(1,0),
    SPS_DISPONIBILIDAD_JURIDICA   NUMBER(16,0),
    MUNICIPIO_REGISTRO            VARCHAR2(20 CHAR)               		NOT NULL,
    REG_NUM_REGISTRO              VARCHAR2(50 CHAR)                 	NOT NULL,
    REG_TOMO                      VARCHAR2(50 CHAR)                     NOT NULL,
    REG_LIBRO                     VARCHAR2(50 CHAR)                     NOT NULL,
    REG_FOLIO                     VARCHAR2(50 CHAR)                     NOT NULL,
    REG_NUM_FINCA                 VARCHAR2(50 CHAR)                     NOT NULL,
    REG_NUM_DEPARTAMENTO          NUMBER(16,0)                  		NOT NULL,
    REG_IDUFIR                    VARCHAR2(50 CHAR),
    REG_HAN_CAMBIADO              NUMBER(1,0),
    MUNICIPIO_REG_ANTERIOR        VARCHAR2(20 CHAR),
    REG_NUM_ANTERIOR              VARCHAR2(50 CHAR),
    REG_NUM_FINCA_ANTERIOR        VARCHAR2(50 CHAR),
    REG_SUPERFICIE                NUMBER(16,2),
    REG_SUPERFICIE_CONSTRUIDA     NUMBER(16,2),
    REG_SUPERFICIE_UTIL           NUMBER(16,2),
    REG_SUPERFICIE_ELEM_COMUN     NUMBER(16,2),
    REG_SUPERFICIE_PARCELA        NUMBER(16,2),
    REG_SUPERFICIE_BAJO_RASANTE   NUMBER(16,2),
    REG_SUPERFICIE_SOBRE_RASANTE  NUMBER(16,2),
    REG_DIV_HOR_INSCRITO          NUMBER(1,0),
    ESTADO_DIVISION_HORIZONTAL    VARCHAR2(20 CHAR),
    ESTADO_OBRA_NUEVA             VARCHAR2(20 CHAR),
    REG_FECHA_CFO                 DATE,
    BIE_DREG_INSCRIPCION          VARCHAR2(50 CHAR),
    BIE_DREG_MUNICIPIO_LIBRO      VARCHAR2(50 CHAR),
    TIPO_UBICACION                VARCHAR2(20 CHAR),
    TIPO_VIA                      VARCHAR2(20 CHAR),
    LOC_NOMBRE_VIA                VARCHAR2(100 CHAR),
    LOC_NUMERO_DOMICILIO          VARCHAR2(100 CHAR),
    LOC_PORTAL                    VARCHAR2(10 CHAR),
    LOC_BLOQUE                    VARCHAR2(10 CHAR),
    LOC_ESCALERA                  VARCHAR2(10 CHAR),
    LOC_PISO                      VARCHAR2(10 CHAR),
    LOC_PUERTA                    VARCHAR2(10 CHAR),
    LOC_COD_POST                  VARCHAR2(20 CHAR),
    LOC_BARRIO                    VARCHAR2(100 CHAR),
    UNIDAD_INFERIOR_MUNICIPIO     VARCHAR2(20 CHAR),
    MUNICIPIO                     VARCHAR2(20 CHAR),
    PROVINCIA                     VARCHAR2(20 CHAR),
    PAIS                          VARCHAR2(20 CHAR),
    LOC_LONGITUD                  NUMBER(21,15),
    LOC_LATITUD                   NUMBER(21,15),
    LOC_DIST_PLAYA                NUMBER(16,2),
    CPR_COD_COM_PROP_EXTERNO      VARCHAR2(10 CHAR),
    ACT_LLV_NECESARIAS            NUMBER(1,0),
    ACT_LLV_LLAVES_HRE            NUMBER(1,0),
    ACT_LLV_NUM_JUEGOS            NUMBER(8,0),
    ACT_LLV_FECHA_RECEPCION       DATE,
    ACT_IND_CONDICIONADO_OTROS    VARCHAR2(255 CHAR),
 VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  


EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.TIPO_VPO IS ''Tipo de vpo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_SUELO_VPO IS ''Indicador de si el activo puede ser vpo o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_PROMOCION_VPO IS ''Indicador de si el activo puede ser promocionado a vpo o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_NUM_EXPEDIENTE IS ''Número de expediente/vpo/vpt''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_FECHA_CALIFICACION IS ''Fecha de calificación vpo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_OBLIGATORIO_SOL_DEV_AYUDA IS ''Indicador de si el activo requiere que se realice solicitud para la devolución de ayudas o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_OBLIG_AUT_ADM_VENTA IS ''Indicador de si el activo requiere una autorización administrativa para la venta o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_DESCALIFICADO IS ''Indicador de si el activo esta descalificado o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_MAX_PRECIO_VENTA IS ''Precio máximo de venta vpo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ADM_OBSERVACIONES IS ''Observaciones sobre la información administrativa.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_REVISION_ESTADO IS ''Última fecha de revisión del estado posesorio del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_TOMA_POSESION IS ''Fecha de toma de posesión del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_OCUPADO IS ''Indicador de si el activo está ocupado o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_CON_TITULO IS ''Indicador de si el activo dispone de título.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_ACC_TAPIADO IS ''Indicador acceso al activo está tapiado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_ACC_TAPIADO IS ''Fecha acceso al activo está tapiado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_ACC_ANTIOCUPA IS ''Indicador acceso al activo está con puerta antiocupa.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_ACC_ANTIOCUPA IS ''Fecha acceso al activo está con puerta antiocupa.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_RIESGO_OCUPACION IS ''Indicador de si el activo tiene riesgo de ocupación.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.TIPO_TITULO_POSESORIO IS ''Tipo de título posesorio''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_TITULO IS ''Fecha del título posesorio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_VENC_TITULO IS ''Fecha de vencimiento del título posesorio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_RENTA_MENSUAL IS ''Importe de renta mensual del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_SOL_DESAHUCIO IS ''Fecha de solicitud de desahucio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_LANZAMIENTO IS ''Fecha de señalamiento de lanzamiento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_LANZAMIENTO_EFECTIVO IS ''Fecha de lanzamiento efectuado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_OTRO IS ''Texto libre condicionante disponibilidad.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_ESTADO_PORTAL_EXTERNO IS ''Indica el estado de publicación en portales externos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_NUMERO_CONTRATO_ALQUILER IS ''Número de contrato de alquiler''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_FECHA_RESOLUCION_CONTRATO IS ''Fecha de resolución del contrato.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_LOTE_COMERCIAL IS ''Id del lote comercial asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.DD_SIJ_ID IS ''Disponibilidad jurídica''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_EDITA_FECHA_TOMA_POSESION IS ''Indica si el campo Fecha Toma Posesión ha sido editado desde web.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.SPS_DISPONIBILIDAD_JURIDICA IS ''Disponibilidad jurídica''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.MUNICIPIO_REGISTRO IS ''Municipio de registro del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_NUM_REGISTRO IS ''Número de registro del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_TOMO IS ''Número de tomo de registro del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_LIBRO IS ''Número de libro de registro del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_FOLIO IS ''Número de folio de registro del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_NUM_FINCA IS ''Número de finca de registro del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_NUM_DEPARTAMENTO IS ''Número de departamento''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_IDUFIR IS ''Código idufir del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_HAN_CAMBIADO IS ''Indicador de si han cambiado los datos registrales del activo o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.MUNICIPIO_REG_ANTERIOR IS ''Municipio de registro anterior del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_NUM_ANTERIOR IS ''Número de registro anterior del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_NUM_FINCA_ANTERIOR IS ''Número de finca anterior del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE IS ''Superficie del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_CONSTRUIDA IS ''Superficie construida del active.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_UTIL IS ''Superficie útil del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_ELEM_COMUN IS ''Superficie con repercusión de elementos comunes del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_PARCELA IS ''Superficie parcela del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_BAJO_RASANTE IS ''Superficie bajo rasante del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_SUPERFICIE_SOBRE_RASANTE IS ''Superficie sobre rasante del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_DIV_HOR_INSCRITO IS ''Indicador de si el activo está inscrito en división horizontal o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ESTADO_DIVISION_HORIZONTAL IS ''Estado de la división horizontal del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ESTADO_OBRA_NUEVA IS ''Estado de obra nueva del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.REG_FECHA_CFO IS ''Fecha de obtención certificado final de obra.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.TIPO_UBICACION IS ''Tipo de ubicación del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.TIPO_VIA IS ''Tipo de vía del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_NOMBRE_VIA IS ''Nombre descriptivo de la vía en la que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_NUMERO_DOMICILIO IS ''Número de domicilio en el que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_ESCALERA IS ''Escalera en la que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_PISO IS ''Piso en la que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_PUERTA IS ''Puerta en la que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_COD_POST IS ''Código postal en el que se ubica el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.UNIDAD_INFERIOR_MUNICIPIO IS ''Unidad inferior al municipio del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.MUNICIPIO IS ''Municipio en el que se ubica el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.PROVINCIA IS ''Provincia en la que se ubica el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.PAIS IS ''País en la que se ubica el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_LONGITUD IS ''Coordenada de longitud en decimal de la ubicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_LATITUD IS ''Coordenada de latitud en decimal de la ubicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.LOC_DIST_PLAYA IS ''Distancia a la playa (en m)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.CPR_COD_COM_PROP_EXTERNO IS ''Código identificador único de la comunidad de propietarios en EXTERNO''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_LLV_NECESARIAS IS ''Indicador de si son necesarias las llaves o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_LLV_LLAVES_HRE IS ''Indicador de si las llaves están en poder de HRE o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_LLV_NUM_JUEGOS IS ''Número total de juegos que se dispone de la llave.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_LLV_FECHA_RECEPCION IS ''Fecha de recepción de las llaves.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA_1||'.MIG_ADA_DATOS_ADI.ACT_IND_CONDICIONADO_OTROS IS ''Texto condicionado''';

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
