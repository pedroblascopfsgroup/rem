--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220321
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11379'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_PARTIDA VARCHAR2(100 CHAR):='PP3010';
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CPP||' T1 USING (
SELECT DISTINCT cpp.cpp_ptdas_id,CPP.cpp_partida_presupuestaria,tga.dd_tga_descripcion,stg.dd_stg_descripcion,eje.eje_anyo,cra.dd_cra_descripcion,scr.dd_scr_descripcion
FROM '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP CPP
JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=CPP.DD_CRA_ID AND CRA.BORRADO = 0
JOIN '||V_ESQUEMA||'.dd_scr_subcartera SCR ON SCR.DD_SCR_ID=CPP.DD_SCR_ID AND SCR.BORRADO = 0
JOIN '||V_ESQUEMA||'.dd_stg_subtipos_gasto STG ON STG.DD_STG_ID=CPP.DD_sTG_ID AND STG.BORRADO = 0
JOIN '||V_ESQUEMA||'.dd_tga_tipos_gasto TGA ON TGA.DD_TGA_ID=CPP.DD_TGA_ID AND TGA.BORRADO = 0
JOIN '||V_ESQUEMA||'.act_eje_ejercicio EJE ON EJE.EJE_ID=CPP.EJE_ID AND EJE.BORRADO =0
WHERE TGA.DD_TGA_CODIGO=05 and STG.DD_STG_CODIGO=27 and CPP.eje_id=73 and CPP.DD_SCR_ID IN (
543,
444,
443,
323


) AND CPP.BORRADO = 0 and CPP.cpp_partida_presupuestaria !='''||V_PARTIDA||'''
ORDER BY DD_CRA_DESCRIPCION,DD_SCR_DESCRIPCION
                ) T2
            ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = '''||V_PARTIDA||''',
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE PARTIDAS PRESUPUESTARIAS');
        

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
