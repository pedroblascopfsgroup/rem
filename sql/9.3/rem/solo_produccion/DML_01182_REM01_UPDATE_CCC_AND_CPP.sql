--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11782
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11782'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    V_NUM_TABLAS NUMBER(16):=0;
    TABLE_COUNT NUMBER(1,0) := 0;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CPP||' T1 USING (
                SELECT DISTINCT aux.base,
TGA.DD_TGA_ID,
aux.tipo_gasto AS TIPO_GASTO_AUX,
STG.DD_STG_ID,
aux.subtipo_gasto as SUBTIPO_GASTO_AUX,
aux.pp_2022 AS PP_AUX,
CONFIG.EJE_ID,
config.CPP_PTDAS_ID,
config.cpp_partida_presupuestaria AS PP_CONFIG,
tga.dd_tga_descripcion,
stg.dd_stg_descripcion,
cra.dd_Cra_descripcion,
scr.dd_scr_descripcion
FROM REM01.AUX_REMVIP_11782 AUX
JOIN REM01.dd_stg_subtipos_gasto STG ON UPPER(STG.DD_STG_DESCRIPCION)=UPPER(AUX.SUBTIPO_GASTO)
JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID and upper(tga.dd_tga_descripcion)=upper(aux.tipo_Gasto) AND TGA.BORRADO = 0
LEFT jOIN REM01.act_config_ptdas_prep config ON CONFIG.DD_STG_ID=STG.DD_STG_ID AND CONFIG.BORRADO = 0 and config.dd_scr_id in (543,444,443,323) AND EJE_ID=73 AND CONFIG.DD_TIM_ID=1
LEFT join REM01.dd_scr_subcartera SCR ON scr.dd_scr_id=CONFIG.DD_SCR_ID AND SCR.BORRADO = 0
LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=config.dd_cra_id AND CRA.BORRADO = 0
where aux.pp_2022 !=config.cpp_partida_presupuestaria
) T2
            ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = T2.PP_AUX,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE PARTIDAS PRESUPUESTARIAS CPP');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' T1 USING (
SELECT DISTINCT aux.base,
TGA.DD_TGA_ID,
tga.dd_tga_codigo,
aux.tipo_gasto AS TIPO_GASTO_AUX,
STG.DD_STG_ID,
stg.dd_stg_codigo,
aux.subtipo_gasto as SUBTIPO_GASTO_AUX,
aux.CC_APPLE_JAGUAR AS CC_AUX_JAGUAR,
aux.CC_DIVARIAN AS CC_AUX_DIVARIAN,
CONFIG.EJE_ID,
CONFIG.CCC_CTAS_ID,
config.CCC_CUENTA_CONTABLE AS PP_CONFIG,
tga.dd_tga_descripcion,
stg.dd_stg_descripcion,
cra.dd_Cra_descripcion,
scr.dd_scr_descripcion,
scr.dd_scr_codigo
FROM REM01.AUX_REMVIP_11782 AUX
JOIN REM01.dd_stg_subtipos_gasto STG ON UPPER(STG.DD_STG_DESCRIPCION)=UPPER(AUX.SUBTIPO_GASTO)
JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID and upper(tga.dd_tga_descripcion)=upper(aux.tipo_Gasto) AND TGA.BORRADO = 0
LEFT jOIN REM01.ACT_CONFIG_CTAS_CONTABLES config ON CONFIG.DD_STG_ID=STG.DD_STG_ID AND CONFIG.BORRADO = 0 and config.dd_scr_id in (543,323,444,443) AND EJE_ID=73
LEFT join REM01.dd_scr_subcartera SCR ON scr.dd_scr_id=CONFIG.DD_SCR_ID AND SCR.BORRADO = 0
LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=config.dd_cra_id AND CRA.BORRADO = 0
where STG.DD_STG_CODIGO NOT IN (119,118,02,01) 
AND ((SCR.DD_SCR_ID IN (543,323) AND AUX.CC_APPLE_JAGUAR!=CONFIG.CCC_CUENTA_CONTABLE) OR (SCR.DD_SCR_ID IN (444,443) AND AUX.CC_DIVARIAN!=CONFIG.CCC_CUENTA_CONTABLE))
                ) T2
            ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = CASE WHEN T2.DD_SCR_CODIGO IN (70,138) THEN T2.CC_AUX_JAGUAR
                                        WHEN T2.DD_SCR_CODIGO IN (151,152) THEN T2.CC_AUX_DIVARIAN END,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES CCC');


        --Modificacion para cuentas contables ibis

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' T1 USING (
SELECT DISTINCT aux.base,
TGA.DD_TGA_ID,
tga.dd_tga_codigo,
aux.tipo_gasto AS TIPO_GASTO_AUX,
STG.DD_STG_ID,
stg.dd_stg_codigo,
aux.subtipo_gasto as SUBTIPO_GASTO_AUX,
aux.CC_APPLE_JAGUAR AS CC_AUX_JAGUAR,
aux.CC_DIVARIAN AS CC_AUX_DIVARIAN,
CONFIG.EJE_ID,
CONFIG.CCC_CTAS_ID,
config.CCC_CUENTA_CONTABLE AS PP_CONFIG,
tga.dd_tga_descripcion,
stg.dd_stg_descripcion,
cra.dd_Cra_descripcion,
scr.dd_scr_descripcion
FROM REM01.AUX_REMVIP_11782 AUX
JOIN REM01.dd_stg_subtipos_gasto STG ON UPPER(STG.DD_STG_DESCRIPCION)=UPPER(AUX.SUBTIPO_GASTO)
JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID and upper(tga.dd_tga_descripcion)=upper(aux.tipo_Gasto) AND TGA.BORRADO = 0
LEFT jOIN REM01.ACT_CONFIG_CTAS_CONTABLES config ON CONFIG.DD_STG_ID=STG.DD_STG_ID AND CONFIG.BORRADO = 0 and config.dd_scr_id in (444,443) AND EJE_ID=73 AND CONFIG.DD_TIM_ID=1
LEFT join REM01.dd_scr_subcartera SCR ON scr.dd_scr_id=CONFIG.DD_SCR_ID AND SCR.BORRADO = 0
LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=config.dd_cra_id AND CRA.BORRADO = 0
WHERE STG.DD_STG_CODIGO IN (02)
                ) T2
            ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = ''6311001'',
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES CCC PARA IBIS 2022 DIVARIAN');


        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' T1 USING (
