--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210906
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10148
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar cuentas y partidas
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(124 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-10148'; -- USUARIOCREAR/USUARIOMODIFICAR.    
    V_STG NUMBER(16);
    V_SCR NUMBER(16);
    V_PRO NUMBER(16);
    V_COUNT1 NUMBER(16);
    V_COUNT2 NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL :='SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = ''08''';
    EXECUTE IMMEDIATE V_MSQL INTO V_STG;

	V_MSQL :='SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138''';
    EXECUTE IMMEDIATE V_MSQL INTO V_SCR;

	V_MSQL :='SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE PRO_CODIGO_UVEM = 10101010';
    EXECUTE IMMEDIATE V_MSQL INTO V_PRO;

    V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES WHERE CCC_CUENTA_CONTABLE = ''6310000110'' AND DD_STG_ID = '||V_STG||' AND DD_SCR_ID = '||V_SCR||' AND PRO_ID = '||V_PRO||' AND EJE_ID IN (70, 71, 72)';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT1;

    V_MSQL :='SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP WHERE CPP_PARTIDA_PRESUPUESTARIA = ''PP054'' AND DD_STG_ID = '||V_STG||' AND DD_SCR_ID = '||V_SCR||' AND PRO_ID = '||V_PRO||' AND EJE_ID IN (70, 71, 72)';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;

    IF V_COUNT1 > 0 THEN
	
        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_CONFIG_CTAS_CONTABLES SET 
            CCC_CUENTA_CONTABLE = ''6780000010'', 
            USUARIOMODIFICAR =  '''||V_USR||''',
            FECHAMODIFICAR = SYSDATE
            WHERE CCC_CUENTA_CONTABLE = ''6310000110'' AND DD_STG_ID = '||V_STG||' AND DD_SCR_ID = '||V_SCR||' AND PRO_ID = '||V_PRO||' AND EJE_ID IN (70, 71, 72)'; 
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: CUENTA ACTUALIZADA');

    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO HAY CUENTA A ACTUALIZAR');

    END IF;

    IF V_COUNT2 > 0 THEN

        V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.ACT_CONFIG_PTDAS_PREP SET 
            CPP_PARTIDA_PRESUPUESTARIA = ''PP058'', 
            USUARIOMODIFICAR =  '''||V_USR||''',
            FECHAMODIFICAR = SYSDATE
            WHERE CPP_PARTIDA_PRESUPUESTARIA = ''PP054'' AND DD_STG_ID = '||V_STG||' AND DD_SCR_ID = '||V_SCR||' AND PRO_ID = '||V_PRO||' AND EJE_ID IN (70, 71, 72)'; 
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO]: PARTIDA ACTUALIZADA');
	
    ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: NO HAY PARTIDA A ACTUALIZAR');

    END IF;
    
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
EXIT;
