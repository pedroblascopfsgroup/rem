--/*
--##########################################
--## AUTOR=Rasul Akhmeddiriov
--## FECHA_CREACION=20181211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5014
--## PRODUCTO=NO
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

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USR VARCHAR2(30 CHAR) := 'HREOS-5014'; -- USUARIOCREAR/USUARIOMODIFICAR.
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_CAMPO VARCHAR2(2400 CHAR) := 'TFI_BUSINESS_OPERATION'; -- Vble. auxiliar para almacenar el nombre de la columna de ref.
    V_DICCIONARIO VARCHAR2(2400 CHAR) := 'DDComiteSancion'; -- Vble. auxiliar para almacenar el nombre del diccionario de ref.
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION '||V_TEXT_TABLA||'');
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la columna existe. Si existe la columna, no se hace nada con esta (no se tiene en cuenta si los tipos coinciden).
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_TEXT_CAMPO||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	DBMS_OUTPUT.PUT_LINE('[INFO] ... Procediendo a actualizar el campo '||V_TEXT_CAMPO||'. ');

	IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
				SET '||V_TEXT_CAMPO||' = '''||V_DICCIONARIO||''',
				USUARIOMODIFICAR = '''||V_USR||''',
				FECHAMODIFICAR = SYSDATE
				WHERE TFI_TIPO = ''combobox''
				AND TFI_NOMBRE = ''comite''
				AND TFI_LABEL = ''Comité'' ';
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA '||V_TEXT_TABLA||'');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[ERROR] La tabla o la columna no existen.');

	END IF; 
	
	COMMIT;
 
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

