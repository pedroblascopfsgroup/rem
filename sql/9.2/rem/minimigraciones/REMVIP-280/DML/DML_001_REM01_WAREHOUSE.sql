--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180313
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-280
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-280';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL T1
		USING (SELECT ICO.ICO_ID, PVE.PVE_ID
		    FROM '||V_ESQUEMA||'.AUX_MEDIADOR AUX
		    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT
		    JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
		    JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = AUX.PVE
		    WHERE NVL(ICO.ICO_MEDIADOR_ID, 0) <> PVE.PVE_ID) T2
		ON (T1.ICO_ID = T2.ICO_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.ICO_MEDIADOR_ID = T2.PVE_ID, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' mediadores actualizados.');
    
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
