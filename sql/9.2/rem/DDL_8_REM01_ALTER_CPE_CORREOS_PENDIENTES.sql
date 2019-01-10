--/*
--##########################################
--## AUTOR=rlb
--## FECHA_CREACION=20181213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Realizar cambio tabla CPE_CORREOS_PENDIENTES
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CPE_CORREOS_PENDIENTES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref
    V_COLUMN_NAME_0 VARCHAR2(30):= 'CPE_TO'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_1 VARCHAR2(30):= 'CPE_FROM'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_2 VARCHAR2(30):= 'CPE_ASUNTO'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_3 VARCHAR2(30):= 'CPE_RESULTADO'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_4 VARCHAR2(30):= 'CPE_ERROR_DESC'; -- Vble. para el nombre de las columnas.
    
BEGIN
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_0||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		-- Se modifica la columna.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_COLUMN_NAME_0||' VARCHAR2(1000 CHAR))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_0||'... Modificada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Columna no encontrada. No se modifica nada.');
	END IF;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_1||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		-- Se modifica la columna.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_COLUMN_NAME_1||' VARCHAR2(1000 CHAR))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_0||'... Modificada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Columna no encontrada. No se modifica nada.');
	END IF;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		-- Se modifica la columna.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_COLUMN_NAME_2||' VARCHAR2(3000 CHAR))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Modificada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Columna no encontrada. No se modifica nada.');
	END IF;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_3||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' AND DATA_TYPE = ''VARCHAR2'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_COLUMN_NAME_3||'';
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_3||' CLOB)';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||'... Modificada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Columna no encontrada. No se modifica nada.');
	END IF;
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin');

	EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;          

END;

/

EXIT