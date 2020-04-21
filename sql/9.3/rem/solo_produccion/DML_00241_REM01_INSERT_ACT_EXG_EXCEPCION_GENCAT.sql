--/*
--#########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20200415
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6782
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6782';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_CMG_COMUNICACION_GENCAT - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT T1
        USING (

		SELECT DISTINCT TAC.ACT_ID
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
        	AND TAP.BORRADO = 0
        	AND TAR.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			7001768,
			7099833,
			6078364
		)
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.ACT_ID = ACT.ACT_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND TAP_CODIGO = ''T016_ComunicarGENCAT''

        ) T2 
        ON (T1.ACT_ID = T2.ACT_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_CMG_COMUNICACION_GENCAT ');  


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
        	AND TAP.BORRADO = 0
        	AND TAR.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			7001768,
			7099833,
			6078364
		)
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.ACT_ID = ACT.ACT_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND TAP_CODIGO = ''T016_ComunicarGENCAT''

        ) T2 
        ON (T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
        USING (

		SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID
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
        	AND TAP.BORRADO = 0
        	AND TAR.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			7001768,
			7099833,
			6078364
		)
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.ACT_ID = ACT.ACT_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND TAP_CODIGO = ''T016_ComunicarGENCAT''
        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
        USING (

		SELECT DISTINCT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
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
        	AND TAP.BORRADO = 0
        	AND TAR.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			7001768,
			7099833,
			6078364
		)
		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.ACT_ID = ACT.ACT_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
		AND TAP_CODIGO = ''T016_ComunicarGENCAT''

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  


-----------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO OFERTA GENCAT 90248386');
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_OFR WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = 90248386)';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET BORRADO = 1, USUARIOBORRAR = '''||V_USUARIOMODIFICAR||''', FECHABORRAR = SYSDATE WHERE OFR_NUM_OFERTA = 90248386';
	EXECUTE IMMEDIATE V_SQL;
	
-----------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Creación de activos de exclusión GENCAT ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EXG_EXCLUSION_GENCAT T1
        USING (

		SELECT DISTINCT ACT_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE  1=1
        	AND ACT.BORRADO = 0
		AND ACT_NUM_ACTIVO IN
		(
			7001768,
			7099833,
			6078364
		)

        ) T2 
        ON (T1.ACT_ID = T2.ACT_ID )
	WHEN NOT MATCHED THEN INSERT
	( ACT_ID )
	VALUES
	( T2.ACT_ID )	
	';

	EXECUTE IMMEDIATE V_SQL;
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
