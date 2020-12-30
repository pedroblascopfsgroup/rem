--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200925
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8133
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-8133';
    V_SQL VARCHAR2(32000 CHAR);

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza cuentas y partidas gastos ');			


	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1
		USING (	
		SELECT GPV.GPV_ID, AUX.CCPP_CORRECTA
		FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
       		INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8133 AUX ON GPV.GPV_NUM_GASTO_HAYA = AUX.NUM_GASTO
			) T2
		ON (T1.GPV_ID = T2.GPV_ID AND T1.BORRADO = 0)
		WHEN MATCHED THEN UPDATE
		SET 	T1.GIC_PTDA_PRESUPUESTARIA = T2.CCPP_CORRECTA,
	    		T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	   	 	T1.FECHAMODIFICAR   = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GIC_GASTOS_INFO_CONTABILIDAD');  

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
