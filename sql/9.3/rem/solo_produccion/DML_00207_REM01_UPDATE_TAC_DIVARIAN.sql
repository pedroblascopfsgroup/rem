--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6930
--## PRODUCTO=NO
--##
--## Finalidad: Script que para cambia el Supervisor de Backoffice
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ID_COD_REM NUMBER(16);
    V_ID_PVC NUMBER(16);
    V_ID_ETP NUMBER(16);
    V_BOOLEAN NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-6930';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: COMENZAMOS ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS USUARIOS');  

    V_MSQL := '
                MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
                USING
                (
                    SELECT 
                        UNIQUE TAC.TAR_ID
                        , (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grusbackoffman'') SUPERVISOR
                    FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                    join '||V_ESQUEMA||'.ofr_ofertas ofr on eco.ofr_id = ofr.ofr_id
                    JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON ofr.ofr_id=AOFR.ofr_id
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID=ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID=TAC.TAR_ID
                    JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID=TAR.TAR_ID
                    JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
                    JOIN '||V_ESQUEMA_M||'.USU_USUARIOS SUP ON TAC.SUP_ID = SUP.USU_ID
                    JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID AND TAP.BORRADO=0
                    LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
                    LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOs_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID
                    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                    WHERE 
                        ECO.BORRADO = 0 
                        AND TAR.TAR_TAREA_FINALIZADA = 0
                        AND TAP.TAP_CODIGO IN (''T017_DefinicionOferta''
                        ,''T017_ResolucionCES''
                        ,''T017_RespuestaOfertanteCES''
                        ,''T017_AdvisoryNote''
                        ,''T017_RecomendCES''
                        ,''T017_ResolucionPROManzana''
                        ,''T017_ResolucionExpediente''
                        ,''T017_InstruccionesReserva''
                        ,''T017_RatificacionComiteCES''
                        ,''T017_ResolucionDivarian''
                        ,''T017_ResolucionArrow'')
                        AND SCR.DD_SCR_CODIGO IN (''151'',''152'')
                ) AUX ON (TAC.TAR_ID = AUX.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                    TAC.SUP_ID = AUX.SUPERVISOR
                    , TAC.USUARIOCREAR = ''REMVIP-6930''
                    , TAC.FECHACREAR = SYSDATE
              ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN TAC: ' ||sql%rowcount);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  MODIFICADO CORRECTAMENTE ');
   

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
