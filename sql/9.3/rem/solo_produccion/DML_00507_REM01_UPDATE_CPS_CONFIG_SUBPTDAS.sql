--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8288
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica config partidas presupuestarias y cuentas contables
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8288'; -- USUARIO CREAR/MODIFICAR
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CPS_CONFIG_SUBPTDAS_PRE T1 USING 
			            (SELECT CPS_ID FROM '||V_ESQUEMA||'.CPS_CONFIG_SUBPTDAS_PRE 
                            WHERE BORRADO = 0 AND CPS_CUENTA_CONTABLE = ''6310000110'' AND CPS_PARTIDA_PRESUPUESTARIA = ''PP054'') T2
                        ON ( T1.CPS_ID = T2.CPS_ID )
                        WHEN MATCHED THEN UPDATE SET 
                        T1.CPS_CUENTA_CONTABLE = ''6310000090'',
                        T1.CPS_PARTIDA_PRESUPUESTARIA = ''PP071'',
                        T1.CPS_DESCRIPCION = ''TASAS Judiciales'',
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                        T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: GASTOS ACTUALIZADOS: ' ||sql%rowcount);


    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');

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