--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210701
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9982
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-9982';
    V_USU_ID NUMBER(16);

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS TAC_TAREAS_ACTIVOS ');

    V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucontroller''';
    EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1 USING (
				SELECT DISTINCT TAC.TAR_ID 
                FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL    ECO
                JOIN '||V_ESQUEMA||'.OFR_OFERTAS                 OFR ON ECO.OFR_ID = OFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_OFR                     AFR ON OFR.OFR_ID = AFR.OFR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO                  ACT ON AFR.ACT_ID = ACT.ACT_ID
                JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO       GAC ON ACT.ACT_ID = GAC.ACT_ID
                JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD          GEE ON GAC.GEE_ID = GEE.GEE_ID
                JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE             TRA ON ACT.ACT_ID = TRA.ACT_ID
                JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS          TAC ON TRA.TRA_ID = TAC.TRA_ID
                JOIN '||V_ESQUEMA_M||'.USU_USUARIOS            USU ON TAC.USU_ID = USU.USU_ID
                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES   TAR ON TAC.TAR_ID = TAR.TAR_ID
                AND TAR.TAR_TAREA = ''Cierre económico''
                AND TAR.TAR_FECHA_FIN IS NULL
                WHERE
                GEE.DD_TGE_ID = 661
                AND TAC.USU_ID != 88740    
            ) T2
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN UPDATE SET
                USU_ID = '||V_USU_ID||', 
                USUARIOMODIFICAR = '''||V_USU||''',
                FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN TAC_TAREAS_ACTIVOS');

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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