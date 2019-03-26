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
V_TABLA VARCHAR2(40 CHAR) := 'MIG_ACA_CALIDADES_ACTIVO';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
    
END IF;

EXECUTE IMMEDIATE '
CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
(
	ACT_NUMERO_ACTIVO	   				NUMBER(16,0)                NOT NULL,  
	CRI_PTA_ENT_NORMAL					NUMBER(1,0),
	CRI_PTA_ENT_BLINDADA					NUMBER(1,0),
	CRI_PTA_ENT_ACORAZADA					NUMBER(1,0),
	CRI_PTA_PASO_MACIZAS					NUMBER(1,0),
	CRI_PTA_PASO_HUECAS					NUMBER(1,0),
	CRI_PTA_PASO_LACADAS					NUMBER(1,0),
	CRI_ARMARIOS_EMPOTRADOS					NUMBER(1,0),
	NIVEL_ACABADO_INTERIOR					VARCHAR2(20 CHAR),
	CRI_CRP_INT_OTROS			        	VARCHAR2(250 CHAR),
	CRE_VTNAS_HIERRO					NUMBER(1,0),
	CRE_VTNAS_ALU_ANODIZADO					NUMBER(1,0),
	CRE_VTNAS_ALU_LACADO					NUMBER(1,0),
	CRE_VTNAS_PVC						NUMBER(1,0),
	CRE_VTNAS_MADERA					NUMBER(1,0),
	CRE_PERS_PLASTICO					NUMBER(1,0),
	CRE_PERS_ALU						NUMBER(1,0),
	CRE_VTNAS_CORREDERAS					NUMBER(1,0),
	CRE_VTNAS_ABATIBLES					NUMBER(1,0),
	CRE_VTNAS_OSCILOBAT					NUMBER(1,0),
	CRE_DOBLE_CRISTAL					NUMBER(1,0),
	CRE_EST_DOBLE_CRISTAL					NUMBER(1,0),
	CRE_CRP_EXT_OTROS					VARCHAR2(250 CHAR),
	PRV_HUMEDAD_PARED					NUMBER(1,0),
	PRV_HUMEDAD_TECHO					NUMBER(1,0),
	PRV_GRIETA_PARED					NUMBER(1,0),
	PRV_GRIETA_TECHO					NUMBER(1,0),
	PRV_GOTELE						NUMBER(1,0),
	PRV_PLASTICA_LISA					NUMBER(1,0),
	PRV_PAPEL_PINTADO					NUMBER(1,0),
	PRV_PINTURA_LISA_TECHO					NUMBER(1,0),
	PRV_PINTURA_LISA_TECHO_EST				NUMBER(1,0),
	PRV_MOLDURA_ESCAYOLA					NUMBER(1,0),
	PRV_MOLDURA_ESCAYOLA_EST				NUMBER(1,0),
	PRV_PARAMENTOS_OTROS					VARCHAR2(250 CHAR),
 	PRV_PINTURA_GOTELE_TECHO_EST 				NUMBER(1,0),
 	PRV_PINTURA_PAPEL_TECHO_EST 				NUMBER(1,0),
	SOL_TARIMA_FLOTANTE					NUMBER(1,0),
	SOL_PARQUE						NUMBER(1,0),
	SOL_MARMOL						NUMBER(1,0),
	SOL_PLAQUETA						NUMBER(1,0),
	SOL_SOLADO_OTROS					VARCHAR2(250 CHAR),
	INF_OCIO						NUMBER(1,0),
	INF_HOTELES						NUMBER(1,0),
	INF_HOTELES_DESC					VARCHAR2(250 CHAR),
	INF_TEATROS						NUMBER(1,0),
	INF_TEATROS_DESC					VARCHAR2(250 CHAR),
	INF_SALAS_CINE						NUMBER(1,0),
	INF_SALAS_CINE_DESC					VARCHAR2(250 CHAR),
	INF_INST_DEPORT						NUMBER(1,0),
	INF_INST_DEPORT_DESC					VARCHAR2(250 CHAR),
	INF_CENTROS_COMERC					NUMBER(1,0),
	INF_CENTROS_COMERC_DESC					VARCHAR2(250 CHAR),
	INF_OCIO_OTROS						VARCHAR2(250 CHAR),
	INF_CENTROS_EDU						NUMBER(1,0),
	INF_ESCUELAS_INF					NUMBER(1,0),
	INF_ESCUELAS_INF_DESC					VARCHAR2(250 CHAR),
	INF_COLEGIOS						NUMBER(1,0),
	INF_COLEGIOS_DESC					VARCHAR2(250 CHAR),
	INF_INSTITUTOS						NUMBER(1,0),
	INF_INSTITUTOS_DESC					VARCHAR2(250 CHAR),
	INF_UNIVERSIDADES					NUMBER(1,0),
	INF_UNIVERSIDADES_DESC					VARCHAR2(250 CHAR),
	INF_CENTROS_EDU_OTROS					VARCHAR2(250 CHAR),
	INF_CENTROS_SANIT					NUMBER(1,0),
	INF_CENTROS_SALUD					NUMBER(1,0),
	INF_CENTROS_SALUD_DESC					VARCHAR2(250 CHAR),
	INF_CLINICAS						NUMBER(1,0),
	INF_CLINICAS_DESC					VARCHAR2(250 CHAR),
	INF_HOSPITALES						NUMBER(1,0),
	INF_HOSPITALES_DESC					VARCHAR2(250 CHAR),
	INF_CENTROS_SANIT_OTROS					VARCHAR2(250 CHAR),
	INF_PARKING_SUP_SUF					NUMBER(1,0),
	INF_COMUNICACIONES					NUMBER(1,0),
	INF_FACIL_ACCESO					NUMBER(1,0),
	INF_FACIL_ACCESO_DESC					VARCHAR2(250 CHAR),
	INF_LINEAS_BUS						NUMBER(1,0),
	INF_LINEAS_BUS_DESC					VARCHAR2(250 CHAR),
	INF_METRO						NUMBER(1,0),
	INF_METRO_DESC						VARCHAR2(250 CHAR),
	INF_EST_TREN						NUMBER(1,0),
	INF_EST_TREN_DESC					VARCHAR2(250 CHAR),
	INF_COMUNICACIONES_OTRO					VARCHAR2(250 CHAR),
	ZCO_ZONAS_COMUNES					NUMBER(1,0),
	ZCO_JARDINES						NUMBER(1,0),
	ZCO_PISCINA						NUMBER(1,0),
	ZCO_INST_DEP						NUMBER(1,0),
	ZCO_PADEL						NUMBER(1,0),
	ZCO_TENIS						NUMBER(1,0),
	ZCO_PISTA_POLIDEP					NUMBER(1,0),
	ZCO_OTROS						VARCHAR2(250 CHAR),
	ZCO_ZONA_INFANTIL					NUMBER(1,0),	
	ZCO_CONSERJE_VIGILANCIA					NUMBER(1,0),	
	ZCO_GIMNASIO						NUMBER(1,0),	
	ZCO_ZONA_COMUN_OTROS					VARCHAR2(250 CHAR),
	INS_ELECTR						NUMBER(1,0),	
	INS_ELECTR_CON_CONTADOR					NUMBER(1,0),	
	INS_ELECTR_BUEN_ESTADO					NUMBER(1,0),
	INS_ELECTR_DEFECTUOSA_ANTIGUA				NUMBER(1,0),
	INS_AGUA						NUMBER(1,0),
	INS_AGUA_CON_CONTADOR					NUMBER(1,0),
	INS_AGUA_BUEN_ESTADO					NUMBER(1,0),
	INS_AGUA_DEFECTUOSA_ANTIGUA				NUMBER(1,0),
	INS_AGUA_CALIENTE_CENTRAL				NUMBER(1,0),
	INS_AGUA_CALIENTE_GAS_NATURAL				NUMBER(1,0),
	INS_GAS							NUMBER(1,0),
	INS_GAS_CON_CONTADOR					NUMBER(1,0),
	INS_GAS_INST_BUEN_ESTADO				NUMBER(1,0),
	INS_GAS_DEFECTUOSA_ANTIGUA				NUMBER(1,0),
	INS_CALEF						NUMBER(1,0),
	INS_CALEF_CENTRAL					NUMBER(1,0),
	INS_CALEF_GAS_NATURAL					NUMBER(1,0),
	INS_CALEF_RADIADORES_ALU				NUMBER(1,0),
	INS_CALEF_PREINSTALACION				NUMBER(1,0),
	INS_AIRE						NUMBER(1,0),
	INS_AIRE_PREINSTALACION					NUMBER(1,0),
	INS_AIRE_INSTALACION					NUMBER(1,0),
	INS_AIRE_FRIO_CALOR					NUMBER(1,0),
	INS_INST_OTROS						VARCHAR2(250 CHAR),
	BNY_DUCHA_BANYERA					NUMBER(1,0),
	BNY_DUCHA						NUMBER(1,0),
	BNY_BANYERA						NUMBER(1,0),
	BNY_BANYERA_HIDROMASAJE					NUMBER(1,0),
	BNY_COLUMNA_HIDROMASAJE					NUMBER(1,0),
	BNY_ALICATADO_MARMOL					NUMBER(1,0),
	BNY_ALICATADO_GRANITO					NUMBER(1,0),
	BNY_ALICATADO_AZULEJO					NUMBER(1,0),
	BNY_ENCIMERA						NUMBER(1,0),
	BNY_MARMOL						NUMBER(1,0),
	BNY_GRANITO						NUMBER(1,0),
	BNY_OTRO_MATERIAL					NUMBER(1,0),
	BNY_SANITARIOS						NUMBER(1,0),
	BNY_SANITARIOS_EST					NUMBER(1,0),
	BNY_SUELOS						NUMBER(1,0),
	BNY_GRIFO_MONOMANDO					NUMBER(1,0),
	BNY_GRIFO_MONOMANDO_EST					NUMBER(1,0),
	BNY_BANYO_OTROS						VARCHAR2(250 CHAR),
	COC_AMUEBLADA						NUMBER(1,0),
	COC_AMUEBLADA_EST					NUMBER(1,0),
	COC_ENCIMERA						NUMBER(1,0),
	COC_ENCI_GRANITO					NUMBER(1,0),
	COC_ENCI_MARMOL						NUMBER(1,0),
	COC_ENCI_OTRO_MATERIAL					NUMBER(1,0),
	COC_VITRO						NUMBER(1,0),
	COC_LAVADORA						NUMBER(1,0),
	COC_FRIGORIFICO						NUMBER(1,0),
	COC_LAVAVAJILLAS					NUMBER(1,0),
	COC_MICROONDAS						NUMBER(1,0),
	COC_HORNO						NUMBER(1,0),
	COC_SUELOS						NUMBER(1,0),
	COC_AZULEJOS						NUMBER(1,0),
	COC_AZULEJOS_EST					NUMBER(1,0),
	COC_GRIFOS_MONOMANDO					NUMBER(1,0),
	COC_GRIFOS_MONOMANDO_EST				NUMBER(1,0),
	COC_COCINA_OTROS					VARCHAR2(250 CHAR)
, VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
;
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_ENT_NORMAL IS ''Indicador del estado de la puerta de la entrada normal.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_ENT_BLINDADA IS ''Indicador del estado de la puerta de la entrada blindada.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_ENT_ACORAZADA IS ''Indicador del estado de la puerta de la entrada acorazada.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_PASO_MACIZAS IS ''Indicador del estado de las puertas de paso macizas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_PASO_HUECAS IS ''Indicador del estado de las puertas de paso huecas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_PTA_PASO_LACADAS IS ''Indicador del estado de las puertas de paso lacadas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_ARMARIOS_EMPOTRADOS IS ''Indicador si existen armarios empotrados.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.NIVEL_ACABADO_INTERIOR IS ''Nivel de acabado interior''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRI_CRP_INT_OTROS IS ''Descripción de otro tipo de calidad relacionado con la carpintería interior.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_HIERRO IS ''Indicador del estado de las ventanas de hierro.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_ALU_ANODIZADO IS ''Indicador del estado de las ventanas de aluminio anodizado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_ALU_LACADO IS ''Indicador del estado de las ventanas de aluminio lacado en blanco.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_PVC IS ''Indicador del estado de las ventanas de PVC.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_MADERA IS ''Indicador del estado de las ventanas de madera.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_PERS_PLASTICO IS ''Indicador del estado de las persianas de plástico.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_PERS_ALU IS ''Indicador del estado de las persianas de aluminio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_CORREDERAS IS ''Indicador del estado de las ventanas correderas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_ABATIBLES IS ''Indicador del estado de las ventanas abatibles.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_VTNAS_OSCILOBAT IS ''Indicador del estado de las ventanas oscilobatientes.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_DOBLE_CRISTAL IS ''Ventanas de doble acristalamiento o climalit.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_EST_DOBLE_CRISTAL IS ''Indicador del estado de las ventanas de doble acristalamiento o climalit.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.CRE_CRP_EXT_OTROS IS ''Descripción de otro tipo de calidad relacionado con la carpintería exterior.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_HUMEDAD_PARED IS ''Indicador de si el activo tiene humedades en las paredes.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_HUMEDAD_TECHO IS ''Indicador de si el activo tiene humedades en el techo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_GRIETA_PARED IS ''Indicador de si el activo tiene grietas en las paredes.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_GRIETA_TECHO IS ''Indicador de si el activo tiene grietas en el techo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_GOTELE IS ''Indicador del estado de la pintura de tipo gotelet en pared.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PLASTICA_LISA IS ''Indicador del estado de la pintura de tipo plástica liso en pared.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PAPEL_PINTADO IS ''Indicador del estado de la pintura de tipo papel pintado en pared.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PINTURA_LISA_TECHO IS ''Indicador de si el activo dispone de pintura lisa en el techo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PINTURA_LISA_TECHO_EST IS ''Indicador del estado de la pintura lisa en techos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_MOLDURA_ESCAYOLA IS ''Indicador de si el activo dispone moldura de escayola en el techo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_MOLDURA_ESCAYOLA_EST IS ''Indicador del estado de la moldura de escayola.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PARAMENTOS_OTROS IS ''Descripción de otro tipo de calidad relacionado con los paramentos verticales.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PINTURA_GOTELE_TECHO_EST IS ''Indicador del estado de la pintura en techos de gotele.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.PRV_PINTURA_PAPEL_TECHO_EST IS ''Indicador del estado de la pintura en techos de papel pintado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.SOL_TARIMA_FLOTANTE IS ''Indicador del estado del suelo de tarima flotante.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.SOL_PARQUE IS ''Indicador del estado del suelo de parquet.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.SOL_MARMOL IS ''Indicador del estado del suelo de mármol.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.SOL_PLAQUETA IS ''Indicador del estado del suelo de plaqueta.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.SOL_SOLADO_OTROS IS ''Descripción de otro tipo de calidad relacionado con los suelos.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_OCIO IS ''Indicador de si el activo dispone de centros de ocio cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_HOTELES IS ''Indicador de si el activo dispone de hoteles cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_HOTELES_DESC IS ''Descripción de los hoteles que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_TEATROS IS ''Indicador de si el activo dispone de teatros cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_TEATROS_DESC IS ''Descripción de los teatros que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_SALAS_CINE IS ''Indicador de si el activo dispone de salas de cine cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_SALAS_CINE_DESC IS ''Descripción de las salas de cine que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_INST_DEPORT IS ''Indicador de si el activo dispone de instalaciones deportivas cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_INST_DEPORT_DESC IS ''Descripción de las instalaciones deportivas que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_COMERC IS ''Indicador de si el activo dispone de centros comerciales cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_COMERC_DESC IS ''Descripción de los centros comerciales que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_OCIO_OTROS IS ''Descripción de otros centros de ocio cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_EDU IS ''Indicador de si el activo dispone de centros educativos cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_ESCUELAS_INF IS ''Indicador de si el activo dispone de escuelas infantiles cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_ESCUELAS_INF_DESC IS ''Descripción de las escuelas infantiles que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_COLEGIOS IS ''Indicador de si el activo dispone de colegios cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_COLEGIOS_DESC IS ''Descripción de los colegios que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_INSTITUTOS IS ''Indicador de si el activo dispone de institutos cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_INSTITUTOS_DESC IS ''Descripción de los institutos que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_UNIVERSIDADES IS ''Indicador de si el activo dispone de universidades cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_UNIVERSIDADES_DESC IS ''Descripción de las universidades que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_EDU_OTROS IS ''Descripción de otros centros educativos que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_SANIT IS ''Indicador de si el activo dispone de centros sanitarios cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_SALUD IS ''Indicador de si el activo dispone de centros de salud cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_SALUD_DESC IS ''Descripción de los centros de salud que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CLINICAS IS ''Indicador de si el activo dispone de clínicas cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CLINICAS_DESC IS ''Descripción de las clínicas que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_HOSPITALES IS ''Indicador de si el activo dispone de hospitales cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_HOSPITALES_DESC IS ''Descripción de los hospitales que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_CENTROS_SANIT_OTROS IS ''Descripción de los centros sanitarios que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_PARKING_SUP_SUF IS ''Indicador de si el activo dispone de parking en superficie suficiente.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_COMUNICACIONES IS ''Indicador de si el activo está bien comunicado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_FACIL_ACCESO IS ''Indicador de si el activo dispone de fácil acceso por carretera.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_FACIL_ACCESO_DESC IS ''Descripción de los hoteles que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_LINEAS_BUS IS ''Indicador de si el activo dispone de líneas de autobuses cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_LINEAS_BUS_DESC IS ''Descripción de las líneas de autobús que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_METRO IS ''Indicador de si el activo dispone de líneas de metro cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_METRO_DESC IS ''Descripción de las paradas de metro que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_EST_TREN IS ''Indicador de si el activo dispone de estaciones de tren cerca.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_EST_TREN_DESC IS ''Descripción de las estaciones de tren que se encuentran cerca del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INF_COMUNICACIONES_OTRO IS ''Descripción de otras comunicaciones que dispone el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_ZONAS_COMUNES IS ''Indicador de si el activo dispone de zonas comunes.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_JARDINES IS ''Indicador de si el activo dispone de jardines o zonas verdes.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_PISCINA IS ''Indicador de si el activo dispone de piscina.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_INST_DEP IS ''Indicador de si el activo dispone de instalaciones deportivas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_PADEL IS ''Indicador de si el activo dispone de pista de padel.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_TENIS IS ''Indicador de si el activo dispone de pista de tenis.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_PISTA_POLIDEP IS ''Indicador de si el activo dispone de pista polideportiva.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_OTROS IS ''Descripción de otras instalaciones deportivas que dispone el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_ZONA_INFANTIL IS ''Indicador de si el activo dispone de zona infantil o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_CONSERJE_VIGILANCIA IS ''Indicador de si el activo dispone de conserje de vigilancia o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_GIMNASIO IS ''Indicador de si el activo dispone de gimnasio o no.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.ZCO_ZONA_COMUN_OTROS IS ''Descripción de otras zonas comunes que dispone el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_ELECTR IS ''Indicador de si el activo dispone de instalación eléctrica.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_ELECTR_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación eléctrica con contador.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_ELECTR_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación eléctrica en buen estado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_ELECTR_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación eléctrica defectuosa o muy antiguas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA IS ''Indicador de si el activo dispone de instalación de agua.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación de agua con contador.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación de agua en buen estado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación de agua defectuosa o antigua.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA_CALIENTE_CENTRAL IS ''Indicador de si el activo dispone de instalación de agua caliente central.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AGUA_CALIENTE_GAS_NATURAL IS ''Indicador de si el activo dispone de instalación de agua caliente con gas natural.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_GAS IS ''Indicador de si el activo dispone de instalación de gas.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_GAS_CON_CONTADOR IS ''Indicador de si el activo dispone de instalación de gas con contador.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_GAS_INST_BUEN_ESTADO IS ''Indicador de si el activo dispone de instalación de gas en buen estado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_GAS_DEFECTUOSA_ANTIGUA IS ''Indicador de si el activo dispone de instalación de gas defectuosa o antigua.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_CALEF IS ''Indicador de si el activo dispone de instalación de calefacción.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_CALEF_CENTRAL IS ''Indicador de si el activo dispone de instalación de calefacción central.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_CALEF_GAS_NATURAL IS ''Indicador de si el activo dispone de instalación de calefacción de gas natural.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_CALEF_RADIADORES_ALU IS ''Indicador de si el activo dispone de instalación de calefacción con radiadores de aluminio.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_CALEF_PREINSTALACION IS ''Indicador de si el activo dispone de preinstalación de calefacción.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AIRE IS ''Indicador de si el activo dispone de instalación de aire acondicionado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AIRE_PREINSTALACION IS ''Indicador de si el activo dispone de preinstalación de aire acondicionado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AIRE_INSTALACION IS ''Indicador de si el activo dispone de instalación de aire acondicionado.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_AIRE_FRIO_CALOR IS ''Indicador de si el activo dispone de instalación de aire acondicionado de frio/calor.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.INS_INST_OTROS IS ''Descripción de otras instalaciones que dispone el activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_DUCHA_BANYERA IS ''Indicador de si el activo dispone de ducha o bañera.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_DUCHA IS ''Indicador del estado de la ducha del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_BANYERA IS ''Indicador del estado de la bañera del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_BANYERA_HIDROMASAJE IS ''Indicador del estado de la bañera de hidromasaje del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_COLUMNA_HIDROMASAJE IS ''Indicador del estado de la columna de hidromasaje del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_ALICATADO_MARMOL IS ''Indicador del estado del alicatado en mármol del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_ALICATADO_GRANITO IS ''Indicador del estado del alicatado en granito del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_ALICATADO_AZULEJO IS ''Indicador del estado del alicatado en azulejo del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_ENCIMERA IS ''Indicador de si el activo dispone encimera en el baño.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_MARMOL IS ''Indicador del estado de la encimera de mármol del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_GRANITO IS ''Indicador del estado de la encimera de granito del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_OTRO_MATERIAL IS ''Indicador del estado de la encimera de otro material del baño del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_SANITARIOS IS ''Indicador de si el activo dispone sanitarios.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_SANITARIOS_EST IS ''Indicador del estado de los sanitarios del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_SUELOS IS ''Indicador del estado del suelo de los baños del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_GRIFO_MONOMANDO IS ''Indicador de si el activo dispone de grifo monomando.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_GRIFO_MONOMANDO_EST IS ''Indicador del estado de la grifería con monomando del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.BNY_BANYO_OTROS IS ''Descripción de otras calidades asociadas a los baños del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_AMUEBLADA IS ''Indicador de si el activo dispone de cocina amueblada.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_AMUEBLADA_EST IS ''Indicador del estado de la cocina amueblada del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_ENCIMERA IS ''Indicador de si el activo dispone de encimera en la cocina.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_ENCI_GRANITO IS ''Indicador del estado de la encimera de granito de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_ENCI_MARMOL IS ''Indicador del estado de la encimera de mármol de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_ENCI_OTRO_MATERIAL IS ''Indicador del estado de la encimera de otro material de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_VITRO IS ''Indicador del estado de la vitrocerámica de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_LAVADORA IS ''Indicador del estado de la lavadora del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_FRIGORIFICO IS ''Indicador del estado del frigorífico del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_LAVAVAJILLAS IS ''Indicador del estado del lavavajillas del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_MICROONDAS IS ''Indicador del estado del microondas del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_HORNO IS ''Indicador del estado del horno del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_SUELOS IS ''Indicador del estado del suelo de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_AZULEJOS IS ''Indicador de si el activo dispone de azulejos en la cocina.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_AZULEJOS_EST IS ''Indicador del estado de los azulejos de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_GRIFOS_MONOMANDO IS ''Indicador de si el activo dispone de grifos monomando en la cocina.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_GRIFOS_MONOMANDO_EST IS ''Indicador del estado de los grifos monomando de la cocina del activo.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.'||V_TABLA||'.COC_COCINA_OTROS IS ''Descripción de otras calidades asociadas a la cocina.''';


DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

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
