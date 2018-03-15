--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-227
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-227';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1
        USING (SELECT VAL.VAL_ID
            FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = VAL.ACT_ID
            JOIN '||V_ESQUEMA||'.AUX_PRECIO PCO ON PCO.ACT = ACT.ACT_NUM_ACTIVO
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''02''
            WHERE VAL.VAL_FECHA_FIN IS NULL) T2
        ON (T1.VAL_ID = T2.VAL_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.VAL_FECHA_FIN = SYSDATE, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES (VAL_ID,ACT_ID,DD_TPC_ID,VAL_IMPORTE,VAL_FECHA_INICIO
            ,VAL_FECHA_APROBACION,VAL_FECHA_CARGA,USUARIOCREAR,FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, ACT.ACT_ID, TPC.DD_TPC_ID, TO_NUMBER(AUX.PRECIO)/100
            , SYSDATE, SYSDATE, SYSDATE, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.AUX_PRECIO AUX
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT
        JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = ''02''
        WHERE NOT EXISTS (SELECT 1
            FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
            WHERE TPC.DD_TPC_ID = VAL.DD_TPC_ID AND ACT.ACT_ID = VAL.ACT_ID
                AND VAL.VAL_FECHA_FIN IS NULL)';
	DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||SQL%ROWCOUNT||' valoraciones actualizadas.');

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
