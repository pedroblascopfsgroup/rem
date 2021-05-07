--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9592
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-9592';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_GLD VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_REMVIP_9592'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

--MODIFICAR PARTIDAS DE LOS GASTOS DE LA AUXILIAR Y MODIFICAR PARTIDAS
--DE FILTRO borrado = 0 and dd_tga_id = 5 and dd_stg_id in (26,27) and dd_tim_id = 1 and dd_Cra_id = 43 and dd_tbe_id is null and pro_id = 589
--CPP_PARTIDA_PRESUPUESTARIA = 004
--CPP_APARTADO = 05	
--CPP_CAPITULO = 15
--total 2244 filas

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
						SELECT CPP_PTDAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PTDAS 
            JOIN REM01.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = PTDAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN REM01.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = PTDAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN REM01.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = PTDAS.DD_TIM_ID AND TIM.BORRADO = 0
            WHERE PTDAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''05'' AND STG.DD_STG_CODIGO IN (''26'',''27'')
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND PTDAS.DD_TBE_ID IS NULL AND PTDAS.PRO_ID = 589) T2
						ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = ''004'', T1.CPP_APARTADO = ''05'', T1.CPP_CAPITULO = ''15'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA||' ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_GLD||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' T1 USING (
						SELECT GLD_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' GLD 
            JOIN REM01.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GPV.GPV_ID AND GPV.BORRADO = 0
            JOIN REM01.'||V_TEXT_TABLA_AUX||' AUX ON AUX.NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA) T2
						ON (T1.GLD_ID = T2.GLD_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.GLD_CPP_BASE = ''004'', T1.GLD_APARTADO_BASE = ''05'', T1.GLD_CAPITULO_BASE = ''15'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_GLD||' ');
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
