--/*
--##########################################
--## AUTOR=Javier Urbán
--## FECHA_CREACION=20210225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13199
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_TCS_TIPO_CORRECTIVO_SAREB
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
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'DD_TCS_TIPO_CORRECTIVO_SAREB';
    V_CHARS VARCHAR2(3 CHAR):= 'TCS';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-13199';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            -- CODIGO  			DESCRIPCION     DESCRIPCION_LARGA
      T_TIPO_DATA('01',			'Desbroces',			'Desbroces'),
      T_TIPO_DATA('02',			'Rellenos / Nivelaciones',		    'Rellenos / Nivelaciones'),
      T_TIPO_DATA('03',			'Limpieza de Solares',			'Limpieza de Solares'),
      T_TIPO_DATA('04',			'Podas',		    'Podas'),
      T_TIPO_DATA('05',			'Desratización / Desinsectación / Plagas / Herbicidas',			'Desratización / Desinsectación / Plagas / Herbicidas'),
      T_TIPO_DATA('06',			'Ejecución / Reparación de vallado provisional',		    'Ejecución / Reparación de vallado provisional'),
      T_TIPO_DATA('07',			'Ejecución / Reparación de vallado definitivo',			'Ejecución / Reparación de vallado definitivo'),
      T_TIPO_DATA('08',			'Revisión de perímetro de parcela / obra parada',		    'Revisión de perímetro de parcela / obra parada'),
      T_TIPO_DATA('09',			'Reparación/ Creación de instalaciones de saneamiento',			'Reparación/ Creación de instalaciones de saneamiento'),
      T_TIPO_DATA('10',			'Inspección de instalaciones de saneamiento',		    'Inspección de instalaciones de saneamiento'),
      T_TIPO_DATA('11',			'Desatrancos / Bombeos',			'Desatrancos / Bombeos'),
      T_TIPO_DATA('12',			'Proyecto / Boletín / Legalización de inst. de saneamiento',		    'Proyecto / Boletín / Legalización de inst. de saneamiento'),
      T_TIPO_DATA('13',			'Revisión técnica de cimentación / estructura',			'Revisión técnica de cimentación / estructura'),
      T_TIPO_DATA('14',			'Pruebas de carga estructurales',		    'Pruebas de carga estructurales'),
      T_TIPO_DATA('15',			'Rehabilitación estructural',			'Rehabilitación estructural'),
      T_TIPO_DATA('16',			'Revisión de medianerías',		    'Revisión de medianerías'),
      T_TIPO_DATA('17',			'Impermeabilizaciones en fachadas',			'Impermeabilizaciones en fachadas'),
      T_TIPO_DATA('18',			'Rehabilitación de fachadas',		    'Rehabilitación de fachadas'),
      T_TIPO_DATA('19',			'Ejecución / Reparación de fábricas de ladrillo',			'Ejecución / Reparación de fábricas de ladrillo'),
      T_TIPO_DATA('20',			'Ejecución / REPARACIÓN de fábricas de bloque',		    'Ejecución / REPARACIÓN de fábricas de bloque'),
      T_TIPO_DATA('21',			'Ejecución / Reparación de tabiquerías de pladur',			'Ejecución / Reparación de tabiquerías de pladur'),
      T_TIPO_DATA('22',			'Aislamientos térmicos en fachadas',		    'Aislamientos térmicos en fachadas'),
      T_TIPO_DATA('23',			'Aislamientos acústicos en fachadas',			'Aislamientos acústicos en fachadas'),
      T_TIPO_DATA('24',			'Ejecución / reparación de otras tabiquerías',		    'Ejecución / reparación de otras tabiquerías'),
      T_TIPO_DATA('25',			'Ejecución /reparación de medios auxiliares',			'Ejecución /reparación de medios auxiliares'),
      T_TIPO_DATA('26',			'Honorarios técnicos para implantación de medios aux.',		    'Honorarios técnicos para implantación de medios aux.'),
      T_TIPO_DATA('27',			'Proyecto / Boletín / Legalización de medios auxiliares',			'Proyecto / Boletín / Legalización de medios auxiliares'),
      T_TIPO_DATA('28',			'Reparación / Ejecución de revestimientos (fasos techos, alicatados, solados…)',		    'Reparación / Ejecución de revestimientos (fasos techos, alicatados, solados…)'),
      T_TIPO_DATA('29',			'Localización / Reparación humedades',			'Localización / Reparación humedades'),
      T_TIPO_DATA('30',			'Reparación / Ejecución de pinturas',		    'Reparación / Ejecución de pinturas'),
      T_TIPO_DATA('31',			'Proyecto / Boletín / Legalización de inst. Eléctrica',			'Proyecto / Boletín / Legalización de inst. Eléctrica'),
      T_TIPO_DATA('32',			'Revisión / Reparación / Ejecución de inst. Eléctrica',		    'Revisión / Reparación / Ejecución de inst. Eléctrica'),
      T_TIPO_DATA('33',			'Acometida eléctrica',			'Acometida eléctrica'),
      T_TIPO_DATA('34',			'Proyecto / Boletín / Legalización de ascensor',		    'Proyecto / Boletín / Legalización de ascensor'),
      T_TIPO_DATA('35',			'Revisión / Reparación / Ejecución de ascensor',			'Revisión / Reparación / Ejecución de ascensor'),
      T_TIPO_DATA('36',			'Revisión / Reparación / Ejecución de inst. De telefonía',		    'Revisión / Reparación / Ejecución de inst. De telefonía'),
      T_TIPO_DATA('37',			'Acometida de inst. de telefonía',			'Acometida de inst. de telefonía'),
      T_TIPO_DATA('38',			'Proyecto / Boletín / Legalización de inst. fontanería',		    'Proyecto / Boletín / Legalización de inst. fontanería'),
      T_TIPO_DATA('39',			'Revisión / Reparación / Ejecución de inst. fontanería',			'Revisión / Reparación / Ejecución de inst. fontanería'),
      T_TIPO_DATA('40',			'Acometida de fontanería',		    'Acometida de fontanería'),
      T_TIPO_DATA('41',			'Revisión / Control legionela',			'Revisión / Control legionela'),
      T_TIPO_DATA('42',			'Proyecto / Boletín / Legalización de inst. PCI',		    'Proyecto / Boletín / Legalización de inst. PCI'),
      T_TIPO_DATA('43',			'Revisión / Reparación / Ejecución de inst. PCI',			'Revisión / Reparación / Ejecución de inst. PCI'),
      T_TIPO_DATA('44',			'Proyecto / Boletín / Legalización de inst. de combustión',		    'Proyecto / Boletín / Legalización de inst. de combustión'),
      T_TIPO_DATA('45',			'Revisión / Reparación / Ejecución de inst. de combustión',			'Revisión / Reparación / Ejecución de inst. de combustión'),
      T_TIPO_DATA('46',			'Acometida de inst. de combustión',		    'Acometida de inst. de combustión'),
      T_TIPO_DATA('47',			'Proyecto / Boletín / Legalización de inst. de climatización',			'Proyecto / Boletín / Legalización de inst. de climatización'),
      T_TIPO_DATA('48',			'Revisión / Reparación / Ejecución de inst. de climatización',		    'Revisión / Reparación / Ejecución de inst. de climatización'),
      T_TIPO_DATA('49',			'Proyecto / Boletín / Legalización de inst. solar térmica',			'Proyecto / Boletín / Legalización de inst. solar térmica'),
      T_TIPO_DATA('50',			'Revisión / Reparación / Ejecución de inst. solar térmica',		    'Revisión / Reparación / Ejecución de inst. solar térmica'),
      T_TIPO_DATA('51',			'Proyecto / Boletín / Legalización de inst. fotovoltaica',			'Proyecto / Boletín / Legalización de inst. fotovoltaica'),
      T_TIPO_DATA('52',			'Revisión / Reparación / Ejecución de inst. fotovoltaica',		    'Revisión / Reparación / Ejecución de inst. fotovoltaica'),
      T_TIPO_DATA('53',			'Revisión / Reparación / Ejecución otras instalaciones',			'Revisión / Reparación / Ejecución otras instalaciones'),
      T_TIPO_DATA('54',			'Revisión de cubierta / Localización de goteras',		    'Revisión de cubierta / Localización de goteras'),
      T_TIPO_DATA('55',			'Reparación de goteras en cubierta',			'Reparación de goteras en cubierta'),
      T_TIPO_DATA('56',			'Aislamiento en cubiertas',		    'Aislamiento en cubiertas'),
      T_TIPO_DATA('57',			'Impermeabilizaciones en cubierta',			'Impermeabilizaciones en cubierta'),
      T_TIPO_DATA('58',			'Colocación / Reparación carpintería interior',		    'Colocación / Reparación carpintería interior'),
      T_TIPO_DATA('59',			'Colocación / Reparación carpintería exterior',			'Colocación / Reparación carpintería exterior'),
      T_TIPO_DATA('60',			'Colocación / Reposición de vidrios',		    'Colocación / Reposición de vidrios'),
      T_TIPO_DATA('61',			'Tasas municipales',		    'Tasas municipales'),
      T_TIPO_DATA('62',			'Licencias municipales',		    'Licencias municipales'),
      T_TIPO_DATA('63',			'Honorarios por informes técnicos',			'Honorarios por informes técnicos'),
      T_TIPO_DATA('64',			'Honorarios por informes proyectos técnicos',		    'Honorarios por informes proyectos técnicos'),
      T_TIPO_DATA('65',			'Honorarios por DO / DEO / CSS',			'Honorarios por DO / DEO / CSS'),
      T_TIPO_DATA('66',			'Otros honorarios (peritos, notarios…)',		    'Otros honorarios (peritos, notarios…)'),
      T_TIPO_DATA('67',			'Colocación / reparación de elementos de cerrajería',			'Colocación / reparación de elementos de cerrajería'),
      T_TIPO_DATA('68',			'Descerrajes / Cambios de cerradura',		    'Descerrajes / Cambios de cerradura'),
      T_TIPO_DATA('69',			'Puertas de garaje y otros automatismos',			'Puertas de garaje y otros automatismos'),
      T_TIPO_DATA('70',			'Instalación de puertas antiocupa',		    'Instalación de puertas antiocupa'),
      T_TIPO_DATA('71',			'Trabajos de jardinería',			'Trabajos de jardinería'),
      T_TIPO_DATA('72',			'Reparación de piscinas enterradas',		    'Reparación de piscinas enterradas'),
      T_TIPO_DATA('73',			'Reparación de vallados / Cerramientos en urbanización',			'Reparación de vallados / Cerramientos en urbanización'),
      T_TIPO_DATA('74',			'Reparación de instalaciones de urbanización',		    'Reparación de instalaciones de urbanización'),
      T_TIPO_DATA('75',			'Reparación de pistas deportivas',			'Reparación de pistas deportivas'),
      T_TIPO_DATA('76',			'Vigilancia presencial',		    'Vigilancia presencial'),
      T_TIPO_DATA('77',			'Vigilancia dinámica',			'Vigilancia dinámica'),
      T_TIPO_DATA('78',			'Alarmas',		    'Alarmas'),
      T_TIPO_DATA('79',			'CCTV',			'CCTV'),
      T_TIPO_DATA('80',			'Otros seguridad y vigilancia',		    'Otros seguridad y vigilancia'),
      T_TIPO_DATA('81',			'Honorarios de redacción de informe de ite',			'Honorarios de redacción de informe de ite'),
      T_TIPO_DATA('82',			'Honorarios de proyecto técnico visado de ite',		    'Honorarios de proyecto técnico visado de ite'),
      T_TIPO_DATA('83',			'Ejecución medidas del informe de ITE',			'Ejecución medidas del informe de ITE'),
      T_TIPO_DATA('84',			'Tasas municipales derivadas de la ITE',		    'Tasas municipales derivadas de la ITE'),
      T_TIPO_DATA('85',			'Limpiezas en edificación',			'Limpiezas en edificación'),
      T_TIPO_DATA('86',			'Gestiones con organismos públicos o privados',		    'Gestiones con organismos públicos o privados'),
      T_TIPO_DATA('87',			'Inspección / comprobación',			'Inspección / comprobación'),
      T_TIPO_DATA('88',			'Otros trabajos de mantenimiento',		    'Otros trabajos de mantenimiento'),
      T_TIPO_DATA('89',			'Agua',			'Agua'),
      T_TIPO_DATA('90',			'Electricidad',		    'Electricidad'),
      T_TIPO_DATA('91',			'Suministro de Gas',			'Suministro de Gas'),
      T_TIPO_DATA('92',			'Teléfono Fijo',		    'Teléfono Fijo'),
      T_TIPO_DATA('93',			'Teléfonos móviles',			'Teléfonos móviles'),
      T_TIPO_DATA('94',			'Otros suministros',		    'Otros suministros'),
      T_TIPO_DATA('95',			'Representar a Sareb CP/EUC',			'Representar a Sareb CP/EUC'),
      T_TIPO_DATA('96',			'Recibir comunicados',		    'Recibir comunicados'),
      T_TIPO_DATA('97',			'Informar a Sareb temas de relevancia',			'Informar a Sareb temas de relevancia'),
      T_TIPO_DATA('98',			'Informar sobre eventos contrarios a los intereses de Sareb',		    'Informar sobre eventos contrarios a los intereses de Sareb'),
      T_TIPO_DATA('99',			'Revisión y control de gastos ordinarios',			'Revisión y control de gastos ordinarios'),
      T_TIPO_DATA('100',		'Revisión y control de gastos extraordinarios',		    'Revisión y control de gastos extraordinarios'),
      T_TIPO_DATA('101',		'Revisión y regularización de deuda tras adquisición',			'Revisión y regularización de deuda tras adquisición'),
      T_TIPO_DATA('102',		'Otros CP/EUC',		    'Otros CP/EUC')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
	    USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				DD_'||V_CHARS||'_ID, DD_'||V_CHARS||'_CODIGO, DD_'||V_CHARS||'_DESCRIPCION, DD_'||V_CHARS||'_DESCRIPCION_LARGA, 
				VERSION, USUARIOCREAR, FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '''||V_TMP_TIPO_DATA(1)||''',
	            '''||V_TMP_TIPO_DATA(2)||''',
	            '''||TRIM(V_TMP_TIPO_DATA(3))||''',
	            0, '''||V_USUARIO||''', SYSDATE FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;

    END LOOP;
  COMMIT;
   

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
