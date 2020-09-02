--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso Canovas
--## FECHA_CREACION=20200826
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.11.0
--## INCIDENCIA_LINK=REMVIP-7935
--## PRODUCTO=NO
--##
--## Finalidad: Crear vista V_ACT_ESTADO_DISP
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##		0.2 Juan Bautista Alfonso - - REMVIP-7935 - Modificado fecha posesion para que cargue de la vista V_FECHA_POSESION_ACTIVO
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] Crear vista V_ACT_ESTADO_DISP');
	
	V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.V_ACT_ESTADO_DISP as (
	    SELECT act.act_id,
		    CASE WHEN ( (FPA.FECHA_POSESION IS NULL AND aba2.dd_cla_id = 2)               -- SIN TOMA POSESION INICIAL
		               OR eac1.dd_eac_codigo=''05''                                                   -- RUINA
		               OR NVL2 (tit.act_id, 0, 1) = 1
		               OR NVL2 (eon.dd_eon_id, 1, 0) = 1
		               OR NVL2 (npa.act_id, 1, 0) = 1
		               OR (eac1.dd_eac_codigo = ''02''  OR   eac1.dd_eac_codigo = ''06'' OR eac1.dd_eac_codigo = ''07'')               -- OBRA NUEVA EN CONSTRUCCIÓN/VANDALIZADO
		               OR (sps1.sps_ocupado = 1 AND TPA.DD_TPA_CODIGO = ''01'')                        -- OCUPADO CON TITULO
		               OR sps1.sps_acc_tapiado = 1                                                  -- TAPIADO
		               OR (sps1.sps_ocupado = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03''))                        -- OCUPADO SIN TITULO
		               OR NVL2 (reg2.reg_id, 1, 0) = 1
		               OR NVL2 (sps1.sps_otro,1,0) = 1                                               -- OTROS MOTIVOS
		              ) OR NVL2 (vcg.con_cargas, vcg.con_cargas, 0) = 1
		        THEN ''01''
		        ELSE ''02''
		    END est_disp_com_codigo,
			CASE WHEN (sps1.sps_ocupado = 1 AND TPA.DD_TPA_CODIGO = ''01'')	-- OCUPADO CON TITULO
		               OR sps1.sps_acc_tapiado = 1	-- TAPIADO
		               OR (sps1.sps_ocupado = 1 AND (TPA.DD_TPA_CODIGO = ''02'' OR TPA.DD_TPA_CODIGO = ''03''))	-- OCUPADO SIN TITULO
		  			THEN 1
		            ELSE 0
		    END es_condicionado_publi
		FROM '||V_ESQUEMA||'.act_activo act 
		LEFT JOIN '||V_ESQUEMA||'.act_aba_activo_bancario aba2 ON aba2.act_id = act.act_id
		LEFT JOIN '||V_ESQUEMA||'.dd_eac_estado_activo eac1 ON eac1.dd_eac_id = act.dd_eac_id
		LEFT JOIN '||V_ESQUEMA||'.act_sps_sit_posesoria sps1 ON sps1.act_id = act.act_id
		LEFT JOIN '||V_ESQUEMA||'.V_FECHA_POSESION_ACTIVO FPA ON FPA.ACT_ID = ACT.ACT_ID
		LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA ON TPA.DD_TPA_ID = SPS1.DD_TPA_ID
		LEFT JOIN
		    (SELECT act_tit.act_id
		        FROM '||V_ESQUEMA||'.act_reg_info_registral act_reg JOIN '||V_ESQUEMA||'.act_aba_activo_bancario aba ON aba.act_id = act_reg.act_id
		        JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO act_tit ON act_tit.act_id = act_reg.act_id
		        JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_DREG_ID = act_REG.BIE_DREG_ID
		        WHERE aba.dd_cla_id = 1 OR act_tit.TIT_FECHA_INSC_REG IS NOT NULL
		    ) tit ON tit.act_id = act.act_id                                                            -- PENDIENTE DE INSCRIPCIÓN
		LEFT JOIN '||V_ESQUEMA||'.act_reg_info_registral reg1 ON reg1.act_id = act.act_id
		LEFT JOIN '||V_ESQUEMA||'.dd_eon_estado_obra_nueva eon ON eon.dd_eon_id = reg1.dd_eon_id AND eon.dd_eon_codigo IN (''02'')                                              -- OBRA NUEVA SIN DECLARAR
		LEFT JOIN '||V_ESQUEMA||'.act_reg_info_registral reg2 ON reg2.act_id = act.act_id AND reg2.reg_div_hor_inscrito = 0                                           -- DIVISIÓN HORIZONTAL NO INSCRITA
		LEFT JOIN '||V_ESQUEMA||'.v_num_propietariosactivo npa ON npa.act_id = act.act_id                                            --PROINDIVISO (VARIOS PROPIETARIOS O 1 PROPIETARIO CON %PROP < 100)
		LEFT JOIN '||V_ESQUEMA||'.vi_activos_con_cargas vcg ON vcg.act_id = act.act_id                                                                                      --SIN_INFORME_APROBADO
		WHERE act.borrado = 0)
	    order by 1 desc';
	
	EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('[INFO] Vista V_ACT_ESTADO_DISP creada');
    
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
