--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4248
--## PRODUCTO=NO
--##
--## Finalidad: Rellenar partidas presupuestarias de ejercicios anteriores
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
	WHERE EJE_ANYO IN ('2018', '2017');
	    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--    TIPO		SUBTIPO		PP A0AANT PP A1AANT	 PP A0AACT	PP A1AACT
		T_TIPO_DATA('Impuesto','IBI urbana',6310000001,''),
		T_TIPO_DATA('Impuesto','IBI rústica',6310000001,''),
		T_TIPO_DATA('Impuesto','Plusvalía (IIVTNU) compra',6310000004,''),
		T_TIPO_DATA('Impuesto','Plusvalía (IIVTNU) venta',6310000004,''),
		T_TIPO_DATA('Impuesto','IAAEE',6310000000,''),
		T_TIPO_DATA('Impuesto','ITPAJD',6310000002,''),
		T_TIPO_DATA('Impuesto','Recargos e intereses',6310000006,''),

		T_TIPO_DATA('Tasa','Basura',6310000005,''),
		T_TIPO_DATA('Tasa','Alcantarillado',6310000005,''),
		T_TIPO_DATA('Tasa','Agua',6310000005,''),
		T_TIPO_DATA('Tasa','Vado',6310000005,''),
		T_TIPO_DATA('Tasa','Ecotasa',6310000005,''),
		T_TIPO_DATA('Tasa','Regularización catastral',6310000005,''),
		T_TIPO_DATA('Tasa','Expedición documentos',6310000005,''),

		T_TIPO_DATA('Tasa','Judicial',6310000005,''),
		T_TIPO_DATA('Tasa','Otras tasas ayuntamiento',6310000005,''),
		T_TIPO_DATA('Tasa','Otras tasas',6310000005,''),

		T_TIPO_DATA('Otros tributos','Contribución especial',6310000005,''),

		T_TIPO_DATA('Comunidad de propietarios','Cuota ordinaria',6290000003,6210400000),
		T_TIPO_DATA('Comunidad de propietarios','Cuota extraordinaria (derrama)',6290000003,6210400000),
		T_TIPO_DATA('Comunidad de propietarios','Certificado deuda comunidad',6290000003,''),

		T_TIPO_DATA('Junta de compensación / EUC'	,'Gastos generales',6210500000,''),
		T_TIPO_DATA('Junta de compensación / EUC'	,'Cuotas y derramas',6210500000,''),
		
		T_TIPO_DATA('Suministro'	,'Electricidad',6280200000,''),
		T_TIPO_DATA('Suministro'	,'Agua',6280200000,''),
		T_TIPO_DATA('Suministro'	,'Gas',6280200000,''),
			
		T_TIPO_DATA('Seguros'	,'Prima TRDM (todo riesgo daño material)',6250000000,''),
		T_TIPO_DATA('Seguros'	,'Prima RC (responsabilidad civil)',6250000000,''),
		T_TIPO_DATA('Seguros'	,'Parte daños propios',6250000000,''),
		T_TIPO_DATA('Seguros'	,'Parte daños a terceros',6250000000,''),

		T_TIPO_DATA('Servicios profesionales independientes','Registro',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Notaría',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Abogado (Ocupacional)',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asuntos generales)',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Abogado (Asistencia jurídica)',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Procurador',6230000000,''),
		T_TIPO_DATA('Servicios profesionales independientes','Otros servicios jurídicos',6230000000,''),

		T_TIPO_DATA('Servicios profesionales independientes','Asesoría',6230000000,''),

		T_TIPO_DATA('Servicios profesionales independientes','Tasación',6290000005,''),

		T_TIPO_DATA('Gestoría','Honorarios gestión activos',6230000000,''),
		T_TIPO_DATA('Gestoría','Honorarios gestión ventas',6230000000,''),

		T_TIPO_DATA('Informes técnicos y obtención documentos','Informes',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',6290000008,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Licencia Primera Ocupación (LPO)',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Cédula Habitabilidad',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Certificado Final de Obra (CFO)',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Boletín instalaciones y suministros',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Obtención certificados y documentación',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','Nota simple actualizada',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','VPO: Solicitud devolución ayudas',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','VPO: Notificación adjudicación (tanteo)',6290000000,''),
		T_TIPO_DATA('Informes técnicos y obtención documentos','VPO: Autorización de venta',6290000000,''),

		T_TIPO_DATA('Actuación técnica y mantenimiento','Cambio de cerradura',6290000004,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Tapiado',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Retirada de enseres',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza y retirada de enseres',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Seguridad y Salud (SS)',6290000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Verificación de averías',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Obra menor',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Control de actuaciones (dirección técnica)',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Colocación puerta antiocupa',6220000000,''),
		T_TIPO_DATA('Actuación técnica y mantenimiento','Mobiliario',6220000000,''),

		T_TIPO_DATA('Vigilancia y seguridad','Vigilancia y seguridad',6290000000,''),
		T_TIPO_DATA('Vigilancia y seguridad','Alarmas',6290000000,''),
		T_TIPO_DATA('Vigilancia y seguridad','Servicios auxiliares',6290000000,''),

		T_TIPO_DATA('Otros gastos','Mensajería/correos/copias',6290000001,'')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar los valores en CCC_CONFIG_CTAS_CONTABLES segun el año-----------------------------------------------------------------
	OPEN EJERCICIOS;
	FETCH EJERCICIOS into V_EJE_ANYO;
	WHILE (EJERCICIOS%FOUND) LOOP

	 
		-- LOOP para insertar los valores en CCC_CONFIG_CTAS_CONTABLES-----------------------------------------------------------------
		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES PARA EL AÑO '''||V_EJE_ANYO||'''');
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			
			IF V_EJE_ANYO <> 2017 THEN
				
				--Comprobamos el dato a insertar par registros sin arrendamiento
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CCC.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CCC.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CCC.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = ''10''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CCC.CCC_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES(CCC_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CCC_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''10''), 
					'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
					0,
					''HREOS-4248'',
					SYSDATE,
					0,
					0)	
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA CC SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
			  
				--Si existe, no hacemos nada   
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE CC SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
				END IF;
				
				--Comprobamos el dato a insertar para registros con arrendamiento
				
				IF TRIM(V_TMP_TIPO_DATA(4)) IS NOT NULL THEN
				
					V_SQL := 'SELECT COUNT(1)  
							FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
							INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CCC.EJE_ID
							INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CCC.DD_CRA_ID
							INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CCC.DD_STG_ID
							INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
							WHERE CRA.DD_CRA_CODIGO = ''10''
							AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
							AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
							AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
							AND CCC.CCC_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN				
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES(CCC_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CCC_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''10''), 
						'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
						0,
						''HREOS-4248'',
						SYSDATE,
						0,
						1)	
						';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				  
					--Si existe, no hacemos nada   
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
					END IF;
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				END IF;
				
			--Si es el año 2017--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			ELSE
				
				--Comprobamos el dato a insertar par registros sin arrendamiento
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CCC.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CCC.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CCC.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = ''10''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CCC.CCC_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES(CCC_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CCC_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''10''), 
					'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
					0,
					''HREOS-4248'',
					SYSDATE,
					0,
					0)	
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA CC SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
			  
				--Si existe, no hacemos nada   
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE CC SIN ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
				END IF;
				
				--Comprobamos el dato a insertar para registros con arrendamiento
				
				IF TRIM(V_TMP_TIPO_DATA(4)) IS NOT NULL THEN
					V_SQL := 'SELECT COUNT(1)  
							FROM '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES CCC
							INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CCC.EJE_ID
							INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CCC.DD_CRA_ID
							INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CCC.DD_STG_ID
							INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
							WHERE CRA.DD_CRA_CODIGO = ''10''
							AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
							AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
							AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
							AND CCC.CCC_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
					
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN				
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CCC_CONFIG_CTAS_CONTABLES(CCC_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CCC_CUENTA_CONTABLE, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CCC_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CCC_CONFIG_CTAS_CONTABLES.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''10''), 
						'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
						0,
						''HREOS-4248'',
						SYSDATE,
						0,
						1)	
						';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADA CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				  
					--Si existe, no hacemos nada   
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');        
					END IF;	
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE CC CON ARRENDAMIENTO PARA EL TIPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' Y SUBTIPO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
				END IF;
			
			END IF;
			
      END LOOP;
      
    FETCH EJERCICIOS INTO V_EJE_ANYO;
      
    END LOOP;	
	CLOSE EJERCICIOS;	
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: CUENTAS CONTABLES ACTUALIZADAS CORRECTAMENTE.');   

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
