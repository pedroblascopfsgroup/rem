--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10307
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica CUENTA Y PARTIDA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA_CCC VARCHAR2(27 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES';
	V_TEXT_TABLA_CPP VARCHAR2(27 CHAR) := 'ACT_CONFIG_PTDAS_PREP';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10307'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
     DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS CUENTAS PARTIDAS GASTOS ');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
               
                SELECT distinct GLD.GLD_ID,ctas.ccc_cuenta_contable AS CCC_BASE,ctas.ccc_subcuenta_contable AS CCC_SUB_BASE,


                CASE WHEN ctas2.ccc_cuenta_contable IS NULL
                THEN GLD.GLD_CCC_RECARGO
                ELSE ctas2.ccc_cuenta_contable END AS CCC_RECARGO, 

                CASE WHEN ctas2.ccc_subcuenta_contable IS NULL 
                THEN GLD.GLD_SUBCUENTA_RECARGO
                ELSE ctas2.ccc_subcuenta_contable 
                END AS CCC_SUB_RECARGO, 

                CASE WHEN ctas3.ccc_cuenta_contable IS NULL
                THEN GLD.GLD_CCC_INTERESES 
                ELSE ctas3.ccc_cuenta_contable
                END AS CCC_INTERES, 

                CASE WHEN ctas3.ccc_subcuenta_contable IS NULL
                THEN GLD.GLD_SUBCUENTA_INTERESES
                ELSE ctas3.ccc_subcuenta_contable
                END AS CCC_SUB_INTERES

                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO = 0
                JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON gic.gpv_id=GPV.GPV_ID
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID AND PRO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.gld_ent GLENT ON GLENT.GLD_ID=GLD.GLD_ID AND glent.dd_ent_id=1 AND GLENT.BORRADO = 0 
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=glent.ent_id AND ACT.BORRADO = 0
                join '||V_ESQUEMA||'.act_ilb_nfo_liberbank ilb on ilb.act_id=act.act_id

                JOIN '||V_ESQUEMA||'.act_config_ctas_contables CTAS ON CTAS.PRO_ID=GPV.PRO_ID --AND CTAS.DD_CRA_ID=PRO.DD_cRA_ID
                AND CTAS.BORRADO = 0 AND CTAS.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS.EJE_ID AND CTAS.DD_SCR_ID=ACT.DD_SCR_ID
                and ilb.dd_tbe_id=ctas.dd_tbe_id and ctas.dd_tim_id=1

                LEFT JOIN '||V_ESQUEMA||'.act_config_ctas_contables CTAS2 ON CTAS2.PRO_ID=GPV.PRO_ID --AND CTAS.DD_CRA_ID=PRO.DD_cRA_ID
                AND CTAS2.BORRADO = 0 AND CTAS2.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS2.EJE_ID AND CTAS2.DD_SCR_ID=ACT.DD_SCR_ID
                and ilb.dd_tbe_id=ctas2.dd_tbe_id and ctas2.dd_tim_id=3

                LEFT JOIN '||V_ESQUEMA||'.act_config_ctas_contables CTAS3 ON CTAS3.PRO_ID=GPV.PRO_ID --AND CTAS.DD_CRA_ID=PRO.DD_cRA_ID
                AND CTAS3.BORRADO = 0 AND CTAS3.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS3.EJE_ID AND CTAS3.DD_SCR_ID=ACT.DD_SCR_ID
                and ilb.dd_tbe_id=ctas3.dd_tbe_id and ctas3.dd_tim_id=4

                WHERE GPV.BORRADO = 0 AND GPV.PRO_ID=(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF=''A93139053'')
                AND GLD.GLD_ID NOT IN (
2938622,
1895301,
4979350,
3880045,
5408322,
2386233,
2955451,
3904777,
2291741,
4984868,
5408346,
5408328,
2236068,
5578684,
3637653,
5524164,
5408309,
3780343,
1961922,
2218071,
5555207,
2940163,
3895613,
2315306,
1923009,
2958748,
1895323,
2160224,
2216459,
5578667,
2976085,
1937884,
2311044,
2304878,
5515597,
5555209,
5408340,
5142083,
5188254,
5515677,
5534747,
2031556,
5515562,
5555183,
2593386,
2045236,
5408310,
2379886,
5515661,
3985204,
2020381,
4968653,
2921051,
2512057,
2370080,
2428922,
5515665,
5251503,
3085303,
2225125,
2353627,
5562998,
2364482,
2368390,
5408315,
2248377,
5342558,
5346338,
5342549,
5342526,
5174915                
                )
                ORDER BY GLD.GLD_ID
                ) T2
            ON (T1.GLD_ID = T2.GLD_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.GLD_CCC_BASE =T2.CCC_BASE,
            T1.GLD_SUBCUENTA_BASE = T2.CCC_SUB_BASE,
            T1.GLD_CCC_RECARGO = T2.CCC_RECARGO,
            T1.GLD_SUBCUENTA_RECARGO =T2.CCC_SUB_RECARGO,
            T1.GLD_CCC_INTERESES = T2.CCC_INTERES,
            T1.GLD_SUBCUENTA_INTERESES = T2.CCC_SUB_INTERES,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS CUENTAS CON ACTIVOS ');



        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
               
                SELECT distinct GPV.GPV_NUM_GASTO_HAYA,GLD.GLD_ID,ctas.CPP_PARTIDA_PRESUPUESTARIA AS CPP_BASE,ctas.CPP_APARTADO AS CPP_APARTADO_BASE,
                    ctas.cpp_capitulo as CPP_CAPITULO_BASE,

                    CASE WHEN ctas2.CPP_PARTIDA_PRESUPUESTARIA IS NULL
                    THEN GLD.GLD_CPP_RECARGO
                    ELSE ctas2.CPP_PARTIDA_PRESUPUESTARIA END AS CPP_RECARGO, 

                    CASE WHEN ctas2.CPP_APARTADO IS NULL 
                    THEN GLD.GLD_APARTADO_RECARGO
                    ELSE ctas2.CPP_APARTADO 
                    END AS CPP_APARTADO_RECARGO, 

                    CASE WHEN ctas2.cpp_capitulo IS NULL 
                    THEN GLD.GLD_CAPITULO_RECARGO
                    ELSE ctas2.cpp_capitulo
                    END AS CPP_CAPITULO_RECARGO, 

                    CASE WHEN ctas3.CPP_PARTIDA_PRESUPUESTARIA IS NULL
                    THEN GLD.GLD_CPP_INTERESES 
                    ELSE ctas3.CPP_PARTIDA_PRESUPUESTARIA
                    END AS CPP_INTERES, 

                    CASE WHEN ctas3.CPP_APARTADO IS NULL
                    THEN GLD.GLD_APARTADO_INTERESES
                    ELSE ctas3.CPP_APARTADO
                    END AS CPP_APARTADO_INTERES,

                    CASE WHEN ctas3.cpp_capitulo IS NULL
                    THEN GLD.GLD_CAPITULO_INTERESES
                    ELSE ctas3.cpp_capitulo
                    END AS CPP_CAPITULO_INTERES

                    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                    JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON gic.gpv_id=GPV.GPV_ID
                    JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID AND PRO.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.gld_ent GLENT ON GLENT.GLD_ID=GLD.GLD_ID AND glent.dd_ent_id=1 AND GLENT.BORRADO = 0 
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=glent.ent_id AND ACT.BORRADO = 0
                    join '||V_ESQUEMA||'.act_ilb_nfo_liberbank ilb on ilb.act_id=act.act_id

                    JOIN '||V_ESQUEMA||'.act_config_ptdas_prep CTAS ON CTAS.PRO_ID=GPV.PRO_ID 
                    AND CTAS.BORRADO = 0 AND CTAS.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS.EJE_ID AND CTAS.DD_SCR_ID=ACT.DD_SCR_ID
                    and ilb.dd_tbe_id=ctas.dd_tbe_id and ctas.dd_tim_id=1

                    LEFT JOIN '||V_ESQUEMA||'.act_config_ptdas_prep CTAS2 ON CTAS2.PRO_ID=GPV.PRO_ID 
                    AND CTAS2.BORRADO = 0 AND CTAS2.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS2.EJE_ID AND CTAS2.DD_SCR_ID=ACT.DD_SCR_ID
                    and ilb.dd_tbe_id=ctas2.dd_tbe_id and ctas2.dd_tim_id=3

                    LEFT JOIN '||V_ESQUEMA||'.act_config_ptdas_prep CTAS3 ON CTAS3.PRO_ID=GPV.PRO_ID
                    AND CTAS3.BORRADO = 0 AND CTAS3.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS3.EJE_ID AND CTAS3.DD_SCR_ID=ACT.DD_SCR_ID
                    and ilb.dd_tbe_id=ctas3.dd_tbe_id and ctas3.dd_tim_id=4


                    WHERE GPV.BORRADO = 0 AND GPV.PRO_ID=(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_DOCIDENTIF=''A93139053'')
                    AND GLD.GLD_ID NOT IN (
1891052,
1503347,
1895301,
2456416,
2158535,
3143647,
1910586,
2246327,
3206649,
1485113,
3135388,
1856403,
5273408,
2046719,
1485109,
1851162,
3141403,
1856317,
1943150,
2421632,
4984868,
5524164,
3637653,
1944587,
1952007,
1979915,
1956757,
5578684,
2082961,
3561613,
3575238,
1882307,
3587387,
2123128,
2054014,
2941363,
3149869,
2218071,
3895613,
3184052,
1927665,
2082934,
1943143,
2142673,
1932367,
3162543,
3160163,
3192966,
2160224,
2212566,
5578667,
1851324,
1970102,
2098560,
1877429,
2260617,
1501896,
2045185,
5515597,
2148094,
2071571,
3179402,
2123047,
1856383,
5515677,
5515562,
1943137,
3167818,
2054019,
2081450,
1855515,
5534747,
2014272,
2142664,
1910473,
2788744,
5515661,
1878835,
3679964,
3697867,
2045130,
2260462,
2251691,
3018350,
1910446,
2045151,
3085303,
1951987,
5515665,
1503343,
2248430,
5321330,
5342558,
2315306
                    )
                    ORDER BY GLD.GLD_ID
                ) T2
            ON (T1.GLD_ID = T2.GLD_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.GLD_CPP_BASE =T2.CPP_BASE,
            T1.GLD_APARTADO_BASE=T2.CPP_APARTADO_BASE,
            T1.GLD_CAPITULO_BASE=T2.CPP_CAPITULO_BASE,
            T1.GLD_CPP_RECARGO = T2.CPP_RECARGO,
            T1.GLD_APARTADO_RECARGO = T2.CPP_APARTADO_RECARGO,
            T1.GLD_CAPITULO_RECARGO =T2.CPP_CAPITULO_RECARGO,
            T1.GLD_CPP_INTERESES = T2.CPP_INTERES,
            T1.GLD_APARTADO_INTERESES = T2.CPP_APARTADO_INTERES,
            T1.GLD_CAPITULO_INTERESES = T2.CPP_CAPITULO_INTERES,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS PARTIDAS CON ACTIVOS ');



	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT