--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1684
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CCC_CONFIG_CTAS_CONTABLES los datos añadidos en T_ARRAY_DATA
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
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- El último valor 'isAllYears' indica si poner la cuenta entre los años 2012-2017. Si el valor es 1 -> 2012-2017; si es 0 -> solo 2017
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(    
    	--			DD_STG_CODIGO,	DD_CRA_CODIGO	PRO_CODIGO_UVEM		CUENTA_CONTABLE, 	CCC_ARRENDAMIENTO, isAllYears	
    	-- Tipo gasto: IMPUESTO
		T_TIPO_DATA('01'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('02'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('03'			,'02'			,''					,'6320000000'		,'0'				,'1'),
		T_TIPO_DATA('04'			,'02'			,''					,'6320000000'		,'0'				,'1'),
		T_TIPO_DATA('92'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		-- Tipo gasto: TASA
		T_TIPO_DATA('08'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('09'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('10'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('11'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('12'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('16'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		T_TIPO_DATA('18'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		-- Tipo gasto: OTROS TRIBUTOS
		T_TIPO_DATA('19'			,'02'			,''					,'6310000000'		,'0'				,'1'),
		-- Tipo gasto: SANCIÓN
		T_TIPO_DATA('21'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		T_TIPO_DATA('22'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		T_TIPO_DATA('23'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		T_TIPO_DATA('24'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		T_TIPO_DATA('25'			,'02'			,''					,'6780000004'		,'0'				,'0'),
		-- Tipo gasto: COMUNIDAD DE PROPIETARIOS
		T_TIPO_DATA('26'			,'02'			,''					,'6220000000'		,'0'				,'1'),
		T_TIPO_DATA('26'			,'02'			,''					,'6210400000'		,'1'				,'1'),
		T_TIPO_DATA('27'			,'02'			,''					,'6220000000'		,'0'				,'1'),
		T_TIPO_DATA('27'			,'02'			,''					,'6210400000'		,'1'				,'1'),
		T_TIPO_DATA('93'			,'02'			,''					,'6220000000'		,'0'				,'0'),
		-- Tipo gasto: JUNTA DE COMPENSACIÓN / EUC
		T_TIPO_DATA('30'			,'02'			,''					,'6210500000'		,'0'				,'1'),
		T_TIPO_DATA('31'			,'02'			,''					,'6220000000'		,'0'				,'1'),
		-- Tipo gasto: SUMINISTRO
		T_TIPO_DATA('35'			,'02'			,''					,'6280200000'		,'0'				,'1'),
		T_TIPO_DATA('36'			,'02'			,''					,'6280100000'		,'0'				,'1'),
		T_TIPO_DATA('37'			,'02'			,''					,'6280500000'		,'0'				,'1'),
		-- Tipo gasto: SEGUROS
		T_TIPO_DATA('39'			,'02'			,''					,'6250000000'		,'0'				,'1'),
		T_TIPO_DATA('40'			,'02'			,''					,'6250000000'		,'0'				,'1'),
		T_TIPO_DATA('41'			,'02'			,''					,'6250000000'		,'0'				,'1'),
		T_TIPO_DATA('42'			,'02'			,''					,'6250000000'		,'0'				,'1'),
		-- Tipo gasto: SERVICIOS PROFESIONALES INDEPENDIENTES
		T_TIPO_DATA('43'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('44'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('95'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('96'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('97'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('46'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('47'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('49'			,'02'			,''					,'6230600000'		,'0'				,'1'),
		T_TIPO_DATA('51'			,'02'			,''					,'6230000001'		,'0'				,'1'),
		-- Tipo gasto: GESTORÍA
		T_TIPO_DATA('53'			,'02'			,''					,'6230100000'		,'0'				,'1'),
		T_TIPO_DATA('54'			,'02'			,''					,'6230100000'		,'0'				,'1'),
		-- Tipo gasto: INFORMES TÉCNICOS Y OBTENCIÓN DE DOCUMENTOS
		T_TIPO_DATA('57'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('58'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('59'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('60'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('61'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('62'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('63'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('64'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('65'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('66'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('67'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		-- Tipo gasto: ACTUACIÓN TÉCNICA Y MANTENIMIENTO
		T_TIPO_DATA('70'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('71'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('72'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('73'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('74'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('75'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('76'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('77'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('78'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('79'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('81'			,'02'			,''					,'6230700000'		,'0'				,'1'),
		T_TIPO_DATA('82'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		T_TIPO_DATA('83'			,'02'			,''					,'6222000002'		,'0'				,'1'),
		-- Tipo gasto: VIGILANCIA Y SEGURIDAD
		T_TIPO_DATA('85'			,'02'			,''					,'6291100000'		,'0'				,'1'),
		T_TIPO_DATA('86'			,'02'			,''					,'6291100000'		,'0'				,'1'),
		T_TIPO_DATA('87'			,'02'			,''					,'6291100000'		,'0'				,'1'),
		-- Tipo gasto: OTROS GASTOS
		T_TIPO_DATA('89'			,'02'			,''					,'6292000000'		,'0'				,'1')
		
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
    -- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.'|| V_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');
	 
    -- LOOP para insertar los valores en CCC_CONFIG_CTAS_CONTABLES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES; PARA SAREB');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        FOR anyo IN 2012 .. 2017
      	 LOOP
	      	V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	      	
	      	V_MSQL := 'SELECT COUNT(1) FROM '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES 
						WHERE 
							DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') AND  
							DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND  
							PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO INNER JOIN '||V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID 
								WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(3)||''' AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND  
							EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND 
							CCC_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' ';
	      	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	      	
	      	IF V_NUM_TABLAS > 0 THEN
	      		V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES 
						SET
							CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||''', USUARIOMODIFICAR = ''DML_F2'', FECHAMODIFICAR = SYSDATE  
						WHERE 
							DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') AND 
							DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND 
							PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO INNER JOIN '||V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID 
								WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(3)||''' AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND 
							EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||''') AND
							CCC_ARRENDAMIENTO = '''||TRIM(V_TMP_TIPO_DATA(5))||''' ';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] ACTUALIZADO CORRECTAMENTE - EJECICIO '||anyo);
	      	ELSE
		      	-- SI isAllYears está activado, o si el año a introducir es el actual, sino, no inserta.
		      	IF (V_TMP_TIPO_DATA(6) = 1 OR  (V_TMP_TIPO_DATA(6) = 0 AND anyo = 2017)) THEN
	 
				        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL FROM DUAL';
				        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
				        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CCC_CONFIG_CTAS_CONTABLES (' ||
				                    'CCC_ID, DD_STG_ID, DD_CRA_ID, PRO_ID, EJE_ID, CCC_CUENTA_CONTABLE, CCC_ARRENDAMIENTO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES' ||
				                      '('|| V_ID || ',
									  (SELECT DD_STG_ID FROM '||V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
									  (SELECT DD_CRA_ID FROM '||V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
									  (SELECT PRO_ID FROM '||V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO INNER JOIN '||V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON PRO.DD_CRA_ID = CRA.DD_CRA_ID 
											WHERE PRO_CODIGO_UVEM = '''||V_TMP_TIPO_DATA(3)||''' AND CRA.DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
									  (SELECT EJE_ID FROM '||V_ESQUEMA ||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO = '''||anyo||'''),
				                      '''||TRIM(V_TMP_TIPO_DATA(4))||''',
				                      '''||TRIM(V_TMP_TIPO_DATA(5))||''',
				                       0, ''DML'',SYSDATE,0 )';
				        EXECUTE IMMEDIATE V_MSQL;
				        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| I ||'] INSERTADO CORRECTAMENTE - EJECICIO '||anyo);
	
			    END IF;
			END IF;
			
		END LOOP;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA CCC_CONFIG_CTAS_CONTABLES ACTUALIZADA CORRECTAMENTE ');
   
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
   