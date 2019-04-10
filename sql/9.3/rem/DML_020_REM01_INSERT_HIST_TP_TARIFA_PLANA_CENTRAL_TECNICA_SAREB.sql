--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6072
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en HIST_TP_TARIFA_PLANA los datos añadidos en T_ARRAY_DATA.
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

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'HIST_TP_TARIFA_PLANA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-6072'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
		 --	CODIGO				STR_TARIFA_PLANA	STR_FECHA_INI_TP		
		 T_TIPO_DATA('26',		1	,				'10/05/2019'),
		 T_TIPO_DATA('27',		1	,				'10/05/2019'),
		 T_TIPO_DATA('28',		1	,				'10/05/2019'),
		 T_TIPO_DATA('29',		1	,				'10/05/2019'),
		 T_TIPO_DATA('30',		1	,				'10/05/2019'),
		 T_TIPO_DATA('31',		1	,				'10/05/2019'),
		 T_TIPO_DATA('32',		1	,				'10/05/2019'),
		 T_TIPO_DATA('57',		1	,				'10/05/2019'),
		 T_TIPO_DATA('60',		1	,				'10/05/2019'),
		 T_TIPO_DATA('61',		1	,				'10/05/2019'),
		 T_TIPO_DATA('63',		1	,				'10/05/2019'),
		 T_TIPO_DATA('64',		1	,				'10/05/2019'),
		 T_TIPO_DATA('66',		1	,				'10/05/2019'),
		 T_TIPO_DATA('67',		1	,				'10/05/2019'),
		 T_TIPO_DATA('68',		1	,				'10/05/2019'),
		 T_TIPO_DATA('69',		1	,				'10/05/2019'),
		 T_TIPO_DATA('70',		1	,				'10/05/2019'),
		 T_TIPO_DATA('71',		1	,				'10/05/2019'),
		 T_TIPO_DATA('72',		1	,				'10/05/2019'),
		 T_TIPO_DATA('73',		1	,				'10/05/2019'),
		 T_TIPO_DATA('100',		1	,				'10/05/2019'),
		 T_TIPO_DATA('101',		1	,				'10/05/2019'),
		 T_TIPO_DATA('102',		1	,				'10/05/2019'),
		 T_TIPO_DATA('103',		1	,				'10/05/2019'),
		 T_TIPO_DATA('104',		1	,				'10/05/2019'),
		 T_TIPO_DATA('105',		1	,				'10/05/2019'),
		 T_TIPO_DATA('109',		1	,				'10/05/2019'),
		 T_TIPO_DATA('110',		1	,				'10/05/2019'),
		 T_TIPO_DATA('111',		1	,				'10/05/2019'),
		 T_TIPO_DATA('112',		1	,				'10/05/2019'),
		 T_TIPO_DATA('113',		1	,				'10/05/2019'),
		 T_TIPO_DATA('114',		1	,				'10/05/2019'),
		 T_TIPO_DATA('115',		1	,				'10/05/2019'),
		 T_TIPO_DATA('116',		1	,				'10/05/2019'),
		 T_TIPO_DATA('117',		1	,				'10/05/2019'),
		 T_TIPO_DATA('120',		1	,				'10/05/2019'),
		 T_TIPO_DATA('129',		1	,				'10/05/2019')
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
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE STR_FECHA_FIN_TP IS NULL AND DD_STR_ID = ( 
																SELECT DD_STR_ID 
																FROM DD_STR_SUBTIPO_TRABAJO 
																WHERE DD_STR_CODIGO = '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''
																)';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

       		IF V_NUM_TABLAS = 0 THEN				
			-- Comprobar secuencias de la tabla.
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS > 0 THEN
			
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
				V_SQL := 'SELECT NVL(MAX(HIST_TP_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
				   
				WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
					V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
					EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
				END LOOP;

				-- Si no existe se inserta.
				DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
				      	'HIST_TP_ID, 
					DD_STR_ID, 
					STR_TARIFA_PLANA, 
					STR_FECHA_INI_TP, 
					VERSION, 
					USUARIOCREAR, 
					FECHACREAR, 
					BORRADO) ' ||
		              	'SELECT 
					'|| V_NUM_SEQUENCE || ', 
					(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), 
					'||V_TMP_TIPO_DATA(2)||',
					TO_DATE('''||TRIM(V_TMP_TIPO_DATA(3))||''', ''dd/mm/yyyy''),
					0, 
					'|| V_USU_MODIFICAR ||',
					SYSDATE,
					0 FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			
			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL SUBTIPO DE TRABAJO CON DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
			END IF;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE UNA TARIFA PLANA VIGENTE PARA EL SUBTIPO DE TRABAJO CON DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
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
