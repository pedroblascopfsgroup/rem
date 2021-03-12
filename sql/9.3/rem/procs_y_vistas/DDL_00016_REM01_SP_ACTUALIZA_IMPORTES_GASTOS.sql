--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210311
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9185
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar importes gasto/s.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_ACTUALIZAR_IMPORTES_GASTOS (GASTOS VARCHAR2, CHECK_TODOS NUMBER, RESULTADO OUT VARCHAR2) AUTHID CURRENT_USER AS

    V_MSQL VARCHAR2(4000 CHAR);
    LISTA_GPV VARCHAR2(32000 CHAR) := GASTOS;
    TODOS NUMBER(1) := CHECK_TODOS;
    ESTADOS VARCHAR2(256 CHAR) := '''01'',''02'',''03'',''07'',''08'',''10'',''12''';
    V_ESQUEMA VARCHAR2(30 CHAR) := '#ESQUEMA#';
    VALOR_INCORRECTO EXCEPTION;

BEGIN

    IF TODOS = 1 THEN
        RESULTADO := '  [INFO] Se ejecutará el procedimiento de actualización de importes para todos los gastos del esquema.' ||CHR(10);
        LISTA_GPV := NULL;
    ELSIF NVL(TODOS, 0) <> 1 AND LISTA_GPV IS NOT NULL THEN
        RESULTADO := '  [INFO] Se ejecutará el procedimiento de actualización de importes para los gastos: ' ||LISTA_GPV|| '.' ||CHR(10);
        LISTA_GPV := 'AND GPV.GPV_NUM_GASTO_HAYA IN ('||LISTA_GPV||')';
    ELSE
        RAISE VALOR_INCORRECTO;
    END IF;
    
    --ARREGLAMOS PRINCIPAL SUJETO CON PRINCIPAL NO SUJETO
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1
        USING (
            SELECT GPV.GPV_NUM_GASTO_HAYA, GLD.GLD_ID, 
                CASE
                    WHEN NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) = 0 THEN 0 
                    WHEN NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) <> 0 THEN ROUND(NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) * GLD.GLD_IMP_IND_TIPO_IMPOSITIVO / 100, 2) 
                END CUOTA,
                CASE
                    WHEN NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) = 0 THEN 0 
                    WHEN NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) <> 0 THEN GLD.GLD_IMP_IND_TIPO_IMPOSITIVO
                END TIPO,
                GLD.GLD_IMP_IND_CUOTA,
                GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 
                GLD.GLD_PRINCIPAL_SUJETO, GLD.GLD_PRINCIPAL_NO_SUJETO
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                AND GLD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0) <> 0
                AND NVL(GLD.GLD_IMP_IND_CUOTA, 0) <> 0
                AND NVL(GLD.GLD_PRINCIPAL_SUJETO, 0) = 0
                '||LISTA_GPV||'
        ) T2
        ON (T1.GLD_ID = T2.GLD_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GLD_PRINCIPAL_SUJETO = NVL(T1.GLD_PRINCIPAL_NO_SUJETO, 0)
                , T1.GLD_PRINCIPAL_NO_SUJETO = 0
                , T1.GLD_IMP_IND_CUOTA = T2.CUOTA
                , T1.GLD_IMP_IND_TIPO_IMPOSITIVO = T2.TIPO';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Principal sujeto desde no sujeto. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS CUOTA IMP IND
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1
        USING (
            SELECT GLD.GLD_ID, 
                ROUND(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0) * NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0) / 100, 2) CUOTA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                AND GLD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND (NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 0 AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0
                        OR NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1 AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 1)
                AND ROUND(GLD.GLD_PRINCIPAL_SUJETO * GLD.GLD_IMP_IND_TIPO_IMPOSITIVO / 100, 2) <> GLD.GLD_IMP_IND_CUOTA
                '||LISTA_GPV||'
        ) T2
        ON (T1.GLD_ID = T2.GLD_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GLD_IMP_IND_CUOTA = T2.CUOTA';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Recálculo de IVA. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS IMPORTE TOTAL LINEA
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1
        USING (
            SELECT GPV.GPV_NUM_GASTO_HAYA, GLD.GLD_ID, GLD.GLD_IMPORTE_TOTAL,
                NVL(GLD_PRINCIPAL_SUJETO, 0) + 
                    NVL(GLD_PRINCIPAL_NO_SUJETO, 0) + 
                    NVL(GLD_RECARGO, 0) + 
                    NVL(GLD_INTERES_DEMORA, 0) + 
                    NVL(GLD_COSTAS, 0) + 
                    NVL(GLD_OTROS_INCREMENTOS, 0) + 
                    NVL(GLD_PROV_SUPLIDOS, 0) + 
                    CASE 
                        WHEN NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1 AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0 
                            THEN 0
                            ELSE NVL(GLD_IMP_IND_CUOTA, 0)
                    END
                    IMPORTE_TOTAL_CALCULADO
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                AND GLD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND GLD.GLD_IMPORTE_TOTAL <> NVL(GLD_PRINCIPAL_SUJETO, 0) + 
                    NVL(GLD_PRINCIPAL_NO_SUJETO, 0) + 
                    NVL(GLD_RECARGO, 0) + 
                    NVL(GLD_INTERES_DEMORA, 0) + 
                    NVL(GLD_COSTAS, 0) + 
                    NVL(GLD_OTROS_INCREMENTOS, 0) + 
                    NVL(GLD_PROV_SUPLIDOS, 0) + 
                    CASE 
                        WHEN NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1 AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0 
                            THEN 0
                            ELSE NVL(GLD_IMP_IND_CUOTA, 0)
                    END
                '||LISTA_GPV||'
        ) T2
        ON (T1.GLD_ID = T2.GLD_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GLD_IMPORTE_TOTAL = T2.IMPORTE_TOTAL_CALCULADO';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Importe total de línea. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS CUOTA IRPF Y BASE IRPF EN GASTOS SIN TIPO IRPF
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            SELECT GPV.GPV_ID
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) = 0
                AND NVL(GDE.GDE_IRPF_CUOTA, 0) <> 0
                '||LISTA_GPV||'
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_IRPF_CUOTA = 0
                , T1.GDE_IRPF_BASE = NVL(T1.GDE_IRPF_BASE, 0)
                , T1.GDE_IRPF_TIPO_IMPOSITIVO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] IRPF a 0. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS CUOTA IRPF EN GASTOS CON BASE IRPF Y TIPO IRPF
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            SELECT GPV.GPV_ID, 
                ROUND(NVL(GDE.GDE_IRPF_BASE, 0) * NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) / 100, 2) CUOTA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND NVL(GDE.GDE_IRPF_CUOTA, 0) <> ROUND(NVL(GDE.GDE_IRPF_BASE, 0) * NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) / 100, 2)
                AND NVL(GDE.GDE_IRPF_BASE, 0) <> 0
                AND NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) <> 0
                '||LISTA_GPV||'
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_IRPF_CUOTA = T2.CUOTA';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Recálculo cuota IRPF. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
            
    --ARREGLAMOS BASE IRPF EN GASTOS CON CUOTA IRPF Y TIPO IRPF
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            WITH IMPORTES_LINEA AS (
                    SELECT GLD.GPV_ID,
                        SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0)) IMPORTE_SUJETO
                    FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
                    WHERE GLD.BORRADO = 0
                    GROUP BY GLD.GPV_ID
                )  
            SELECT GPV.GPV_ID, GLD.IMPORTE_SUJETO BASE,
                ROUND(GLD.IMPORTE_SUJETO * GDE.GDE_IRPF_TIPO_IMPOSITIVO / 100, 2) CUOTA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            JOIN IMPORTES_LINEA GLD ON GLD.GPV_ID = GPV.GPV_ID
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND NVL(GDE.GDE_IRPF_BASE, 0) = 0
                AND NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) <> 0
                AND NVL(GDE.GDE_IRPF_CUOTA, 0) <> 0
                '||LISTA_GPV||'
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_IRPF_CUOTA = T2.CUOTA
                , T1.GDE_IRPF_BASE = T2.BASE';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Recálculo base IRPF. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS RETENCION GARANTIA NO APLICA Ó APLICA PERO SIN TIPO/BASE
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            SELECT GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                AND PRO.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                AND CRA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND (
                        (
                            NVL(GDE.GDE_RET_GAR_APLICA, 0) = 0
                            AND (
                                    NVL(GDE.GDE_RET_GAR_BASE, 0) <> 0
                                    OR NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) <> 0 
                                    OR NVL(GDE.GDE_RET_GAR_CUOTA, 0) <> 0
                                )
                        ) 
                        OR 
                        (
                            NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1
                            AND (
                                    NVL(GDE.GDE_RET_GAR_BASE, 0) = 0 
                                    OR NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) = 0
                                )
                        )
                        OR
                        (
                            CRA.DD_CRA_CODIGO = ''08''
                            AND GDE.DD_TRE_ID IS NULL
                            AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1
                        )
                    )
                '||LISTA_GPV||'
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_RET_GAR_BASE = 0
                , T1.GDE_RET_GAR_TIPO_IMPOSITIVO = 0
                , T1.GDE_RET_GAR_CUOTA = 0
                , T1.GDE_RET_GAR_APLICA = 0
                , T1.DD_TRE_ID = NULL';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] No aplica retención garantía. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
    
    --ARREGLAMOS CUOTA RETENCIÓN GARANTÍA
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            SELECT GPV.GPV_ID, 
                ROUND(NVL(GDE.GDE_RET_GAR_BASE, 0) * NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) / 100, 2) CUOTA
            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                AND GDE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                AND GGE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                AND GIC.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                AND EGA.BORRADO = 0
            WHERE GPV.BORRADO = 0
                AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1
                AND ROUND(NVL(GDE.GDE_RET_GAR_BASE, 0) * NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) / 100, 2) <> NVL(GDE.GDE_RET_GAR_CUOTA, 0)
                '||LISTA_GPV||'
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_RET_GAR_CUOTA = T2.CUOTA';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Recálculo cuota de retención de garantía. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
        
    --ARREGLAMOS IMPORTE TOTAL GASTO
    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (
            WITH IMPORTES_LINEA AS (
                    SELECT GLD.GPV_ID,
                        SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0) 
                                + NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0)
                                + NVL(GLD.GLD_RECARGO, 0)
                                + NVL(GLD.GLD_COSTAS, 0)
                                + NVL(GLD.GLD_INTERES_DEMORA, 0)
                                + NVL(GLD.GLD_PROV_SUPLIDOS, 0)
                                + NVL(GLD.GLD_OTROS_INCREMENTOS, 0)
                                + CASE
                                    WHEN NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1
                                            AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0
                                        THEN 0
                                        ELSE NVL(GLD.GLD_PRINCIPAL_SUJETO, 0) * NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0) / 100
                                    END
                            ) IMPORTE_TOTAL,
                        SUM(CASE
                                WHEN NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1
                                        AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0
                                    THEN 0
                                    ELSE NVL(GLD.GLD_PRINCIPAL_SUJETO, 0) * NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0) / 100
                                END
                            ) IVA
            FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
                    WHERE GLD.BORRADO = 0
                    GROUP BY GLD.GPV_ID
            ), CALCULOS AS (
                SELECT GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA, 
                    NVL(GDE.GDE_IMPORTE_TOTAL, 0) GDE_IMPORTE_TOTAL,
                    NVL(GLD.IMPORTE_TOTAL, 0) GLD_IMPORTE_TOTAL,
                    NVL(GDE.GDE_IRPF_BASE, 0) * NVL(GDE.GDE_IRPF_TIPO_IMPOSITIVO, 0) / 100 IRPF, 
                    CASE
                        WHEN CRA.DD_CRA_CODIGO = ''08'' AND TRE.DD_TRE_CODIGO = ''ANT''
                            THEN (NVL(GDE.GDE_RET_GAR_BASE, 0) + NVL(GLD.IVA, 0)) * NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) / 100
                            ELSE NVL(GDE.GDE_RET_GAR_BASE, 0) * NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0) / 100
                        END RETENCION
                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
                    AND GDE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
                    AND GGE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                    AND EGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                    AND PRO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                    AND CRA.BORRADO = 0
                LEFT JOIN IMPORTES_LINEA GLD ON GLD.GPV_ID = GPV.GPV_ID
                LEFT JOIN '||V_ESQUEMA||'.DD_TRE_TIPO_RETENCION TRE ON TRE.DD_TRE_ID = GDE.DD_TRE_ID
                    AND TRE.BORRADO = 0
                WHERE GPV.BORRADO = 0
                    AND EGA.DD_EGA_CODIGO IN ('||ESTADOS||')
                    '||LISTA_GPV||'
            )
            SELECT GPV_ID, GPV_NUM_GASTO_HAYA, GDE_IMPORTE_TOTAL, 
                ROUND(GLD_IMPORTE_TOTAL - IRPF - RETENCION, 2) CALCULO,
                GLD_IMPORTE_TOTAL, IRPF, RETENCION
            FROM CALCULOS
            WHERE ABS(GDE_IMPORTE_TOTAL - ROUND(GLD_IMPORTE_TOTAL - IRPF - RETENCION, 2)) <> 0
        ) T2
        ON (T1.GPV_ID = T2.GPV_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.GDE_IMPORTE_TOTAL = T2.CALCULO';
    EXECUTE IMMEDIATE V_MSQL;
    RESULTADO := RESULTADO || ' [INFO] Recálculo importe total gasto. '||SQL%ROWCOUNT||' filas fusionadas.'||CHR(10);
        
    COMMIT;

EXCEPTION
    WHEN VALOR_INCORRECTO THEN
        RESULTADO := RESULTADO || '  [ERROR] Parámetros suministrados insuficientes o incorrectos. Opciones -> TODOS: 0 y LISTA_GPV rellena con gastos separados por comas. TODOS: 1.'||CHR(10);
    WHEN OTHERS THEN
        RESULTADO := RESULTADO || SQLERRM ||CHR(10);
        RESULTADO := RESULTADO || V_MSQL ||CHR(10);
        ROLLBACK;
        RAISE;
        
END SP_ACTUALIZAR_IMPORTES_GASTOS;