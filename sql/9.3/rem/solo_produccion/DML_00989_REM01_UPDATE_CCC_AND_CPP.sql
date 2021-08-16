--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9151
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9151'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--CPP		CCC
		T_TIPO_DATA('PP039','6250001')
        );
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' T1 USING (
                SELECT DISTINCT CTAS.CCC_CTAS_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_CCC||' CTAS
                JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CTAS.EJE_ID AND EJE.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = CTAS.DD_SCR_ID AND SCR.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CTAS.DD_STG_ID AND STG.BORRADO = 0
                WHERE SCR.DD_SCR_CODIGO IN (''151'',''152'') AND STG.DD_STG_CODIGO = ''40''
                ) T2
            ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.CCC_CUENTA_CONTABLE = '''||V_TMP_TIPO_DATA(2)||''',
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS DE CUENTAS CONTABLES PARA Prima RC (responsabilidad civil).');
        
    END LOOP;

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