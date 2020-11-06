--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8317
--## PRODUCTO=NO
--##
--## Finalidad: Modificar gestor Tareas en vuelo subcartera apple, tarea posicionamiento y firma
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8317'; -- USUARIO CREAR/MODIFICAR
    V_USERNAME VARCHAR2(50 CHAR) := 'grucierreventa';
    V_TAP_CODIGO VARCHAR2(50 CHAR):= 'T017_PosicionamientoYFirma';
    V_DD_TIPO_PROCEDIMIENTO VARCHAR2(50 CHAR):='T017';
    V_DD_TGE_CODIGO VARCHAR2(50 CHAR):='GIAFORM';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS USUARIOS DE LAS TAREAS EN VUELO');  

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
                USING (SELECT DISTINCT TAC2.TAR_ID,USU.USU_ID
                        FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
                        JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL eco ON ECO.OFR_ID = OFR.OFR_ID
                        JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj ON TBJ.TBJ_ID = ECO.TBJ_ID AND TBJ.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON OFR.OFR_ID=AOFR.OFR_ID
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID=ACT.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO tpo ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND TPO.DD_TPO_CODIGO = '''||V_DD_TIPO_PROCEDIMIENTO||'''
                        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC2 ON TAC2.TRA_ID = TRA.TRA_ID
                        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar ON TAR.TAR_ID = TAC2.TAR_ID
                        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex ON TEX.TAR_ID = TAR.TAR_ID
                        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap ON TAP.TAP_ID = TEX.TAP_ID AND TAP.TAP_CODIGO = '''||V_TAP_CODIGO||''' AND TAR.TAR_TAREA_FINALIZADA = 0
                        INNER JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO.ECO_ID
                        INNER JOIN '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO GCO ON GCO.ECO_ID = ECO.ECO_ID
                        INNER JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GCO.GEE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_DD_TGE_CODIGO||''') AND GEE.BORRADO = 0
                        INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = '''||V_DD_TGE_CODIGO||''') AND GEH.GEH_FECHA_HASTA IS NULL AND GEH.BORRADO = 0                      
                        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID=GEE.USU_ID AND USU.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=ACT.DD_SCR_ID AND SCR.BORRADO=0
                        WHERE TAC2.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||''') 
                        AND ACT.DD_CRA_ID=(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO=''07'')
                        AND ACT.DD_SCR_ID=(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO=''138'')
                ) AUX ON (TAC.TAR_ID = AUX.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                TAC.USU_ID = AUX.USU_ID, TAC.USUARIOMODIFICAR = '''||V_USUARIO||''', TAC.FECHAMODIFICAR = SYSDATE';
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