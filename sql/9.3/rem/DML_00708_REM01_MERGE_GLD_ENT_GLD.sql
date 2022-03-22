--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=2020308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17341
--## PRODUCTO=NO
--##
--## Finalidad: Merges cañonazos
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-17341'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] GLD_ENT');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_ENT T1
                USING (
                    WITH PRINCIPAL AS (
                            SELECT
                                GEN.GLD_ENT_ID
                                , TBJ.TBJ_PRIM_TOMA_POS PRIM_TOMA_POSESION
                                , SED.DD_SED_ID
                                , ACTTBJ.ACT_ID
                                , GPV.GPV_ID
                                , GPV.PRO_ID
                                , PRO.DD_PRO_ID
                                , TBJ.TBJ_IMPORTE_TOTAL
                            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PROP ON PROP.PRO_ID=GPV.PRO_ID
                                AND PROP.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID= PROP.DD_CRA_ID
                                --AND CRA.BORRAD0 = 0
                            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                                AND GLD.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                                AND GEN.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO DD_ENT ON DD_ENT.DD_ENT_ID = GEN.DD_ENT_ID AND DD_ENT.DD_ENT_CODIGO = ''ACT''
                            LEFT JOIN '||V_ESQUEMA||'.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID
                                AND GLD_TBJ.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GLD_TBJ.TBJ_ID
                                AND TBJ.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_TBJ ACTTBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID AND GEN.ENT_ID = ACTTBJ.ACT_ID
                            LEFT JOIN '||V_ESQUEMA||'.DD_SED_SUBPARTIDA_EDIFICACION SED ON SED.DD_SED_CODIGO = TBJ.TBJ_CODIGO_SUBPARTIDA
                                AND SED.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.DD_PRO_PROMOCIONES PRO ON PRO.DD_PRO_CODIGO = TBJ.TBJ_NOMBRE_PROYECTO
                                AND PRO.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                                AND GIC.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                                AND EJE.BORRADO = 0      
                            WHERE GPV.BORRADO = 0      
                            AND EJE.EJE_ANYO = ''2022''  
                            AND CRA.DD_CRA_CODIGO = ''03''
                        ),PRIMERA_TOMA_POSESION AS (
                            SELECT
                                P.GLD_ENT_ID
                                ,P.ACT_ID
                                ,P.PRIM_TOMA_POSESION
                                ,P.DD_SED_ID
                                ,P.DD_PRO_ID
                                ,ROW_NUMBER() OVER(PARTITION BY P.GLD_ENT_ID ORDER BY P.TBJ_IMPORTE_TOTAL DESC NULLS LAST) RN
                            FROM PRINCIPAL P
                        )
                        SELECT DISTINCT
                                GEN.GLD_ENT_ID
                                , CASE
                                    WHEN DCA.DCA_ID IS NOT NULL AND DCA.DCA_FECHA_FIRMA < SYSDATE AND DCA.DCA_FECHA_FIN_CONTRATO >= SYSDATE  AND DCA.DCA_EST_CONTRATO = ''Alquilada''
                                        THEN (SELECT DD_CBC_ID FROM '||V_ESQUEMA||'.DD_CBC_CARTERA_BC WHERE DD_CBC_CODIGO = ''03'')
                                    ELSE (SELECT DD_CBC_ID FROM '||V_ESQUEMA||'.DD_CBC_CARTERA_BC WHERE DD_CBC_CODIGO = ''01'')
                                END AS DD_CBC_ID
                                , ACT.DD_TTR_ID
                                , PRIM.PRIM_TOMA_POSESION
                                , PRIM.DD_SED_ID
                                , PRIM.DD_PRO_ID            
                                , CASE
                                    WHEN SCM.DD_SCM_CODIGO = ''05'' THEN SCM.DD_SCM_ID
                                    ELSE NULL
                                END AS DD_SCM_ID
                            from PRINCIPAL GPV
                            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                                AND GLD.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                                AND GEN.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                                AND PRO.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
                                AND ACT.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
                            AND SCM.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID
                                AND PTA.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.ACT_DCA_DATOS_CONTRATO_ALQ DCA ON DCA.ACT_ID=PTA.ACT_ID
                                AND DCA.BORRADO = 0
                            LEFT JOIN PRIMERA_TOMA_POSESION PRIM ON GEN.GLD_ENT_ID = PRIM.GLD_ENT_ID AND ACT.ACT_ID = PRIM.ACT_ID AND PRIM.RN = 1    
                            WHERE NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 0
                ) T2 ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.DD_CBC_ID = T2.DD_CBC_ID
                    , T1.DD_TTR_ID = T2.DD_TTR_ID
                    , T1.PRIM_TOMA_POSESION = T2.PRIM_TOMA_POSESION
                    , T1.DD_SED_ID = T2.DD_SED_ID
                    , T1.DD_PRO_ID = T2.DD_PRO_ID
                    , T1.DD_SCM_ID = T2.DD_SCM_ID
                    , T1.USUARIOMODIFICAR = ''HREOS-17341''
                    , T1.FECHAMODIFICAR = SYSDATE  
                ';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN GLD_ENT');  

     DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO REM01.GLD_GASTOS_LINEA_DETALLE T1
                USING (
                    WITH PRINCIPAL AS (
                            SELECT
                                GLD.GLD_ID
                                , TBJ.TBJ_PRIM_TOMA_POS PRIM_TOMA_POSESION
                                , SED.DD_SED_ID
                                , GPV.GPV_ID
                                , GPV.PRO_ID
                                , PRO.DD_PRO_ID
                                , TBJ.TBJ_IMPORTE_TOTAL
                            FROM REM01.GPV_GASTOS_PROVEEDOR GPV
                            JOIN REM01.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                                AND GLD.BORRADO = 0
                            LEFT JOIN REM01.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID
                                AND GLD_TBJ.BORRADO = 0
                            LEFT JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GLD_TBJ.TBJ_ID
                                AND TBJ.BORRADO = 0
                            LEFT JOIN REM01.DD_SED_SUBPARTIDA_EDIFICACION SED ON SED.DD_SED_CODIGO = TBJ.TBJ_CODIGO_SUBPARTIDA
                                AND SED.BORRADO = 0
                            LEFT JOIN REM01.DD_PRO_PROMOCIONES PRO ON PRO.DD_PRO_CODIGO = TBJ.TBJ_NOMBRE_PROYECTO
                                AND PRO.BORRADO = 0
                            JOIN REM01.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                                AND GIC.BORRADO = 0
                            JOIN REM01.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                                AND EJE.BORRADO = 0
                            JOIN REM01.ACT_PRO_PROPIETARIO PROP ON PROP.PRO_ID=GPV.PRO_ID
                                AND PROP.BORRADO = 0  
                            JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=PROP.DD_CRA_ID
                                --AND CRA.BORRAD0 = 0
                            WHERE GPV.BORRADO = 0      
                            AND EJE.EJE_ANYO = ''2022''  
                            AND CRA.DD_CRA_CODIGO = ''03''  
                            AND NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 1
                        ),PRIMERA_TOMA_POSESION AS (
                            SELECT
                                P.GLD_ID
                                ,P.PRIM_TOMA_POSESION
                                ,P.DD_SED_ID
                                ,P.DD_PRO_ID
                                ,ROW_NUMBER() OVER(PARTITION BY P.GLD_ID ORDER BY P.TBJ_IMPORTE_TOTAL DESC NULLS LAST) RN
                            FROM PRINCIPAL P
                        )
                        SELECT DISTINCT
                                PRIM.GLD_ID
                                , PRIM.PRIM_TOMA_POSESION
                                , PRIM.DD_SED_ID
                                , PRIM.DD_PRO_ID        
                            from PRIMERA_TOMA_POSESION PRIM
                            WHERE PRIM.RN = 1  
                ) T2 ON (T1.GLD_ID = T2.GLD_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.PRIM_TOMA_POSESION = T2.PRIM_TOMA_POSESION
                    , T1.DD_SED_ID = T2.DD_SED_ID
                    , T1.DD_PRO_ID = T2.DD_PRO_ID
                    , T1.USUARIOMODIFICAR = ''HREOS-17341''
                    , T1.FECHAMODIFICAR = SYSDATE 
                ';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN GLD_GASTOS_LINEA_DETALLE');  


    COMMIT;

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
