--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8288
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica partidas presupuestarias y cuentas contables de gastos
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

    V_TIPO_GASTO VARCHAR2(100 CHAR) := '02'; -- COD Tasa
    V_SUBTIPO_GASTO VARCHAR2(100 CHAR) := '16'; -- COD Judicial
    V_SUBCARTERA VARCHAR2(100 CHAR) := '138'; -- COD Apple - Inmobiliario
    -- EGA CODIGOS: 04,05,06 -> DESCRIPCIONES Contabilizado,Pagado,Anulado
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING 
			            (SELECT GIC_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                            INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID AND GPV.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.GPV_ACT GACT ON GPV.GPV_ID = GACT.GPV_ID
                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID AND TGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                            WHERE GIC.BORRADO = 0 AND GIC.GIC_CUENTA_CONTABLE = ''6310000110'' AND GIC.GIC_PTDA_PRESUPUESTARIA = ''PP054''
                            AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''06'') AND TGA.DD_TGA_CODIGO = '''||V_TIPO_GASTO||'''
                            AND STG.DD_STG_CODIGO = '''||V_SUBTIPO_GASTO||''' AND SCR.DD_SCR_CODIGO = '''||V_SUBCARTERA||''') T2
                        ON ( T1.GIC_ID = T2.GIC_ID )
                        WHEN MATCHED THEN UPDATE SET 
                        T1.GIC_CUENTA_CONTABLE = ''6310000090'',
                        T1.GIC_PTDA_PRESUPUESTARIA = ''PP071'',
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