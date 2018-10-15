--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20180829
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4456
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
		T_TIPO_DATA('Impuesto'	,'IBI urbana','G011311','','G011311',''),
		T_TIPO_DATA('Impuesto'	,'IBI rústica','G011311','','G011311',''),
		T_TIPO_DATA('Impuesto'	,'Plusvalía (IIVTNU) compra','G011367','','G011367',''),
		T_TIPO_DATA('Impuesto'	,'Plusvalía (IIVTNU) venta','G011324','','G011324',''),
		T_TIPO_DATA('Impuesto'	,'Recargos e intereses','G011379','','G011379',''),
			
		T_TIPO_DATA('Tasa'	,'Basura','G011323','','G011323',''),
		T_TIPO_DATA('Tasa'	,'Alcantarillado','G011323','','G011323',''),
		T_TIPO_DATA('Tasa'	,'Agua','G011323','','G011323',''),
		T_TIPO_DATA('Tasa'	,'Vado','G011323','','G011323',''),
		T_TIPO_DATA('Tasa'	,'Ecotasa','G011323','','G011323',''),
		T_TIPO_DATA('Tasa'	,'Regularización catastral','G011383','','G011383',''),
		T_TIPO_DATA('Tasa'	,'Expedición documentos','G011383','','G011383',''),
		T_TIPO_DATA('Tasa'	,'Judicial','G011338','','G011338',''),
		T_TIPO_DATA('Tasa'	,'Otras tasas ayuntamiento','G011383','','G011383',''),
		T_TIPO_DATA('Tasa'	,'Otras tasas','G011383','','G011383',''),
			
		T_TIPO_DATA('Otros tributos'	,'Contribución especial','G011383','','G011383',''),
			
		T_TIPO_DATA('Sanción'	,'Urbanística','G011325','','G011325',''),
		T_TIPO_DATA('Sanción'	,'Tributaria','G011325','','G011325',''),
		T_TIPO_DATA('Sanción'	,'Ruina','G011325','','G011325',''),
		T_TIPO_DATA('Sanción'	,'Multa coercitiva','G011325','','G011325',''),
		T_TIPO_DATA('Sanción'	,'Otros','G011325','','G011325',''),
			
		T_TIPO_DATA('Comunidad de propietarios'	,'Cuota ordinaria','G011309','','G011309',''),
		T_TIPO_DATA('Comunidad de propietarios'	,'Cuota extraordinaria (derrama)','G011309','','G011309',''),
		T_TIPO_DATA('Comunidad de propietarios'	,'Certificado deuda comunidad','G011378','','G011378',''),
			
		T_TIPO_DATA('Junta de compensación / EUC'	,'Gastos generales','G011313','','G011313',''),
		T_TIPO_DATA('Junta de compensación / EUC'	,'Cuotas y derramas','G011357','','G011357',''),
			
		T_TIPO_DATA('Suministro'	,'Electricidad','G011335','G011373','G011335','G011373'),
		T_TIPO_DATA('Suministro'	,'Agua','G011336','G011374','G011336','G011374'),
		T_TIPO_DATA('Suministro'	,'Gas','G011337','G011375','G011337','G011375'),
			
		T_TIPO_DATA('Seguros'	,'Prima TRDM (todo riesgo daño material)','G011321','','G011321',''),
		T_TIPO_DATA('Seguros'	,'Prima RC (responsabilidad civil)','G011321','','G011321',''),
		T_TIPO_DATA('Seguros'	,'Parte daños propios','G011321','','G011321',''),
		T_TIPO_DATA('Seguros'	,'Parte daños a terceros','G011321','','G011321',''),
			
		T_TIPO_DATA('Servicios profesionales independientes'	,'Registro','G011360','','G011360',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Notaría','G011301','','G011301',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Abogado (Ocupacional)','G011358','','G011358',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Abogado (Asuntos generales)','G011358','','G011358',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Abogado (Asistencia jurídica)','G011358','','G011358',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Procurador','G011334','','G011334',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Otros servicios jurídicos','G011377','','G011377',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Asesoría','G011377','','G011377',''),
		T_TIPO_DATA('Servicios profesionales independientes'	,'Tasación','G011318','','G011318',''),
			
		T_TIPO_DATA('Gestoría'	,'Honorarios gestión activos','G011361','','G011361',''),
		T_TIPO_DATA('Gestoría'	,'Honorarios gestión ventas','G011328','','G011328',''),
			
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Informes','G011332','','G011332',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Certif. eficiencia energética (CEE)','G011329','','G011329',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Licencia Primera Ocupación (LPO)','G011351','','G011351',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Cédula Habitabilidad','G011330','','G011330',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Certificado Final de Obra (CFO)','G011333','','G011333',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Boletín instalaciones y suministros','G011346','','G011346',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Obtención certificados y documentación','G011332','','G011332',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'Nota simple actualizada','G011360','','G011360',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'VPO: Solicitud devolución ayudas','G011376','','G011376',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'VPO: Notificación adjudicación (tanteo)','G011376','','G011376',''),
		T_TIPO_DATA('Informes técnicos y obtención documentos'	,'VPO: Autorización de venta','G011376','','G011376',''),
			
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Cambio de cerradura','G011317','','G011317',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Tapiado','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Retirada de enseres','G011315','','G011315',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Limpieza','G011315','','G011315',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Limpieza y retirada de enseres','G011315','','G011315',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Limpieza, retirada de enseres y descerraje','G011315','','G011315',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Limpieza, desinfección… (solares)','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Seguridad y Salud (SS)','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Verificación de averías','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Obra menor','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Control de actuaciones (dirección técnica)','G011332','','G011332',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Colocación puerta antiocupa','G011316','','G011316',''),
		T_TIPO_DATA('Actuación técnica y mantenimiento'	,'Mobiliario','G011316','','G011316',''),
			
		T_TIPO_DATA('Vigilancia y seguridad'	,'Vigilancia y seguridad','G011327','','G011327',''),
		T_TIPO_DATA('Vigilancia y seguridad'	,'Alarmas','G011327','','G011327',''),
		T_TIPO_DATA('Vigilancia y seguridad'	,'Servicios auxiliares','G011327','','G011327',''),
			
		T_TIPO_DATA('Otros gastos'	,'Mensajería/correos/copias','G011349','','G011349','')

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
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = ''14''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''14''), 
					'''|| TRIM(V_TMP_TIPO_DATA(3)) ||''',
					0,
					''HREOS-4456'',
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
							INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
							INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
							WHERE CRA.DD_CRA_CODIGO = ''14''
							AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
							AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
							AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
							AND CPP.CPP_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
				
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN			
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''14''), 
						'''|| TRIM(V_TMP_TIPO_DATA(4)) ||''',
						0,
						''HREOS-4456'',
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
				
			--Si es el año 2017--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			ELSE
				
				--Comprobamos el dato a insertar par registros sin arrendamiento
				V_SQL := 'SELECT COUNT(1)  
						FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP
						INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = CPP.EJE_ID
						INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CPP.DD_CRA_ID
						INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
						INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
						WHERE CRA.DD_CRA_CODIGO = ''14''
						AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
						AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
						AND CPP.CPP_ARRENDAMIENTO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				--Si NO existe lo insertamos
				IF V_NUM_TABLAS = 0 THEN				
			  
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
				VALUES (
					'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
					(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
					(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
					(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''14''), 
					'''|| TRIM(V_TMP_TIPO_DATA(5)) ||''',
					0,
					''HREOS-4456'',
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
							INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
							INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
							WHERE CRA.DD_CRA_CODIGO = ''14''
							AND EJE.EJE_ANYO = '''||V_EJE_ANYO||'''
							AND STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
							AND TGA.DD_TGA_DESCRIPCION ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
							AND CPP.CPP_ARRENDAMIENTO = 1';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
					
					--Si NO existe lo insertamos
					IF V_NUM_TABLAS = 0 THEN				
				  
					V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP(CPP_ID, EJE_ID, DD_STG_ID, DD_CRA_ID, CPP_PARTIDA_PRESUPUESTARIA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, CPP_ARRENDAMIENTO)
					VALUES (
						'||V_ESQUEMA||'.S_CPP_CONFIG_PTDAS_PREP.NEXTVAL,
						(SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = '''||V_EJE_ANYO||'''),
						(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG WHERE STG.DD_STG_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' AND STG.DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA WHERE TGA.DD_TGA_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''')),
						(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''14''), 
						'''|| TRIM(V_TMP_TIPO_DATA(6)) ||''',
						0,
						''HREOS-4456'',
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
