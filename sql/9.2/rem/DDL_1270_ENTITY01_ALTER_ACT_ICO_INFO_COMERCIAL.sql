--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columnas de fecha venta, fecha alquiler y unidad poblacional.
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE_0 VARCHAR2(500 CHAR):= 'Fecha de estimación para la venta.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_1 VARCHAR2(500 CHAR):= 'Fecha de estimación para el alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_2 VARCHAR2(500 CHAR):= 'Unidad inferior al municipio.'; -- Vble. para los comentarios de las tablas
    V_COLUMN_NAME_0 VARCHAR2(26):= 'ICO_FECHA_ESTIMACION_VENTA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_1 VARCHAR2(26):= 'ICO_FECHA_ESTIMACION_RENTA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_2 VARCHAR2(26):= 'DD_UPO_ID'; -- Vble. para el nombre de las columnas.
    
BEGIN
	-- Comprobar si existe la columna ICO_FECHA_ESTIMACION_VENTA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_0||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_0||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_0||' DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_0||' IS '''||V_COMMENT_TABLE_0||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_0||'... Creada');
	END IF;
	
	-- Comprobar si existe la columna ICO_FECHA_ESTIMACION_RENTA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_1||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_1||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_1||' DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_1||' IS '''||V_COMMENT_TABLE_1||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_1||'... Creada');
	END IF;
	
	-- Comprobar si existe la columna DD_UPO_ID.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna, se le agrega un comentario y se genera la foreign key.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_2||' NUMBER(16,0))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||' IS '''||V_COMMENT_TABLE_2||'''';
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_INFOCOMER_DD_UPO_POBL FOREIGN KEY('||V_COLUMN_NAME_2||') REFERENCES '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL(DD_UPO_ID) ENABLE;';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Creada');
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