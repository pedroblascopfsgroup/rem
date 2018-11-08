--/*
--##########################################
--## AUTOR=CARLOS GÓRRIZ
--## FECHA_CREACION=20180817
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4403
--## PRODUCTO=NO
--## Finalidad: Vista para la búsqueda de agrupaciones.
--##  
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial.
--##		0.2 No contar publicados oculto.
--##		0.3 Modificación.
--##		0.4 Corrección activos publicados.
--##		0.5 Nuevo campo en select
--##		0.6 Nuevo campo en select (código e id del tipo de alquiler)
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(1); -- Vble. para validar la existencia de las Tablas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(4000 CHAR);


BEGIN

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';
	IF table_count > 0 THEN
		DBMS_OUTPUT.PUT('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES';
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';
	IF table_count > 0 THEN
		DBMS_OUTPUT.PUT('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES';
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;

	DBMS_OUTPUT.PUT('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_AGRUPACIONES...');
	EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_AGRUPACIONES 
		AS
		SELECT 
			agr.agr_id, 
			agr.dd_tag_id, 
			agr.agr_num_agrup_rem,
			agr.agr_num_agrup_uvem, 
			agr.agr_nombre, 
			agr.agr_descripcion, 
			agr.agr_fecha_alta, 
			agr.agr_fecha_baja, 
			agr.agr_ini_vigencia, 
			agr.agr_fin_vigencia, 
			agr.agr_publicado,
			nvl(agr_p.activos,0) AS activos, 
			nvl(agr_p.publicados,0) AS publicados, 
			COALESCE (obr.dd_prv_id, res.dd_prv_id, lco.dd_prv_id, asi.dd_prv_id, pry.dd_prv_id) AS provincia,
			COALESCE (obr.dd_loc_id, res.dd_loc_id, lco.dd_loc_id, asi.dd_loc_id, pry.dd_loc_id) AS localidad, 
			COALESCE (obr.onv_direccion, res.res_direccion, lco.lco_direccion, asi.asi_direccion, pry.PRY_DIRECCION) AS direccion,
			agr_p.dd_cra_codigo cartera, 
			agr.agr_is_formalizacion,
			alq.dd_tal_id AS idTipoAlquiler,
			alq.dd_tal_codigo AS codTipoAlquiler
		FROM '||V_ESQUEMA||'.act_agr_agrupacion agr 
		JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag ON tag.dd_tag_id = agr.dd_tag_id
		LEFT JOIN
			(SELECT SUM (1) activos, SUM (CASE
			WHEN dd_epu.dd_epu_codigo NOT IN (''03'', ''05'', ''06'')
			THEN 1
			ELSE 0
			END) publicados, 
			aga.agr_id, 
			cra.dd_cra_codigo
			FROM '||V_ESQUEMA||'.act_aga_agrupacion_activo aga 
			LEFT JOIN '||V_ESQUEMA||'.act_activo act ON act.act_id = aga.act_id
			LEFT JOIN '||V_ESQUEMA||'.dd_epu_estado_publicacion dd_epu ON act.dd_epu_id = dd_epu.dd_epu_id
			LEFT JOIN '||V_ESQUEMA||'.dd_cra_cartera cra ON cra.dd_cra_id = act.dd_cra_id
			WHERE aga.borrado = 0 AND act.borrado = 0
			GROUP BY aga.agr_id, cra.dd_cra_codigo) agr_p ON agr_p.agr_id = agr.agr_id
		LEFT JOIN '||V_ESQUEMA||'.act_onv_obra_nueva obr ON (agr.agr_id = obr.agr_id)
		LEFT JOIN '||V_ESQUEMA||'.act_res_restringida res ON (agr.agr_id = res.agr_id)
		LEFT JOIN '||V_ESQUEMA||'.act_lco_lote_comercial lco ON (agr.agr_id = lco.agr_id)
		LEFT JOIN '||V_ESQUEMA||'.act_asi_asistida asi ON (agr.agr_id = asi.agr_id)
		LEFT JOIN '||V_ESQUEMA||'.dd_tal_tipo_alquiler alq ON (agr.dd_tal_id = alq.dd_tal_id)
		LEFT JOIN '||V_ESQUEMA||'.ACT_PRY_PROYECTO PRY ON (agr.agr_id = PRY.agr_id)
		WHERE agr.borrado = 0 AND tag.borrado = 0';

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_AGA_IDX1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
	IF table_count > 0 THEN
		EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.ACT_AGA_IDX1';  
	END IF;

	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.ACT_AGA_IDX1 ON ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO (AGA_ID, AGR_ID, ACT_ID, BORRADO) LOGGING NOPARALLEL';

	SELECT COUNT(*) INTO table_count FROM ALL_OBJECTS WHERE OBJECT_NAME = 'ACT_ACTIVO_IDX3' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='INDEX';  
	IF table_count > 0 THEN
		EXECUTE IMMEDIATE 'DROP INDEX ' || V_ESQUEMA || '.ACT_ACTIVO_IDX3';  
	END IF;

	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.ACT_ACTIVO_IDX3 ON ' || V_ESQUEMA || '.ACT_ACTIVO (ACT_ID, DD_CRA_ID, DD_EPU_ID, BORRADO) LOGGING NOPARALLEL';

	DBMS_OUTPUT.PUT_LINE('OK');

END;
/
EXIT;
