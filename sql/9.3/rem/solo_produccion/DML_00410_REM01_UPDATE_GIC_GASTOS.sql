--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201231
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8513
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8513'; -- USUARIO CREAR/MODIFICAR

    V_CARTERA VARCHAR2(50 CHAR) := '07'; --COD CERBERUS
    V_SUBCARTERA VARCHAR2(100 CHAR) := '138'; -- COD Apple - Inmobiliario
    V_TIPO_GASTO VARCHAR2(100 CHAR) := '02'; -- COD Tasa

    V_SUBTIPO_GASTO VARCHAR2(100 CHAR) := '16'; -- COD Judicial
    V_CCC VARCHAR2(100 CHAR) := '6312013'; -- ccc judicial
    V_CPP VARCHAR2(100 CHAR) := 'PP071'; -- cpp judicial

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
	   T_TIPO_DATA('08','PP077',	'TASA Basura',	'6310000020','6312010'), --BASURA
        T_TIPO_DATA('09','PP076',	'TASA Alcantarillado',	'6310000030', '6312009'),--ALCANTARILLADO
        T_TIPO_DATA('10','PP075',	'TASA Agua',	'6310000040', '6312008'),--AGUA
        T_TIPO_DATA('11','PP084',	'TASA Vado',	'6310000050','6312018'),--VADO
        T_TIPO_DATA('12','PP078',	'TASA Ecotasa',	'6310000060', '6312011'),--ECOTASA
        T_TIPO_DATA('13','PP083',	'TASA Regularización catastral',	'6310000070','6312017'),--REGULARIZACION CATASTRAL
        T_TIPO_DATA('14','PP079',	'TASA Expedición documentos',	'6310000080','6312012'),--Expedición documentos
        T_TIPO_DATA('15','PP080',	'TASA Obras / Rehabilitación / Mantenimiento',	'6310000010','6312014'),--Obras / Rehabilitación / Mantenimiento
        T_TIPO_DATA('17','PP082',	'TASA Otras tasas ayuntamiento',	'6310000100','6312016'),--Otras tasas ayuntamiento
        T_TIPO_DATA('18','PP081',	'TASA Otras tasas',	'6310000100','6312015')--OTRAS TASAS
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  

    TYPE T_TIPO_DATA_SCR IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_SCR IS TABLE OF T_TIPO_DATA_SCR;
    V_TIPO_DATA_SCR T_ARRAY_DATA_SCR := T_ARRAY_DATA_SCR
    (
	    T_TIPO_DATA_SCR('152'), 
        T_TIPO_DATA_SCR('151')
    ); 
    V_TMP_TIPO_DATA_SCR T_TIPO_DATA_SCR; 
    -- EGA CODIGOS: 04,05,06 -> DESCRIPCIONES Contabilizado,Pagado,Anulado
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

   

FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	      LOOP      
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);    

 V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING 
			            (SELECT DISTINCT GIC_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                            INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID AND GPV.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.GPV_ACT GACT ON GPV.GPV_ID = GACT.GPV_ID
                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID AND TGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                            WHERE GIC.BORRADO = 0 AND GIC.GIC_CUENTA_CONTABLE = ''6310000110'' AND GIC.GIC_PTDA_PRESUPUESTARIA = ''PP054''
                            AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''06'') AND TGA.DD_TGA_CODIGO = '''||V_TIPO_GASTO||'''
                            AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SCR.DD_SCR_CODIGO = '''||V_SUBCARTERA||'''
                            AND NOT EXISTS (
                                SELECT 1 FROM '||V_ESQUEMA||'.VI_GASTOS_HISTORICO_ENVIO VI
                                WHERE GPV.GPV_NUM_GASTO_HAYA = VI.GPV_NUM_GASTO_HAYA
                            )) T2
                        ON ( T1.GIC_ID = T2.GIC_ID )
                        WHEN MATCHED THEN UPDATE SET 
                        T1.GIC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                        T1.GIC_PTDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                        T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
    

    DBMS_OUTPUT.PUT_LINE('[INFO]: GASTOS ACTUALIZADOS: ' ||sql%rowcount || ' DEL SUBTIPO DE GASTO '||TRIM(V_TMP_TIPO_DATA(3))||'');

    FOR I IN V_TIPO_DATA_SCR.FIRST .. V_TIPO_DATA_SCR.LAST
	      LOOP      
	        V_TMP_TIPO_DATA_SCR := V_TIPO_DATA_SCR(I);    
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING 
			            (SELECT DISTINCT GIC_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                            INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID AND GPV.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.GPV_ACT GACT ON GPV.GPV_ID = GACT.GPV_ID
                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID AND TGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                            WHERE GIC.BORRADO = 0 AND GIC.GIC_CUENTA_CONTABLE = ''6310000110'' AND GIC.GIC_PTDA_PRESUPUESTARIA = ''PP054''
                            AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''06'') AND TGA.DD_TGA_CODIGO = '''||V_TIPO_GASTO||'''
                            AND STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA_SCR(1)||'''
                            AND NOT EXISTS (
                                SELECT 1 FROM '||V_ESQUEMA||'.VI_GASTOS_HISTORICO_ENVIO VI
                                WHERE GPV.GPV_NUM_GASTO_HAYA = VI.GPV_NUM_GASTO_HAYA
                            )) T2
                        ON ( T1.GIC_ID = T2.GIC_ID )
                        WHEN MATCHED THEN UPDATE SET 
                        T1.GIC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                        T1.GIC_PTDA_PRESUPUESTARIA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                        T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: GASTOS ACTUALIZADOS: ' ||sql%rowcount || ' DEL SUBTIPO DE GASTO '||TRIM(V_TMP_TIPO_DATA(3))||'');
        END LOOP;	

    END LOOP;	

    FOR I IN V_TIPO_DATA_SCR.FIRST .. V_TIPO_DATA_SCR.LAST
	      LOOP      
	        V_TMP_TIPO_DATA_SCR := V_TIPO_DATA_SCR(I);    
            V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1 USING 
			            (SELECT DISTINCT GIC_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                            INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID AND GPV.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.GPV_ACT GACT ON GPV.GPV_ID = GACT.GPV_ID
                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GACT.ACT_ID AND ACT.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID AND SCR.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID AND TGA.BORRADO = 0
                            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID AND STG.BORRADO = 0
                            WHERE GIC.BORRADO = 0 AND GIC.GIC_CUENTA_CONTABLE = ''6310000110'' AND GIC.GIC_PTDA_PRESUPUESTARIA = ''PP054''
                            AND EGA.DD_EGA_CODIGO NOT IN (''04'',''05'',''06'') AND TGA.DD_TGA_CODIGO = '''||V_TIPO_GASTO||'''
                            AND STG.DD_STG_CODIGO = '''||V_SUBTIPO_GASTO||''' AND SCR.DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA_SCR(1)||'''AND NOT EXISTS (
                                SELECT 1 FROM '||V_ESQUEMA||'.VI_GASTOS_HISTORICO_ENVIO VI
                                WHERE GPV.GPV_NUM_GASTO_HAYA = VI.GPV_NUM_GASTO_HAYA
                            )) T2
                        ON ( T1.GIC_ID = T2.GIC_ID )
                        WHEN MATCHED THEN UPDATE SET 
                        T1.GIC_CUENTA_CONTABLE = '''||V_CCC||''',
                        T1.GIC_PTDA_PRESUPUESTARIA = '''||V_CPP||''',
                        T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                        T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: GASTOS ACTUALIZADOS: ' ||sql%rowcount || ' DEL SUBTIPO DE GASTO '||TRIM(V_TMP_TIPO_DATA(3))||'');
        END LOOP;	

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