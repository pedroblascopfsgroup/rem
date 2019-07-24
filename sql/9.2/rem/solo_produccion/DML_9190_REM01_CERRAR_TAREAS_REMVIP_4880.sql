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
	-- Trata el caso 1 del item:
	-- Para aquellos activos vendidos, es decir con fecha de venta, y fecha de ingreso cheque:
	--	* Cerrar todas las tareas de Admisión que estén abiertas.
	-- 	* Cerrar todas las tareas de Publicación que estén abiertas.
	DBMS_OUTPUT.PUT_LINE(' ----------------------------------- ');
	DBMS_OUTPUT.PUT_LINE(' --        Trata el caso 1        -- ');

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAC_TAREAS_ACTIVOS - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
        USING (

		SELECT DISTINCT TRA.TRA_ID, ACT.ACT_ID, TAR.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,             
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
             	     '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM,
             	     '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
             	     '||V_ESQUEMA||'.ACT_OFR ACT_OFR,
             	     '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC
		WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID

	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
            
        	AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
        	AND ACT_OFR.ACT_ID = ACT.ACT_ID
        	AND ECO.OFR_ID = ACT_OFR.OFR_ID
        	AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
        	AND DD_EEC_CODIGO = ''08''
        	AND DD_SCM_CODIGO = ''05''
        
        	AND ECO.ECO_FECHA_VENTA IS NOT NULL
        	AND ECO.ECO_FECHA_CONT_PROPIETARIO IS NOT NULL
        	AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM REMMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )
        	AND EXISTS ( SELECT 1
                      	     FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE
                      	     WHERE TGE.DD_TGE_ID = TAP.DD_TGE_ID
                      	     AND DD_TGE_CODIGO IN ( ''GADM'', ''SUPADM'', ''GGADM'', ''GTOADM'', ''SPUBL'', ''GPUBL'' )
                        ) 

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
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,             
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
             	     '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM,
             	     '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
             	     '||V_ESQUEMA||'.ACT_OFR ACT_OFR,
             	     '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC
		WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID

	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
            
        	AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
        	AND ACT_OFR.ACT_ID = ACT.ACT_ID
        	AND ECO.OFR_ID = ACT_OFR.OFR_ID
        	AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
        	AND DD_EEC_CODIGO = ''08''
        	AND DD_SCM_CODIGO = ''05''
        
        	AND ECO.ECO_FECHA_VENTA IS NOT NULL
        	AND ECO.ECO_FECHA_CONT_PROPIETARIO IS NOT NULL
        	AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM REMMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )
        	AND EXISTS ( SELECT 1
                      	     FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE
                      	     WHERE TGE.DD_TGE_ID = TAP.DD_TGE_ID
                      	     AND DD_TGE_CODIGO IN ( ''GADM'', ''SUPADM'', ''GGADM'', ''GTOADM'', ''SPUBL'', ''GPUBL'' )
                        ) 

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
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA,             
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
             	     '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM,
             	     '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
             	     '||V_ESQUEMA||'.ACT_OFR ACT_OFR,
             	     '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC
		WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID

	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
            
        	AND SCM.DD_SCM_ID = ACT.DD_SCM_ID
        	AND ACT_OFR.ACT_ID = ACT.ACT_ID
        	AND ECO.OFR_ID = ACT_OFR.OFR_ID
        	AND EEC.DD_EEC_ID = ECO.DD_EEC_ID
        	AND DD_EEC_CODIGO = ''08''
        	AND DD_SCM_CODIGO = ''05''
        
        	AND ECO.ECO_FECHA_VENTA IS NOT NULL
        	AND ECO.ECO_FECHA_CONT_PROPIETARIO IS NOT NULL
        	AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM REMMASTER.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )
        	AND EXISTS ( SELECT 1
                      	     FROM REMMASTER.DD_TGE_TIPO_GESTOR TGE
                      	     WHERE TGE.DD_TGE_ID = TAP.DD_TGE_ID
                      	     AND DD_TGE_CODIGO IN ( ''GADM'', ''SUPADM'', ''GGADM'', ''GTOADM'', ''SPUBL'', ''GPUBL'' )
                        ) 

        ) T2 
        ON (T1.TRA_ID = T2.TRA_ID )
	WHEN MATCHED THEN UPDATE
	SET T1.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''05''),
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_TRA_TRAMITE '); 

	------------------------------------------------------------------------------------------------------
	-- Trata el caso 2 del item:
	-- Para todos los activos fuera de perímetro de HAYA eliminar todas las tareas abiertas sobre activos fuera de perímetro que no sean tareas del proceso de gestión de activos (trabajos).

	DBMS_OUTPUT.PUT_LINE(' ----------------------------------- ');
	DBMS_OUTPUT.PUT_LINE(' --        Trata el caso 2        -- ');
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza TAR_TAREAS_NOTIFICACIONES - Borrado lógico ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
        USING (


	SELECT DISTINCT TAR_ID
	FROM	
	(

		SELECT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
             	     '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
             	     '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
        	WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID
	        AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TTR.DD_TTR_FILTRAR IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )

	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )  
        	UNION
		SELECT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	             '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
             	     '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR,
             	     '||V_ESQUEMA||'.ACT_TBJ ACT_TBJ
	        WHERE  1=1

		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
        	AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = ACT_TBJ.TBJ_ID
	        AND ACT.ACT_ID = ACT_TBJ.ACT_ID
	        AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TTR.DD_TTR_FILTRAR IS NULL
	        AND TRA.ACT_ID IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )     
	        UNION
		SELECT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	             '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
	        WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
        
	        UNION
		SELECT TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
             	     '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
	        WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )     
	        AND TBJ_DESCRIPCION IS NULL
	        AND TBJ_FECHA_APROBACION IS NULL
	        AND PVC_ID IS NULL
	        AND TBJ_FECHA_INICIO IS NULL
	        AND TBJ_FECHA_FIN IS NULL
	        AND TBJ_IMPORTE_TOTAL IS NULL
        
		) WHERE 1 = 1

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


	SELECT DISTINCT TRA_ID, ACT_ID, TAR_ID
	FROM	
	(

		SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
             	     '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
             	     '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
        	WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID
	        AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TTR.DD_TTR_FILTRAR IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )  
        	UNION
		SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	             '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
             	     '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR,
             	     '||V_ESQUEMA||'.ACT_TBJ ACT_TBJ
	        WHERE  1=1

		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
        	AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = ACT_TBJ.TBJ_ID
	        AND ACT.ACT_ID = ACT_TBJ.ACT_ID
	        AND TBJ.DD_TTR_ID = TTR.DD_TTR_ID
	        AND TTR.DD_TTR_FILTRAR IS NULL
	        AND TRA.ACT_ID IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )     
	        UNION
		SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
	             '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
	        WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID IS NULL
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )    
        
	        UNION
		SELECT TAC.TRA_ID, TAC.ACT_ID, TAC.TAR_ID
		FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
		     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
		     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
		     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
		     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
		     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR,
             	     '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC,
             	     '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
	        WHERE  1=1

		AND ACT.ACT_ID = TRA.ACT_ID
		AND TAC.TRA_ID = TRA.TRA_ID
		AND TAP.TAP_ID = TEX.TAP_ID
		AND TAR.TAR_ID = TAC.TAR_ID
		AND TEX.TAR_ID = TAR.TAR_ID
	        AND PAC.ACT_ID = ACT.ACT_ID
	        AND TRA.TBJ_ID = TBJ.TBJ_ID
        
	        AND ( TEX.BORRADO = 0 )
	        AND ( TAP.BORRADO = 0 ) 
	        AND ( ACT.BORRADO = 0 )         
	        AND ( TRA.BORRADO = 0 ) 
	        AND ( ( TAC.BORRADO = 0 ) OR ( TAC.BORRADO = 1 AND TAC.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
	        AND ( ( TAR.BORRADO = 0 ) OR ( TAR.BORRADO = 1 AND TAR.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''' ) )
        
	        AND PAC.PAC_INCLUIDO = 0
	        AND TRA.DD_EPR_ID = (SELECT DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO WHERE DD_EPR_CODIGO = ''10'' )     
	        AND TBJ_DESCRIPCION IS NULL
	        AND TBJ_FECHA_APROBACION IS NULL
	        AND PVC_ID IS NULL
	        AND TBJ_FECHA_INICIO IS NULL
	        AND TBJ_FECHA_FIN IS NULL
	        AND TBJ_IMPORTE_TOTAL IS NULL
        
		) WHERE 1 = 1

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
