 --/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2583
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
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_BUSQUEDA_PUBLICACION_ACTIVO';
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || ' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || '';  
    DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || ' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || '';  
    DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Crear nueva vista: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || '..');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || ' (act_id,
                                                                  act_num_activo,
                                                                  tipo_activo_codigo,
                                                                  tipo_activo_descripcion,
                                                                  subtipo_activo_codigo,
                                                                  subtipo_activo_descripcion,
                                                                  direccion,
                                                                  cartera_codigo,
                                                                  estado_publicacion_codigo,
                                                                  estado_publicacion_descripcion,
                                                                  admision,
                                                                  gestion,
                                                                  informe_comercial,
                                                                  publicacion,
                                                                  precio
                                                                 )
AS
   SELECT act.act_id, act.act_num_activo AS act_num_activo, tpa.dd_tpa_codigo AS tipo_activo_codigo, tpa.dd_tpa_descripcion AS tipo_activo_descripcion, sac.dd_sac_codigo AS subtipo_activo_codigo,
          sac.dd_sac_descripcion AS subtipo_activo_descripcion,
          (tvi.dd_tvi_descripcion || '' '' || loc.bie_loc_nombre_via || '' '' || loc.bie_loc_numero_domicilio || '' '' || loc.bie_loc_puerta) AS direccion, cra.dd_cra_codigo AS cartera_codigo,
          epu.dd_epu_codigo AS estado_publicacion_codigo, epu.dd_epu_descripcion AS estado_publicacion_descripcion, act.act_admision AS admision, act.act_gestion AS gestion,
          DECODE (aic.dd_aic_codigo, ''02'', 1, 0) informe_comercial, (CASE
                                                                        WHEN act.act_fecha_ind_publicable IS NOT NULL
                                                                           THEN 1
                                                                        ELSE 0
                                                                     END) AS publicacion,
          (CASE
              WHEN val1.val_id_venta IS NOT NULL OR val2.val_id_renta IS NOT NULL
                 THEN CASE
                        WHEN val1.val_id_venta IS NOT NULL AND act.dd_tco_id IN (SELECT tco.dd_tco_id
                                                                                   FROM ' || V_ESQUEMA || '.dd_tco_tipo_comercializacion tco
                                                                                  WHERE tco.dd_tco_codigo IN (''01'', ''02'', ''04''))
                           THEN 1
                        WHEN val2.val_id_renta IS NOT NULL AND act.dd_tco_id IN (SELECT tco.dd_tco_id
                                                                                   FROM ' || V_ESQUEMA || '.dd_tco_tipo_comercializacion tco
                                                                                  WHERE tco.dd_tco_codigo IN (''02'', ''03'', ''04''))
                           THEN 1
                        ELSE 0
                     END
              ELSE 0
           END
          ) AS precio
     FROM ' || V_ESQUEMA || '.act_activo act LEFT JOIN ' || V_ESQUEMA || '.dd_cra_cartera cra ON cra.dd_cra_id = act.dd_cra_id
          LEFT JOIN ' || V_ESQUEMA || '.dd_sac_subtipo_activo sac ON sac.dd_sac_id = act.dd_sac_id
          LEFT JOIN ' || V_ESQUEMA || '.dd_tpa_tipo_activo tpa ON tpa.dd_tpa_id = act.dd_tpa_id
          LEFT JOIN ' || V_ESQUEMA || '.bie_localizacion loc ON act.bie_id = loc.bie_id
          LEFT JOIN remmaster.dd_tvi_tipo_via tvi ON loc.dd_tvi_id = tvi.dd_tvi_id
          LEFT JOIN ' || V_ESQUEMA || '.dd_epu_estado_publicacion epu ON act.dd_epu_id = epu.dd_epu_id
          LEFT JOIN ' || V_ESQUEMA || '.act_ico_info_comercial ico ON act.act_id = ico.act_id AND ico.borrado = 0
          LEFT JOIN ' || V_ESQUEMA || '.act_pac_perimetro_activo pac ON act.act_id = pac.act_id AND pac.borrado = 0
          LEFT JOIN ' || V_ESQUEMA || '.act_hic_est_inf_comer_hist hic ON act.act_id = hic.act_id
          LEFT JOIN ' || V_ESQUEMA || '.dd_aic_accion_inf_comercial aic ON hic.dd_aic_id = aic.dd_aic_id
          JOIN ' || V_ESQUEMA || '.dd_scm_situacion_comercial scm ON act.dd_scm_id = scm.dd_scm_id AND scm.dd_scm_codigo != ''01'' AND scm.dd_scm_codigo != ''05''
          LEFT JOIN
          (SELECT val_id AS val_id_venta, act_id AS act_id_val_venta
             FROM ' || V_ESQUEMA || '.act_val_valoraciones val JOIN ' || V_ESQUEMA || '.dd_tpc_tipo_precio tpc ON (val.dd_tpc_id = tpc.dd_tpc_id AND tpc.dd_tpc_codigo = ''02'' AND val.borrado = 0)
                  ) val1 ON val1.act_id_val_venta = act.act_id
          LEFT JOIN
          (SELECT val_id AS val_id_renta, act_id AS act_id_val_renta
             FROM ' || V_ESQUEMA || '.act_val_valoraciones val JOIN ' || V_ESQUEMA || '.dd_tpc_tipo_precio tpc ON (val.dd_tpc_id = tpc.dd_tpc_id AND tpc.dd_tpc_codigo = ''03'' AND val.borrado = 0)
                  ) val2 ON val2.act_id_val_renta = act.act_id
    WHERE (pac.pac_id IS NULL OR pac.pac_check_comercializar = 1) AND (hic.hic_fecha IS NULL OR hic.hic_fecha = 
	NVL(
    	(SELECT MAX (hist2.hic_fecha)
        	FROM ' || V_ESQUEMA || '.act_hic_est_inf_comer_hist hist2
        	JOIN ' || V_ESQUEMA || '.dd_aic_accion_inf_comercial aic ON hist2.dd_aic_id = aic.dd_aic_id
        	WHERE act.act_id = hist2.act_id and aic.DD_AIC_CODIGO in (''02'',''04''))
  		,
      	(SELECT MAX (hist2.hic_fecha)
        	FROM ' || V_ESQUEMA || '.act_hic_est_inf_comer_hist hist2
        	JOIN ' || V_ESQUEMA || '.dd_aic_accion_inf_comercial aic ON hist2.dd_aic_id = aic.dd_aic_id
        	WHERE act.act_id = hist2.act_id and aic.DD_AIC_CODIGO in (''01'',''02'',''03'',''04''))
  )

) AND act.borrado = 0
';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;