--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6222
--## PRODUCTO=NO
--## 
--## Finalidad: REASIGNAR TAREAS A ELECNOR
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= '';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-6222';
    ACT_NUM_ACTIVO NUMBER(16);
    ACT_ID VARCHAR2(55 CHAR);

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion DE TAREAS');
		
		V_SQL := '  MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
					USING (
							SELECT DISTINCT TAC.TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
							INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TEX.TAR_ID
							INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
							INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
							INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TRA.TBJ_ID = TBJ.TBJ_ID
							INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
							WHERE TRA.DD_EPR_ID = 30 AND TBJ.PVC_ID = (SELECT PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''paci03''))
							AND TAP.TAP_CODIGO = ''T003_EmisionCertificado'' AND TAR.BORRADO = 0 AND TAC.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''---------.29'')
                    			)T2
					ON (T1.TAR_ID = T2.TAR_ID)
					WHEN MATCHED THEN 
					UPDATE SET 
						T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''paci03''),
						T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
						T1.FECHAMODIFICAR = SYSDATE';

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS.');

		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
