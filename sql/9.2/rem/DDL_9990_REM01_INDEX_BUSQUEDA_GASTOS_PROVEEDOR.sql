--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20171031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Indices necesarios para la búsqueda de gastos
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--## 		HREOS-3072 - Mejora rendimiento
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en GPV_GASTOS_PROVEEDOR ------------------------------.');
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_GASTOS_PROVEEDOR_IDX1'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX GPV_GASTOS_PROVEEDOR_IDX1 ON '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID, PVE_ID_EMISOR, PVE_ID_GESTORIA ASC) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX1 - GPV_ID, PVE_ID_EMISOR, PVE_ID_GESTORIA(ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX1 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX2
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_GASTOS_PROVEEDOR_IDX2'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX GPV_GASTOS_PROVEEDOR_IDX2 ON '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID, BORRADO ASC) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX2 - GPV_ID, BORRADO (ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX2 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX3
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_GASTOS_PROVEEDOR_IDX3'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX GPV_GASTOS_PROVEEDOR_IDX3 ON '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID, PRO_ID ASC) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX3 - GPV_ID, PRO_ID (ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX3 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX4
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_GASTOS_PROVEEDOR_IDX4'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX GPV_GASTOS_PROVEEDOR_IDX4 ON '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID, GPV_FECHA_EMISION, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA ASC) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX4 - GPV_ID, GPV_FECHA_EMISION, GPV_NUM_GASTO_HAYA, GPV_NUM_GASTO_GESTORIA (ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_GASTOS_PROVEEDOR_IDX4 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GDE_GASTOS_DETALLE_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GDE_GASTOS_DETALLE_IDX1'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN 
		V_MSQL := 'DROP INDEX GDE_GASTOS_DETALLE_IDX1';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	V_MSQL := 'CREATE UNIQUE INDEX GDE_GASTOS_DETALLE_IDX1 ON '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO (GDE_ID, GPV_ID, DD_TIT_ID, GDE_IMPORTE_TOTAL, GDE_FECHA_PAGO, GDE_FECHA_TOPE_PAGO ASC) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';	
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Indice GDE_GASTOS_DETALLE_IDX1 - GDE_ID, GPV_ID, DD_TIT_ID, GDE_IMPORTE_TOTAL, GDE_FECHA_PAGO, GDE_FECHA_TOPE_PAGO(ASC) - creado.');

	
		-- Creamos indice GGE_GASTOS_GESTION_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GGE_GASTOS_GESTION_IDX1''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	
	IF V_NUM_TABLAS = 1 THEN 
		V_MSQL := 'DROP INDEX GGE_GASTOS_GESTION_IDX1';
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	V_MSQL := 'CREATE UNIQUE INDEX GGE_GASTOS_GESTION_IDX1 ON '||V_ESQUEMA||'.GGE_GASTOS_GESTION (GGE_ID, GPV_ID, GGE_FECHA_ANULACION, GGE_FECHA_RP, gge_fecha_eah, DD_EAH_ID, DD_EAP_ID ASC) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Indice GGE_GASTOS_GESTION_IDX1 - GGE_ID, GPV_ID, GGE_FECHA_ANULACION, GGE_FECHA_RP, GGE_FECHA_EAH, DD_EAH_ID, DD_EAP_ID (ASC) - creado.');

	
		-- Creamos indice ACT_PVE_PROVEEDOR_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''ACT_PVE_PROVEEDOR_IDX1'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX ACT_PVE_PROVEEDOR_IDX1 ON '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID, PVE_NOMBRE,	PVE_DOCIDENTIF,	PVE_COD_UVEM, PVE_COD_REM ASC) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_PVE_PROVEEDOR_IDX1 - PVE_ID, PVE_DOCIDENTIF, PVE_COD_UVEM, PVE_COD_REM (ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_PVE_PROVEEDOR_IDX1 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice ACT_PRO_PROPIETARIO_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''ACT_PRO_PROPIETARIO_IDX1''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX ACT_PRO_PROPIETARIO_IDX1 ON '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (PRO_ID, PRO_DOCIDENTIF, PRO_NOMBRE ASC) TABLESPACE '||V_TABLESPACE_IDX||' COMPUTE STATISTICS';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_PRO_PROPIETARIO_IDX1 - PRO_ID, PRO_DOCIDENTIF, PRO_NOMBRE (ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice ACT_PRO_PROPIETARIO_IDX1 - Ya existe - no se hace nada.');
	END IF;
	

	
	
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] CREACION INDICES...OK');
	
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