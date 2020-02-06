--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6243
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6243';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN					

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT DISTINCT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
		WHERE  1=1
        	AND TRA.BORRADO = 0
        	AND ACT.BORRADO = 0
        	AND TAC.BORRADO = 0
        	AND TEX.BORRADO = 0
        	AND TAR.BORRADO = 0
		AND TRA.TRA_ID IN
				        (        
						183448,
						184551,
						184396,
						157022,
						291930,
						232981,
						304785,
						263700,
						174970,
						179853,
						220382,
						304848,
						233053,
						284573,
						296810,
						220299,
						310697,
						304592,
						184558,
						123438,
						220312,
						292383,
						291424,
						220049,
						235302,
						224362,
						220039,
						156554                
				        )

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.ACT_ID = ACT.ACT_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID

        ) T2 
        ON (T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE,
	    T1.TAR_FECHA_FIN = SYSDATE,
	    T1.TAR_TAREA_FINALIZADA = 1

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  


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
