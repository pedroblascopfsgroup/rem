--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20160412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para la carga temporal de CALIDADES-ACTIVOS que vienen desde fichero enviado  (UVEM a REM).
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_CALIDADES_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_TABLA_IN VARCHAR2(2400 CHAR) := 'APR_AUX_CALIDADES_ACTIVOS'; -- INDICE DE LA TABLA CREADA.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para la carga temporal de CALIDADES-ACTIVOS que vienen desde fichero enviado  (UVEM a REM).'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		

		ACT_NUMERO_ACTIVO				NUMBER(16,0) NOT NULL,
		TIPO_ACABADO_CARPINTERIA			VARCHAR2(20 CHAR),
		CRI_PTA_ENT_NORMAL				NUMBER(1,0),
		CRI_PTA_ENT_BLINDADA				NUMBER(1,0),
		CRI_PTA_ENT_ACORAZADA				NUMBER(1,0),
		CRI_PTA_PASO_MACIZAS				NUMBER(1,0),
                CRI_PTA_PASO_HUECAS				NUMBER(1,0),
		CRI_PTA_PASO_LACADAS				NUMBER(1,0),
		CRI_ARMARIOS_EMPOTRADOS				NUMBER(1,0),
		CRI_CRP_INT_OTROS				VARCHAR2(250 CHAR),
		CRE_VTNAS_HIERRO				NUMBER(1,0),
		CRE_VTNAS_ALU_ANODIZADO				NUMBER(1,0),
		CRE_VTNAS_ALU_LACADO				NUMBER(1,0),
		CRE_VTNAS_PVC					NUMBER(1,0),
		CRE_VTNAS_MADERA				NUMBER(1,0),
		CRE_PERS_PLASTICO				NUMBER(1,0),
		CRE_PERS_ALU					NUMBER(1,0),
		CRE_VTNAS_CORREDERAS				NUMBER(1,0),
		CRE_VTNAS_ABATIBLES				NUMBER(1,0),
		CRE_VTNAS_OSCILOBAT				NUMBER(1,0),
		CRE_DOBLE_CRISTAL				NUMBER(1,0),
		CRE_EST_DOBLE_CRISTAL				NUMBER(1,0),
		CRE_CRP_EXT_OTROS				VARCHAR2(250 CHAR),
		PRV_HUMEDAD_PARED				NUMBER(1,0),
		PRV_HUMEDAD_TECHO				NUMBER(1,0),
		PRV_GRIETA_PARED				NUMBER(1,0),
		PRV_GRIETA_TECHO				NUMBER(1,0),
		PRV_GOTELE					NUMBER(1,0),
		PRV_PLASTICA_LISA				NUMBER(1,0),
		PRV_PAPEL_PINTADO				NUMBER(1,0),
		PRV_PINTURA_LISA_TECHO				NUMBER(1,0),
		PRV_PINTURA_LISA_TECHO_EST			NUMBER(1,0),	
		PRV_MOLDURA_ESCAYOLA				NUMBER(1,0),
		PRV_MOLDURA_ESCAYOLA_EST			NUMBER(1,0),
		PRV_PARAMENTOS_OTROS				VARCHAR2(250 CHAR),
		SOL_TARIMA_FLOTANTE				NUMBER(1,0),
		SOL_PARQUE					NUMBER(1,0),
		SOL_MARMOL					NUMBER(1,0),
		SOL_PLAQUETA					NUMBER(1,0),
		SOL_SOLADO_OTROS				VARCHAR2(250 CHAR),
		INF_OCIO    					NUMBER(1,0),
		INF_HOTELES					NUMBER(1,0),
		INF_HOTELES_DESC				VARCHAR2(250 CHAR),		
		INF_TEATROS					NUMBER(1,0),
		INF_TEATROS_DESC				VARCHAR2(250 CHAR),		
		INF_SALAS_CINE					NUMBER(1,0),
		INF_SALAS_CINE_DESC				VARCHAR2(250 CHAR),
		INF_INST_DEPORT					NUMBER(1,0),
		INF_INST_DEPORT_DESC				VARCHAR2(250 CHAR),
		INF_CENTROS_COMERC                                                   NUMBER(1,0),
		INF_CENTROS_COMERC_DESC                                              VARCHAR2(250 CHAR),
		INF_OCIO_OTROS                                                       VARCHAR2(250 CHAR),
		INF_CENTROS_EDU                                                      NUMBER(1,0),
		INF_ESCUELAS_INF                                                     NUMBER(1,0),
		INF_ESCUELAS_INF_DESC                                                VARCHAR2(250 CHAR),
		INF_COLEGIOS                                                         NUMBER(1,0),
		INF_COLEGIOS_DESC                                                    VARCHAR2(250 CHAR),
		INF_INSTITUTOS                                                       NUMBER(1,0),
		INF_INSTITUTOS_DESC                                                  VARCHAR2(250 CHAR),
		INF_UNIVERSIDADES                                                    NUMBER(1,0),
		INF_UNIVERSIDADES_DESC                                               VARCHAR2(250 CHAR),
		INF_CENTROS_EDU_OTROS                                                VARCHAR2(250 CHAR),
		INF_CENTROS_SANIT                                                    NUMBER(1,0),
		INF_CENTROS_SALUD                                                    NUMBER(1,0),
		INF_CENTROS_SALUD_DESC                                               VARCHAR2(250 CHAR),
		INF_CLINICAS                                                         NUMBER(1,0),
 		INF_CLINICAS_DESC                                                    VARCHAR2(250 CHAR),
		INF_HOSPITALES                                                       NUMBER(1,0),
		INF_HOSPITALES_DESC                                                  VARCHAR2(250 CHAR),
		INF_CENTROS_SANIT_OTROS                                              VARCHAR2(250 CHAR),
		INF_PARKING_SUP_SUF                                                  NUMBER(1,0),
		INF_COMUNICACIONES                                                   NUMBER(1,0),
		INF_FACIL_ACCESO                                                     NUMBER(1,0),
		INF_FACIL_ACCESO_DESC                                                VARCHAR2(250 CHAR),
		INF_LINEAS_BUS                                                       NUMBER(1,0),
		INF_LINEAS_BUS_DESC                                                  VARCHAR2(250 CHAR),
		INF_METRO                                                            NUMBER(1,0),
		INF_METRO_DESC                                                       VARCHAR2(250 CHAR),
		INF_EST_TREN                                                         NUMBER(1,0),
		INF_EST_TREN_DESC                                                    VARCHAR2(250 CHAR),
		INF_COMUNICACIONES_OTRO                                              VARCHAR2(250 CHAR),
		ZCO_ZONAS_COMUNES                                                    NUMBER(1,0),
		ZCO_JARDINES                                                         NUMBER(1,0),
		ZCO_PISCINA                                                          NUMBER(1,0),
		ZCO_INST_DEP                                                         NUMBER(1,0),
		ZCO_PADEL                                                            NUMBER(1,0),
		ZCO_TENIS                                                            NUMBER(1,0),
		ZCO_PISTA_POLIDEP                                                    NUMBER(1,0),
		ZCO_OTROS                                                            VARCHAR2(250 CHAR),
		ZCO_ZONA_INFANTIL                                                    NUMBER(1,0),
		ZCO_CONSERJE_VIGILANCIA                                              NUMBER(1,0),
		ZCO_GIMNASIO                                                         NUMBER(1,0),
		ZCO_ZONA_COMUN_OTROS                                                 VARCHAR2(250 CHAR),
		INS_ELECTR                                                           NUMBER(1,0),
		INS_ELECTR_CON_CONTADOR                                              NUMBER(1,0),
		INS_ELECTR_BUEN_ESTADO                                               NUMBER(1,0),
		INS_ELECTR_DEFECTUOSA_ANTIGUA                                        NUMBER(1,0),
		INS_AGUA                                                             NUMBER(1,0),
		INS_AGUA_CON_CONTADOR                                                NUMBER(1,0),
		INS_AGUA_BUEN_ESTADO                                                 NUMBER(1,0),
		INS_AGUA_DEFECTUOSA_ANTIGUA                                          NUMBER(1,0),
		INS_AGUA_CALIENTE_CENTRAL                                            NUMBER(1,0),
		INS_AGUA_CALIENTE_GAS_NATURAL                                        NUMBER(1,0),
		INS_GAS                                                              NUMBER(1,0),
		INS_GAS_CON_CONTADOR                                                 NUMBER(1,0),
		INS_GAS_INST_BUEN_ESTADO                                             NUMBER(1,0),
		INS_GAS_DEFECTUOSA_ANTIGUA                                           NUMBER(1,0),
		INS_CALEF                                                            NUMBER(1,0),
		INS_CALEF_CENTRAL                                                    NUMBER(1,0),
		INS_CALEF_GAS_NATURAL                                                NUMBER(1,0),
		INS_CALEF_RADIADORES_ALU                                             NUMBER(1,0),
		INS_CALEF_PREINSTALACION                                             NUMBER(1,0),
		INS_AIRE                                                             NUMBER(1,0),
		INS_AIRE_PREINSTALACION                                              NUMBER(1,0),
		INS_AIRE_INSTALACION                                                 NUMBER(1,0),
		INS_AIRE_FRIO_CALOR                                                  NUMBER(1,0),
		INS_INST_OTROS                                                       VARCHAR2(250 CHAR),
		BNY_DUCHA_BANYERA                                                    NUMBER(1,0),
		BNY_DUCHA                                                            NUMBER(1,0),
		BNY_BANYERA                                                          NUMBER(1,0),
		BNY_BANYERA_HIDROMASAJE                                              NUMBER(1,0),
		BNY_COLUMNA_HIDROMASAJE                                              NUMBER(1,0),
		BNY_ALICATADO_MARMOL                                                 NUMBER(1,0),
		BNY_ALICATADO_GRANITO                                                NUMBER(1,0),
		BNY_ALICATADO_AZULEJO                                                NUMBER(1,0),
		BNY_ENCIMERA                                                         NUMBER(1,0),
		BNY_MARMOL                                                           NUMBER(1,0),
		BNY_GRANITO                                                          NUMBER(1,0),
		BNY_OTRO_MATERIAL                                                    NUMBER(1,0),
		BNY_SANITARIOS                                                       NUMBER(1,0),
		BNY_SANITARIOS_EST                                                   NUMBER(1,0),
		BNY_SUELOS                                                           NUMBER(1,0),
		BNY_GRIFO_MONOMANDO                                                  NUMBER(1,0),
		BNY_GRIFO_MONOMANDO_EST                                              NUMBER(1,0),
		BNY_BANYO_OTROS                                                      VARCHAR2(250 CHAR),
		COC_AMUEBLADA                                                        NUMBER(1,0),
		COC_AMUEBLADA_EST                                                    NUMBER(1,0),
		COC_ENCIMERA                                                         NUMBER(1,0),
		COC_ENCI_GRANITO                                                     NUMBER(1,0),
		COC_ENCI_MARMOL                                                      NUMBER(1,0),
		COC_ENCI_OTRO_MATERIAL                                               NUMBER(1,0),
		COC_VITRO                                                            NUMBER(1,0),
		COC_LAVADORA                                                         NUMBER(1,0),
		COC_FRIGORIFICO                                                      NUMBER(1,0),
		COC_LAVAVAJILLAS                                                     NUMBER(1,0),
		COC_MICROONDAS                                                       NUMBER(1,0),
		COC_HORNO                                                            NUMBER(1,0),
		COC_SUELOS                                                           NUMBER(1,0),
		COC_AZULEJOS                                                         NUMBER(1,0),
		COC_AZULEJOS_EST                                                     NUMBER(1,0),
		COC_GRIFOS_MONOMANDO                                                 NUMBER(1,0),
		COC_GRIFOS_MONOMANDO_EST                                             NUMBER(1,0),
		COC_COCINA_OTROS                                                     VARCHAR2(250 CHAR),
		USUARIOCREAR 					VARCHAR2(50 CHAR), 
		FECHACREAR 						TIMESTAMP (6), 
		USUARIOMODIFICAR 				VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 					TIMESTAMP (6), 
		USUARIOBORRAR 					VARCHAR2(50 CHAR), 
		FECHABORRAR 					TIMESTAMP (6), 
		BORRADO 						NUMBER(1,0)
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	

	-- Creamos indice	
	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_IN||'_IN ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ACT_NUMERO_ACTIVO) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_IN||'_IN... Indice creado.');
	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	
COMMIT;



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
