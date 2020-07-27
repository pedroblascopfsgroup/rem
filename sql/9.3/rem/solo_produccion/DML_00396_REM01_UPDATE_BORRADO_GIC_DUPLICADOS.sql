--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=202007017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7807
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7807';
    V_SQL VARCHAR2(32000 CHAR);

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza GIC GASTOS');	

	V_SQL := 'MERGE INTO  '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING (	
			SELECT GIC_ID FROM (
				SELECT GIC.GIC_ID, GPV.GPV_ID,  ROW_NUMBER() OVER(PARTITION BY GPV.GPV_ID ORDER BY GIC.GIC_ID DESC) AS RN
				FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				INNER JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID 
				WHERE GPV.GPV_ID IN 
				(SELECT GPV_ID
				FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC WHERE BORRADO = 0
				GROUP BY GPV_ID
				HAVING  COUNT(1) > 1)) 
			WHERE RN = 1 
		) T2 
			ON (T1.GIC_ID = T2.GIC_ID )
			WHEN MATCHED THEN UPDATE
			SET T1.BORRADO = 1,
			    T1.USUARIOBORRAR = ''' || V_USUARIOMODIFICAR || ''',
			    T1.FECHABORRAR   = SYSDATE';		

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GIC_GASTOS_INFO_CONTABILIDAD ');  

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
