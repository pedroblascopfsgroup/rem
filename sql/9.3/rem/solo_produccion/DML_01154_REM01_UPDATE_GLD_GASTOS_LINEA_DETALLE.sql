--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220308
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10999
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10999'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS CUENTAS PARTIDAS GASTOS ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
            
            SELECT distinct GLD.GLD_ID,ctas.ccc_cuenta_contable AS CCC_BASE

            FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
            JOIN '||V_ESQUEMA||'.AUX_REMVIP_10999 AUX ON AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
            JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON gic.gpv_id=GPV.GPV_ID
            JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID AND PRO.BORRADO = 0
            JOIN '||V_ESQUEMA||'.gld_ent GLENT ON GLENT.GLD_ID=GLD.GLD_ID AND glent.dd_ent_id=1 AND GLENT.BORRADO = 0 
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=glent.ent_id AND ACT.BORRADO = 0

            JOIN '||V_ESQUEMA||'.act_config_ctas_contables CTAS ON CTAS.PRO_ID=GPV.PRO_ID 
            AND CTAS.BORRADO = 0 AND CTAS.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS.EJE_ID 
            AND CTAS.DD_SCR_ID=ACT.DD_SCR_ID and ctas.dd_tim_id=1
            WHERE GPV.BORRADO = 0) T2
        ON (T1.GLD_ID = T2.GLD_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.GLD_CCC_BASE =T2.CCC_BASE,
        T1.USUARIOMODIFICAR = '''||V_USU||''',
        T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ASIGNADA CUENTA CONTABLE EN '|| SQL%ROWCOUNT ||' REGISTROS');



    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
            
            SELECT distinct GPV.GPV_NUM_GASTO_HAYA,GLD.GLD_ID,ctas.CPP_PARTIDA_PRESUPUESTARIA AS CPP_BASE

                FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.AUX_REMVIP_10999 AUX ON AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
                JOIN '||V_ESQUEMA||'.gld_gastos_linea_detalle GLD ON GLD.GPV_ID=GPV.GPV_ID AND GLD.BORRADO = 0
                JOIN '||V_ESQUEMA||'.gic_gastos_info_contabilidad GIC ON gic.gpv_id=GPV.GPV_ID
                JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID=GPV.PRO_ID AND PRO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.gld_ent GLENT ON GLENT.GLD_ID=GLD.GLD_ID AND glent.dd_ent_id=1 AND GLENT.BORRADO = 0 
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=glent.ent_id AND ACT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.act_config_ptdas_prep CTAS ON CTAS.PRO_ID=GPV.PRO_ID 
                AND CTAS.BORRADO = 0 AND CTAS.DD_STG_ID=GLD.DD_STG_ID AND gic.eje_id=CTAS.EJE_ID 
                AND CTAS.DD_SCR_ID=ACT.DD_SCR_ID and ctas.dd_tim_id=1
                WHERE GPV.BORRADO = 0) T2
        ON (T1.GLD_ID = T2.GLD_ID)
        WHEN MATCHED THEN UPDATE SET
        T1.GLD_CPP_BASE =T2.CPP_BASE,
        T1.USUARIOMODIFICAR = '''||V_USU||''',
        T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ASIGNADA PARTIDA PRESUPUESTARIA EN '|| SQL%ROWCOUNT ||' REGISTROS');

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