--/*
--##########################################
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13790
--## PRODUCTO=NO
--## Finalidad: Cambio de obtención de datos ES_CONDICIONADO(Mejora de rendimiento)
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Daniel Gallego
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
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEM_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ES_CONDICIONADO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ES_CONDICIONADO...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ES_CONDICIONADO';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ES_CONDICIONADO... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ES_CONDICIONADO...');
  V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.v_es_condicionado (act_id,es_condicionado)
AS
SELECT act.act_id, 
CASE WHEN ( 
  (FPA.FECHA_POSESION IS NULL AND aba2.dd_cla_id = 2)               -- SIN TOMA POSESION INICIAL
    OR eac1.dd_eac_codigo=''05''                                                  -- RUINA
    OR NVL2 (tit.act_id, 0, 1) = 1
    OR NVL2 (eon.dd_eon_id, 1, 0) = 1
    OR NVL2 (npa.act_id, 1, 0) = 1
    OR (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'' OR eac1.dd_eac_codigo = ''07'')               -- OBRA NUEVA EN CONSTRUCCIÓN/VANDALIZADO
    OR (sps1.sps_ocupado = 1 AND TPA.DD_TPA_CODIGO = ''01'')                        -- OCUPADO CON TITULO
    OR sps1.sps_acc_tapiado = 1                                                  -- TAPIADO
    OR (sps1.sps_ocupado = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03''))                        -- OCUPADO SIN TITULO
    OR NVL2 (reg2.reg_id, 1, 0) = 1
    OR NVL2(sps1.sps_otro,1,0) = 1                                               -- OTROS MOTIVOS
    --OR DECODE(VEI.DD_AIC_CODIGO ,''02'' ,0 , 1) = 1                              -- sin_informe_aprobado
    )
  OR NVL2 (vcg.con_cargas, vcg.con_cargas, 0) = 1
  THEN 1
  ELSE 0

END AS est_disp_com_codigo1 
  
  FROM ACT_ACTIVO act  
  LEFT JOIN REM01.V_FECHA_POSESION_ACTIVO FPA ON FPA.ACT_ID = ACT.ACT_ID
  LEFT JOIN REM01.dd_eac_estado_activo eac1 ON eac1.dd_eac_id = act.dd_eac_id
  LEFT JOIN REM01.vi_activos_con_cargas vcg ON vcg.act_id = act.act_id
  LEFT JOIN REM01.act_sps_sit_posesoria sps1 ON sps1.act_id = act.act_id
  LEFT JOIN REM01.act_reg_info_registral reg2 ON reg2.act_id = act.act_id AND reg2.reg_div_hor_inscrito = 0  
  LEFT JOIN REM01.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS1.DD_TPA_ID
  LEFT JOIN REM01.v_num_propietariosactivo npa ON npa.act_id = act.act_id  
  LEFT JOIN REM01.act_reg_info_registral reg1 ON reg1.act_id = act.act_id
  LEFT JOIN REM01.dd_eon_estado_obra_nueva eon ON eon.dd_eon_id = reg1.dd_eon_id AND eon.dd_eon_codigo IN (''02'')
  LEFT JOIN (SELECT act_tit.act_id
              FROM REM01.act_reg_info_registral act_reg
              LEFT JOIN REM01.act_aba_activo_bancario aba ON aba.act_id = act_reg.act_id
              JOIN REM01.ACT_TIT_TITULO act_tit ON act_tit.act_id = act_reg.act_id
              JOIN REM01.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_DREG_ID = act_REG.BIE_DREG_ID
              WHERE aba.dd_cla_id = 1 OR act_tit.TIT_FECHA_INSC_REG IS NOT NULL) tit ON tit.act_id = act.act_id  
LEFT JOIN REM01.act_aba_activo_bancario aba2 ON aba2.act_id = act.act_id                    ';

  EXECUTE IMMEDIATE V_MSQL;
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ES_CONDICIONADO...Creada OK');

  COMMIT;

  
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   

END;

/

EXIT;

