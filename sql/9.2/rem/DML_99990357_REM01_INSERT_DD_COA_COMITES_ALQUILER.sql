--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180809
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4311
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_COA_COMITES_ALQUILER los datos añadidos en T_ARRAY_DATA.
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

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_COA_COMITES_ALQUILER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'COA'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-4311'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				CODIGO COA		DESCRIPCION				DESCRIPCION_LARGA		CODIGO CARTERA
        T_TIPO_DATA('1',			'HAYA',						'HAYA',				'01'),
        T_TIPO_DATA('2',			'Comité Cajamar',			'Comité Cajamar',	'01'),
        T_TIPO_DATA('3',			'HAYA',						'HAYA',				'02'),
        T_TIPO_DATA('4',			'Comité Sareb'	,			'Sareb',			'02'),
        T_TIPO_DATA('5',			'HAYA',						'HAYA',				'03'),
        T_TIPO_DATA('6',			'Comité Bankia',			'Comité Bankia',	'03'),
        T_TIPO_DATA('7',			'HAYA',						'HAYA',				'04'),
        T_TIPO_DATA('8',			'Comité Otras carteras','Comité Otras carteras','04'),
        T_TIPO_DATA('9',			'HAYA',						'HAYA',				'06'),
        T_TIPO_DATA('10',			'Comité HyT',			'Comité HyT',			'06'),
        T_TIPO_DATA('11',			'HAYA',					'HAYA',					'07'),
        T_TIPO_DATA('12',			'Comité Cerberus',		'Comité Cerberus',		'07'),
        T_TIPO_DATA('13',			'HAYA',					'HAYA',					'08'),
        T_TIPO_DATA('14',			'Comité Liberbank',		'Comité Liberbank',		'08'),
        T_TIPO_DATA('15',			'HAYA'	,				'HAYA',					'10'),
        T_TIPO_DATA('16',			'Comité Tango'	,		'Comité Tango',			'10'),
        T_TIPO_DATA('17',			'HAYA',					'HAYA',					'11'),
        T_TIPO_DATA('18',			'Comité Third Parties',	'Comité Third Parties',	'11'),
        T_TIPO_DATA('19',			'HAYA'	,				'HAYA',					'12'),
        T_TIPO_DATA('20',			'Comité Giants',		'Comité Giants',		'12'),
        T_TIPO_DATA('21',			'HAYA',					'HAYA',					'05'),
        T_TIPO_DATA('22',			'Comité Sin definir',	'Comité Sin definir',	'05')
        
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
					  ', DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')'||
					  ', USUARIOMODIFICAR = '|| V_USU_MODIFICAR ||' , FECHAMODIFICAR = SYSDATE, FECHABORRAR=null, USUARIOBORRAR=null, BORRADO=0 '||
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
                      'DD_'||V_TEXT_CHARS||'_ID, DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, DD_CRA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', '''||V_TMP_TIPO_DATA(1)||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 0, '|| V_USU_MODIFICAR ||',SYSDATE,0 FROM DUAL';
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