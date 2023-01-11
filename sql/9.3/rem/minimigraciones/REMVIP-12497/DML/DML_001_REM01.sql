--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20230111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12497
--## PRODUCTO=NO
--## 
--## Finalidad: Script que MODIFICA PROVEEDOR EN GASTOS Y TRABAJOS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	
	V_TABLA_TMP VARCHAR2(50 CHAR) := 'AUX_REMVIP_12497'; -- Variable para tabla 	
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_MSQL VARCHAR2(4000 CHAR);--Variable para consultar la existencia de registros en la tabla
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12497';
	

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' T1 USING (
                            SELECT DISTINCT TBJ.TBJ_ID, TRABAJO FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                            JOIN '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX ON TRABAJO = TBJ_NUM_TRABAJO
                            WHERE TBJ.BORRADO = 0) T2
                            ON (T1.TRABAJO = T2.TRABAJO)
                            WHEN MATCHED THEN UPDATE SET
                            T1.TBJ_ID = T2.TBJ_ID';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han MODIFICADO '||SQL%ROWCOUNT||' registros PARA TRABAJOS');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TMP||' T1 USING (
                            SELECT DISTINCT GPV.GPV_ID, GASTO FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                            JOIN '||V_ESQUEMA||'.'||V_TABLA_TMP||' AUX ON GASTO = GPV_NUM_GASTO_HAYA
                            WHERE GPV.BORRADO = 0) T2
                            ON (T1.GASTO = T2.GASTO)
                            WHEN MATCHED THEN UPDATE SET
                            T1.GPV_ID = T2.GPV_ID';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han MODIFICADO '||SQL%ROWCOUNT||' registros PARA GASTOS');

    COMMIT;

    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO
            SET PVC_ID = (SELECT PVC.PVC_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
                         JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE_COD_REM = 491
                         WHERE PVC.BORRADO = 0),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE
            WHERE TBJ_ID IN (SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE TBJ_ID IS NOT NULL)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO PVC_ID EN '|| SQL%ROWCOUNT ||' TRABAJOS');

    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
            SET PVE_ID_EMISOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE_COD_REM = 491),
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE
            WHERE GPV_ID IN (SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_TMP||' WHERE GPV_ID IS NOT NULL)';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO PVE_ID_EMISOR EN '|| SQL%ROWCOUNT ||' GASTOS');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_MSQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
