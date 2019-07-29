--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190722
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4880
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4880';
    V_SQL VARCHAR2(8192 CHAR);


BEGIN			

	------------------------------------------------------------------------------------------------------
	-- Trata el caso 3 del item:
	-- 3 Para todos los activos que tengan el check de admisión a 1 sacar tareas abiertas del tramite de trabajos admisión
	DBMS_OUTPUT.PUT_LINE(' ----------------------------------- ');
	DBMS_OUTPUT.PUT_LINE(' --        Trata el caso 3        -- ');

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
        USING (

		SELECT DISTINCT TRA.TRA_ID, ACT.ACT_ID, TAR.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
			'||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
			'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
			'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
			'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
			'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
		WHERE  1=1
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID

		AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
		AND TRA.DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T001'' )    
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
		AND ACT.ACT_ADMISION = 1

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  



	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT DISTINCT TAR.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
			'||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
			'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
			'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
			'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
			'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
		WHERE  1=1
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID

		AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
		AND TRA.DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T001'' )    
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
		AND ACT.ACT_ADMISION = 1

        ) T2 
        ON (T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE,
	    T1.TAR_TAREA_FINALIZADA = 1,
	    T1.TAR_FECHA_FIN = SYSDATE,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Cerrar tareas ');

										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
        USING (

		SELECT DISTINCT TRA.TRA_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
			'||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
			'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
			'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
			'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
			'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
		WHERE  1=1
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID

		AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
		AND TRA.DD_TPO_ID = (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''T001'' )    
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
		AND ACT.ACT_ADMISION = 1

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05''),
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE,
	    T1.TRA_FECHA_FIN = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE '); 

	------------------------------------------------------------------------------------------------------
	-- Trata el caso 4 del item:
	-- 4 Para todos los activos que tengan el check de gestión a 1 sacar tareas abiertas del tramite de trabajos.

	DBMS_OUTPUT.PUT_LINE(' ----------------------------------- ');
	DBMS_OUTPUT.PUT_LINE(' --        Trata el caso 4        -- ');
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

	        SELECT DISTINCT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
	        ( SELECT COALESCE( TRA.ACT_ID, ACT_TBJ.ACT_ID ) AS ACT_ID, TRA_ID, TRA.TBJ_ID
	          FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
	          LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ
	            ON ACT_TBJ.TBJ_ID = TRA.TBJ_ID
	          WHERE TRA.BORRADO = 0  
	          AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
	         ) TRA,
		'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	        '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
	        '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
		WHERE  1=1

		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID 
		AND TTR.DD_TTR_FILTRAR IS NULL
    
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
		AND ACT.ACT_GESTION = 1

        ) T2 
        ON (T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE,
	    T1.TAR_TAREA_FINALIZADA = 1,
	    T1.TAR_FECHA_FIN = SYSDATE,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  

-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
        USING (

		SELECT DISTINCT TRA.TRA_ID, ACT.ACT_ID, TAR.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
	        ( SELECT COALESCE( TRA.ACT_ID, ACT_TBJ.ACT_ID ) AS ACT_ID, TRA_ID, TRA.TBJ_ID
	          FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
	          LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ
	            ON ACT_TBJ.TBJ_ID = TRA.TBJ_ID
	          WHERE TRA.BORRADO = 0  
	          AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
	         ) TRA,
		'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	        '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
	        '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
		WHERE  1=1

		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID 
		AND TTR.DD_TTR_FILTRAR IS NULL
    
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
		AND ACT.ACT_GESTION = 1

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Cerrar tareas ');

										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
        USING (

		SELECT DISTINCT TRA.TRA_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,        
	        ( SELECT COALESCE( TRA.ACT_ID, ACT_TBJ.ACT_ID ) AS ACT_ID, TRA_ID, TRA.TBJ_ID
	          FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
	          LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ
	            ON ACT_TBJ.TBJ_ID = TRA.TBJ_ID
	          WHERE TRA.BORRADO = 0  
	          AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
	         ) TRA,
		'||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		'||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		'||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	        '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
	        '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
		WHERE  1=1

		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID 
		AND TTR.DD_TTR_FILTRAR IS NULL
    
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
		AND ACT.ACT_GESTION = 1

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05''),
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE,
	    T1.TRA_FECHA_FIN = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE '); 



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
