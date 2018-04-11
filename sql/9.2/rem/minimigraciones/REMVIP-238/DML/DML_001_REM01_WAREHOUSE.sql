--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180309
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-238
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-238';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    EXECUTE IMMEDIATE 'UPDATE REM01.ACT_ICO_INFO_COMERCIAL SET
    					  ICO_MEDIADOR_ID = NULL
    					, USUARIOMODIFICAR = '''||V_USUARIO||'''
    					, FECHAMODIFICAR = SYSDATE
						WHERE ACT_ID IN 
						(SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO IN (SELECT ACT FROM REM01.AUX_CUSTODIO WHERE PVE = ''NULL''))'
						;

    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL T1
        USING (
            SELECT ACT.ACT_ID, PVE.PVE_ID 
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.AUX_CUSTODIO AUX ON AUX.ACT = ACT.ACT_NUM_ACTIVO
            JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON TO_CHAR(PVE.PVE_COD_REM) = TO_CHAR(AUX.PVE)) T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.ICO_MEDIADOR_ID = T2.PVE_ID, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
        WHERE T1.ICO_MEDIADOR_ID <> T2.PVE_ID
        OR T1.ICO_MEDIADOR_ID IS NULL';
    DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' mediadores actualizados.');

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
EXIT;
