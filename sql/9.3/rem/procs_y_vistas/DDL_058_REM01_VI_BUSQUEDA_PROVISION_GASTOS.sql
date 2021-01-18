--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20171201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3403
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
		prg.prg_id,
		prg.prg_num_provision,
		epr.dd_epr_codigo,
		epr.dd_epr_descripcion,
		prg.prg_fecha_alta,
		pve.pve_id,
		pve.pve_cod_rem,
		pve.pve_nombre,
		prg.prg_fecha_envio,
		prg.prg_fecha_respuesta,
		prg.prg_fecha_anulacion,
		pro.pro_nombre,
		pro.pro_docidentif,
		cra.dd_cra_codigo,
		cra.dd_cra_descripcion,
		NULL dd_scr_codigo,
		NULL dd_scr_descripcion,
		gpv.importe AS importe_total
		FROM '||V_ESQUEMA||'.prg_provision_gastos prg
		JOIN (SELECT SUM (gde2.gde_importe_total) importe,
				prg2.prg_id,
		 		gpv2.pro_id
			FROM '||V_ESQUEMA||'.prg_provision_gastos prg2 
			JOIN '||V_ESQUEMA||'.gpv_gastos_proveedor gpv2 ON gpv2.prg_id = prg2.prg_id
			INNER JOIN '||V_ESQUEMA||'.gde_gastos_detalle_economico gde2 ON gde2.gpv_id = gpv2.gpv_id
		    GROUP BY prg2.prg_id,
		 gpv2.pro_id) gpv ON gpv.prg_id = prg.prg_id
		JOIN '||V_ESQUEMA||'.act_pro_propietario pro ON pro.pro_id = gpv.pro_id
		JOIN '||V_ESQUEMA||'.dd_cra_cartera cra ON cra.dd_cra_id = pro.dd_cra_id
		JOIN '||V_ESQUEMA||'.dd_epr_estados_provision_gasto epr ON epr.dd_epr_id = prg.dd_epr_id
		JOIN '||V_ESQUEMA||'.act_pve_proveedor pve ON pve.pve_id = prg.pve_id_gestoria
		WHERE prg.borrado = 0
		ORDER BY prg.prg_num_provision ASC';

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