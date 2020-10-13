--/*
--##########################################
--## AUTOR=Carlos Augusto
--## FECHA_CREACION=20200908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11220
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar USU_ID 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-11220'; -- Usuario modificar
	PL_OUTPUT VARCHAR2(32000 CHAR);
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

  	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 USING(
	SELECT tac.tra_id,tac.tar_id,act.act_id,usu.usu_id,eco.eco_num_expediente
    FROM  '||V_ESQUEMA||'.eco_expediente_comercial eco
    inner join '||V_ESQUEMA||'.act_ofr actofr on actofr.ofr_id = eco.ofr_id
    inner join '||V_ESQUEMA||'.act_activo act on act.act_id = actofr.act_id
    inner join '||V_ESQUEMA||'.act_tra_tramite atr on eco.tbj_id = atr.tbj_id
    inner join '||V_ESQUEMA||'.tac_tareas_activos tac on atr.tra_id = tac.tra_id
    inner join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id
    inner join '||V_ESQUEMA||'.tex_tarea_externa txt on txt.tar_id = tar.tar_id
    inner join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on txt.tap_id = tap.tap_id
    inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = tac.usu_id     
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TAC.ACT_ID
     inner join '||V_ESQUEMA||'.coe_condicionantes_expediente coe on coe.eco_id=eco.eco_id
    where eco.borrado = 0
    and tar.tar_tarea_finalizada in (0)
    and tar.borrado = 0
    and eco.dd_eec_id not in(2,8,15)
     and coe.coe_solicita_reserva=1
    and tap.tap_codigo in (''T013_PBCReserva'', ''T017_PBCReserva'', ''T013_InstruccionesReserva'',''T013_ObtencionContratoReserva'',''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'')
    AND eco.eco_num_expediente NOT IN(87143,86139,17261,17236))
				AUX ON (
                    T1.TRA_ID = AUX.TRA_ID AND T1.TAR_ID = AUX.TAR_ID AND T1.ACT_ID = AUX.ACT_ID 
                    )
				WHEN MATCHED THEN UPDATE SET
				T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''gruboarding''),
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
  	
	EXECUTE IMMEDIATE V_MSQL;  
        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 


  
   			
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
