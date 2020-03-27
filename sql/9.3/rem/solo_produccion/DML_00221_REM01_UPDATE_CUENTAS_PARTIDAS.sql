--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200327
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6703
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6703';
    V_SQL VARCHAR2(32000 CHAR);

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza datos registrales ');			


	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1
		USING (	
		SELECT DISTINCT GPV.GPV_ID, TMP.COD_GASTO, TMP.PARTIDA_PRESUPUESTARIA, TMP.CUENTA_CONTABLE
		FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		JOIN '||V_ESQUEMA||'.TMP_PARTIDA_PRESUPUESTARIA_2019_REMVIP_6703 TMP ON TMP.COD_GASTO = GPV.GPV_NUM_GASTO_HAYA
		WHERE GPV.DD_EGA_ID = 1 OR gpv.gpv_id in (6840259,
		6827209,
		7227903,
		6852194,
		6724646,
		6827193,
		7168885,
		7227904,
		6556462,
		7165190,
		7109267,
		6921057,
		6556484,
		7127220)
			) T2
		ON (T1.GPV_ID = T2.GPV_ID)
		WHEN MATCHED THEN UPDATE
		SET T1.GIC_CUENTA_CONTABLE = T2.CUENTA_CONTABLE,
	    	    T1.GIC_PTDA_PRESUPUESTARIA = T2.PARTIDA_PRESUPUESTARIA,
	   	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    	    T1.FECHAMODIFICAR = SYSDATE ';

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
