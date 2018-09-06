--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20180829
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=
--## PRODUCTO=NO
--## Finalidad: Modificar el tamaño de la columna TFI_TIPO en TFI_TAREAS_FORM_ITEMS y añadir comentarios a la tabla.
--##
--## INSTRUCCIONES: Este script permite cambiar el tipo de contenido del campo de una tabla y añadir comentarios a las
--##				columnas y a la tabla. Si dejamos nulo el campo TIPO tan sólo comentará la columna.
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
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(250 CHAR) := 'Esta tabla registra los elementos visuales que conforman el formulario de la tarea asociada de un procedimiento';

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
	--			NOMBRE CAMPO				TIPO/NULL para sólo comentar	COMENTARIO
	T_TIPO_DATA('TFI_TIPO', 				'VARCHAR2(50 CHAR)', 			'Indica el xtype personalizado del tipo de elemento visual en ExtJS que se genera en el formulario'),
	T_TIPO_DATA('TFI_ID', 					null, 							'ID único del registro'),
	T_TIPO_DATA('TAP_ID', 					null, 							'Referencia a la tarea a la que pertenece el elemento visual'),
	T_TIPO_DATA('TFI_ORDEN', 				null, 							'Indica la posición del elemento visual entre todos los elementos que conforman la tarea'),
	T_TIPO_DATA('TFI_NOMBRE', 				null, 							'Hace referencia a la etiqueta name del elemento visual. Utilizado para obtener el elemento por nombre. Único entre elementos de una misma tarea'),
	T_TIPO_DATA('TFI_LABEL', 				null, 							'Etiqueta de descripción del elemento visual que es mostrada en el formulario'),
	T_TIPO_DATA('TFI_ERROR_VALIDACION',		null, 							'Indica el texto descriptivo que se muestra si existe error'),
	T_TIPO_DATA('TFI_VALIDACION',			null, 							'Indica si está permitido que el elemento visual se encuentre en blanco o si debe tener contenido'),
	T_TIPO_DATA('TFI_VALOR_INICIAL',		null, 							'Indica si el elemento visual ha de tener un valor inicial'),
	T_TIPO_DATA('TFI_BUSINESS_OPERATION',	null, 							'Utilizado en elementos visuales que contienen una lista de valores, indica el nombre de entidad de la cual se obtienen los valores'),
	T_TIPO_DATA('VERSION',					null, 							'Indica la versión del registro'),
	T_TIPO_DATA('USUARIOCREAR',				null, 							'Indica el usuario que crea el registro'),
	T_TIPO_DATA('FECHACREAR',				null, 							'Indica la fecha en la que se crea el registro'),
	T_TIPO_DATA('USUARIOMODIFICAR',			null, 							'Indica el usuario que modifica el registro'),
	T_TIPO_DATA('FECHAMODIFICAR',			null, 							'Indica la fecha en la que se modifica el registro'),
	T_TIPO_DATA('USUARIOBORRAR',			null, 							'Indica el usuario que borra el registro'),
	T_TIPO_DATA('FECHABORRAR',				null, 							'Indica la fecha en la que se borra el registro'),
	T_TIPO_DATA('BORRADO',					null, 							'Indica si el registro se encuentra borrado de manera lógica')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- Comprobar si existe la tabla.
	DBMS_OUTPUT.PUT('[INFO] Comprobar que la tabla ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' existe____');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('OK');

		-- Crear comentario de la tabla.
		EXECUTE IMMEDIATE 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario de tabla creado.');

		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			-- Comprobar si existe la columna.
			DBMS_OUTPUT.PUT('[INFO] Comprobar que la columna '||TRIM(V_TMP_TIPO_DATA(1))||' existe____');
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('OK');
				
				-- Comprobar si ha de realizarse modificación y comentario o sólo comentario sobre la columna.
				IF V_TMP_TIPO_DATA(2) IS NOT NULL THEN
					EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
					EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';
					DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_TMP_TIPO_DATA(1)||' modificada y comentada');
					
				ELSE
					EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';
					DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_TMP_TIPO_DATA(1)||' solo comentada');
				
				END IF;

			ELSE
				DBMS_OUTPUT.PUT('la columna no existe. No se realizan cambios en ella.');

			END IF;
		END LOOP;
	
	ELSE
		DBMS_OUTPUT.PUT('la tabla no existe. No se realiza ningún cambio.');
	
	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		err_num := SQLCODE;
		err_msg := SQLERRM;

		DBMS_OUTPUT.PUT_LINE('KO operacion no realizada');
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);

		ROLLBACK;
		RAISE;

END;

/

EXIT
