--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-246
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_M VARCHAR2(10 CHAR) := 'REMMASTER';
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-246';
    V_TABLA VARCHAR2(30 CHAR) := 'OFR_OFERTAS';
    V_AUX VARCHAR2(30 CHAR) := 'AUX_OFERTAS';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.'||V_AUX||' 
		WHERE ROWID IN (
		    SELECT ROWID
		    FROM (SELECT ROWID, ROW_NUMBER() OVER(PARTITION BY OFR, PVE ORDER BY 1) RN
		        FROM '||V_ESQUEMA||'.'||V_AUX||')
		    WHERE RN > 1)';
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' filas duplicadas eliminadas.');

	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.'||V_AUX||'
		WHERE OFR IN (
		    SELECT OFR
		    FROM '||V_ESQUEMA||'.'||V_AUX||'
		    GROUP BY OFR
		    HAVING COUNT(1) > 1)';
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' ofertas duplicadas eliminados.');

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
        USING (SELECT OFR.OFR_ID, PVE.PVE_ID
        	FROM '||V_ESQUEMA||'.'||V_AUX||' AUX
        	JOIN '||V_ESQUEMA||'.'||V_TABLA||' OFR ON AUX.OFR = OFR.OFR_NUM_OFERTA
        	JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = AUX.PVE
        	WHERE OFR.PVE_ID_PRESCRIPTOR <> PVE.PVE_ID OR OFR.PVE_ID_PRESCRIPTOR IS NULL) T2
        ON (T1.OFR_ID = T2.OFR_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.PVE_ID_PRESCRIPTOR = T2.PVE_ID, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' prescriptores de ofertas actualizadas.');

    DBMS_OUTPUT.PUT_LINE('[FIN]');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
