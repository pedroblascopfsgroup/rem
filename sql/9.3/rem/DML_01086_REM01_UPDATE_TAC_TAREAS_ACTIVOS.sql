--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220831
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12151
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de usuario tareas
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


DECLARE
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12151'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
                USING(
                SELECT TAC.TAR_ID FROM ACT_ACTIVO act
                JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac ON tac.ACT_ID = act.ACT_ID AND tac.BORRADO=0
                JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra ON tra.TRA_ID = tac.TRA_ID AND tra.BORRADO = 0
                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar ON tar.TAR_ID = tac.TAR_ID AND tar.BORRADO= 0
                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex ON tex.TAR_ID = tar.TAR_ID AND tex.BORRADO = 0
                JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap ON tap.TAP_ID = tex.TAP_ID AND tap.BORRADO = 0
                WHERE act.BORRADO=0 AND tra.TRA_FECHA_FIN IS NULL AND tar.TAR_TAREA_FINALIZADA = 0
                AND tar.TAR_FECHA_FIN IS NULL
                AND tap.TAP_CODIGO IN (''T011_AnalisisPeticionCorreccion'',''T011_RevisionInformeComercial'')
				) T2
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''usugrupub''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN TAC_TAREAS_ACTIVOS');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');

	COMMIT;
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;