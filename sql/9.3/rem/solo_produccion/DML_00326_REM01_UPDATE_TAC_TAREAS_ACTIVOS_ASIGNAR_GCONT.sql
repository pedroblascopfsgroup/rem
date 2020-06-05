--/*
--###########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7436
--## PRODUCTO=NO
--## 
--## Finalidad: ASIGNAR GCONT TAREAS CIERRE ECONOMICO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7436';
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ASIGNAR TAREAS ''T013_CierreEconomico'' Y ''T017_CierreEconomico'' A GESTOR CONTROLLER');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucontroller''),
				USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
				WHERE TAR_ID IN (
					SELECT TAR.TAR_ID FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
					INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TAR.TAR_ID AND TAC.BORRADO = 0
					INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID AND TEX.BORRADO = 0
					INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
					INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = TAC.USU_ID
					WHERE TAR.BORRADO = 0 AND TAP.TAP_CODIGO IN (''T013_CierreEconomico'', ''T017_CierreEconomico'') 
					AND TAR.TAR_TAREA_FINALIZADA = 0 AND TAR.FECHACREAR > TO_DATE(''31/12/2019'', ''DD/MM/YYYY'')
					AND USU.USU_USERNAME <> ''grucontroller''
				)';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros EN TAC_TAREAS_ACTIVOS ');  

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
