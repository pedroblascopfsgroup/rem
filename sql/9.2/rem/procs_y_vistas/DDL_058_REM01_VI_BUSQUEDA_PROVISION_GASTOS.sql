--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1945
--## PRODUCTO=NO
--## Finalidad: Vista para la búsqueda de provisiones de gastos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_BUSQUEDA_PROVISION_GASTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista para la búsqueda de provisiones de gastos.'; -- Vble. para los comentarios de las tablas
    
    CUENTA NUMBER;
    
BEGIN
	

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comprobaciones previas');
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');	
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista materializada '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
	END IF;
  
  
 
   -- Creamos vista
	DBMS_OUTPUT.PUT_LINE('[INFO] Crear nueva vista : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'..');
  	EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
		SELECT
		PRG.PRG_ID,  
		PRG.PRG_NUM_PROVISION,
		EPR.DD_EPR_CODIGO,
		EPR.DD_EPR_DESCRIPCION,
		PRG.PRG_FECHA_ALTA,
		PVE.PVE_ID,
		PVE.PVE_COD_REM,
		PVE.PVE_NOMBRE,
		PRG.PRG_FECHA_ENVIO,
		PRG.PRG_FECHA_RESPUESTA,
		PRG.PRG_FECHA_ANULACION,
		PRO.PRO_NOMBRE,
		PRO.PRO_DOCIDENTIF,
		CRA.DD_CRA_CODIGO,
		CRA.DD_CRA_DESCRIPCION,
		SCR.DD_SCR_CODIGO,
		SCR.DD_SCR_DESCRIPCION,
		(SELECT SUM(GDE2.GDE_IMPORTE_TOTAL) 
			FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG2 
			LEFT JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV2 ON GPV2.PRG_ID = PRG2.PRG_ID
			INNER JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE2 ON GDE2.GPV_ID = GPV2.GPV_ID
			WHERE PRG2.PRG_ID = PRG.PRG_ID) AS IMPORTE_TOTAL 
		FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG 
		LEFT JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.PRG_ID = PRG.PRG_ID AND GPV.BORRADO = 0
		LEFT JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID 
		LEFT JOIN '||V_ESQUEMA||'.GPV_ACT GPVA ON GPVA.GPV_ID = GPV.GPV_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GPVA.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO EPR ON EPR.DD_EPR_ID = PRG.DD_EPR_ID
		LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PRG.PVE_ID_GESTORIA
		WHERE PRG.BORRADO = 0 
		and act.borrado = 0
		GROUP BY  
		PRG.PRG_ID,  
		PRG.PRG_NUM_PROVISION,
		EPR.DD_EPR_CODIGO,
		EPR.DD_EPR_DESCRIPCION,
		PRG.PRG_FECHA_ALTA,
		PVE.PVE_ID,
		PVE.PVE_COD_REM,
		PVE.PVE_NOMBRE,
		PRG.PRG_FECHA_ENVIO,
		PRG.PRG_FECHA_RESPUESTA,
		PRG.PRG_FECHA_ANULACION,
		PRO.PRO_NOMBRE,
		PRO.PRO_DOCIDENTIF,
		CRA.DD_CRA_CODIGO,
		CRA.DD_CRA_DESCRIPCION,
		SCR.DD_SCR_CODIGO,
		SCR.DD_SCR_DESCRIPCION
		ORDER BY PRG.PRG_NUM_PROVISION ASC';

 	DBMS_OUTPUT.PUT_LINE('[INFO] Vista : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... creada');
 		
 	
	EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS IS ''Vista para la búsqueda de provisiones de gastos''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_ID IS ''Identificador único de la provision''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_NUM_PROVISION IS ''Número identificador único de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_EPR_CODIGO IS ''Código del estado de la provision''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_EPR_DESCRIPCION IS ''Descripción del estado de la provision''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_FECHA_ALTA IS ''Fecha de alta de la provision''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PVE_ID IS ''Indentificador del proveedor de la gestoría responsable de la provisión''';  
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PVE_COD_REM IS ''Código proveedor REM de la gestoría responsable de la provisión''';  
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PVE_NOMBRE IS ''Nombre proveedor REM de la gestoría responsable de la provisión''';  
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_FECHA_ENVIO IS ''Fecha envio de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_FECHA_RESPUESTA IS ''Fecha respuesta de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRG_FECHA_ANULACION IS ''Fecha anulación de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRO_NOMBRE IS ''Nombre del propietario''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.PRO_DOCIDENTIF IS ''Nif del propietario''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_CRA_CODIGO IS ''Código de la cartera de los activos asociados a los gastos de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_CRA_DESCRIPCION IS ''Descripción de la cartera de los activos asociados a los gastos de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_SCR_CODIGO IS ''Código de la subcartera de los activos asociados a los gastos de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.DD_SCR_DESCRIPCION IS ''Descripción de la subcartera de los activos asociados a los gastos de la provisión''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_BUSQUEDA_PROVISION_GASTOS.IMPORTE_TOTAL IS ''Importe total de los gastos asociados a la provisión''';
  


  	DBMS_OUTPUT.PUT_LINE('Comentarios de la vista : '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creados');
  


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

EXIT;