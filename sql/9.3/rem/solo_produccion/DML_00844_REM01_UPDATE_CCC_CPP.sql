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

    V_TEXT_TABLA_PTDAS VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_CTAS VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_GLD VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_REMVIP_9536'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] RESTAURAMOS TABLAS  '||V_TEXT_TABLA_CTAS||' Y '||V_TEXT_TABLA_PTDAS||' ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_CTAS||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' T1 USING (
						SELECT CTAS.CCC_CTAS_ID, AUX.CCC_CUENTA_CONTABLE, AUX.CCC_SUBCUENTA_CONTABLE 
            FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' CTAS 
            JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||'_1 AUX ON AUX.CCC_CTAS_ID = CTAS.CCC_CTAS_ID) T2
						ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = T2.CCC_CUENTA_CONTABLE,T1.CCC_SUBCUENTA_CONTABLE = T2.CCC_SUBCUENTA_CONTABLE,
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_CTAS||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' T1 USING (
						SELECT CTAS.CCC_CTAS_ID, AUX.CCC_CUENTA_CONTABLE
            FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' CTAS 
            JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||'_2 AUX ON AUX.CCC_CTAS_ID = CTAS.CCC_CTAS_ID) T2
						ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = T2.CCC_CUENTA_CONTABLE,
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_CTAS||' ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_PTDAS||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' T1 USING (
						SELECT PTDAS.CPP_PTDAS_ID, AUX.CPP_PARTIDA_PRESUPUESTARIA, AUX.CPP_APARTADO, AUX.CPP_CAPITULO
            FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' PTDAS 
            JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||'_3 AUX ON AUX.CPP_PTDAS_ID = PTDAS.CPP_PTDAS_ID) T2
						ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = T2.CPP_PARTIDA_PRESUPUESTARIA,
            T1.CPP_APARTADO = T2.CPP_APARTADO,T1.CPP_CAPITULO = T2.CPP_CAPITULO,
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_PTDAS||' ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICACIONES SOLICITADAS');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_CTAS||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' T1 USING (
						SELECT CTAS.CCC_CTAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' CTAS 
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = CTAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CTAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = CTAS.DD_TIM_ID AND TIM.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = CTAS.DD_TBE_ID AND TBE.BORRADO = 0
            WHERE CTAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''52''
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND TBE.DD_TBE_CODIGO IN (''01'',''02'',''03'',''07'') AND CTAS.PRO_ID = 589) T2
						ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = ''6874'',T1.CCC_SUBCUENTA_CONTABLE = ''0000003'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_CTAS||' PARA PRO_ID =  589');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' T1 USING (
						SELECT CTAS.CCC_CTAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CTAS||' CTAS 
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = CTAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CTAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = CTAS.DD_TIM_ID AND TIM.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = CTAS.DD_TBE_ID AND TBE.BORRADO = 0
            WHERE CTAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''52''
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND TBE.DD_TBE_CODIGO IN (''01'',''02'',''03'',''07'') AND CTAS.PRO_ID = 593) T2
						ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = ''6310'',T1.CCC_SUBCUENTA_CONTABLE = ''0000007'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_CTAS||' PARA PRO_ID =  593');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_PTDAS||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' T1 USING (
						SELECT PTDAS.CPP_PTDAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' PTDAS 
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = PTDAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = PTDAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = PTDAS.DD_TIM_ID AND TIM.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = PTDAS.DD_TBE_ID AND TBE.BORRADO = 0
            WHERE PTDAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''52''
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND TBE.DD_TBE_CODIGO = ''02'' AND PTDAS.PRO_ID IN (593,589)) T2
						ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = ''010'',
            T1.CPP_APARTADO = ''05'',T1.CPP_CAPITULO = ''20'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_PTDAS||' PARA DD_TBE_CODIGO =  02');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' T1 USING (
						SELECT PTDAS.CPP_PTDAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' PTDAS 
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = PTDAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = PTDAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = PTDAS.DD_TIM_ID AND TIM.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = PTDAS.DD_TBE_ID AND TBE.BORRADO = 0
            WHERE PTDAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''52''
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND TBE.DD_TBE_CODIGO = ''03'' AND PTDAS.PRO_ID IN (593,589)) T2
						ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = ''032'',
            T1.CPP_APARTADO = ''01'',T1.CPP_CAPITULO = ''10'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_PTDAS||' PARA DD_TBE_CODIGO =  03');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' T1 USING (
						SELECT PTDAS.CPP_PTDAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_PTDAS||' PTDAS 
            JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = PTDAS.DD_TGA_ID AND TGA.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = PTDAS.DD_STG_ID AND STG.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_ID = PTDAS.DD_TIM_ID AND TIM.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON TBE.DD_TBE_ID = PTDAS.DD_TBE_ID AND TBE.BORRADO = 0
            WHERE PTDAS.BORRADO = 0 AND TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''52''
            AND TIM.DD_TIM_CODIGO = ''BAS'' AND TBE.DD_TBE_CODIGO IN (''01'',''07'') AND PTDAS.PRO_ID IN (593,589)) T2
						ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.CPP_PARTIDA_PRESUPUESTARIA = ''032'',
            T1.CPP_APARTADO = ''02'',T1.CPP_CAPITULO = ''15'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_PTDAS||' PARA DD_TBE_CODIGO IN (''01'',''07'')');
    
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
