--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190523
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4328
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4328';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza ACT_CMG_COMUNICACION_GENCAT - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT T1
        USING (

                SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT ,
		'||V_ESQUEMA||'.VI_ACTIVOS_AFECTOS_GENCAT AFE  ,
		'||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ,
		'||V_ESQUEMA||'.ACT_OFR ACT_OFR,
		'||V_ESQUEMA||'.OFR_OFERTAS OFR,
		'||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF,
		'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		'||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC,
		'||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX,
                '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
                '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
                '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC,
                '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
                '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR,
                '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN,
                '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
                '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
		WHERE 1 = 1
		AND ACT.ACT_ID = AFE.ACT_ID
		AND ACT_OFR.ACT_ID = ACT.ACT_ID
		AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
		AND ACT_OFR.OFR_ID = OFR.OFR_ID
		AND EOF.DD_EOF_ID = OFR.DD_EOF_ID
		AND ECO.OFR_ID = OFR.OFR_ID
		AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
		AND ECO.ECO_ID = CEX.ECO_ID
		AND OFR_NUM_OFERTA IN ( 90185305, 90174933, 90127758, 90187854 )
                AND TAC.DD_TAC_CODIGO = ''GES''
                AND TPO.DD_TPO_CODIGO = ''T016''
                AND EPR.DD_EPR_CODIGO = ''10''
                AND EIN.DD_EIN_CODIGO = ''61''
                AND TAP.TAP_CODIGO = ''T016_ProcesoAdecuacion''
                AND TAR.DD_STA_ID = TAP.DD_STA_ID
                AND TAR.DD_EIN_ID = EIN.DD_EIN_ID
                AND TAR.DTYPE = ''EXTTareaNotificacion''
                AND TAR.TAR_TAREA = TAP.TAP_DESCRIPCION
                AND TAC.TRA_ID = TRA.TRA_ID
                AND ACT.ACT_ID = TRA.ACT_ID
                AND TAC.TRA_ID = TRA.TRA_ID
                AND TAC.ACT_ID = ACT.ACT_ID
                AND TAC.TAR_ID = TAR.TAR_ID

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

                SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT ,
		'||V_ESQUEMA||'.VI_ACTIVOS_AFECTOS_GENCAT AFE  ,
		'||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ,
		'||V_ESQUEMA||'.ACT_OFR ACT_OFR,
		'||V_ESQUEMA||'.OFR_OFERTAS OFR,
		'||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF,
		'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		'||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC,
		'||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX,
                '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
                '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
                '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC,
                '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
                '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR,
                '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN,
                '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
                '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
		WHERE 1 = 1
		AND ACT.ACT_ID = AFE.ACT_ID
		AND ACT_OFR.ACT_ID = ACT.ACT_ID
		AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
		AND ACT_OFR.OFR_ID = OFR.OFR_ID
		AND EOF.DD_EOF_ID = OFR.DD_EOF_ID
		AND ECO.OFR_ID = OFR.OFR_ID
		AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
		AND ECO.ECO_ID = CEX.ECO_ID
		AND OFR_NUM_OFERTA IN ( 90185305, 90174933, 90127758, 90187854 )
                AND TAC.DD_TAC_CODIGO = ''GES''
                AND TPO.DD_TPO_CODIGO = ''T016''
                AND EPR.DD_EPR_CODIGO = ''10''
                AND EIN.DD_EIN_CODIGO = ''61''
                AND TAP.TAP_CODIGO = ''T016_ProcesoAdecuacion''
                AND TAR.DD_STA_ID = TAP.DD_STA_ID
                AND TAR.DD_EIN_ID = EIN.DD_EIN_ID
                AND TAR.DTYPE = ''EXTTareaNotificacion''
                AND TAR.TAR_TAREA = TAP.TAP_DESCRIPCION
                AND TAC.TRA_ID = TRA.TRA_ID
                AND ACT.ACT_ID = TRA.ACT_ID
                AND TAC.TRA_ID = TRA.TRA_ID
                AND TAC.ACT_ID = ACT.ACT_ID
                AND TAC.TAR_ID = TAR.TAR_ID

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

                SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT ,
		'||V_ESQUEMA||'.VI_ACTIVOS_AFECTOS_GENCAT AFE  ,
		'||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ,
		'||V_ESQUEMA||'.ACT_OFR ACT_OFR,
		'||V_ESQUEMA||'.OFR_OFERTAS OFR,
		'||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF,
		'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		'||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC,
		'||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX,
                '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
                '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
                '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC,
                '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
                '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR,
                '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN,
                '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
                '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
		WHERE 1 = 1
		AND ACT.ACT_ID = AFE.ACT_ID
		AND ACT_OFR.ACT_ID = ACT.ACT_ID
		AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
		AND ACT_OFR.OFR_ID = OFR.OFR_ID
		AND EOF.DD_EOF_ID = OFR.DD_EOF_ID
		AND ECO.OFR_ID = OFR.OFR_ID
		AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
		AND ECO.ECO_ID = CEX.ECO_ID
		AND OFR_NUM_OFERTA IN ( 90185305, 90174933, 90127758, 90187854 )
                AND TAC.DD_TAC_CODIGO = ''GES''
                AND TPO.DD_TPO_CODIGO = ''T016''
                AND EPR.DD_EPR_CODIGO = ''10''
                AND EIN.DD_EIN_CODIGO = ''61''
                AND TAP.TAP_CODIGO = ''T016_ProcesoAdecuacion''
                AND TAR.DD_STA_ID = TAP.DD_STA_ID
                AND TAR.DD_EIN_ID = EIN.DD_EIN_ID
                AND TAR.DTYPE = ''EXTTareaNotificacion''
                AND TAR.TAR_TAREA = TAP.TAP_DESCRIPCION
                AND TAC.TRA_ID = TRA.TRA_ID
                AND ACT.ACT_ID = TRA.ACT_ID
                AND TAC.TRA_ID = TRA.TRA_ID
                AND TAC.ACT_ID = ACT.ACT_ID
                AND TAC.TAR_ID = TAR.TAR_ID

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

                SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT ,
		'||V_ESQUEMA||'.VI_ACTIVOS_AFECTOS_GENCAT AFE  ,
		'||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ,
		'||V_ESQUEMA||'.ACT_OFR ACT_OFR,
		'||V_ESQUEMA||'.OFR_OFERTAS OFR,
		'||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF,
		'||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
		'||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC,
		'||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX,
                '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
                '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
                '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC,
                '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO,
                '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR,
                '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN,
                '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
                '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
		WHERE 1 = 1
		AND ACT.ACT_ID = AFE.ACT_ID
		AND ACT_OFR.ACT_ID = ACT.ACT_ID
		AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
		AND ACT_OFR.OFR_ID = OFR.OFR_ID
		AND EOF.DD_EOF_ID = OFR.DD_EOF_ID
		AND ECO.OFR_ID = OFR.OFR_ID
		AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
		AND ECO.ECO_ID = CEX.ECO_ID
		AND OFR_NUM_OFERTA IN ( 90185305, 90174933, 90127758, 90187854 )
                AND TAC.DD_TAC_CODIGO = ''GES''
                AND TPO.DD_TPO_CODIGO = ''T016''
                AND EPR.DD_EPR_CODIGO = ''10''
                AND EIN.DD_EIN_CODIGO = ''61''
                AND TAP.TAP_CODIGO = ''T016_ProcesoAdecuacion''
                AND TAR.DD_STA_ID = TAP.DD_STA_ID
                AND TAR.DD_EIN_ID = EIN.DD_EIN_ID
                AND TAR.DTYPE = ''EXTTareaNotificacion''
                AND TAR.TAR_TAREA = TAP.TAP_DESCRIPCION
                AND TAC.TRA_ID = TRA.TRA_ID
                AND ACT.ACT_ID = TRA.ACT_ID
                AND TAC.TRA_ID = TRA.TRA_ID
                AND TAC.ACT_ID = ACT.ACT_ID
                AND TAC.TAR_ID = TAR.TAR_ID

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
