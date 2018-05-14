--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-735
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
    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-735';
    PL_OUTPUT VARCHAR2(32000 CHAR);
    SP_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);

BEGIN

    PL_OUTPUT := '[INICIO]' || CHR(10);

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR TEV1 WHERE EXISTS (
        SELECT 1
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID
        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.DD_TPO_ID = TPO.DD_TPO_ID AND TAP.TAP_ID = TEX.TAP_ID AND TAP.TAP_CODIGO = ''T004_ResultadoTarificada''
        LEFT JOIN '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR TEV ON TEV.TEX_ID = TEX.TEX_ID
        WHERE TBJ.TBJ_NUM_TRABAJO = ''9000062969'' AND TBJ.BORRADO = 0 AND TEV.TEV_ID = TEV1.TEV_ID
        )';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros eliminados de la tabla TEV' || CHR(10);
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA T1
    USING (
        SELECT TEX.TEX_ID, TEX.USUARIOMODIFICAR
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID
        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.DD_TPO_ID = TPO.DD_TPO_ID AND TAP.TAP_ID = TEX.TAP_ID AND TAP.TAP_CODIGO = ''T004_ResultadoTarificada''
        WHERE TBJ.TBJ_NUM_TRABAJO = ''9000062969'' AND TBJ.BORRADO = 0
        ) T2
    ON (T1.TEX_ID = T2.TEX_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.TEX_TOKEN_ID_BPM = NULL, T1.TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T004_ResultadoNoTarificada''), T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
    WHERE T1.TEX_TOKEN_ID_BPM IS NOT NULL';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros actualizados de la tabla TEX' || CHR(10);
        
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
    USING (
        SELECT TAR.TAR_ID, TAP.TAP_DESCRIPCION, TAR.USUARIOMODIFICAR
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID
        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID
        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.DD_TPO_ID = TPO.DD_TPO_ID AND TAP.TAP_ID = TEX.TAP_ID AND TAP.TAP_CODIGO = ''T004_ResultadoNoTarificada''
        WHERE TBJ.TBJ_NUM_TRABAJO = ''9000062969'' AND TBJ.BORRADO = 0
        ) T2
    ON (T1.TAR_ID = T2.TAR_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.TAR_TAREA = T2.TAP_DESCRIPCION, T1.TAR_DESCRIPCION = T2.TAP_DESCRIPCION, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
    WHERE T1.TAR_TAREA <> T2.TAP_DESCRIPCION OR T1.TAR_DESCRIPCION <> T2.TAP_DESCRIPCION';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros actualizados de la tabla TAR' || CHR(10);
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE T1
    USING (
        SELECT TRA.TRA_ID
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = TBJ.TBJ_ID AND TRA.BORRADO = 0
        WHERE TBJ.TBJ_NUM_TRABAJO = ''9000062969'' AND TBJ.BORRADO = 0
        ) T2
    ON (T1.TRA_ID = T2.TRA_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.TRA_PROCESS_BPM = NULL, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
    WHERE T1.TRA_PROCESS_BPM IS NOT NULL';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || ' [INFO] ' || SQL%ROWCOUNT || ' registros actualizados de la tabla TRA' || CHR(10);
    
    REM01.ALTA_BPM_INSTANCES('SP_BPM',SP_OUTPUT);
    
    SP_OUTPUT := SP_OUTPUT || CHR(10);
    
    DBMS_OUTPUT.PUT_LINE(SP_OUTPUT);

    PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);
    
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL;
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        ROLLBACK;
        RAISE;
END;
/
EXIT;