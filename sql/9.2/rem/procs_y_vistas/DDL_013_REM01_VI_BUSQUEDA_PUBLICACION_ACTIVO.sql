 --/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1566
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista busqueda publicación activo con correccion al filtrar con historico de inf comercial
--## Comentario1: Se adapta la vista para filtrar por valoracion sin borrar y que diferencie entre el destino comercial del activo.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_PUBLICACION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_PUBLICACION_ACTIVO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO';  
    DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Crear nueva vista: '|| V_ESQUEMA ||'.V_BUSQUEDA_PUBLICACION_ACTIVO..');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_PUBLICACION_ACTIVO 
	AS		  
		SELECT
		  	act.act_id,
		  	act.act_num_activo AS act_num_activo,
		  	tpa.dd_tpa_codigo AS tipo_activo_codigo,
		  	tpa.dd_tpa_descripcion AS tipo_activo_descripcion,
		  	sac.dd_sac_codigo AS subtipo_activo_codigo,
          	sac.dd_sac_descripcion AS subtipo_activo_descripcion,
          	(tvi.dd_tvi_descripcion || '' '' || loc.bie_loc_nombre_via || '' '' || loc.bie_loc_numero_domicilio || '' '' || loc.bie_loc_puerta) AS direccion,
          	cra.dd_cra_codigo AS cartera_codigo,
          	epu.dd_epu_codigo AS estado_publicacion_codigo,
          	epu.dd_epu_descripcion AS estado_publicacion_descripcion,
          	act.act_admision AS admision,
          	act.act_gestion AS gestion,
          	DECODE (aic.dd_aic_codigo, ''02'', 1, 0) informe_comercial,
          	(CASE WHEN act.act_fecha_ind_publicable IS NOT NULL THEN 1 ELSE 0 END) AS publicacion,
            (CASE WHEN val1.val_id_venta IS NOT NULL OR val2.val_id_renta IS NOT NULL THEN
                    CASE 
                        WHEN val1.val_id_venta IS NOT NULL AND act.dd_tco_id IN (select tco.dd_tco_id from '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION tco where tco.dd_tco_codigo in (''01'', ''02'', ''04'')) THEN 1
                        WHEN val2.val_id_renta IS NOT NULL AND act.dd_tco_id IN (select tco.dd_tco_id from '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION tco where tco.dd_tco_codigo in (''02'', ''03'', ''04'')) THEN 1
                    ELSE
                        0
                    END
             ELSE
                    0 
             END) AS precio

       	FROM '|| V_ESQUEMA ||'.act_activo act
       		LEFT JOIN '|| V_ESQUEMA ||'.dd_cra_cartera cra ON cra.dd_cra_id = act.dd_cra_id
			LEFT JOIN '|| V_ESQUEMA ||'.dd_sac_subtipo_activo sac ON sac.dd_sac_id = act.dd_sac_id
			LEFT JOIN '|| V_ESQUEMA ||'.dd_tpa_tipo_activo tpa ON tpa.dd_tpa_id = act.dd_tpa_id
			LEFT JOIN '|| V_ESQUEMA ||'.bie_localizacion loc ON act.bie_id = loc.bie_id
			LEFT JOIN '|| V_ESQUEMA_MASTER ||'.dd_tvi_tipo_via tvi ON loc.dd_tvi_id = tvi.dd_tvi_id
			LEFT JOIN '|| V_ESQUEMA ||'.dd_epu_estado_publicacion epu ON act.dd_epu_id = epu.dd_epu_id
			LEFT JOIN '|| V_ESQUEMA ||'.act_ico_info_comercial ico ON act.act_id = ico.act_id AND ico.borrado = 0
			LEFT JOIN '|| V_ESQUEMA ||'.act_pac_perimetro_activo pac ON act.act_id = pac.act_id AND pac.borrado = 0
			LEFT JOIN '|| V_ESQUEMA ||'.act_hic_est_inf_comer_hist hic ON act.act_id = hic.act_id
			LEFT JOIN '|| V_ESQUEMA ||'.dd_aic_accion_inf_comercial aic ON hic.dd_aic_id = aic.dd_aic_id
			JOIN '|| V_ESQUEMA ||'.dd_scm_situacion_comercial scm ON act.dd_scm_id = scm.dd_scm_id AND scm.dd_scm_codigo != ''01'' AND scm.dd_scm_codigo != ''05''
			left join (select val_id as val_id_venta, act_id as act_id_val_venta from '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
				JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON (VAL.DD_TPC_ID = TPC.DD_TPC_ID and tpc.DD_TPC_CODIGO = ''02'' and VAL.borrado = 0)) val1 on val1.act_id_val_venta = act.act_id
			left join (select val_id as val_id_renta, act_id as act_id_val_renta from '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL
				JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON (VAL.DD_TPC_ID = TPC.DD_TPC_ID and tpc.DD_TPC_CODIGO = ''03'' and VAL.borrado = 0)) val2 on val2.act_id_val_renta = act.act_id
   		WHERE (pac.pac_id IS NULL OR pac.pac_check_comercializar = 1) AND (hic.hic_fecha IS NULL OR hic.hic_fecha = (SELECT MAX (hist2.hic_fecha)
                                                                                                                   FROM act_hic_est_inf_comer_hist hist2
                                                                                                                  WHERE act.act_id = hist2.act_id))';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;