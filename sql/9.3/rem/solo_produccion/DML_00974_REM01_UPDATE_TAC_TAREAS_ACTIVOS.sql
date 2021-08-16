--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10180
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de países
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10180'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS act
                USING(

                SELECT act.ACT_ID FROM ACT_ACTIVO act
                JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS tac ON tac.ACT_ID = act.ACT_ID
                JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE tra ON tra.TRA_ID = tac.TRA_ID
                JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES tar ON tar.TAR_ID = tac.TAR_ID
                JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA tex ON tex.TAR_ID = tar.TAR_ID
                JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO tap ON tap.TAP_ID = tex.TAP_ID
                WHERE act.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''02'')
                AND tac.BORRADO = 0
                AND act.BORRADO=0
                AND tra.BORRADO=0
                AND tra.TRA_FECHA_FIN IS NULL
                AND tar.BORRADO= 0
                AND tar.TAR_TAREA_FINALIZADA = 0
                AND tar.TAR_FECHA_FIN IS NULL
                AND tra.DD_EPR_ID = 30
                AND tex.BORRADO = 0
                AND tap.BORRADO = 0
                AND tap.TAP_CODIGO= ''T011_AnalisisPeticionCorreccion''
				) us
				
                ON (act.ACT_ID = us.ACT_ID)
                WHEN MATCHED THEN UPDATE SET 
                act.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''rabad''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN BIE_LOCALIZACION');

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