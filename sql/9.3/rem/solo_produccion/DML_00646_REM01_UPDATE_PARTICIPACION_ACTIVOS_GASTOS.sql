--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8708
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para consulta que valida la existencia de una tabla.
  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR) := 'GLD_ENT';  -- Tabla a modificar
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-8708'; -- USUARIOCREAR/USUARIOMODIFICAR
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INFO] PARTICIPACIONES INCORRECTAS');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_ENT T1
        USING (
        SELECT AUX.GLD_ENT_ID, AUX.PARTICIPACION_CLI
        FROM (
            WITH SUPLIDOS AS (
                SELECT PSU.TBJ_ID
                        , NVL(
                        SUM(
                            CASE
                                WHEN TAD.DD_TAD_CODIGO = ''01''
                                    THEN -NVL(PSU.PSU_IMPORTE, 0)
                                WHEN TAD.DD_TAD_CODIGO = ''02''
                                    THEN NVL(PSU.PSU_IMPORTE, 0)
                                ELSE NVL(PSU.PSU_IMPORTE, 0)
                            END
                        )
                    , 0) IMPORTE_PROV_SUPL
                FROM '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO PSU 
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = PSU.TBJ_ID
                    AND TBJ.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_TAD_TIPO_ADELANTO TAD ON TAD.DD_TAD_ID = PSU.DD_TAD_ID
                    AND TAD.BORRADO = 0
                WHERE PSU.BORRADO = 0
                GROUP BY PSU.TBJ_ID
            )
            , PART_TBJ_LIN AS ( 
                SELECT
                       GLD.GPV_ID
                     , GLD.GLD_ID
                     , TBJ.TBJ_ID
                     , (TBJ.TBJ_IMPORTE_PRESUPUESTO + NVL(SUP.IMPORTE_PROV_SUPL, 0)) / SUM(TBJ.TBJ_IMPORTE_PRESUPUESTO + NVL(SUP.IMPORTE_PROV_SUPL, 0))
                                                       OVER(PARTITION BY GLD.GLD_ID)       PART_TBJ_LIN_PVE
                     , (TBJ.TBJ_IMPORTE_TOTAL + NVL(SUP.IMPORTE_PROV_SUPL, 0)) / SUM(TBJ.TBJ_IMPORTE_TOTAL + NVL(SUP.IMPORTE_PROV_SUPL, 0))
                                                 OVER(PARTITION BY GLD.GLD_ID)       PART_TBJ_LIN_CLI
                 FROM
                        '||V_ESQUEMA||'.GLD_TBJ GTB
                     JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE    GLD ON GLD.GLD_ID = GTB.GLD_ID
                      AND GLD.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO             TBJ ON TBJ.TBJ_ID = GTB.TBJ_ID
                      AND TBJ.BORRADO = 0
                    LEFT JOIN SUPLIDOS SUP ON SUP.TBJ_ID = TBJ.TBJ_ID
                WHERE
                      (
                        (
                            NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) <> 0
                            AND NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) <> 0
                        )
                        OR (
                            NVL(SUP.IMPORTE_PROV_SUPL, 0) <> 0
                        )
                     )
                      AND GTB.BORRADO = 0
            ), PRINCIPAL AS (
                SELECT PTL.GPV_ID, PTL.GLD_ID, GEN.GLD_ENT_ID
                    , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END PARTICIPACION_PVE
                    , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END PARTICIPACION_CLI
                    , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END + 100 - SUM(CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_PVE, 4) END) OVER(PARTITION BY PTL.GLD_ID) AJUSTE_PVE
                    , CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END + 100 - SUM(CASE WHEN ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) < 0.01 THEN 0.01 ELSE ROUND(ATB.ACT_TBJ_PARTICIPACION * PTL.PART_TBJ_LIN_CLI, 4) END) OVER(PARTITION BY PTL.GLD_ID) AJUSTE_CLI
                    , ROW_NUMBER() OVER(PARTITION BY PTL.GLD_ID ORDER BY PTL.PART_TBJ_LIN_CLI DESC) RN_CLI
                FROM PART_TBJ_LIN PTL
                JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = PTL.GLD_ID
                    AND GEN.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
                    AND ENT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON ATB.ACT_ID = GEN.ENT_ID
                    AND ATB.TBJ_ID = PTL.TBJ_ID
                WHERE ENT.DD_ENT_CODIGO = ''ACT''
            ), RN_1 AS (
                SELECT GPV_ID, GLD_ID, GLD_ENT_ID
                    , SUM(AJUSTE_PVE) PARTICIPACION_PVE, SUM(AJUSTE_CLI) PARTICIPACION_CLI
                FROM PRINCIPAL
                WHERE RN_CLI = 1
                GROUP BY GPV_ID, GLD_ID, GLD_ENT_ID
            ), RN_RESTO AS (
                SELECT GPV_ID, GLD_ID, GLD_ENT_ID, SUM(PARTICIPACION_PVE) PARTICIPACION_PVE, SUM(PARTICIPACION_CLI) PARTICIPACION_CLI
                FROM PRINCIPAL
                WHERE RN_CLI > 1
                GROUP BY GPV_ID, GLD_ID, GLD_ENT_ID
            )
            SELECT GPV_ID, GLD_ID, GLD_ENT_ID, PARTICIPACION_PVE, PARTICIPACION_CLI
            FROM RN_1
            UNION
            SELECT GPV_ID, GLD_ID, GLD_ENT_ID, PARTICIPACION_PVE, PARTICIPACION_CLI
            FROM RN_RESTO
        ) AUX
        WHERE EXISTS (
                WITH GASTOS_MAS_1_TRABAJO AS (
                    SELECT GLD.GPV_ID, COUNT(1) 
                    FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD 
                    INNER JOIN '||V_ESQUEMA||'.GLD_TBJ GTBJ ON GTBJ.GLD_ID = GLD.GLD_ID 
                        AND GTBJ.BORRADO = 0
                    INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID 
                        AND GPV.BORRADO = 0
                    WHERE GLD.USUARIOCREAR = ''HREOS-10574''
                        AND GLD.BORRADO = 0
                        AND GPV.DD_EGA_ID IN (1,2,8,10,12)
                    GROUP BY GLD.GPV_ID
                )
                SELECT 1
                FROM GASTOS_MAS_1_TRABAJO MAS
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = MAS.GPV_ID
                    AND GPV.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                    AND GLD.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                    AND GEN.BORRADO = 0
                WHERE GPV.GPV_ID = AUX.GPV_ID
                GROUP BY GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA, GEN.GLD_ID
                HAVING SUM(GEN.GLD_PARTICIPACION_GASTO) <> 100
            )
        ) T2
        ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GLD_PARTICIPACION_GASTO = T2.PARTICIPACION_CLI';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] FUSIONADOS '||SQL%ROWCOUNT||' REGISTROS');
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] ');
  
EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;          

END;

/

EXIT