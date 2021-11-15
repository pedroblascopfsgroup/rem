--/*
--##########################################
--## AUTOR=vIOREL rEMUSD oVIDIU
--## FECHA_CREACION=20211111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-REMVIP-10737
--## PRODUCTO=NO
--##
--## Finalidad: Script modificar usuarios
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10490'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO rem01.eco_expediente_comercial T1 USING 
			(
			select distinct eco.eco_id, ofr.ofr_num_oferta, eco.eco_num_expediente, tap.tap_codigo, eco.fechamodificar
			from '||V_ESQUEMA||'.eco_expediente_comercial eco
			inner join '||V_ESQUEMA||'.act_ofr actofr on actofr.ofr_id = eco.ofr_id
			inner join '||V_ESQUEMA||'.ofr_ofertas ofr on ofr.ofr_id = actofr.ofr_id
			inner join '||V_ESQUEMA||'.act_activo act on act.act_id = actofr.act_id
			inner join '||V_ESQUEMA||'.act_tra_tramite atr on eco.tbj_id = atr.tbj_id
			inner join '||V_ESQUEMA||'.tac_tareas_activos tac on atr.tra_id = tac.tra_id
			inner join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id
			inner join '||V_ESQUEMA||'.tex_tarea_externa txt on txt.tar_id = tar.tar_id
			inner join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on txt.tap_id = tap.tap_id
			inner join '||V_ESQUEMA||'.dd_eec_est_exp_comercial eec on eec.dd_eec_id = eco.dd_eec_id and dd_eec_codigo = ''06''
			where tar.tar_tarea_finalizada in (0)
			and tap.tap_codigo in (''T017_InstruccionesReserva'', ''T017_ObtencionContratoReserva'', ''T017_PBCReserva'')
			and act.dd_cra_id not in (21)
			and eco.fechamodificar >= to_date(''05/11/2021'', ''dd/MM/yyyy'')
			)
			 T2 
			ON (T1.eco_id = T2.eco_id)
			WHEN MATCHED THEN UPDATE SET 
			T1.USUARIOMODIFICAR = '''REMVIP-10737''',
			T1.FECHAMODIFICAR = SYSDATE,
			T1.DD_EEC_ID = 11';
			
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' expedientes');
		COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT
