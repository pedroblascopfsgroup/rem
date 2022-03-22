--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10962
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica CUENTA Y PARTIDA en gastos en vuelo
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
    V_TEXT_TABLA_GLD VARCHAR2(100 CHAR):='GLD_GASTOS_LINEA_DETALLE';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10962'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' T1 USING (
SELECT DISTINCT gld.gld_id, gpv.gpv_num_gasto_haya,gld.gld_ccc_base,ccc.ccc_cuenta_contable
FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON GIC.GPV_ID=GPV.GPV_ID AND GIC.BORRADO =0
JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO =0
join '||V_ESQUEMA||'.gld_ent glent on glent.gld_id=gld.gld_id and glent.borrado = 0
join '||V_ESQUEMA||'.act_activo act on act.acT_id=glent.ent_id
left join '||V_ESQUEMA||'.act_config_ctas_contables ccc on ccc.dd_stg_id=gld.dd_stg_id and act.dd_scr_id=ccc.dd_scr_id and ccc.dd_tim_id=1 and ccc.pro_id=gpv.pro_id
join '||V_ESQUEMA||'.dd_scr_subcartera scr on scr.dd_scr_id=act.dd_Scr_id and scr.borrado = 0
join '||V_ESQUEMA||'.dd_stg_subtipos_gasto stg on stg.dd_stg_id=gld.dd_stg_id
join '||V_ESQUEMA||'.dd_tga_tipos_gasto tga on tga.dd_tga_id=stg.dd_tga_id
join '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID
JOIN '||V_ESQUEMA||'.dd_ega_estados_gasto EGA ON EGA.DD_eGA_ID=gpv.dd_ega_id AND EGA.BORRADO =0
JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE ON EJE.EJE_ID=gic.eje_id AND EJE.BORRADO =0
JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE2 ON EJE2.EJE_ID=CCC.eje_id AND EJE2.BORRADO =0 AND eje2.eje_anyo=''2022''
WHERE eje.eje_anyo=''2022'' and gpv.borrado = 0 and gpv.dd_ega_id not in (04,05,06) and gld.gld_ccc_base is not null AND SCR.DD_SCR_CODIGO IN (138,151,152,70)
AND GLD.GLD_CCC_BASE !=CCC.CCC_CUENTA_CONTABLE AND CCC.CCC_CUENTA_CONTABLE IS NOT NULL
ORDER BY GLD.GLD_ID
                ) T2
            ON (T1.GLD_ID = T2.GLD_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.GLD_CCC_BASE = T2.CCC_CUENTA_CONTABLE,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES PARA GASTOS EN VUELO');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' T1 USING (
SELECT DISTINCT gld.gld_id, gpv.gpv_num_gasto_haya,gld.gld_ccc_base,ccc.cpp_partida_presupuestaria
FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON GIC.GPV_ID=GPV.GPV_ID AND GIC.BORRADO =0
JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO =0
join '||V_ESQUEMA||'.gld_ent glent on glent.gld_id=gld.gld_id and glent.borrado = 0
join '||V_ESQUEMA||'.act_activo act on act.acT_id=glent.ent_id
left join '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP ccc on ccc.dd_stg_id=gld.dd_stg_id and act.dd_scr_id=ccc.dd_scr_id and ccc.dd_tim_id=1 and ccc.pro_id=gpv.pro_id
join '||V_ESQUEMA||'.dd_scr_subcartera scr on scr.dd_scr_id=act.dd_Scr_id and scr.borrado = 0
join '||V_ESQUEMA||'.dd_stg_subtipos_gasto stg on stg.dd_stg_id=gld.dd_stg_id
join '||V_ESQUEMA||'.dd_tga_tipos_gasto tga on tga.dd_tga_id=stg.dd_tga_id
join '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID
JOIN '||V_ESQUEMA||'.dd_ega_estados_gasto EGA ON EGA.DD_eGA_ID=gpv.dd_ega_id AND EGA.BORRADO =0
JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE ON EJE.EJE_ID=gic.eje_id AND EJE.BORRADO =0
JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE2 ON EJE2.EJE_ID=CCC.eje_id AND EJE2.BORRADO =0 AND eje2.eje_anyo=''2022''
WHERE eje.eje_anyo=''2022'' and gpv.borrado = 0 and gpv.dd_ega_id not in (04,05,06) and gld.gld_ccc_base is not null AND SCR.DD_SCR_CODIGO IN (138,151,152,70)
AND GLD.gld_cpp_base !=CCC.cpp_partida_presupuestaria AND CCC.cpp_partida_presupuestaria IS NOT NULL
ORDER BY GLD.GLD_ID
                ) T2
            ON (T1.GLD_ID = T2.GLD_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.gld_cpp_base = T2.cpp_partida_presupuestaria,
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE PARTIDAS PRESUPUESTARIAS PARA GASTOS EN VUELO');
        

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