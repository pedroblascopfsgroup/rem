--/*
--#########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210226
--## ARTEFACTO=Batch
--## VERSION_ARTEFACTO=3.0
--## INCIDENCIA_LINK=REMVIP-9049
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar tarifas.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9049';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);

    V_TABLA_TTF VARCHAR2(30 CHAR) := 'DD_TTF_TIPO_TARIFA';
    V_TABLA_CFT VARCHAR2(30 CHAR) := 'ACT_CFT_CONFIG_TARIFA';
    V_TABLA_TRABAJO VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO';
    V_TABLA_TCT VARCHAR2(30 CHAR) :='ACT_TCT_TRABAJO_CFGTARIFA';
    V_TABLA_AUX VARCHAR2(30 CHAR):='AUX_REMVIP_9049';
    V_NUM_TABLAS NUMBER(16);
    V_ID NUMBER(16);
    V_CFT_ID NUMBER(16);

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizacion en '||V_TABLA_TRABAJO||' y '||V_TABLA_TCT||'');


        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TCT||' T1
        USING (SELECT DISTINCT TBJ.TBJ_ID,AUX.DD_TCT_ID,CFT.CFT_ID,CFT.CFT_PRECIO_UNITARIO,CFT.CFT_PRECIO_UNITARIO_CLIENTE FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' TBJ
                JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.NUM_TRABAJO=TBJ.TBJ_NUM_TRABAJO
                JOIN '||V_ESQUEMA||'.'||V_TABLA_TCT||' TCT ON TCT.TCT_ID=AUX.DD_TCT_ID                 
                JOIN '||V_ESQUEMA||'.'||V_TABLA_TTF||' TTF ON TTF.DD_TTF_CODIGO=AUX.CODIGO_TARIFA_CAMBIAR
                JOIN '||V_ESQUEMA||'.'||V_TABLA_CFT||' CFT ON CFT.DD_TTF_ID=TTF.DD_TTF_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ ACTBJ ON ACTBJ.TBJ_ID=TBJ.TBJ_ID
                LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=ACTBJ.ACT_ID
                WHERE TBJ.USUARIOMODIFICAR IN (''MIG_BBVA'',''MIG_BBVA_REMVIP-8926'')
                AND CFT.DD_STR_ID=TBJ.DD_STR_ID AND CFT.DD_SCR_ID=ACT.DD_SCR_ID
                AND TBJ.BORRADO=0 AND TCT.BORRADO=0  AND CFT.BORRADO=0 AND TTF.BORRADO=0 AND ACT.BORRADO=0   ) T2 
        ON (T1.TCT_ID = T2.DD_TCT_ID)
        WHEN MATCHED THEN UPDATE SET 
        T1.CFT_ID=T2.CFT_ID,
        T1.TCT_PRECIO_UNITARIO=T2.CFT_PRECIO_UNITARIO,
        T1.TCT_PRECIO_UNITARIO_CLIENTE=T2.CFT_PRECIO_UNITARIO_CLIENTE, 
        T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
        T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA_TCT||' CAMBIADOS DE TARIFAS');


        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' T1
        USING (SELECT DISTINCT TBJ.TBJ_ID,SUM(TCT.TCT_PRECIO_UNITARIO*TCT.TCT_MEDICION) AS PRECIO_UNITARIO, SUM(TCT.TCT_PRECIO_UNITARIO_CLIENTE * TCT.TCT_MEDICION) AS PRECIO_CLIENTE FROM '||V_ESQUEMA||'.'||V_TABLA_TRABAJO||' TBJ
                JOIN '||V_ESQUEMA||'.'||V_TABLA_TCT||' TCT ON TCT.TBJ_ID=TBJ.TBJ_ID AND TCT.BORRADO=0
                JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON AUX.NUM_TRABAJO=TBJ.TBJ_NUM_TRABAJO AND TBJ.BORRADO=0
                WHERE TBJ.USUARIOMODIFICAR IN (''MIG_BBVA'',''MIG_BBVA_REMVIP-8926'') AND TCT.USUARIOMODIFICAR='''||V_USUARIO||'''
                AND TBJ.TBJ_ID NOT IN (
                                        787685,
                                        789621,
                                        794581,
                                        794859,
                                        798013,
                                        798044,
                                        803917,
                                        807551,
                                        809700,
                                        815272,
                                        821948,
                                        822516,
                                        823788,
                                        826616,
                                        827976,
                                        832078,
                                        832107,
                                        832395,
                                        834539,
                                        834553,
                                        837260,
                                        837262,
                                        837880,
                                        841714,
                                        842657,
                                        843300,
                                        846499,
                                        851454,
                                        852734,
                                        855892,
                                        858312,
                                        858340,
                                        860478,
                                        861692,
                                        863813
                                        )
                GROUP BY TBJ.TBJ_ID) T2 
        ON (T1.TBJ_ID = T2.TBJ_ID)
        WHEN MATCHED THEN UPDATE SET 
        T1.TBJ_IMPORTE_TOTAL=T2.PRECIO_CLIENTE,
        T1.TBJ_IMPORTE_PRESUPUESTO=T2.PRECIO_UNITARIO,        
        T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
        T1.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_SQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TABLA_TRABAJO||' CAMBIADOS IMPORTES');
                

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado la modificacion de tarifas y trabajos.');
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
