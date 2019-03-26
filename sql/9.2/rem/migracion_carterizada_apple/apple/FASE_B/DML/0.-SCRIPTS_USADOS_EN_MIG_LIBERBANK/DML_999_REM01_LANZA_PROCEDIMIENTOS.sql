--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=2017075
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2318
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

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    FILAS_ACT NUMBER(16) := 0;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] EJECUTANDO SP_PERFILADO_FUNCIONES...');
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  SP_PERFILADO_FUNCIONES  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');
    
    REM01.SP_PERFILADO_FUNCIONES;
    
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  FIN LOG  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');

    MERGE INTO REM01.ACT_ACTIVO T1
    USING (
        SELECT DISTINCT ACT.ACT_ID
        FROM REM01.ACT_TRA_TRAMITE TRA
        JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID AND TPO.DD_TPO_CODIGO = 'T013'
        JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID AND TBJ.BORRADO = 0
        JOIN REM01.ACT_TBJ ON ACT_TBJ.TBJ_ID = TBJ.TBJ_ID
        JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = ACT_TBJ.ACT_ID AND ACT.BORRADO = 0 AND ACT.DD_TCR_ID IS NULL
        JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON ACT.ACT_ID = TAC.ACT_ID
        JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID
        JOIN REMMASTER.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
        JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON USU.USU_ID = GEE.USU_ID
        JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
        WHERE TAR.TAR_FECHA_FIN IS NULL AND TGE.DD_TGE_CODIGO = 'GCOM') T2
    ON (T1.ACT_ID = T2.ACT_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.DD_TCR_ID = (SELECT TCR.DD_TCR_ID FROM REM01.DD_TCR_TIPO_COMERCIALIZAR TCR WHERE TCR.DD_TCR_CODIGO = '01')
        , T1.USUARIOMODIFICAR = '#USUARIO_MIGRACION#', T1.FECHAMODIFICAR = SYSDATE;--1668
    FILAS_ACT := SQL%ROWCOUNT;

    MERGE INTO REM01.ACT_ACTIVO T1
    USING (
        SELECT DISTINCT TRA.ACT_ID
        FROM REM01.ACT_TRA_TRAMITE TRA
        JOIN REM01.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TRA.DD_TPO_ID = TPO.DD_TPO_ID AND TPO.DD_TPO_CODIGO = 'T013'
        JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = TRA.ACT_ID AND ACT.BORRADO = 0 AND ACT.DD_TCR_ID IS NULL
        JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON ACT.ACT_ID = TAC.ACT_ID
        JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID
        JOIN REMMASTER.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
        JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON USU.USU_ID = GEE.USU_ID
        JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
        WHERE TAR.TAR_FECHA_FIN IS NULL AND TGE.DD_TGE_CODIGO = 'GCOM') T2
    ON (T1.ACT_ID = T2.ACT_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.DD_TCR_ID = (SELECT TCR.DD_TCR_ID FROM REM01.DD_TCR_TIPO_COMERCIALIZAR TCR WHERE TCR.DD_TCR_CODIGO = '01')
        , T1.USUARIOMODIFICAR = '#USUARIO_MIGRACION#', T1.FECHAMODIFICAR = SYSDATE;
    FILAS_ACT := FILAS_ACT + SQL%ROWCOUNT;

    MERGE INTO REM01.ACT_ACTIVO T1
    USING (
        SELECT ACT.ACT_ID, TAG.DD_TAG_ID, TUD.DD_TUD_ID, TPC.DD_TPC_ID, TAS.TAS_ID
            , CASE WHEN TAG.DD_TAG_ID IS NULL AND TUD.DD_TUD_ID IS NULL AND TPC.DD_TPC_ID IS NULL AND TAS.TAS_ID IS NULL THEN 0 ELSE 1 END RETAIL
            , ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY CASE WHEN TAG.DD_TAG_ID IS NULL AND TUD.DD_TUD_ID IS NULL AND TPC.DD_TPC_ID IS NULL AND TAS.TAS_ID IS NULL THEN 0 ELSE 1 END DESC) RN
        FROM REM01.ACT_ACTIVO ACT
        JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
        JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
        JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
        JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = 'GCOM'
        LEFT JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID
        LEFT JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID
        LEFT JOIN REM01.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.AGR_FECHA_BAJA IS NULL
        LEFT JOIN REM01.DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID AND TAG.DD_TAG_CODIGO IN ('01','13')
        LEFT JOIN REM01.DD_TUD_TIPO_USO_DESTINO TUD ON ACT.DD_TUD_ID = TUD.DD_TUD_ID AND TUD.DD_TUD_CODIGO IN ('01','06')
        LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID AND VAL.VAL_IMPORTE <= DECODE(CRA.DD_CRA_CODIGO,'01',50000,60000) AND (VAL.VAL_FECHA_FIN IS NULL OR VAL.VAL_FECHA_FIN >= SYSDATE)
        LEFT JOIN REM01.DD_TPC_TIPO_PRECIO TPC ON VAL.DD_TPC_ID = TPC.DD_TPC_ID AND TPC.DD_TPC_CODIGO = DECODE(CRA.DD_CRA_CODIGO,'01','01','02')
        LEFT JOIN REM01.ACT_VAL_VALORACIONES VAL2 ON ACT.ACT_ID = VAL2.ACT_ID AND VAL2.VAL_IMPORTE <= DECODE(CRA.DD_CRA_CODIGO,'01',50000,60000)
        LEFT JOIN REM01.ACT_TAS_TASACION TAS ON TAS.ACT_ID = ACT.ACT_ID AND TAS.TAS_IMPORTE_TAS_FIN <= VAL2.VAL_IMPORTE
        WHERE ACT.BORRADO = 0 AND ACT.DD_TCR_ID IS NULL AND ACT.ACT_BLOQUEO_TIPO_COMERCIALIZAR = 0
            AND (PAC.PAC_CHECK_COMERCIALIZAR IS NULL OR PAC.PAC_CHECK_COMERCIALIZAR = 1)) T2
    ON (T1.ACT_ID = T2.ACT_ID AND T2.RN = 1)
    WHEN MATCHED THEN UPDATE SET
        T1.DD_TCR_ID = (SELECT TCR.DD_TCR_ID FROM REM01.DD_TCR_TIPO_COMERCIALIZAR TCR WHERE TCR.DD_TCR_CODIGO = DECODE(T2.RETAIL,1,'02','01'))
        , T1.USUARIOMODIFICAR = '#USUARIO_MIGRACION#', T1.FECHAMODIFICAR = SYSDATE;--19148
    FILAS_ACT := FILAS_ACT + SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(FILAS_ACT||' activos actualizados en el campo DD_TCR_ID.');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('  ############################  FIN LOG  ###################################### ');
    DBMS_OUTPUT.PUT_LINE(' ');

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