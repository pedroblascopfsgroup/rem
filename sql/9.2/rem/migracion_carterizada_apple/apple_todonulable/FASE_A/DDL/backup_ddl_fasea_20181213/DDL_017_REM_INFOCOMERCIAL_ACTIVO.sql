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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_AIA_INFCOMERCIAL_ACT';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
ACT_NUMERO_ACTIVO                       NUMBER(16,0)                                         NOT NULL,
UBICACION_ACTIVO                        VARCHAR2(20 CHAR)                                          NOT NULL,
ESTADO_CONSTRUCCION                     VARCHAR2(20 CHAR),
ESTADO_CONSERVACION                     VARCHAR2(20 CHAR),
ICO_DESCRIPCION                         VARCHAR2(512 CHAR),
TIPO_INFO_COMERCIAL                     VARCHAR2(20 CHAR),
ICO_ANO_CONSTRUCCION                    NUMBER(8,0),
ICO_ANO_REHABILITACION                  NUMBER(8,0),
ICO_APTO_PUBLICIDAD                     NUMBER(1,0),
ICO_ACTIVOS_VINC                        VARCHAR2(250 CHAR),
ICO_FECHA_EMISION_INFORME               DATE,
ICO_FECHA_ULTIMA_VISITA                 DATE,
ICO_FECHA_ACEPTACION                    DATE ,
ICO_FECHA_RECHAZO                       DATE ,
PVE_CODIGO                              VARCHAR2(50 CHAR),
ICO_CONDICIONES_LEGALES                 VARCHAR2(3000 CHAR),
ESTADO_CONSERVACION_EDIFICIO            VARCHAR2(20 CHAR),
TIPO_FACHADA_EDIFICIO                   VARCHAR2(20 CHAR),
EDI_ANO_REHABILITACION                  NUMBER(8,0),
EDI_NUM_PLANTAS                         NUMBER(8,0),
EDI_ASCENSOR                            NUMBER(1,0),
EDI_NUM_ASCENSORES                      NUMBER(8,0),
EDI_REFORMA_FACHADA                     NUMBER(1,0),
EDI_REFORMA_ESCALERA                    NUMBER(1,0),
EDI_REFORMA_PORTAL                      NUMBER(1,0),
EDI_REFORMA_ASCENSOR                    NUMBER(1,0),
EDI_REFORMA_CUBIERTA                    NUMBER(1,0),
EDI_REFORMA_OTRA_ZONA                   NUMBER(1,0),
EDI_REFORMA_OTRO                        NUMBER(1,0),
EDI_REFORMA_OTRO_DESC                   VARCHAR2(250 CHAR),
EDI_DESCRIPCION                         VARCHAR2(3000 CHAR),
EDI_ENTORNO_INFRAESTRUCTURA             VARCHAR2(1024 CHAR),
EDI_ENTORNO_COMUNICACION                VARCHAR2(1024 CHAR),
TIPO_VIVIENDA                           VARCHAR2(20 CHAR),
TIPO_ORIENTACION                        VARCHAR2(20 CHAR),
TIPO_RENTA                              VARCHAR2(20 CHAR),
VIV_ULTIMA_PLANTA                       NUMBER(1,0),
VIV_NUM_PLANTAS_INTERIOR                NUMBER(8,0),
VIV_REFORMA_CARP_INT                    NUMBER(1,0),
VIV_REFORMA_CARP_EXT                    NUMBER(1,0),
VIV_REFORMA_COCINA                      NUMBER(1,0),
VIV_REFORMA_BANYO                       NUMBER(1,0),
VIV_REFORMA_SUELO                       NUMBER(1,0),
VIV_REFORMA_PINTURA                     NUMBER(1,0),
VIV_REFORMA_INTEGRAL                    NUMBER(1,0),
VIV_REFORMA_OTRO                        NUMBER(1,0),
VIV_REFORMA_OTRO_DESC                   VARCHAR2(250 CHAR),
VIV_REFORMA_PRESUPUESTO                 NUMBER(16,2),
VIV_DISTRIBUCION_TXT                    VARCHAR2(1500 CHAR),
LCO_MTS_FACHADA_PPAL                    NUMBER(16,2),
LCO_MTS_FACHADA_LAT                     NUMBER(16,2),
LCO_MTS_LUZ_LIBRE                       NUMBER(16,2),
LCO_MTS_ALTURA_LIBRE                    NUMBER(16,2),
LCO_MTS_LINEALES_PROF                   NUMBER(16,2),
LCO_DIAFANO                             NUMBER(1,0),
LCO_USO_IDONEO                          VARCHAR2(250 CHAR),
LCO_USO_ANTERIOR                        VARCHAR2(250 CHAR),
LCO_OBSERVACIONES                       VARCHAR2(512 CHAR),
APR_DESTINO_COCHE                       NUMBER(1,0),
APR_DESTINO_MOTO                        NUMBER(1,0),
APR_DESTINO_DOBLE                       NUMBER(1,0),
DD_TUA_ID                               VARCHAR2(20 CHAR),
DD_TCA_ID                               VARCHAR2(20 CHAR),
APR_ANCHURA                             NUMBER(16,2),
APR_PROFUNDIDAD                         NUMBER(16,2),
APR_FORMA_IRREGULAR                     NUMBER(16,2),
ICO_FECHA_RECEPCION_LLAVES              NUMBER(8,0),
ICO_JUSTI_IMPORTE_VENTA          	VARCHAR2(3000 CHAR),
ICO_JUSTI_IMPORTE_ALQUILER       	VARCHAR2(3000 CHAR),
ICO_ANO_REHAB_EDIFICIO         		NUMBER(8,0),
ICO_DISTRITO                            VARCHAR2(20 CHAR),
ICO_DERRAMACP_ORIENTATIVA               NUMBER(16,2),
ICO_FECHA_ESTIMACION_VENTA              DATE,
ICO_FECHA_ESTIMACION_RENTA              DATE,
ICO_INFO_DESCRIPCION                    VARCHAR2(500 CHAR),
ICO_INFO_DISTRIBUCION_INTERIOR          VARCHAR2(500 CHAR),
DD_DIS_ID                               VARCHAR2(20 CHAR),
ICO_POSIBLE_HACER_INF                   NUMBER(1,0),
ICO_FECHA_ENVIO_LLAVES_API              DATE,
ICO_RECIBIO_IMPORTE_ADM                 NUMBER(16,2),
ICO_IBI_IMPORTE_ADM                     NUMBER(16,2),
ICO_DERRAMA_IMPORTE_ADM                 NUMBER(16,2),
ICO_DET_DERRAMA_IMPORTE_ADM             VARCHAR2(500 CHAR),
DD_TVP_ID                               VARCHAR2(20 CHAR),
ICO_VALOR_MAX_VPO                       NUMBER(16,2),
ICO_PRESIDENTE_NOMBRE                   VARCHAR2(100 CHAR),
ICO_PRESIDENTE_TELF                     VARCHAR2(20 CHAR),
ICO_ADMINISTRADOR_NOMBRE                VARCHAR2(100 CHAR),
ICO_ADMINISTRADOR_TELF                  VARCHAR2(20 CHAR),
ICO_EXIS_COM_PROP                       NUMBER(1,0),
EDI_DIVISIBLE                           NUMBER(1,0),
EDI_DESC_PLANTAS                        VARCHAR2(150 CHAR),
EDI_OTRAS_CARACTERISTICAS               VARCHAR2(3000 CHAR),
LCO_NUMERO_ESTANCIAS                    NUMBER(16,0),
    LCO_NUMERO_BANYOS                       NUMBER(16,0),
    LCO_NUMERO_ASEOS                        NUMBER(16,0),
    LCO_SALIDA_HUMOS                        NUMBER(1,0),
    LCO_SALIDA_EMERGENCIA                   NUMBER(1,0),
    LCO_ACCESO_MINUSVALIDOS                 NUMBER(1,0),
    LCO_OTROS_OTRAS_CARACT                  VARCHAR2(150 CHAR),
    DD_TPV_ID                               VARCHAR2(20 CHAR),
    APR_ALTURA                              NUMBER(16,2),
    DD_SPG_ID                               VARCHAR2(20 CHAR),
    APR_LICENCIA                            NUMBER(1,0),
    APR_SERVIDUMBRE                         NUMBER(1,0),
    APR_ASCENSOR_MONTACARGA                 NUMBER(1,0),
    APR_COLUMNAS                            NUMBER(1,0),
    APR_SEGURIDAD                           NUMBER(1,0),
 VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.UBICACION_ACTIVO IS ''Tipo de ubicación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ESTADO_CONSTRUCCION IS ''Estado de construcción del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ESTADO_CONSERVACION IS ''Estado de conservación del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_DESCRIPCION IS ''Descripción comercial del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TIPO_INFO_COMERCIAL IS ''Tipo Información Comercial''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ANO_CONSTRUCCION IS ''Año de construcción del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ANO_REHABILITACION IS ''Año de rehabilitación del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_APTO_PUBLICIDAD IS ''Indicador de si es apto para valla publicitaria o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ACTIVOS_VINC IS ''Descripción de los números de activos vinculados al activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_EMISION_INFORME IS ''Fecha emisión del informe comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_ULTIMA_VISITA IS ''Fecha última visita al activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_ACEPTACION IS ''Fecha aceptación del informe del mediador.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_RECHAZO IS ''Fecha rechazo del informe del mediador''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PVE_CODIGO IS ''Código mediador (proveedor de tipo mediador) único.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_CONDICIONES_LEGALES IS ''Descipción de las condiciones legales del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ESTADO_CONSERVACION_EDIFICIO IS ''Estado de conservación del edificio del activo. (Código según Dic. Datos).''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TIPO_FACHADA_EDIFICIO IS ''Tipo de fachada del edificio del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_ANO_REHABILITACION IS ''Año de rehabilitación del edificio del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_NUM_PLANTAS IS ''Número de plantas del edificio del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_ASCENSOR IS ''Indicador de si el edificio tiene ascensor o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_NUM_ASCENSORES IS ''Número de ascensores del edificio del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_FACHADA IS ''Indicador de si el edificio requiere reforma en la fachada o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_ESCALERA IS ''Indicador de si el edificio requiere reforma en la escalera o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_PORTAL IS ''Indicador de si el edificio requiere reforma en el portal o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_ASCENSOR IS ''Indicador de si el edificio requiere reforma del ascensor o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_CUBIERTA IS ''Indicador de si el edificio requiere reforma en la cubierta o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_OTRA_ZONA IS ''Indicador de si el edificio requiere reforma en otras zonas comunes o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_OTRO IS ''Indicador de si el edificio requiere otro tipo de reforma o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_REFORMA_OTRO_DESC IS ''Descripción de otro tipo de reforma que requiera el edificio del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_DESCRIPCION IS ''Descripción del edificio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_ENTORNO_INFRAESTRUCTURA IS ''Descripción del entorno de infraestructuras''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_ENTORNO_COMUNICACION IS ''Descripción del entorno de comunicación''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TIPO_VIVIENDA IS ''Catalogación del tipo de vivienda del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TIPO_ORIENTACION IS ''Catalogación del tipo de orientación del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.TIPO_RENTA IS ''Catalogación del tipo de renta del activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_ULTIMA_PLANTA IS ''Indicador de si la vivienda está en la última planta o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_NUM_PLANTAS_INTERIOR IS ''Número de plantas interiores de la vivienda.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_CARP_INT IS ''Indicador de si la vivienda requiere reforma de carpintería interior o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_CARP_EXT IS ''Indicador de si la vivienda requiere reforma de carpintería exterior o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_COCINA IS ''Indicador de si la vivienda requiere reforma de la cocina o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_BANYO IS ''Indicador de si la vivienda requiere reforma de la cocina o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_SUELO IS ''Indicador de si la vivienda requiere reforma del suelo o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_PINTURA IS ''Indicador de si la vivienda requiere reforma de pintura o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_INTEGRAL IS ''Indicador de si la vivienda requiere reforma integral o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_OTRO IS ''Indicador de si la vivienda requiere otro tipo de reforma o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_OTRO_DESC IS ''Descripción de otro tipo de reforma que requiera el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_REFORMA_PRESUPUESTO IS ''Presupuesto total estimado de las reformas de la vivienda.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.VIV_DISTRIBUCION_TXT IS ''Descripción para la web de la distribución interior de la vivienda.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_MTS_FACHADA_PPAL IS ''Longitud en metros de la fachada a calle principal del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_MTS_FACHADA_LAT IS ''Longitud en metros de la fachada a calles laterales del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_MTS_LUZ_LIBRE IS ''Longitud en metros de la luz libre entre pilares del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_MTS_ALTURA_LIBRE IS ''Longitud en metros de altura libre del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_MTS_LINEALES_PROF IS ''Longitud en metros de profundidad del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_DIAFANO IS ''Indicador de si el local comercial es diáfano o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_USO_IDONEO IS ''Descripción del uso idóneo del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_USO_ANTERIOR IS ''Descripción del uso anterior del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_OBSERVACIONES IS ''Descripción del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_DESTINO_COCHE IS ''Indicador de si se trata de una plaza de aparcamiento para coche o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_DESTINO_MOTO IS ''Indicador de si se trata de una plaza de aparcamiento para motos o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_DESTINO_DOBLE IS ''Indicador de si se trata de una plaza de aparcamiento doble o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_TUA_ID IS ''Catalogación del tipo de ubicación del aparcamiento''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_TCA_ID IS ''Catalogación del tipo de calidad del aparcamiento''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_ANCHURA IS ''Longitud en metros de la anchura del aparcamiento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_PROFUNDIDAD IS ''Longitud en metros de la profundidad del aparcamiento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_FORMA_IRREGULAR IS ''Indicador de si el aparcamiento tiene forma irregular o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_RECEPCION_LLAVES IS ''Fecha recepción llaves por el API''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_JUSTI_IMPORTE_VENTA IS ''Texto justificante importe venta''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_JUSTI_IMPORTE_ALQUILER IS ''Texto justificante importe renta''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ANO_REHAB_EDIFICIO IS ''Año rehabilitación edificio donde está el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_DISTRITO IS ''Distrito donde está ubicado el activo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_DERRAMACP_ORIENTATIVA IS ''Derrama orientativa de la comunidad de propietarios''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_ESTIMACION_VENTA IS ''Fecha de estimación para la venta.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_ESTIMACION_RENTA IS ''Fecha de estimación para el alquiler.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_INFO_DESCRIPCION IS ''Descripción del informe del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_INFO_DISTRIBUCION_INTERIOR IS ''Distribución interior del informe del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_DIS_ID IS ''Distrito del Activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_POSIBLE_HACER_INF IS ''Es posible hacer el informe.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_FECHA_ENVIO_LLAVES_API IS ''Fecha recepción de envío llaves a Api.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_RECIBIO_IMPORTE_ADM IS ''Importe recibido datos administración.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_IBI_IMPORTE_ADM IS ''Importe Ibi datos administración.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_DERRAMA_IMPORTE_ADM IS ''Importe derrama datos administración.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_DET_DERRAMA_IMPORTE_ADM IS ''Detalle derrama datos administración.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_TVP_ID IS ''Tipo de vpo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_VALOR_MAX_VPO IS ''Valor máximo vpo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_PRESIDENTE_NOMBRE IS ''Nombre del presidente comunidad propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_PRESIDENTE_TELF IS ''Teléfono del presidente comunidad propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ADMINISTRADOR_NOMBRE IS ''Nombre del administrador comunidad propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_ADMINISTRADOR_TELF IS ''Teléfono del administrador comunidad propietarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ICO_EXIS_COM_PROP IS ''Indica si existe la comunidad de propietarios''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_DIVISIBLE IS ''Indica si es divisible.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_DESC_PLANTAS IS ''Descripción de las plantas del edificio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.EDI_OTRAS_CARACTERISTICAS IS ''Descripción otras características del edificio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_NUMERO_ESTANCIAS IS ''Numero de estancias del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_NUMERO_BANYOS IS ''Numero de banyos del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_NUMERO_ASEOS IS ''Numero de aseos del local comercial.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_SALIDA_HUMOS IS ''Indicador de si tiene salida de humos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_SALIDA_EMERGENCIA IS ''Indicador de si tiene salida de emergencia.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_ACCESO_MINUSVALIDOS IS ''Indicador de si tiene acceso para minusvalidos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.LCO_OTROS_OTRAS_CARACT IS ''Descripcion otras características.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_TPV_ID IS ''Catalogación del tipo vario.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_ALTURA IS ''Longitud en metros de la altura del aparcamiento.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.DD_SPG_ID IS ''Tipo de uso.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_LICENCIA IS ''Indicador de si tiene licencia''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_SERVIDUMBRE IS ''Indicador de si tiene servidumbre.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_ASCENSOR_MONTACARGA IS ''Indicador de si tiene ascensor o montacarga.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_COLUMNAS IS ''Indicador de si tiene columnas .''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.APR_SEGURIDAD IS ''Indicador de si tiene seguridad.''';

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
