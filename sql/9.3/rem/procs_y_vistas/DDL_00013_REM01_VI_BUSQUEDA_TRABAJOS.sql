--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8721
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Cambio obtener id-activo de la unidad alquilable
--##		0.3 Añadimos el numero de activo UA
--##        0.4 Deshacemos cambios de 0.2 y 0.3
--##		0.5 Añadimos la subcartera
--##		0.6 Añadimos columna para saber si un trabajo está en otro gasto
--##		0.7 Añadimos idActivo, numActivo, numAgrupacion
--##		0.8 HREOS-9586 Añadimos cruce act_tbj
--##		0.8 HREOS-10618 Adaptación de consulta al nuevo modelo de facturación
--##		1.0 HREOS-12002 Agregar campos solicitados
--##		1.1 HREOS-12030 Ajustar campos solicitados
--##		1.2 HREOS-12764 Adaptar consulta para evitar duplicar trabajos
--##		1.3 REMVIP-8721 Adaptar consulta para que salgan todos los trabajos de los activos
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

  /*SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
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
*/
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS 

	AS
	WITH busqueda_trabajos AS (
    		SELECT /*+ leading(rn act agr) use_hash(act) use_hash(agr) */
			DISTINCT
			tbj.tbj_id AS TBJ_ID,
			act.act_id AS IDACTIVO,
			1 AS RANGO,
            		DENSE_RANK() OVER(
            			PARTITION BY tbj.tbj_num_trabajo 
            			ORDER BY act.act_num_activo) ROW_NUM,
			tbj.tbj_num_trabajo AS TBJ_NUM_TRABAJO,
			tbj.tbj_webcom_id AS TBJ_WEBCOM_ID,
			tbj.tbj_cubre_seguro AS TBJ_CUBRE_SEGURO,
			tbj.tbj_importe_total AS TBJ_IMPORTE_TOTAL, 
			tbj.tbj_fecha_ejecutado AS TBJ_FECHA_EJECUTADO,
          		NVL2 (agr.agr_num_agrup_rem, agr.agr_num_agrup_rem, act.act_num_activo) AS NUM_ACTIVO_AGRUPACION,
          		NVL2 (agr.agr_num_agrup_rem, ''agrupaciones'', NVL2 (tbj.act_id, ''activo'', ''listado'')) AS TIPO_ENTIDAD,
			ttr.dd_ttr_codigo AS DD_TTR_CODIGO,
			ttr.dd_ttr_descripcion AS DD_TTR_DESCRIPCION,
			str.dd_str_codigo AS DD_STR_CODIGO,
			str.dd_str_descripcion AS DD_STR_DESCRIPCION,
          		tbj.tbj_fecha_solicitud AS TBJ_FECHA_SOLICITUD,
			est.dd_est_codigo AS DD_EST_CODIGO,
			est.dd_est_descripcion AS DD_EST_DESCRIPCION,
			pve.pve_nombre AS PROVEEDOR,
			actpro.pro_id AS PROPIETARIO,
			pve.pve_id AS PVE_ID,
          		--solic.usu_username AS SOLICITANTE,
			NVL2 (solic.usu_nombre, INITCAP (solic.usu_nombre) || NVL2 (solic.usu_apellido1, '' '' || INITCAP (solic.usu_apellido1), '''') ||
			NVL2 (solic.usu_apellido2, '' '' || INITCAP (solic.usu_apellido2), ''''), INITCAP (pve2.pve_nombre)) AS SOLICITANTE,
          		ddloc.dd_loc_descripcion AS POBLACION,
			ddprv.dd_prv_codigo AS DD_PRV_CODIGO,
			ddprv.dd_prv_descripcion AS PROVINCIA,
			bieloc.bie_loc_cod_post AS CODPOSTAL,
			act.act_num_activo AS NUMACTIVO,
			agr.agr_num_agrup_rem AS NUMAGRUPACION,
			cra.dd_cra_codigo AS CARTERA,
			cra.dd_cra_descripcion AS DESCRIPCIONCARTERA,
			scr.dd_scr_codigo AS SUBCARTERA,
			scr.dd_scr_descripcion AS DESCRIPCIONSUBCARTERA,
			usu.usu_username AS GESTOR_ACTIVO,
			DECODE (tbj.tbj_fecha_cierre_economico, NULL, 0, 1) AS CON_CIERRE_ECONOMICO,
          		tbj.tbj_fecha_cierre_economico AS TBJ_FECHA_CIERRE_ECONOMICO,
			DECODE (tbj.TBJ_FECHA_EMISION_FACTURA , NULL, DECODE(tbj.TBJ_IMPORTE_TOTAL, NULL, 1, 0, 1, 0), 1) AS FACTURADO,
			ttr.dd_ttr_filtrar AS DD_TTR_FILTRAR,
			DECODE (gtb.tbj_id, NULL, 0, 1) AS EN_OTRO_GASTO,
			IRE.DD_IRE_DESCRIPCION AS DD_IRE_DESCRIPCION,
    			TBJ.TBJ_FECHA_CAMBIO_ESTADO AS TBJ_FECHA_CAMBIO_ESTADO, 
            		usu2.usu_username as TBJ_RESPONSABLE_TRABAJO,
			usu3.usu_username AS GESTORRESPONSABLE

     			FROM ' || V_ESQUEMA || '.act_tbj_trabajo tbj 
			JOIN ' || V_ESQUEMA || '.act_tbj atj 					ON atj.tbj_id = tbj.tbj_id
			LEFT JOIN ' || V_ESQUEMA || '.act_activo act 				ON act.act_id = atj.act_id and act.borrado = 0
			LEFT JOIN ' || V_ESQUEMA || '.act_pac_propietario_activo actpro 	ON act.act_id = actpro.act_id
			LEFT JOIN ' || V_ESQUEMA || '.act_agr_agrupacion agr 		ON agr.agr_id = tbj.agr_id and agr.borrado = 0
			LEFT JOIN ' || V_ESQUEMA || '.gac_gestor_add_activo gac 		ON gac.act_id = act.act_id
			LEFT JOIN ' || V_ESQUEMA || '.gee_gestor_entidad gee 		ON gac.gee_id = gee.gee_id
			JOIN ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor tge 		ON (tge.dd_tge_id = gee.dd_tge_id AND tge.dd_tge_codigo = ''GACT'')
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios usu 		ON gee.usu_id = usu.usu_id
			LEFT JOIN ' || V_ESQUEMA || '.act_loc_localizacion loc 		ON (loc.act_id = NVL (tbj.act_id, agr.agr_act_principal))
			LEFT JOIN ' || V_ESQUEMA || '.bie_localizacion bieloc 		ON loc.bie_loc_id = bieloc.bie_loc_id
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.dd_loc_localidad ddloc 		ON bieloc.dd_loc_id = ddloc.dd_loc_id
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.dd_prv_provincia ddprv 		ON bieloc.dd_prv_id = ddprv.dd_prv_id
			JOIN ' || V_ESQUEMA || '.dd_ttr_tipo_trabajo ttr 			ON (ttr.dd_ttr_id = tbj.dd_ttr_id and ttr.dd_ttr_filtrar IS NULL)
			LEFT JOIN ' || V_ESQUEMA || '.dd_str_subtipo_trabajo str 		ON str.dd_str_id = tbj.dd_str_id
			LEFT JOIN ' || V_ESQUEMA || '.dd_est_estado_trabajo est 		ON tbj.dd_est_id = est.dd_est_id
			INNER JOIN ' || V_ESQUEMA || '.dd_cra_cartera cra 			ON cra.dd_cra_id = act.dd_cra_id
			INNER JOIN ' || V_ESQUEMA || '.dd_scr_subcartera scr 		ON scr.dd_scr_id = act.dd_scr_id
			LEFT JOIN ' || V_ESQUEMA || '.act_pvc_proveedor_contacto pvc 	ON pvc.pvc_id = tbj.pvc_id
			LEFT JOIN ' || V_ESQUEMA || '.act_pve_proveedor pve 			ON pve.pve_id = pvc.pve_id
			LEFT JOIN ' || V_ESQUEMA || '.act_pve_proveedor pve2 		ON pve2.pve_id = tbj.mediador_id
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios solic 		ON solic.usu_id = tbj.usu_id
			LEFT JOIN ' || V_ESQUEMA || '.gld_tbj gtb                       	ON tbj.tbj_id = gtb.tbj_id AND GTB.BORRADO = 0
			LEFT JOIN ' || V_ESQUEMA || '.DD_IRE_IDENTIFICADOR_REAM IRE		ON TBJ.DD_IRE_ID = IRE.DD_IRE_ID
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios usu2	 	ON usu2.usu_id = tbj.TBJ_RESPONSABLE_TRABAJO
			LEFT JOIN ' || V_ESQUEMA_MASTER || '.usu_usuarios usu3	 	ON usu3.usu_id = tbj.TBJ_GESTOR_ACTIVO_RESPONSABLE
          		where tbj.borrado = 0
          )
		SELECT 
		TBJ_ID,
		IDACTIVO,
		RANGO,
		TBJ_NUM_TRABAJO,
		TBJ_WEBCOM_ID,
		TBJ_CUBRE_SEGURO,
		TBJ_IMPORTE_TOTAL,
		TBJ_FECHA_EJECUTADO,
		NUM_ACTIVO_AGRUPACION,
		TIPO_ENTIDAD,
		DD_TTR_CODIGO,
		DD_TTR_DESCRIPCION,
		DD_STR_CODIGO,
		DD_STR_DESCRIPCION,
		TBJ_FECHA_SOLICITUD,
		DD_EST_CODIGO,
		DD_EST_DESCRIPCION,
		PROVEEDOR,
		PROPIETARIO,
		PVE_ID,
		SOLICITANTE,
		POBLACION,
		DD_PRV_CODIGO,
		PROVINCIA,
		CODPOSTAL,
		NUMACTIVO,
		NUMAGRUPACION,
		CARTERA,
		DESCRIPCIONCARTERA,
		SUBCARTERA,
		DESCRIPCIONSUBCARTERA,
		GESTOR_ACTIVO,
		CON_CIERRE_ECONOMICO,
		TBJ_FECHA_CIERRE_ECONOMICO,
		FACTURADO,
		DD_TTR_FILTRAR,
		EN_OTRO_GASTO,
		DD_IRE_DESCRIPCION,
		TBJ_FECHA_CAMBIO_ESTADO,
		TBJ_RESPONSABLE_TRABAJO,
		GESTORRESPONSABLE
		FROM busqueda_trabajos
		WHERE ROW_NUM = 1
          ';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...Creada OK');

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

EXIT;
