 --/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3027
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
  /*EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || ' (act_id,
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
';*/

EXECUTE IMMEDIATE 'WITH VISTA_ACT_PUB AS (
  SELECT 
    ACT.ACT_ID    
    , ACT.ACT_NUM_ACTIVO AS ACT_NUM_ACTIVO
    , TPA.DD_TPA_CODIGO AS TIPO_ACTIVO_CODIGO
    , TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO_DESCRIPCION
    , SAC.DD_SAC_CODIGO AS SUBTIPO_ACTIVO_CODIGO
    , SAC.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO_DESCRIPCION
    , TVI.DD_TVI_DESCRIPCION || '' '' || LOC.BIE_LOC_NOMBRE_VIA || '' '' || LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.BIE_LOC_PUERTA AS DIRECCION
    , CRA.DD_CRA_CODIGO AS CARTERA_CODIGO
    , EPU.DD_EPU_CODIGO AS ESTADO_PUBLICACION_CODIGO
    , EPU.DD_EPU_DESCRIPCION AS ESTADO_PUBLICACION_DESCRIPCION
    , ACT.ACT_ADMISION AS ADMISION
    , ACT.ACT_GESTION AS GESTION
    , DECODE (AIC.DD_AIC_CODIGO, ''02'', 1, 0) INFORME_COMERCIAL
    , CASE 
        WHEN ACT.ACT_FECHA_IND_PUBLICABLE IS NULL THEN 0 
        ELSE 1 
      END AS PUBLICACION
    , CASE 
        WHEN NVL(TPC.DD_TPC_CODIGO,''00'') = ''02'' AND NVL(TCO.DD_TCO_CODIGO,''00'') IN (''01'',''02'',''04'') THEN 1 
        WHEN NVL(TPC.DD_TPC_CODIGO,''00'') = ''03'' AND NVL(TCO.DD_TCO_CODIGO,''00'') IN (''02'',''03'',''04'') THEN 1
        ELSE 0 
      END AS PRECIO
    , TPC.DD_TPC_CODIGO
    , TCO.DD_TCO_CODIGO
    , HIC.HIC_FECHA
    , AIC.DD_AIC_CODIGO
    , ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY DECODE(AIC.DD_AIC_CODIGO,''02'',0,''04'',0,''01'',1,''03'',1,2), HIC.HIC_FECHA DESC, DECODE(TPC.DD_TPC_CODIGO||TCO.DD_TCO_CODIGO,''0201'',0,''0202'',0,''0204'',0,''0302'',0,''0303'',0,''0304'',0,1)) RN
  FROM REM01.ACT_ACTIVO ACT 
  JOIN REM01.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.DD_SCM_CODIGO IN (''02'',''03'',''04'',''06'',''07'',''08'',''09'')
  LEFT JOIN REM01.ACT_HIC_EST_INF_COMER_HIST HIC ON ACT.ACT_ID = HIC.ACT_ID
  LEFT JOIN REM01.DD_AIC_ACCION_INF_COMERCIAL AIC ON HIC.DD_AIC_ID = AIC.DD_AIC_ID AND AIC.DD_AIC_CODIGO IN (''01'',''02'',''03'',''04'')
  LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
  LEFT JOIN REM01.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
  LEFT JOIN REM01.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
  LEFT JOIN REM01.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID
  LEFT JOIN REMMASTER.DD_TVI_TIPO_VIA TVI ON LOC.DD_TVI_ID = TVI.DD_TVI_ID
  LEFT JOIN REM01.DD_EPU_ESTADO_PUBLICACION EPU ON ACT.DD_EPU_ID = EPU.DD_EPU_ID
  LEFT JOIN REM01.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
  LEFT JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID AND PAC.BORRADO = 0
  LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0
  LEFT JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO IN (''02'',''03'')
  LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID AND TCO.DD_TCO_CODIGO IN (''01'',''02'',''03'',''04'')
  WHERE (PAC.PAC_ID IS NULL OR PAC.PAC_CHECK_COMERCIALIZAR = 1) AND ACT.BORRADO = 0)
  SELECT ACT_ID, ACT_NUM_ACTIVO, TIPO_ACTIVO_CODIGO, TIPO_ACTIVO_DESCRIPCION, SUBTIPO_ACTIVO_CODIGO, SUBTIPO_ACTIVO_DESCRIPCION
    , DIRECCION, CARTERA_CODIGO, ESTADO_PUBLICACION_CODIGO, ESTADO_PUBLICACION_DESCRIPCION, ADMISION, GESTION, INFORME_COMERCIAL
    , PUBLICACION, PRECIO
  FROM VISTA_ACT_PUB
  WHERE RN = 1';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;