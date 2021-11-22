--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20201028
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16100
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar label
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
	V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
	V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
	V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	
	V_TAP_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16100';
	V_TAP_CODIGO VARCHAR2(50 CHAR) := 'T018_AnalisisBc';
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('5', 'textarea',		'observacionesBC'		, 'Observaciones BC', 			'', 		''),
		T_TIPO_DATA('6', 'textarea',		'observaciones'		, 'Observaciones', 			'', 		'')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		--Comprobar el dato a insertar.
		V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TAP_CODIGO)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE 
			TAP_ID = '''||V_TAP_ID||'''
			AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' DE '''|| TRIM(V_TAP_CODIGO) ||'''');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET 
				TFI_ORDEN = '''||TRIM(V_TMP_TIPO_DATA(1))||''',
				TFI_TIPO = '''||TRIM(V_TMP_TIPO_DATA(2))||''',  
				TFI_LABEL = '''||TRIM(V_TMP_TIPO_DATA(4))||''', 
				TFI_ERROR_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
				TFI_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA(6))||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''' , 
				FECHAMODIFICAR = SYSDATE, 
				BORRADO = 0 
				WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND TAP_ID = '||V_TAP_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
         
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

		ELSE
			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' DE '''|| TRIM(V_TAP_CODIGO) ||'''');

			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA|| 
				' (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
				SELECT '
					||V_ID|| ', '
					||V_TAP_ID|| ', '
					||TRIM(V_TMP_TIPO_DATA(1))||','''
					||TRIM(V_TMP_TIPO_DATA(2))||''','''
					||TRIM(V_TMP_TIPO_DATA(3))||''','''
					||TRIM(V_TMP_TIPO_DATA(4))||''','''
					||TRIM(V_TMP_TIPO_DATA(5))||''',''' 
					||TRIM(V_TMP_TIPO_DATA(6))||''',
					0, '''
					||V_USUARIO||''', 
					SYSDATE, 
					0 
					FROM DUAL';
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		END IF;
	END LOOP;
    
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
