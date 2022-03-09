--/* 
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17208
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16596] - Alejandra García
--##        0.2 Añadir merge a la GLD_ENT - [HREOS-16896] - Alejandra García
--##        0.3 Quitar merge a la GLD_ENT y el filtro del campo DD_EAL_ID en la LFACT_SIN_PROV y FACT_PROV- [HREOS-16968] - Alejandra García
--##        0.4 Modificar filtro del la ETG- [HREOS-17018] - Alejandra García
--##        0.5 Corrección filtro del la ETG- [HREOS-17073] - Alejandra García
--##        0.6 Corrección filtro del la ETG campos TGA y STG- [HREOS-17073] - Alejandra García
--##        0.7 Cambiar campo PROMOCION por DD_PRO_ID - [HREOS-17073] - Alejandra García
--##        0.8 Añadir campo DD_SCM_ID como nuevo parámetro- [HREOS-17208] - Alejandra García
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_CODIGOS_GASTOS (
                                                                pGLD_ID IN NUMBER DEFAULT NULL
                                                              , pENT_ID IN NUMBER DEFAULT NULL
                                                              , pGPV_ID IN NUMBER DEFAULT NULL
                                                              , pETL IN NUMBER DEFAULT 0
                                                              , pUSUARIOMODIFICAR IN VARCHAR2 DEFAULT 'SP_CODIGOS_GASTOS'
                                                              , PL_OUTPUT OUT VARCHAR2) IS

	  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_MSQL VARCHAR2(20000 CHAR); -- Sentencia a ejecutar

BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO]');

  --Cuando se ejecuta desde el ETL apr_gen_ru_salidas_facturas
  IF pETL = 1 THEN

        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.APR_AUX_I_RU_LFACT_SIN_PROV T1
              USING (
                SELECT
                        GPV.GPV_NUM_GASTO_HAYA AS FAC_ID_REM
                      , AUX.ID_ACTIVO_ESPECIAL AS ID_ACTIVO_ESPECIAL
                      , AUX.LINEA_GASTO AS LINEA_GASTO
                      , ETG.ELEMENTO_PEP AS ELEMENTO_PEP
                      ,  CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS COD_GRUPO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS COD_TIPO_ACCION
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS COD_SUBTIPO_ACCION
                      , ROW_NUMBER() OVER(PARTITION BY GPV.GPV_NUM_GASTO_HAYA, AUX.ID_ACTIVO_ESPECIAL, AUX.LINEA_GASTO ORDER BY ETG.DD_SCM_ID DESC NULLS LAST) RN
                FROM '|| V_ESQUEMA ||'.APR_AUX_I_RU_LFACT_SIN_PROV AUX
                JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = AUX.FAC_ID_REM
                    AND GPV.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0 AND NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 0  AND GLD.GLD_ID = AUX.LINEA_GASTO
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID AND GEN.ENT_ID = AUX.ACT_ID
                    AND GEN.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON NVL(ETG.DD_TGA_ID, 0) = CASE
                                                                                              WHEN GEN.DD_SED_ID IS NOT NULL AND GEN.DD_PRO_ID IS NOT NULL THEN 0
                                                                                              ELSE GPV.DD_TGA_ID
                                                                                              END
                    AND NVL(ETG.DD_STG_ID, 0) = CASE
                                                  WHEN GEN.DD_SED_ID IS NOT NULL AND GEN.DD_PRO_ID IS NOT NULL THEN 0
                                                  ELSE GLD.DD_STG_ID 
                                                  END 
                    AND CASE 
                        WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                        WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                        ELSE ETG.PRO_ID
                    END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND NVL(ETG.DD_CBC_ID, GEN.DD_CBC_ID) = GEN.DD_CBC_ID
                    AND NVL(ETG.DD_TTR_ID, NVL(GEN.DD_TTR_ID, 0)) = NVL(GEN.DD_TTR_ID, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.PRIM_TOMA_POSESION, NVL(GEN.PRIM_TOMA_POSESION, 0)) = NVL(GEN.PRIM_TOMA_POSESION, 0)
                    AND NVL(ETG.DD_SED_ID, NVL(GEN.DD_SED_ID, 0)) = NVL(GEN.DD_SED_ID, 0)
                    AND NVL(ETG.DD_PRO_ID, NVL(GEN.DD_PRO_ID, 0)) = NVL(GEN.DD_PRO_ID, 0)
                    AND NVL(ETG.DD_SCM_ID,  NVL(GEN.DD_SCM_ID, 0) = NVL(GEN.DD_SCM_ID, 0)
                    AND ETG.BORRADO = 0
                UNION
                SELECT
                        GPV.GPV_NUM_GASTO_HAYA AS FAC_ID_REM
                      , AUX.ID_ACTIVO_ESPECIAL AS ID_ACTIVO_ESPECIAL
                      , AUX.LINEA_GASTO AS LINEA_GASTO
                      , ETG.ELEMENTO_PEP AS ELEMENTO_PEP
                      ,  CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS COD_GRUPO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS COD_TIPO_ACCION
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS COD_SUBTIPO_ACCION
                FROM '|| V_ESQUEMA ||'.APR_AUX_I_RU_LFACT_SIN_PROV AUX
                JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = AUX.FAC_ID_REM
                    AND GPV.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0 AND NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 1 AND GLD.GLD_ID = AUX.LINEA_GASTO
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON NVL(ETG.DD_TGA_ID, 0) = CASE
                                                                                              WHEN GLD.DD_SED_ID IS NOT NULL AND GLD.DD_PRO_ID IS NOT NULL THEN 0
                                                                                              ELSE GPV.DD_TGA_ID
                                                                                              END
                    AND NVL(ETG.DD_STG_ID, 0) = CASE
                                                  WHEN GLD.DD_SED_ID IS NOT NULL AND GLD.DD_PRO_ID IS NOT NULL THEN 0
                                                  ELSE GLD.DD_STG_ID 
                                                  END 
                    AND CASE 
                              WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                              WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                              ELSE ETG.PRO_ID
                          END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.DD_PRO_ID, NVL(GLD.DD_PRO_ID, 0)) = NVL(GLD.DD_PRO_ID, 0)
                    AND ETG.BORRADO = 0
              ) T2 ON (T1.FAC_ID_REM = T2.FAC_ID_REM AND T1.LINEA_GASTO = T2.LINEA_GASTO AND T1.ID_ACTIVO_ESPECIAL = T2.ID_ACTIVO_ESPECIAL AND T2.RN = 1)
              WHEN MATCHED THEN UPDATE SET
                  T1.COD_GRUPO_GASTO = T2.COD_GRUPO_GASTO
                , T1.COD_TIPO_ACCION = T2.COD_TIPO_ACCION
                , T1.COD_SUBTIPO_ACCION = T2.COD_SUBTIPO_ACCION
                , T1.ELEMENTO_PEP = T2.ELEMENTO_PEP
                 ';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] (' || sql%rowcount || ') FILAS MODIFICADAS EN APR_AUX_I_RU_LFACT_SIN_PROV');
        PL_OUTPUT := PL_OUTPUT ||'[INFO]: FILAS MODIFICADAS EN APR_AUX_I_RU_LFACT_SIN_PROV (' || sql%rowcount || ') '|| CHR(10);

        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.APR_AUX_I_RU_FACT_PROV T1
              USING (
                SELECT
                        GPV.GPV_NUM_GASTO_HAYA AS FAC_ID_REM
                      , AUX.ID_ACTIVO_ESPECIAL AS ID_ACTIVO_ESPECIAL
                      , AUX.LINEA_GASTO AS LINEA_GASTO
                      , ETG.ELEMENTO_PEP AS ELEMENTO_PEP
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS COD_GRUPO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS COD_TIPO_CONCEPTO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS COD_SUBTIPO_GASTO
                      , ROW_NUMBER() OVER(PARTITION BY GPV.GPV_NUM_GASTO_HAYA, AUX.ID_ACTIVO_ESPECIAL, AUX.LINEA_GASTO ORDER BY ETG.DD_SCM_ID DESC NULLS LAST) RN
                FROM '|| V_ESQUEMA ||'.APR_AUX_I_RU_FACT_PROV AUX
                JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = AUX.FAC_ID_REM
                    AND GPV.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0 AND NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 0 AND GLD.GLD_ID = AUX.LINEA_GASTO
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                    AND GEN.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON NVL(ETG.DD_TGA_ID, 0) = CASE
                                                                                              WHEN GEN.DD_SED_ID IS NOT NULL AND GEN.DD_PRO_ID IS NOT NULL THEN 0
                                                                                              ELSE GPV.DD_TGA_ID
                                                                                              END
                    AND NVL(ETG.DD_STG_ID, 0) = CASE
                                                  WHEN GEN.DD_SED_ID IS NOT NULL AND GEN.DD_PRO_ID IS NOT NULL THEN 0
                                                  ELSE GLD.DD_STG_ID 
                                                  END 
                    AND CASE 
                              WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                              WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                              ELSE ETG.PRO_ID
                          END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND NVL(ETG.DD_CBC_ID, GEN.DD_CBC_ID) = GEN.DD_CBC_ID
                    AND NVL(ETG.DD_TTR_ID, NVL(GEN.DD_TTR_ID, 0)) = NVL(GEN.DD_TTR_ID, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.PRIM_TOMA_POSESION, NVL(GEN.PRIM_TOMA_POSESION, 0)) = NVL(GEN.PRIM_TOMA_POSESION, 0)
                    AND NVL(ETG.DD_SED_ID, NVL(GEN.DD_SED_ID, 0)) = NVL(GEN.DD_SED_ID, 0)
                    AND NVL(ETG.DD_PRO_ID, NVL(GEN.DD_PRO_ID, 0)) = NVL(GEN.DD_PRO_ID, 0)
                    AND NVL(ETG.DD_SCM_ID,  NVL(GEN.DD_SCM_ID, 0) = NVL(GEN.DD_SCM_ID, 0)
                    AND ETG.BORRADO = 0
                UNION
                 SELECT
                        GPV.GPV_NUM_GASTO_HAYA AS FAC_ID_REM
                      , AUX.ID_ACTIVO_ESPECIAL AS ID_ACTIVO_ESPECIAL
                      , AUX.LINEA_GASTO AS LINEA_GASTO
                      , ETG.ELEMENTO_PEP AS ELEMENTO_PEP
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS COD_GRUPO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS COD_TIPO_CONCEPTO_GASTO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS COD_SUBTIPO_GASTO
                FROM '|| V_ESQUEMA ||'.APR_AUX_I_RU_FACT_PROV AUX
                JOIN '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = AUX.FAC_ID_REM
                    AND GPV.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0 AND NVL(GLD.GLD_LINEA_SIN_ACTIVOS, 0) = 1 AND GLD.GLD_ID = AUX.LINEA_GASTO
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON NVL(ETG.DD_TGA_ID, 0) = CASE
                                                                                              WHEN GLD.DD_SED_ID IS NOT NULL AND GLD.DD_PRO_ID IS NOT NULL THEN 0
                                                                                              ELSE GPV.DD_TGA_ID
                                                                                              END
                    AND NVL(ETG.DD_STG_ID, 0) = CASE
                                                  WHEN GLD.DD_SED_ID IS NOT NULL AND GLD.DD_PRO_ID IS NOT NULL THEN 0
                                                  ELSE GLD.DD_STG_ID 
                                                  END 
                    AND CASE 
                              WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                              WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                              ELSE ETG.PRO_ID
                          END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.DD_PRO_ID, NVL(GLD.DD_PRO_ID, 0)) = NVL(GLD.DD_PRO_ID, 0)
                    AND ETG.BORRADO = 0
              ) T2 ON (T1.FAC_ID_REM = T2.FAC_ID_REM AND T1.LINEA_GASTO = T2.LINEA_GASTO AND T1.ID_ACTIVO_ESPECIAL = T2.ID_ACTIVO_ESPECIAL AND T2.RN =1)
              WHEN MATCHED THEN UPDATE SET
                  T1.COD_GRUPO_GASTO = T2.COD_GRUPO_GASTO
                , T1.COD_TIPO_CONCEPTO_GASTO = T2.COD_TIPO_CONCEPTO_GASTO
                , T1.COD_SUBTIPO_GASTO = T2.COD_SUBTIPO_GASTO
                , T1.ELEMENTO_PEP = T2.ELEMENTO_PEP
                 ';

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] (' || sql%rowcount || ') FILAS MODIFICADAS EN APR_AUX_I_RU_FACT_PROV');
        PL_OUTPUT := PL_OUTPUT ||'[INFO]: FILAS MODIFICADAS EN APR_AUX_I_RU_FACT_PROV (' || sql%rowcount || ') '|| CHR(10);

        
  ELSIF pGPV_ID IS NOT NULL THEN

        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GLD_ENT T1
              USING (
                SELECT
                        GEN.GLD_ENT_ID
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS GRUPO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS TIPO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS SUBTIPO

                FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                    AND GEN.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
                    AND ACT.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID
                    AND PTA.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID
                    AND GLD_TBJ.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GLD_TBJ.TBJ_ID
                    AND TBJ.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
                      AND TGA.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_TGA_ID = TGA.DD_TGA_ID
                      AND STG.DD_STG_ID = GLD.DD_STG_ID
                      AND STG.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON ETG.DD_TGA_ID = GPV.DD_TGA_ID
                    AND ETG.DD_STG_ID = GLD.DD_STG_ID AND CASE 
                                                              WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                                                              WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                                                              ELSE ETG.PRO_ID
                                                          END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND NVL(ETG.DD_CBC_ID, ACT.DD_CBC_ID) = ACT.DD_CBC_ID
                    AND NVL(ETG.DD_TTR_ID, NVL(ACT.DD_TTR_ID, 0)) = NVL(ACT.DD_TTR_ID, 0)
                    AND NVL(ETG.DD_EAL_ID ,NVL(PTA.DD_EAL_ID, 0)) = NVL(PTA.DD_EAL_ID, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.PRIM_TOMA_POSESION, NVL(TBJ.TBJ_PRIM_TOMA_POS, 0)) = NVL(TBJ.TBJ_PRIM_TOMA_POS, 0)
                    AND ETG.BORRADO = 0
                WHERE GPV.GPV_ID = '|| pGPV_ID ||'
                AND GPV.BORRADO = 0
              ) T2 ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
              WHEN MATCHED THEN UPDATE SET
                  T1.GRUPO = T2.GRUPO
                , T1.TIPO = T2.TIPO
                , T1.SUBTIPO = T2.SUBTIPO
                , T1.USUARIOMODIFICAR = '||pUSUARIOMODIFICAR||'
                , T1.FECHAMODIFICAR = SYSDATE
                 ';


        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] (' || sql%rowcount || ') FILAS MODIFICADAS EN GLD_ENT');
        PL_OUTPUT := PL_OUTPUT ||'[INFO]: FILAS MODIFICADAS EN GLD_ENT (' || sql%rowcount || ') '|| CHR(10);

  ELSIF pGLD_ID IS NOT NULL AND pENT_ID IS NOT NULL THEN

        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GLD_ENT T1
              USING (
                SELECT
                        GEN.GLD_ENT_ID
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COGRUG_POS
                          ELSE ETG.COGRUG_NEG
                        END AS GRUPO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COTACA_POS
                          ELSE ETG.COTACA_NEG
                        END AS TIPO
                      , CASE
                          WHEN NVL(GLD.GLD_IMPORTE_TOTAL, 0) > 0 THEN ETG.COSBAC_POS
                          ELSE ETG.COSBAC_NEG
                        END AS SUBTIPO

                FROM '|| V_ESQUEMA ||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '|| V_ESQUEMA ||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID
                      AND GLD.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
                    AND GEN.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.GIC_GASTOS_INFO_CONTABILIDAD GIC ON GIC.GPV_ID = GPV.GPV_ID
                    AND GIC.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = GIC.EJE_ID
                    AND EJE.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = GPV.PRO_ID
                  AND PRO.PRO_DOCIDENTIF IN (''B46644290'',''A08663619'',''A58032244'') AND PRO.PRO_SOCIEDAD_PAGADORA IN (''3148'',''0001'',''0015'')
                  AND PRO.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GEN.ENT_ID
                    AND ACT.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID
                    AND PTA.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.GLD_TBJ ON GLD_TBJ.GLD_ID = GLD.GLD_ID
                    AND GLD_TBJ.BORRADO = 0
                LEFT JOIN '|| V_ESQUEMA ||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GLD_TBJ.TBJ_ID
                    AND TBJ.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
                      AND TGA.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_TGA_ID = TGA.DD_TGA_ID
                      AND STG.DD_STG_ID = GLD.DD_STG_ID
                      AND STG.BORRADO = 0
                JOIN '|| V_ESQUEMA ||'.DD_ETG_EQV_TIPO_GASTO ETG ON ETG.DD_TGA_ID = GPV.DD_TGA_ID
                    AND ETG.DD_STG_ID = GLD.DD_STG_ID AND CASE 
                                                              WHEN ETG.PRO_ID IS NULL AND PRO.PRO_SOCIEDAD_PAGADORA = ''3148'' AND EJE.EJE_ANYO <= ''2021'' THEN NULL
                                                              WHEN ETG.PRO_ID IS NULL THEN PRO.PRO_ID
                                                              ELSE ETG.PRO_ID
                                                          END = PRO.PRO_ID
                    AND NVL(ETG.SUBROGADO,NVL(GPV.ALQ_SUBROGADO, 0)) = NVL(GPV.ALQ_SUBROGADO, 0)
                    AND NVL(ETG.DD_CBC_ID, ACT.DD_CBC_ID) = ACT.DD_CBC_ID
                    AND NVL(ETG.DD_TTR_ID, NVL(ACT.DD_TTR_ID, 0)) = NVL(ACT.DD_TTR_ID, 0)
                    AND NVL(ETG.DD_EAL_ID ,NVL(PTA.DD_EAL_ID, 0)) = NVL(PTA.DD_EAL_ID, 0)
                    AND ETG.EJE_ID = CASE
                                        WHEN EJE.EJE_ANYO <= ''2021'' THEN (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2021'')
                                        ELSE (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
                                    END
                    AND NVL(ETG.PRIM_TOMA_POSESION, NVL(TBJ.TBJ_PRIM_TOMA_POS, 0)) = NVL(TBJ.TBJ_PRIM_TOMA_POS, 0)
                    AND ETG.BORRADO = 0
                WHERE GLD.GLD_ID = '|| pGLD_ID ||'
                AND GEN.ENT_ID = '|| pENT_ID ||'
                AND GPV.BORRADO = 0
              ) T2 ON (T1.GLD_ENT_ID = T2.GLD_ENT_ID)
              WHEN MATCHED THEN UPDATE SET
                  T1.GRUPO = T2.GRUPO
                , T1.TIPO = T2.TIPO
                , T1.SUBTIPO = T2.SUBTIPO
                , T1.USUARIOMODIFICAR = '||pUSUARIOMODIFICAR||'
                , T1.FECHAMODIFICAR = SYSDATE
                 ';


        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] (' || sql%rowcount || ') FILAS MODIFICADAS EN GLD_ENT');
        PL_OUTPUT := PL_OUTPUT ||'[INFO]: FILAS MODIFICADAS EN GLD_ENT (' || sql%rowcount || ') '|| CHR(10);

  END IF;

	COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]');

	EXCEPTION
	  WHEN OTHERS THEN
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
	    DBMS_OUTPUT.put_line(ERR_MSG);
	    ROLLBACK;
	    RAISE;

	END SP_CODIGOS_GASTOS;
/
EXIT;
