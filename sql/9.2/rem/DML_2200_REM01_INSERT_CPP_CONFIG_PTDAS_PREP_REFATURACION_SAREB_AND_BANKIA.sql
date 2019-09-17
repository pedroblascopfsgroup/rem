--/*
--##########################################
--## AUTOR=DAVID GARCÍA
--## FECHA_CREACION=20190625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6680
--## PRODUCTO=NO
--##
--## Finalidad: Rellenar partidas presupuestarias
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
    
    V_EJE_ANYO NUMBER(16);
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    CURSOR EJERCICIOS
	IS
	SELECT EJE_ANYO FROM #ESQUEMA#.ACT_EJE_EJERCICIO
	WHERE EJE_ANYO IN ('2019', '2018');
	    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--    TIPO		SUBTIPO		PP A0AANT PP A1AANT	 PP A0AACT	PP A1AACT  CODIGO CARTERA    PRO_ID
		T_TIPO_DATA('14'	,'57',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('14'	,'58',      '906247',       '',     '906247',       '',     '02',				'3780'),
		T_TIPO_DATA('14'	,'61',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('14'	,'62',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('14'	,'63',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('14'	,'68',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('14'	,'69',      '906245',       '',     '906245',       '',     '03',				'3781'),
			
		T_TIPO_DATA('15'	,'70',      '906247',       '',     '906247',       '',     '02',				'3780'),
		T_TIPO_DATA('15'	,'71',      '906247',       '',     '906247',       '',     '02',				'3780'),
		T_TIPO_DATA('15'	,'72',      '906247',       '',     '906247',       '',     '02',				'3780'),
		T_TIPO_DATA('15'	,'73',      '906247',       '',     '906247',       '',     '02',				'3780'),
		T_TIPO_DATA('15'	,'74',      '906247',       '',     '906247',       '',     '02',				'3780'),
        T_TIPO_DATA('15'	,'74',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('15'	,'75',      '906247',       '',     '906247',       '',     '02',				'3780'),
        T_TIPO_DATA('15'	,'75',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('15'	,'76',      '906247',       '',     '906247',       '',     '02',				'3780'),
        T_TIPO_DATA('15'	,'76',      '906245',       '',     '906245',       '',     '03',				'3781'),
		T_TIPO_DATA('15'	,'79',      '906247',       '',     '906247',       '',     '02',				'3780'),
        T_TIPO_DATA('15'	,'79',      '906245',       '',     '906245',       '',     '03',				'3781'),
        T_TIPO_DATA('15'	,'80',      '906248',       '',     '906248',       '',     '02',				'3780'),
		

			
		T_TIPO_DATA('16'	,'85',      '906246',       '',     '906246',       '',     '02',				'3780')


		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP segun el año-----------------------------------------------------------------
	OPEN EJERCICIOS;
	FETCH EJERCICIOS into V_EJE_ANYO;
	WHILE (EJERCICIOS%FOUND) LOOP

	 
		-- LOOP para insertar los valores en CPP_CONFIG_PTDAS_PREP-----------------------------------------------------------------
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPP_CONFIG_PTDAS_PREP PARA EL AÑO '''||V_EJE_ANYO||'''');
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			
			IF V_EJE_ANYO <> 2017 THEN
				
				--Comprobamos el dato a insertar par registros sin arrendamiento
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CPP.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CPP.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = CPP.PRO_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''
						AND PRO.PRO_ID = '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_CODIGO ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID,PRO_ID,CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''),
					(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_ID = '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''), 
					'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
					0,
					''HREOS-6680'',
					SYSDATE,
					0,
					0)	
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA PP SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
			  
				--Si existe, no hacemos nada   
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE PP SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
				END IF;
				
				--Comprobamos el dato a insertar para registros con arrendamiento
				
				IF TRIM(V_TMP_TIPO_DATA(4)) IS NOT NULL THEN
				
					V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CPP.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CPP.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = CPP.PRO_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''
						AND PRO.PRO_ID= '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_CODIGO ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN				
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, PRO_ID ,CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''), 
						(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_ID= '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''), 
						'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
						0,
						''HREOS-6680'',
						SYSDATE,
						0,
						1)	
						';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				  
					--Si existe, no hacemos nada   
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
					END IF;
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				END IF;
				
			--Si es el año 2018--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			ELSE
				
				--Comprobamos el dato a insertar par registros sin arrendamiento
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CPP.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CPP.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID= CPP.PRO_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''
						AND PRO.PRO_ID= '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_CODIGO ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID,PRO_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''), 
					(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_ID= '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''), 
					'''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
					0,
					''HREOS-6680'',
					SYSDATE,
					0,
					0)	
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA PP SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
			  
				--Si existe, no hacemos nada   
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE PP SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
				END IF;
				
				--Comprobamos el dato a insertar para registros con arrendamiento
				
				IF TRIM(V_TMP_TIPO_DATA(4)) IS NOT NULL THEN
					V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CPP.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CPP.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = CPP.PRO_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''
						AND PRO.PRO_ID = '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_CODIGO ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
					
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN				
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID,PRO_ID ,CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(7)) ||'''), 
						(SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_ID = '''|| TRIM(V_TMP_TIPO_DATA(8)) ||'''), 
						'''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
						0,
						''HREOS-6680'',
						SYSDATE,
						0,
						1)	
						';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				  
					--Si existe, no hacemos nada   
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
					END IF;	
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE PP CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				END IF;
			
			END IF;
			
      END LOOP;
      
    FETCH EJERCICIOS INTO V_EJE_ANYO;
      
    END LOOP;	
	CLOSE EJERCICIOS;	
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: PARTIDAS PRESUPUESTARIAS ACTUALIZADAS CORRECTAMENTE.');   

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
