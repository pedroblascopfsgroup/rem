--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20180829
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=MIREC-1166
--## PRODUCTO=NO
--## Finalidad: Adaptar los tipos de elementos visuales en la tabla TFI_TAREAS_FORM_ITEMS.
--##
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
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TEXT_TABLA VARCHAR2(27 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_COLUMN VARCHAR2(27 CHAR) := 'TFI_TIPO'; -- Vble. auxiliar para almacenar el nombre de la columna de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				ANTERIOR TFI_TIPO	NUEVO TFI_TIPO
        T_TIPO_DATA('textinf',			'textinf'),
        T_TIPO_DATA('time',				'timefield'),
        T_TIPO_DATA('emptyField',		'displayfieldbase'),
        T_TIPO_DATA('textarea',			'textarea'),
        T_TIPO_DATA('text',				'textfield'),
        T_TIPO_DATA('checkbox',			'checkbox'),
        T_TIPO_DATA('combo',			'combobox'),
        T_TIPO_DATA('datemintod',		'datemintoday'),
        T_TIPO_DATA('comboini',			'comboboxinicial'),
        T_TIPO_DATA('date',				'datefield'),
        T_TIPO_DATA('label',			'label'),
        T_TIPO_DATA('datemaxtod',		'datemaxtoday'),
        T_TIPO_DATA('textfield',		'textfield'),
        T_TIPO_DATA('comboesp',			'comboboxespecial'),
        T_TIPO_DATA('elctrabajo',		'elctrabajo'),
        T_TIPO_DATA('tfi_label',		'tfi_label'),
        T_TIPO_DATA('number',			'numberfield'),
        T_TIPO_DATA('elcactivo',		'elcactivo'),
        T_TIPO_DATA('comboinied',		'comboboxinicialedi')
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
		
		-- Comprobar si existe la columna.
		DBMS_OUTPUT.PUT('[INFO] Comprobar que la columna '||V_TEXT_COLUMN||' existe____');
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_TEXT_COLUMN||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('OK');

			DBMS_OUTPUT.PUT('[INFO] Actualizar valores en la columna ' || V_TEXT_COLUMN || '___');
	
			-- Actualizar los valores de la columna.
			FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
			LOOP
				V_TMP_TIPO_DATA := V_TIPO_DATA(I);
				V_MSQL:='UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
						'SET '|| V_TEXT_COLUMN ||' = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
						'WHERE '|| V_TEXT_COLUMN ||' = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
				EXECUTE IMMEDIATE V_MSQL;
	
			END LOOP;
	
			DBMS_OUTPUT.PUT_LINE('OK');
		ELSE
			DBMS_OUTPUT.PUT('la columna no existe. No se realizan cambios en su contenido.');

		END IF;

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
