--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200911
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8247
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
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8247';
    V_SQL VARCHAR2(32000 CHAR);

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza GPV_ACT');	

	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.GPV_ACT 
		  WHERE GPV_ACT_ID IN 
		  (
		    SELECT GPV_ACT_ID
		    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
		    INNER JOIN '||V_ESQUEMA||'.GPV_ACT GPVA ON GPVA.GPV_ID = GPV.GPV_ID
		    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GPVA.ACT_ID
		    WHERE GPV_NUM_GASTO_HAYA = 11288414
		    MINUS
		    SELECT GPV_ACT_ID
		    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
		    INNER JOIN '||V_ESQUEMA||'.GPV_ACT GPVA ON GPVA.GPV_ID = GPV.GPV_ID
		    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GPVA.ACT_ID
		    WHERE GPV_NUM_GASTO_HAYA = 11288414 
		    AND ACT.ACT_NUM_ACTIVO IN (67607,
		    67873,
		    67874,
		    67876,
		    67978,
		    68016,
		    68031,
		    68032,
		    68034,
		    68259,
		    68260,
		    75351,
		    75352,
		    76756,
		    76757,
		    78350,
		    78430,
		    78641,
		    78642,
		    142745,
		    164447,
		    164645,
		    164838,
		    164839,
		    165180,
		    165605,
		    165606,
		    172129,
		    172225,
		    172226,
		    172228,
		    172229,
		    172334,
		    172606,
		    172607,
		    172608,
		    198060,
		    198061,
		    198161,
		    198162,
		    198163,
		    198227,
		    198757
		    )
		  )';		

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_ACT ');  
	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_ACT SET 
		  SET GPV_PARTICIPACION_GASTO = '2.3255'
		  WHERE GPV_ID IN (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 11288414)';		

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' PORCENTAJES en GPV_ACT ');  
	

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso realizado');
	

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
