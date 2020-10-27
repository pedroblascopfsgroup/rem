--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11815
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-11815'; -- USUARIO CREAR/MODIFICAR
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS USUARIOS DE LAS TAREAS EN VUELO');  

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
                USING (SELECT UNIQUE TAC.TAR_ID, USU2.USU_ID
                        FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON ECO.OFR_ID = OFR.OFR_ID AND OFR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON OFR.OFR_ID=AOFR.OFR_ID
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID=ACT.ACT_ID AND TAC.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID=TAC.TAR_ID AND TAR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID=TAR.TAR_ID AND TEX.BORRADO=0
                        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID AND USU.BORRADO=0
                        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS SUP ON TAC.SUP_ID = SUP.USU_ID AND SUP.BORRADO=0
                        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID=TEX.TAP_ID AND TAP.BORRADO=0
                        
                        INNER JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO.ECO_ID
                        INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                        INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GFORM'') AND GEE.BORRADO = 0
                    	INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GFORM'') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU2 ON GEE.USU_ID = USU2.USU_ID
                        
                        LEFT JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID AND EEC.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO=0
                        
                    WHERE ECO.BORRADO = 0 
                    AND TAR.TAR_TAREA_FINALIZADA = 0 
                    AND TAP.TAP_CODIGO IN (''T017_PBCReserva'')
                    AND CRA.DD_CRA_CODIGO = (SELECT DD_CRA_CODIGO FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_DESCRIPCION = ''BBVA'')
                    AND EEC.DD_EEC_CODIGO != ''02'' AND EOF.DD_EOF_CODIGO != ''02'') AUX 
                    ON (TAC.TAR_ID = AUX.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                TAC.SUP_ID = AUX.USU_ID, TAC.USUARIOMODIFICAR = '''||V_USUARIO||''', TAC.FECHAMODIFICAR = SYSDATE';
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
