--/*
--##########################################
--## AUTOR=JUAN TORRELLA
--## FECHA_CREACION=20171222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3462
--## PRODUCTO=SI
--## Finalidad: DDL
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
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS 

	AS
		SELECT /*+ use_hash(rn,act)(rn,tbj) */
			tbj.tbj_id, 
			act.act_id AS idactivo, 
			rn.rango, 
			tbj.tbj_num_trabajo, 
			tbj.tbj_webcom_id, 
			tbj.tbj_cubre_seguro, 
			tbj.tbj_importe_total, 
			tbj.tbj_fecha_ejecutado,
          	NVL2 (agr.agr_num_agrup_rem, agr.agr_num_agrup_rem, act.act_num_activo) AS num_activo_agrupacion,
          	NVL2 (agr.agr_num_agrup_rem, ''agrupaciones'', NVL2 (tbj.act_id, ''activo'', ''listado'')) AS tipo_entidad, 
			ttr.dd_ttr_codigo, 
			ttr.dd_ttr_descripcion, 
			str.dd_str_codigo, 
			str.dd_str_descripcion,
          	tbj.tbj_fecha_solicitud, 
			est.dd_est_codigo, 
			est.dd_est_descripcion, 
			pve.pve_nombre AS proveedor, 
			actpro.pro_id AS propietario,
			pve.pve_id,
          	NVL2 (solic.usu_nombre, INITCAP (solic.usu_nombre) || NVL2 (solic.usu_apellido1, '' '' || INITCAP (solic.usu_apellido1), '''') || 
				NVL2 (solic.usu_apellido2, '' '' || INITCAP (solic.usu_apellido2), ''''), INITCAP (pve2.pve_nombre)) AS solicitante,
          	ddloc.dd_loc_descripcion AS poblacion, 
			ddprv.dd_prv_codigo, 
			ddprv.dd_prv_descripcion AS provincia, 
			bieloc.bie_loc_cod_post AS codpostal, 
			act.act_num_activo AS numactivo,
          	agr.agr_num_agrup_rem AS numagrupacion, 
			cra.dd_cra_codigo AS cartera, 
			usu.usu_username AS gestor_activo, 
			DECODE (tbj.tbj_fecha_cierre_economico, NULL, 0, 1) AS con_cierre_economico,
          	tbj.tbj_fecha_cierre_economico, 
			DECODE (tbj.TBJ_FECHA_EMISION_FACTURA , NULL, DECODE(tbj.TBJ_IMPORTE_TOTAL, NULL, 1, 0, 1, 0), 1) AS facturado, 
			ttr.dd_ttr_filtrar

     FROM ' || V_ESQUEMA || '.act_tbj_trabajo tbj JOIN ' || V_ESQUEMA || '.act_tbj atj ON atj.tbj_id = tbj.tbj_id
          LEFT JOIN ' || V_ESQUEMA || '.act_activo act ON act.act_id = atj.act_id and act.borrado = 0
		LEFT JOIN ' || V_ESQUEMA || '.act_pac_propietario_activo actpro ON act.act_id = actpro.act_id
          LEFT JOIN ' || V_ESQUEMA || '.act_agr_agrupacion agr ON agr.agr_id = tbj.agr_id and agr.borrado = 0
          LEFT JOIN ' || V_ESQUEMA || '.gac_gestor_add_activo gac ON gac.act_id = act.act_id
          LEFT JOIN ' || V_ESQUEMA || '.gee_gestor_entidad gee ON gac.gee_id = gee.gee_id
          JOIN ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor tge ON (tge.dd_tge_id = gee.dd_tge_id AND tge.dd_tge_codigo = ''GACT'')
          LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios usu ON gee.usu_id = usu.usu_id
          LEFT JOIN ' || V_ESQUEMA || '.act_loc_localizacion loc ON (loc.act_id = NVL (tbj.act_id, agr.agr_act_principal))
          LEFT JOIN ' || V_ESQUEMA || '.bie_localizacion bieloc ON loc.bie_loc_id = bieloc.bie_loc_id
          LEFT JOIN ' || V_ESQUEMA_MASTER || '.dd_loc_localidad ddloc ON bieloc.dd_loc_id = ddloc.dd_loc_id
          LEFT JOIN ' || V_ESQUEMA_MASTER || '.dd_prv_provincia ddprv ON bieloc.dd_prv_id = ddprv.dd_prv_id
          JOIN ' || V_ESQUEMA || '.dd_ttr_tipo_trabajo ttr ON (ttr.dd_ttr_id = tbj.dd_ttr_id and ttr.dd_ttr_filtrar IS NULL)
          LEFT JOIN ' || V_ESQUEMA || '.dd_str_subtipo_trabajo str ON str.dd_str_id = tbj.dd_str_id
          LEFT JOIN ' || V_ESQUEMA || '.dd_est_estado_trabajo est ON tbj.dd_est_id = est.dd_est_id
          INNER JOIN ' || V_ESQUEMA || '.dd_cra_cartera cra ON cra.dd_cra_id = act.dd_cra_id
          LEFT JOIN ' || V_ESQUEMA || '.act_pvc_proveedor_contacto pvc ON pvc.pvc_id = tbj.pvc_id
          LEFT JOIN ' || V_ESQUEMA || '.act_pve_proveedor pve ON pve.pve_id = pvc.pve_id
          LEFT JOIN ' || V_ESQUEMA || '.act_pve_proveedor pve2 ON pve2.pve_id = tbj.mediador_id
          LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios solic ON solic.usu_id = tbj.usu_id
          LEFT JOIN
          (SELECT act_id, tbj_id, ROW_NUMBER() OVER(PARTITION BY tbj_id ORDER BY act_id) rango
             FROM ' || V_ESQUEMA || '.act_tbj) rn ON (rn.act_id = act.act_id AND rn.tbj_id = tbj.tbj_id)
          where tbj.borrado = 0
          ';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...Creada OK');
  
END;
/

EXIT;