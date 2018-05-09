--/*
--##########################################
--## AUTOR=Angel Pastelero
--## FECHA_CREACION=20180412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3962
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_STR_SUBTIPO_TRABAJO los datos añadidos en T_ARRAY_DATA.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_STR_SUBTIPO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'STR'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-3962'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	CODIGO				DESCRIPCION					DESCRIPCION_LARGA		TIPO_TRABAJO_CODIGO
	T_TIPO_DATA('100',		'Limpeza extraordinaria hasta 150m2',		'Limpeza extraordinaria hasta 150m2',		'03'),
	T_TIPO_DATA('101',		'Limpieza extraordinaria de 5 a 10 activos',	'Limpieza extraordinaria de 5 a 10 activos',	'03'),
	T_TIPO_DATA('102',		'Limpieza extraordinaria de 10 a 20 activos',	'Limpieza extraordinaria de 10 a 20 activos',	'03'),
	T_TIPO_DATA('103',		'Limpieza extraordinaria de 20 a 30 activos',	'Limpieza extraordinaria de 20 a 30 activos',	'03'),
	T_TIPO_DATA('104',		'Limpieza extraordinaria más de 30 activos',	'Limpieza extraordinaria más de 30 activos',	'03'),
	T_TIPO_DATA('105',		'Limpieza extraordinaria más de 150 m2',	'Limpieza extraordinaria más de 150 m2',	'03'),
	T_TIPO_DATA('106',		'Mobiliario de cocina',				'Mobiliario de cocina',				'03'),
	T_TIPO_DATA('107',		'Electrodomésticos',				'Electrodomésticos',				'03'),
	T_TIPO_DATA('108',		'Adecuación suelos',				'Adecuación suelos',				'03'),
	T_TIPO_DATA('109',		'Vallado de hormigón',				'Vallado de hormigón',				'03'),
	T_TIPO_DATA('110',		'Vallado de chapa',				'Vallado de chapa',				'03'),
	T_TIPO_DATA('111',		'Cerramiento de ladrillo',			'Cerramiento de ladrillo',			'03'),
	T_TIPO_DATA('112',		'Puerta peatonal',				'Puerta peatonal',				'03'),
	T_TIPO_DATA('113',		'Puerta abatible',				'Puerta abatible',				'03'),
	T_TIPO_DATA('114',		'Cercado',					'Cercado',					'03'),
	T_TIPO_DATA('115',		'Desmontado cercado',				'Desmontado cercado',				'03'),
	T_TIPO_DATA('116',		'Retirada residuos',				'Retirada residuos',				'03'),
	T_TIPO_DATA('117',		'Retirada fibrocemento',			'Retirada fibrocemento',			'03'),
	T_TIPO_DATA('118',		'Aislamiento ',					'Aislamiento ',					'03'),
	T_TIPO_DATA('119',		'Desinfección urbanización',			'Desinfección urbanización',			'03'),
	T_TIPO_DATA('120',		'Cepo garaje',					'Cepo garaje',					'03'),
	T_TIPO_DATA('121',		'Reformas mayores',				'Reformas mayores',				'03'),
	T_TIPO_DATA('122',		'Pintura',					'Pintura',					'03'),
	T_TIPO_DATA('123',		'Carpintería',					'Carpintería',					'03'),
	T_TIPO_DATA('124',		'Fontanería',					'Fontanería',					'03'),
	T_TIPO_DATA('125',		'Albañilería',					'Albañilería',					'03'),
	T_TIPO_DATA('126',		'Electricidad',					'Electricidad',					'03'),
	T_TIPO_DATA('127',		'Cristalería',					'Cristalería',					'03')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
					  'SET DD_'||V_TEXT_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					  ', DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					  ', DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
					  ', USUARIOMODIFICAR = '|| V_USU_MODIFICAR ||' , FECHAMODIFICAR = SYSDATE '||
					  'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE

			-- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(DD_'||V_TEXT_CHARS||'_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;

			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_'||V_TEXT_CHARS||'_ID, DD_TTR_ID, DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, '|| V_USU_MODIFICAR ||',SYSDATE,0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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
