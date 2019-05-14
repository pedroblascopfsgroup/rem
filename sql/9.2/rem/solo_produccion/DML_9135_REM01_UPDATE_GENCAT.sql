--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190513
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4202
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4202';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_CMG_COMUNICACION_GENCAT - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT T1
        USING (

		SELECT 
		       ACT.ACT_ID,
		       TRA.TRA_ID,
		       TAR.TAR_ID,
		       ACT_NUM_ACTIVO
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
		    AND OFG.OFR_ID_ANT IS NULL
		JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFG.OFR_ID
		JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
		    AND CEX.CEX_TITULAR_CONTRATACION = 1
		JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
		    AND COM.COM_NOMBRE <> ''AGENCIA HABITATGE CATALUNYA''
		JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
		    AND TPO.DD_TPO_CODIGO = ''T016''
		JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
		JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
		JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
		    AND TAP.TAP_CODIGO = ''T016_ComunicarGENCAT''
		WHERE ( TAR.BORRADO = 0 OR TRA.BORRADO = 0 OR CMG.BORRADO = 0 )
		AND ACT.ACT_NUM_ACTIVO IN
		(
	
			5967629	,
			5968341	,
			5930798	,
			5949522	,
			5942706	,
			5935497	,
			5963135	,
			5934198	,
			5954214	,
			5944839	,
			5933778	,
			6956361	,
			5955444	,
			5962997	,
			5962405	,
			6814444	,
			6061753	,
			6938934	,
			6988502	,
			6060281	,
			7001445	,
			5957429	,
			5938308	,
			5941013	,
			5947419	,
			5951554	,
			5938448	,
			5945879	,
			5948005	
			
		)

        ) T2 
        ON (T1.ACT_ID = T2.ACT_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE
	WHERE USUARIOCREAR = ''MIGRA_GENCAT'' 

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_CMG_COMUNICACION_GENCAT ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT 
		       ACT.ACT_ID,
		       TRA.TRA_ID,
		       TAR.TAR_ID,
		       ACT_NUM_ACTIVO
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
		    AND OFG.OFR_ID_ANT IS NULL
		JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFG.OFR_ID
		JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
		    AND CEX.CEX_TITULAR_CONTRATACION = 1
		JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
		    AND COM.COM_NOMBRE <> ''AGENCIA HABITATGE CATALUNYA''
		JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
		    AND TPO.DD_TPO_CODIGO = ''T016''
		JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
		JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
		JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
		    AND TAP.TAP_CODIGO = ''T016_ComunicarGENCAT''
		WHERE ( TAR.BORRADO = 0 OR TRA.BORRADO = 0 OR CMG.BORRADO = 0 )
		AND ACT.ACT_NUM_ACTIVO IN
		(
	
			5967629	,
			5968341	,
			5930798	,
			5949522	,
			5942706	,
			5935497	,
			5963135	,
			5934198	,
			5954214	,
			5944839	,
			5933778	,
			6956361	,
			5955444	,
			5962997	,
			5962405	,
			6814444	,
			6061753	,
			6938934	,
			6988502	,
			6060281	,
			7001445	,
			5957429	,
			5938308	,
			5941013	,
			5947419	,
			5951554	,
			5938448	,
			5945879	,
			5948005	
			
		)

        ) T2 
        ON (T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE
	WHERE USUARIOCREAR = ''MIGRA_GENCAT'' 

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_TRA_TRAMITE - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
        USING (

		SELECT 
		       ACT.ACT_ID,
		       TRA.TRA_ID,
		       TAR.TAR_ID,
		       ACT_NUM_ACTIVO
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
		    AND OFG.OFR_ID_ANT IS NULL
		JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFG.OFR_ID
		JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
		    AND CEX.CEX_TITULAR_CONTRATACION = 1
		JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
		    AND COM.COM_NOMBRE <> ''AGENCIA HABITATGE CATALUNYA''
		JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
		    AND TPO.DD_TPO_CODIGO = ''T016''
		JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
		JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
		JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
		    AND TAP.TAP_CODIGO = ''T016_ComunicarGENCAT''
		WHERE ( TAR.BORRADO = 0 OR TRA.BORRADO = 0 OR CMG.BORRADO = 0 )
		AND ACT.ACT_NUM_ACTIVO IN
		(
	
			5967629	,
			5968341	,
			5930798	,
			5949522	,
			5942706	,
			5935497	,
			5963135	,
			5934198	,
			5954214	,
			5944839	,
			5933778	,
			6956361	,
			5955444	,
			5962997	,
			5962405	,
			6814444	,
			6061753	,
			6938934	,
			6988502	,
			6060281	,
			7001445	,
			5957429	,
			5938308	,
			5941013	,
			5947419	,
			5951554	,
			5938448	,
			5945879	,
			5948005	
			
		)

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE
	WHERE USUARIOCREAR = ''MIGRA_GENCAT'' 

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
        USING (

		SELECT 
		       ACT.ACT_ID,
		       TRA.TRA_ID,
		       TAR.TAR_ID,
		       ACT_NUM_ACTIVO
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG ON OFG.CMG_ID = CMG.CMG_ID
		    AND OFG.OFR_ID_ANT IS NULL
		JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFG.OFR_ID
		JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID
		    AND CEX.CEX_TITULAR_CONTRATACION = 1
		JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID
		    AND COM.COM_NOMBRE <> ''AGENCIA HABITATGE CATALUNYA''
		JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
		    AND TPO.DD_TPO_CODIGO = ''T016''
		JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID AND TAC.ACT_ID = ACT.ACT_ID
		JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
		JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
		JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.DD_TPO_ID = TPO.DD_TPO_ID
		    AND TAP.TAP_CODIGO = ''T016_ComunicarGENCAT''
		WHERE ( TAR.BORRADO = 0 OR TRA.BORRADO = 0 OR CMG.BORRADO = 0 )
		AND ACT.ACT_NUM_ACTIVO IN
		(
	
			5967629	,
			5968341	,
			5930798	,
			5949522	,
			5942706	,
			5935497	,
			5963135	,
			5934198	,
			5954214	,
			5944839	,
			5933778	,
			6956361	,
			5955444	,
			5962997	,
			5962405	,
			6814444	,
			6061753	,
			6938934	,
			6988502	,
			6060281	,
			7001445	,
			5957429	,
			5938308	,
			5941013	,
			5947419	,
			5951554	,
			5938448	,
			5945879	,
			5948005	
			
		)

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.ACT_ID = T2.ACT_ID AND T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE
	WHERE USUARIOCREAR = ''MIGRA_GENCAT'' 

	';

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
