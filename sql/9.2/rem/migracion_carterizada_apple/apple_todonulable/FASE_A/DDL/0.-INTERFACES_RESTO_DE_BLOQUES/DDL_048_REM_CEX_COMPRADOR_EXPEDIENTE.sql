--/*
--######################################### 
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-791
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_CEX_COMPRADOR_EXPEDIENTE'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_CEX_COMPRADOR_EXPEDIENTE';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
        CEX_COD_OFERTA                                  NUMBER(16,0)                NOT NULL,     
        CEX_COD_COMPRADOR                               VARCHAR2(20 CHAR)			NOT NULL,     
        CEX_COD_ESTADO_CIVIL                            VARCHAR2(20 CHAR)			NOT NULL,
        CEX_COD_REGIMEN_MATRIMONIAL                     VARCHAR2(20 CHAR)			NOT NULL,
        CEX_DOCUMENTO_CONYUGE                           VARCHAR2(50 CHAR)			NOT NULL,
        CEX_IND_ANTIGUO_DEUDOR                          NUMBER(1,0),
        CEX_COD_USO_ACTIVO                              VARCHAR2(20 CHAR),
        CEX_IMPORTE_PROPORCIONAL_OFR            		NUMBER(16,2)				NOT NULL,
        CEX_IMPORTE_FINANCIADO                          NUMBER(16,2)				NOT NULL,
        CEX_RESPONSABLE_TRAMITACION                     VARCHAR2(256 CHAR),
        CEX_IND_PBC                                     NUMBER(1,0)					NOT NULL,
        CEX_PORCENTAJE_COMPRA                           NUMBER(16,2)				NOT NULL,
        CEX_IND_TITULAR_RESERVA                         NUMBER(1,0)					NOT NULL,
        CEX_IND_TITULAR_CONTRATACION            		NUMBER(1,0)					NOT NULL,
        CEX_NOMBRE_REPRESENTANTE                        VARCHAR2(256 CHAR)			NOT NULL,
        CEX_APELLIDOS_REPRESENTANTE                     VARCHAR2(256 CHAR)			NOT NULL,
        CEX_COD_TIPO_DOC_RTE                            VARCHAR2(20 CHAR)			NOT NULL,
        CEX_DOCUMENTO_RTE                               VARCHAR2(50 CHAR)			NOT NULL,
        CEX_TELEFONO1_RTE                               VARCHAR2(50 CHAR),
        CEX_TELEFONO2_RTE                               VARCHAR2(50 CHAR),
        CEX_EMAIL_RTE                                   VARCHAR2(50 CHAR),
        CEX_COD_TIPO_VIA_RTE                            VARCHAR2(20 CHAR)			NOT NULL,
        CEX_DIRECCION_RTE                               VARCHAR2(256 CHAR)			NOT NULL,
        CEX_COD_LOCALIDAD_RTE                           VARCHAR2(20 CHAR)			NOT NULL,
        CEX_CODIGO_POSTAL_RTE                           VARCHAR2(5 CHAR)			NOT NULL,
        CEX_COD_UNIDADPOBLACIONAL_RTE           		VARCHAR2(20 CHAR)			NOT NULL,
        CEX_COD_PROVINCIA_RTE                           VARCHAR2(20 CHAR)			NOT NULL,
        CEX_FECHA_PETICION                              DATE,
        CEX_FECHA_RESOLUCION                            DATE,
        DD_PAI_ID                               		NUMBER(3,0)                 NOT NULL,
        DD_PAI_ID_RTE                           		NUMBER(3,0)                 NOT NULL      
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_OFERTA IS ''Código identificador único de la Oferta Aceptada''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_COMPRADOR IS ''Código identificador único del Comprador''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_ESTADO_CIVIL IS ''Código del Estado Civil (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_REGIMEN_MATRIMONIAL IS ''Código del Régimen Matrimonial (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_DOCUMENTO_CONYUGE IS ''Documento del Conyuge''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IND_ANTIGUO_DEUDOR IS ''Indicador de si ha sido antiguo Deudor''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_USO_ACTIVO IS ''Código del Uso del Activo (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IMPORTE_PROPORCIONAL_OFR IS ''Importe Proporcional de la Oferta''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IMPORTE_FINANCIADO IS ''Importe Financiado de la Oferta''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_RESPONSABLE_TRAMITACION IS ''Nombre y Apellidos del Responsable de la Tramitación''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IND_PBC IS ''Indicador de si el comprador ha pasado PBC''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_PORCENTAJE_COMPRA IS ''Porcentaje de la Compra''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IND_TITULAR_RESERVA IS ''Indicador de si es el Titular de la Reserva''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_IND_TITULAR_CONTRATACION IS ''Indicador de si es el Titular de la Contratación''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_NOMBRE_REPRESENTANTE IS ''Nombre del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_APELLIDOS_REPRESENTANTE IS ''Apellidos del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_TIPO_DOC_RTE IS ''Código del Tipo de Documento del Representante (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_DOCUMENTO_RTE IS ''Documento del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_TELEFONO1_RTE IS ''Teléfono 1 del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_TELEFONO2_RTE IS ''Teléfono 2 del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_EMAIL_RTE IS ''Email del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_TIPO_VIA_RTE IS ''Código del Tipo de Via (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_DIRECCION_RTE IS ''Dirección Postal del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_LOCALIDAD_RTE IS ''Código del Municipio de la Dirección del Representante (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_CODIGO_POSTAL_RTE IS ''Código Postal de la Dirección del Representante''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_UNIDADPOBLACIONAL_RTE IS ''Código de la Unidad Poblacional de la Dirección del Representante (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_COD_PROVINCIA_RTE IS ''Código de la Provincia de la Dirección del Representante (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_FECHA_PETICION IS ''Fecha de Petición''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.CEX_FECHA_RESOLUCION IS ''Fecha de Resolución''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.DD_PAI_ID IS ''Pais.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_CEX_COMPRADOR_EXPEDIENTE.DD_PAI_ID_RTE IS ''Pais del representante.''';

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
