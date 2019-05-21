--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4149
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-4149';
    V_SQL VARCHAR2(4000 CHAR);
    V_MAX_PTO_ID NUMBER(16,0);
    V_EJE_ID NUMBER(16,0);
    V_COUNT NUMBER(16):= 0;
    V_COUNT2 NUMBER(16):= 0;


BEGIN			
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza GPV_GASTOS_PROVEEDOR ');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1
        USING (

		SELECT 
		       PRO.PRO_ID,
		       AUX.GPV_NUM_GASTO_HAYA
		FROM '||V_ESQUEMA||'.AUX_REMVIP_4149 AUX
		JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = AUX.PRO_DOCIDENTIF

        ) T2 
        ON (T1.GPV_NUM_GASTO_HAYA = T2.GPV_NUM_GASTO_HAYA )
	WHEN MATCHED THEN UPDATE
	SET T1.PRO_ID = T2.PRO_ID,
	    T1.USUARIOMODIFICAR = ''' || V_USUARIOMODIFICAR || ''',
	    T1.FECHAMODIFICAR   = SYSDATE

	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR ');  


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
