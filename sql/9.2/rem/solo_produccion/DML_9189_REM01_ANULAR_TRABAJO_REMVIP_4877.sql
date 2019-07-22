--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190719
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4877
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4877';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Cerrar tareas ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
        USING (

		SELECT DISTINCT TRA.TRA_ID, TRA.TBJ_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		     '||V_ESQUEMA||'.AUX_REMVIP_4877_TBJ AUX
		WHERE  1=1
		AND AUX.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO

		AND TBJ.TBJ_ID = TRA.TBJ_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
        
        	AND ( TRA.BORRADO = 0 )
        	AND ( TBJ.BORRADO = 0 )
        	AND ( TAC.BORRADO = 0 )
        	AND ( TEX.BORRADO = 0 )
        	AND ( TAP.BORRADO = 0 )
        	AND ( TAR.BORRADO = 0 )

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.TBJ_ID = T2.TBJ_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05''),
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE ');  

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TBJ_TRABAJO - Cambiar estado a "ANULADO" ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1
        USING (

		SELECT AUX.TBJ_NUM_TRABAJO
		FROM  '||V_ESQUEMA||'.AUX_REMVIP_4877_TBJ AUX
		WHERE 1 = 1

        ) T2 
        ON (T1.TBJ_NUM_TRABAJO = T2.TBJ_NUM_TRABAJO )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_EST_ID = ( SELECT DD_EST_ID FROM DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = ''02'' ),
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TBJ_TRABAJO ');  

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
