--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Indices necesarios para agilizar vista VI_OFERTAS_ACTIVOS_AGRUPACION
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
    
    
BEGIN
	
-- INDICES NECESARIOS VI_OFERTAS_ACTIVOS_AGRUPACION: ----------------------------------------------

-- CREATE UNIQUE INDEX VIS_VISITAS_NUMVISITA_IDX ON VIS_VISITAS (VIS_ID, VIS_NUM_VISITA) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX ACT_ACTIVO_NUMACTIVO_IDX ON ACT_ACTIVO (ACT_ID, ACT_NUM_ACTIVO) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX OFR_OFERTAS_VISITAS_IDX ON OFR_OFERTAS (OFR_ID, VIS_ID) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX OFR_OFERTAS_PROVEEDOR_IDX ON OFR_OFERTAS (OFR_ID, PVE_ID_PRESCRIPTOR) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX OFR_OFERTAS_CLIENTEC_IDX ON OFR_OFERTAS (OFR_ID, CLC_ID) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX PVE_PROVEEDOR_TIPONOM_IDX ON ACT_PVE_PROVEEDOR (PVE_ID, DD_TPR_ID, PVE_NOMBRE) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX RES_RESERVAS_FFIRMA_IDX ON RES_RESERVAS (RES_ID, ECO_ID, RES_FECHA_FIRMA) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX ECO_EXPCOM_OFRECO_IDX ON ECO_EXPEDIENTE_COMERCIAL (OFR_ID, ECO_ID, ECO_NUM_EXPEDIENTE, DD_EEC_ID) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX LCO_LOTECOM_LOTGESCOM_IDX ON ACT_LCO_LOTE_COMERCIAL (AGR_ID, LCO_GESTOR_COMERCIAL) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX CLC_CLIENTC_OFERTANTE_IDX ON CLC_CLIENTE_COMERCIAL (CLC_ID, NVL2(CLC_RAZON_SOCIAL,CLC_RAZON_SOCIAL, CLC_NOMBRE || NVL2(CLC_APELLIDOS, ' ' || CLC_APELLIDOS, '')), CLC_TELEFONO1 ||'@'|| CLC_TELEFONO2 ||'@', CLC_EMAIL, CLC_DOCUMENTO) COMPUTE STATISTICS;
-- CREATE UNIQUE INDEX GAC_GESACTIVO_GESACT_IDX ON GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID) COMPUTE STATISTICS;
 

	-- Creamos indice ACT_ACTIVO_NUMACTIVO_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en ACT_ACTIVO ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''ACT_ACTIVO_NUMACTIVO_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX ACT_ACTIVO_NUMACTIVO_IDX ON '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID, ACT_NUM_ACTIVO) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_ACTIVO_NUMACTIVO_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_ACTIVO_NUMACTIVO_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice OFR_OFERTAS_VISITAS_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en OFR_OFERTAS ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''OFR_OFERTAS_VISITAS_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX OFR_OFERTAS_VISITAS_IDX ON '||V_ESQUEMA||'.OFR_OFERTAS (OFR_ID, VIS_ID) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice OFR_OFERTAS_VISITAS_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice OFR_OFERTAS_VISITAS_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice OFR_OFERTAS_PROVEEDOR_IDX
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''OFR_OFERTAS_PROVEEDOR_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX OFR_OFERTAS_PROVEEDOR_IDX ON '||V_ESQUEMA||'.OFR_OFERTAS (OFR_ID, PVE_ID_PRESCRIPTOR) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice OFR_OFERTAS_PROVEEDOR_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice OFR_OFERTAS_PROVEEDOR_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice OFR_OFERTAS_CLIENTEC_IDX
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''OFR_OFERTAS_CLIENTEC_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX OFR_OFERTAS_CLIENTEC_IDX ON '||V_ESQUEMA||'.OFR_OFERTAS (OFR_ID, CLC_ID) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice OFR_OFERTAS_CLIENTEC_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||V_ESQUEMA_M||'.OFR_OFERTAS_CLIENTEC_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice VIS_VISITAS_NUMVISITA_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en VIS_VISITAS ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''VIS_VISITAS_NUMVISITA_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX VIS_VISITAS_NUMVISITA_IDX ON '||V_ESQUEMA||'.VIS_VISITAS (VIS_ID, VIS_NUM_VISITA) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice VIS_VISITAS_NUMVISITA_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice VIS_VISITAS_NUMVISITA_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice PVE_PROVEEDOR_TIPONOM_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en ACT_PVE_PROVEEDOR ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''PVE_PROVEEDOR_TIPONOM_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX PVE_PROVEEDOR_TIPONOM_IDX ON '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID, DD_TPR_ID, PVE_NOMBRE) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice PVE_PROVEEDOR_TIPONOM_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice PVE_PROVEEDOR_TIPONOM_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice RES_RESERVAS_FFIRMA_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en RES_RESERVAS ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''RES_RESERVAS_FFIRMA_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX RES_RESERVAS_FFIRMA_IDX ON '||V_ESQUEMA||'.RES_RESERVAS (RES_ID, ECO_ID, RES_FECHA_FIRMA) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice RES_RESERVAS_FFIRMA_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice RES_RESERVAS_FFIRMA_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice ECO_EXPCOM_OFRECO_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en ECO_EXPEDIENTE_COMERCIAL ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''ECO_EXPCOM_OFRECO_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX ECO_EXPCOM_OFRECO_IDX ON '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (OFR_ID, ECO_ID, ECO_NUM_EXPEDIENTE, DD_EEC_ID) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ECO_EXPCOM_OFRECO_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ECO_EXPCOM_OFRECO_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice LCO_LOTECOM_LOTGESCOM_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en ACT_LCO_LOTE_COMERCIAL ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''LCO_LOTECOM_LOTGESCOM_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX LCO_LOTECOM_LOTGESCOM_IDX ON '||V_ESQUEMA||'.ACT_LCO_LOTE_COMERCIAL (AGR_ID, LCO_GESTOR_COMERCIAL) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice LCO_LOTECOM_LOTGESCOM_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice LCO_LOTECOM_LOTGESCOM_IDX - Ya existe - no se hace nada.');
	END IF;

	-- Creamos indice CLC_CLIENTC_OFERTANTE_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en CLC_CLIENTE_COMERCIAL ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''CLC_CLIENTC_OFERTANTE_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX CLC_CLIENTC_OFERTANTE_IDX ON '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL (CLC_ID, NVL2(CLC_RAZON_SOCIAL,CLC_RAZON_SOCIAL, CLC_NOMBRE || NVL2(CLC_APELLIDOS, '' '' || CLC_APELLIDOS, '''')), CLC_TELEFONO1 ||''@''|| CLC_TELEFONO2 ||''@'', CLC_EMAIL, CLC_DOCUMENTO) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice CLC_CLIENTC_OFERTANTE_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice CLC_CLIENTC_OFERTANTE_IDX - Ya existe - no se hace nada.');
	END IF;

    -- Creamos indice GAC_GESACTIVO_GESACT_IDX
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en GAC_GESTOR_ADD_ACTIVO ------------------------------.');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GAC_GESACTIVO_GESACT_IDX'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX GAC_GESACTIVO_GESACT_IDX ON '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GAC_GESACTIVO_GESACT_IDX - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GAC_GESACTIVO_GESACT_IDX - Ya existe - no se hace nada.');
	END IF;



	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT