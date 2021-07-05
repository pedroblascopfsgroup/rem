--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10085
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia el usuario de las tareas activas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10085'; -- USUARIO CREAR/MODIFICAR
    V_USERNAME VARCHAR2(50 CHAR) := 'grusbackoffice';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS USUARIOS DE LAS TAREAS EN VUELO');  

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
                USING (SELECT UNIQUE TAC.TAR_ID, (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||''') SUP_ID
                        FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                        join '||V_ESQUEMA||'.ofr_ofertas ofr on eco.ofr_id = ofr.ofr_id AND OFR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON ofr.ofr_id=AOFR.ofr_id
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID=ACT.ACT_ID AND TAC.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID=TAC.TAR_ID AND TAR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID=TAR.TAR_ID AND TEX.BORRADO=0
                        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID AND usu.BORRADO=0
                        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS SUP ON TAC.SUP_ID = SUP.USU_ID AND SUP.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID AND TAP.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOs_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO=0
                    WHERE ECO.BORRADO = 0 AND TAR.TAR_TAREA_FINALIZADA = 0
                    AND TAP.TAP_CODIGO IN (''T013_InstruccionesReserva'',''T013_ObtencionContratoReserva'',''T013_DefinicionOferta'',''T013_FirmaPropietario'',
                    ''T013_PendienteDevolucion'',''T013_RatificacionComite'',''T013_ResolucionComite'',''T013_ResolucionExpediente'',''T013_RespuestaBankiaAnulacionDevolucion'',
                    ''T013_RespuestaBankiaDevolucion'',''T013_RespuestaOfertante'',''T013_ValidacionClientes'',''T017_DefinicionOferta'',''T017_AnalisisPM'',''T017_ResolucionCES'',''T017_RatificacionComiteCES'',
                    ''T017_RespuestaOfertanteCES'',''T017_AdvisoryNote'',''T017_PBCReserva'',''T017_PBCVenta'',''T017_RecomendCES'',''T017_ResolucionPROManzana'',''T017_ResolucionExpediente'',''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'',
                    ''T017_PosicionamientoYFirma'',''T017_DocsPosVenta'',''T017_CierreEconomico'',''T017_ResolucionDivarian'',''T017_ResolucionArrow'')
                    AND CRA.DD_CRA_CODIGO in (''01'',''02'',''03'',''08'',''16'') AND EEC.DD_EEC_CODIGO != ''02'' AND EEC.DD_EEC_CODIGO != ''08'' AND EOF.DD_EOF_CODIGO != ''02''
                ) AUX ON (TAC.TAR_ID = AUX.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                TAC.SUP_ID = AUX.SUP_ID, TAC.USUARIOMODIFICAR = '''||V_USUARIO||''', TAC.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN TAC: ' ||sql%rowcount);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');
   

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
