--/*
--######################################### 
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7210
--## PRODUCTO=NO
--## 
--## Finalidad:
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master 
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7210';
	
BEGIN
        DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO TABLA ACT_NOG_NOTIFICACION_GENCAT');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_NOG_NOTIFICACION_GENCAT SET BORRADO = 1, 
		USUARIOBORRAR = ''REMVIP-7210'',
		FECHABORRAR = SYSDATE 
		WHERE CMG_ID IN (SELECT distinct c.cmg_id
				FROM(
				SELECT ofr.ofr_id,
				ofr.ofr_num_oferta,
				tra.tra_id, 
				tar.tar_id,
				cmg.cmg_id,
				eco.eco_num_expediente,
				EEC.DD_EEC_DESCRIPCION as estado_expediente,
				TAP.TAP_DESCRIPCION as TAREA_ACTUAL,
				ACT.ACT_NUM_ACTIVO as NUMERO_ACTIVO,
				ROW_NUMBER() OVER(PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC) AS RN
				FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
				inner JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
				inner JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID and tar.TAR_TAREA_FINALIZADA = 0
				inner JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
				inner JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
				inner join REM01.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID 
				inner join REM01.DD_STR_SUBTIPO_TRABAJO str on str.dd_str_id = tbj.dd_str_id
				inner join REM01.DD_TTR_TIPO_TRABAJO ttr on ttr.dd_ttr_id = tbj.dd_ttr_id
				inner join REM01.ECO_EXPEDIENTE_COMERCIAL eco on ECO.tbj_id = tbj.tbj_id
				inner join REM01.DD_EEC_EST_EXP_COMERCIAL eec on eco.dd_eec_id = eec.dd_eec_id
				inner join REM01.OFR_OFERTAS ofr on ofr.ofr_id = eco.ofr_id
				inner join rem01.act_tbj atbj on atbj.tbj_id = tbj.tbj_id 
				inner join REM01.ACT_ACTIVO act on act.act_id = atbj.act_id 
				inner join REM01.ACT_CMG_COMUNICACION_GENCAT cmg on cmg.act_id = act.act_id and cmg.usuariocrear = ''MIG_DIVARIAN'' and cmg.borrado = 0
				WHERE tbj.dd_ttr_id = 23
				AND TRA.BORRADO = 0 
				and tap.tap_descripcion not in (''Informe jurídico'', ''PBC Venta'',''Resolución expediente'')
				order by ofr.ofr_num_oferta, act.act_num_activo
				)C 
		)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros .');

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO TABLA ACT_VIG_VISITA_GENCAT');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_VIG_VISITA_GENCAT SET BORRADO = 1, 
		USUARIOBORRAR = ''REMVIP-7210'',
		FECHABORRAR = SYSDATE 
		WHERE CMG_ID IN (SELECT distinct c.cmg_id
				FROM(
				SELECT ofr.ofr_id,
				ofr.ofr_num_oferta,
				tra.tra_id, 
				tar.tar_id,
				cmg.cmg_id,
				eco.eco_num_expediente,
				EEC.DD_EEC_DESCRIPCION as estado_expediente,
				TAP.TAP_DESCRIPCION as TAREA_ACTUAL,
				ACT.ACT_NUM_ACTIVO as NUMERO_ACTIVO,
				ROW_NUMBER() OVER(PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC) AS RN
				FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
				inner JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
				inner JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID and tar.TAR_TAREA_FINALIZADA = 0
				inner JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
				inner JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
				inner join REM01.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID 
				inner join REM01.DD_STR_SUBTIPO_TRABAJO str on str.dd_str_id = tbj.dd_str_id
				inner join REM01.DD_TTR_TIPO_TRABAJO ttr on ttr.dd_ttr_id = tbj.dd_ttr_id
				inner join REM01.ECO_EXPEDIENTE_COMERCIAL eco on ECO.tbj_id = tbj.tbj_id
				inner join REM01.DD_EEC_EST_EXP_COMERCIAL eec on eco.dd_eec_id = eec.dd_eec_id
				inner join REM01.OFR_OFERTAS ofr on ofr.ofr_id = eco.ofr_id
				inner join rem01.act_tbj atbj on atbj.tbj_id = tbj.tbj_id 
				inner join REM01.ACT_ACTIVO act on act.act_id = atbj.act_id 
				inner join REM01.ACT_CMG_COMUNICACION_GENCAT cmg on cmg.act_id = act.act_id and cmg.usuariocrear = ''MIG_DIVARIAN'' and cmg.borrado = 0
				WHERE tbj.dd_ttr_id = 23
				AND TRA.BORRADO = 0 
				and tap.tap_descripcion not in (''Informe jurídico'', ''PBC Venta'',''Resolución expediente'')
				order by ofr.ofr_num_oferta, act.act_num_activo
				)C 
		)';

	EXECUTE IMMEDIATE V_MSQL;


	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros .');

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO LOGICO TABLA ACT_CMG_COMUNICACION_GENCAT');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT SET BORRADO = 1, 
		USUARIOBORRAR = ''REMVIP-7210'',
		FECHABORRAR = SYSDATE 
		WHERE CMG_ID IN (SELECT distinct c.cmg_id
				FROM(
				SELECT ofr.ofr_id,
				ofr.ofr_num_oferta,
				tra.tra_id, 
				tar.tar_id,
				cmg.cmg_id,
				eco.eco_num_expediente,
				EEC.DD_EEC_DESCRIPCION as estado_expediente,
				TAP.TAP_DESCRIPCION as TAREA_ACTUAL,
				ACT.ACT_NUM_ACTIVO as NUMERO_ACTIVO,
				ROW_NUMBER() OVER(PARTITION BY TRA.TRA_ID ORDER BY TAR.TAR_ID DESC) AS RN
				FROM REM01.TAP_TAREA_PROCEDIMIENTO TAP
				inner JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAP.TAP_ID = TEX.TAP_ID
				inner JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TEX.TAR_ID = TAR.TAR_ID and tar.TAR_TAREA_FINALIZADA = 0
				inner JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TAR.TAR_ID = TAC.TAR_ID
				inner JOIN REM01.ACT_TRA_TRAMITE TRA ON TAC.TRA_ID = TRA.TRA_ID 
				inner join REM01.ACT_TBJ_trabajo tbj on tbj.TBJ_ID = TRA.TBJ_ID 
				inner join REM01.DD_STR_SUBTIPO_TRABAJO str on str.dd_str_id = tbj.dd_str_id
				inner join REM01.DD_TTR_TIPO_TRABAJO ttr on ttr.dd_ttr_id = tbj.dd_ttr_id
				inner join REM01.ECO_EXPEDIENTE_COMERCIAL eco on ECO.tbj_id = tbj.tbj_id
				inner join REM01.DD_EEC_EST_EXP_COMERCIAL eec on eco.dd_eec_id = eec.dd_eec_id
				inner join REM01.OFR_OFERTAS ofr on ofr.ofr_id = eco.ofr_id
				inner join rem01.act_tbj atbj on atbj.tbj_id = tbj.tbj_id 
				inner join REM01.ACT_ACTIVO act on act.act_id = atbj.act_id 
				inner join REM01.ACT_CMG_COMUNICACION_GENCAT cmg on cmg.act_id = act.act_id and cmg.usuariocrear = ''MIG_DIVARIAN'' and cmg.borrado = 0
				WHERE tbj.dd_ttr_id = 23
				AND TRA.BORRADO = 0 
				and tap.tap_descripcion not in (''Informe jurídico'', ''PBC Venta'',''Resolución expediente'')
				order by ofr.ofr_num_oferta, act.act_num_activo
				)C 
		)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros .');

    	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
  
EXCEPTION
	WHEN OTHERS THEN 
	    DBMS_OUTPUT.PUT_LINE('KO!');
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    
	    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
	    DBMS_OUTPUT.PUT_LINE(err_msg);
	    
	    ROLLBACK;
	    RAISE;          

END;
/
EXIT;
