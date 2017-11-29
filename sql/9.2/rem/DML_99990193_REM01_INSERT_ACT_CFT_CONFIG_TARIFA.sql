--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3323
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA.
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

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-3323'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		PRECIO_UNITARIO		UNIDAD_MEDIDA
        T_TIPO_DATA('BK-ANTIOC1',				'03',					'40',						'03',				'99,15',			'unidad'),
        T_TIPO_DATA('BK-ANTIOC2',				'03',					'40',						'03',				'603,25',			'unidad'),
        T_TIPO_DATA('BK-ANTIOC3',				'03',					'40',						'03',				'81,74',			'unidad'),
        T_TIPO_DATA('BK-ANTIOC4',				'03',					'40',						'03',				'160,96',			'unidad'),
        T_TIPO_DATA('BK-ANTIOC5',				'03',					'40',						'03',				'50',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC6',				'03',					'40',						'03',				'20',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC7',				'03',					'40',						'03',				'70',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC8',				'03',					'40',						'03',				'42',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC9',				'03',					'40',						'03',				'65',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC10',				'03',					'40',						'03',				'81',				'€/h'),
        T_TIPO_DATA('BK-ANTIOC11',				'03',					'40',						'03',				'35',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC12',				'03',					'40',						'03',				'80',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC13',				'03',					'40',						'03',				'250',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC14',				'03',					'40',						'03',				'55',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC15',				'03',					'40',						'03',				'110',				'unidad'),
        T_TIPO_DATA('BK-ANTIOC16',				'03',					'40',						'03',				'350',				'unidad'),
        T_TIPO_DATA('ANTIOC1',					'03',					'40',						'02',				'765',				'unidad')
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
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

			-- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(CFT_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;

			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      ''||TRIM(V_TMP_TIPO_DATA(5))||', '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			
			--Borrar tarifa Obra menor tarificada
			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TEXT_TABLA);
			
			V_MSQL := 	'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' cft set cft.BORRADO=1, cft.USUARIOBORRAR=''HREOS-3323'', cft.FECHABORRAR=SYSDATE  where cft.CFT_ID = ' ||
						' (SELECT cft2.CFT_ID from '||V_ESQUEMA||'.'||V_TEXT_TABLA||' cft2' ||	
						' INNER JOIN '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA ttf on cft2.DD_TTF_ID = ttf.DD_TTF_ID ' ||
						' INNER JOIN '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO ttr on cft2.DD_TTR_ID = ttr.DD_TTR_ID ' ||
						' INNER JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO str on cft2.DD_STR_ID = str.DD_STR_ID ' ||
						' INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra on cft2.DD_CRA_ID = cra.DD_CRA_ID ' ||
						' WHERE ttf.DD_TTF_CODIGO= ''ANTIOC1'' AND ttr.DD_TTR_CODIGO=''03'' AND str.DD_STR_CODIGO=''37'' AND cra.DD_CRA_CODIGO= ''02'') ';
			
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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