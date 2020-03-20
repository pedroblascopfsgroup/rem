--/*
--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6295
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6295';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
													
-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
		        USING (			
					SELECT DISTINCT TAC.TAR_ID
					FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
					     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TRA.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
					     INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
					     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			             INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
					WHERE TRA.TRA_ID IN
					(
						310617,
						296765
					)
		        ) T2 
        		ON (T1.TAR_ID = T2.TAR_ID )
				WHEN MATCHED THEN 
					UPDATE
					SET T1.BORRADO = 1,
					    T1.USUARIOBORRAR = '''||V_USUARIOMODIFICAR||''',
					    T1.FECHABORRAR   = SYSDATE,
					    T1.TAR_FECHA_FIN = SYSDATE,
					    T1.TAR_TAREA_FINALIZADA = 1';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
		        USING (		
					SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID
					FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
					     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TRA.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
					     INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
					     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			             INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
					WHERE TRA.TRA_ID IN
					(
						310617,
						296765
					)
		        ) T2 
		        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID )
				WHEN MATCHED THEN UPDATE
				SET T1.BORRADO = 1,
				    T1.USUARIOBORRAR = '''||V_USUARIOMODIFICAR||''',
				    T1.FECHABORRAR   = SYSDATE,
				    T1.TRA_FECHA_FIN = SYSDATE'

	;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
		        USING (
					SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
					FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
					     INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TRA.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID = ACT.ACT_ID
					     INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
					     INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
					     INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
			             INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID
					WHERE TRA.TRA_ID IN
					(
						310617,
						296765
					)		
		        ) T2 
		        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
				WHEN MATCHED THEN UPDATE
				SET T1.BORRADO = 1,
				    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
				    T1.FECHABORRAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  


-----------------------------------------------------------------------------------------------------------------


	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