SELECT DISTINCT aux.base,
TGA.DD_TGA_ID,
tga.dd_tga_codigo,
aux.tipo_gasto AS TIPO_GASTO_AUX,
STG.DD_STG_ID,
stg.dd_stg_codigo,
aux.subtipo_gasto as SUBTIPO_GASTO_AUX,
aux.CC_APPLE_JAGUAR AS CC_AUX_JAGUAR,
aux.CC_DIVARIAN AS CC_AUX_DIVARIAN,
CONFIG.EJE_ID,
CONFIG.CCC_CTAS_ID,
config.CCC_CUENTA_CONTABLE AS PP_CONFIG,
tga.dd_tga_descripcion,
stg.dd_stg_descripcion,
cra.dd_Cra_descripcion,
scr.dd_scr_descripcion
FROM REM01.AUX_REMVIP_11782 AUX
JOIN REM01.dd_stg_subtipos_gasto STG ON UPPER(STG.DD_STG_DESCRIPCION)=UPPER(AUX.SUBTIPO_GASTO)
JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID and upper(tga.dd_tga_descripcion)=upper(aux.tipo_Gasto) AND TGA.BORRADO = 0
LEFT jOIN REM01.ACT_CONFIG_CTAS_CONTABLES config ON CONFIG.DD_STG_ID=STG.DD_STG_ID AND CONFIG.BORRADO = 0 and config.dd_scr_id in (444,443) AND EJE_ID=72 AND CONFIG.DD_TIM_ID=1
LEFT join REM01.dd_scr_subcartera SCR ON scr.dd_scr_id=CONFIG.DD_SCR_ID AND SCR.BORRADO = 0
LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=config.dd_cra_id AND CRA.BORRADO = 0
WHERE STG.DD_STG_CODIGO IN (119,118,02,01)
                ) T2
            ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = ''6311003'',
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES CCC PARA IBIS 2021 DIVARIAN');


        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' T1 USING (
SELECT DISTINCT aux.base,
TGA.DD_TGA_ID,
tga.dd_tga_codigo,
aux.tipo_gasto AS TIPO_GASTO_AUX,
STG.DD_STG_ID,
stg.dd_stg_codigo,
aux.subtipo_gasto as SUBTIPO_GASTO_AUX,
aux.CC_APPLE_JAGUAR AS CC_AUX_JAGUAR,
aux.CC_DIVARIAN AS CC_AUX_DIVARIAN,
CONFIG.EJE_ID,
CONFIG.CCC_CTAS_ID,
config.CCC_CUENTA_CONTABLE AS PP_CONFIG,
tga.dd_tga_descripcion,
stg.dd_stg_descripcion,
cra.dd_Cra_descripcion,
scr.dd_scr_descripcion
FROM REM01.AUX_REMVIP_11782 AUX
JOIN REM01.dd_stg_subtipos_gasto STG ON UPPER(STG.DD_STG_DESCRIPCION)=UPPER(AUX.SUBTIPO_GASTO)
JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID and upper(tga.dd_tga_descripcion)=upper(aux.tipo_Gasto) AND TGA.BORRADO = 0
LEFT jOIN REM01.ACT_CONFIG_CTAS_CONTABLES config ON CONFIG.DD_STG_ID=STG.DD_STG_ID AND CONFIG.BORRADO = 0 and config.dd_scr_id in (444,443) AND EJE_ID NOT IN (72,73) AND CONFIG.DD_TIM_ID=1
LEFT join REM01.dd_scr_subcartera SCR ON scr.dd_scr_id=CONFIG.DD_SCR_ID AND SCR.BORRADO = 0
LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=config.dd_cra_id AND CRA.BORRADO = 0
WHERE STG.DD_STG_CODIGO IN (01)
                ) T2
            ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = ''6311000'',
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES CCC PARA IBIS ANTERIORES A 2021 IBI URBANA DIVARIAN');
        

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