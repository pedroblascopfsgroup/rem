--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190708
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4621
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
--		AND ECO_NUM_EXPEDIENTE IN ( 165855, 165859, 165856, 165860 )

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4328';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_OFG_OFERTA_GENCAT - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT T1
        USING (

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON (T1.OFG_ID = T2.OFG_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_OFG_OFERTA_GENCAT ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )
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

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.TBJ_ID = T2.TBJ_ID )
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

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID AND T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAC_TAREAS_ACTIVOS ');  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON ( T1.TAR_ID = T2.TAR_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza OFG_OFERTAS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.OFG_OFERTAS T1
        USING (

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON ( T1.OFG_ID = T2.OFG_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en OFG_OFERTAS ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ECO_EXPEDIENTE - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE T1
        USING (

		SELECT  TAC.TRA_ID, TAC.TAR_ID, OFR.OFR_ID, ECO.ECO_ID, OFG.OFG_ID
		FROM 	'||V_ESQUEMA||'.OFR_OFERTAS OFR,
			'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		        '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		        '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		        '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,
		        '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG        
		WHERE 1 = 1
		AND ECO.OFR_ID = OFR.OFR_ID     
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAC.TAR_ID = TAR.TAR_ID
		AND TRA.TBJ_ID = ECO.TBJ_ID
		AND OFG.OFR_ID = OFR.OFR_ID
		AND OFR.DD_EOF_ID = ( SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '03' )
		AND ECO_NUM_EXPEDIENTE IN ( 165063, 165640 )

        ) T2 
        ON (T1.ECO_ID = T2.ECO_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.BORRADO = 1,
	    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHABORRAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ECO_EXPEDIENTE ');  


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
