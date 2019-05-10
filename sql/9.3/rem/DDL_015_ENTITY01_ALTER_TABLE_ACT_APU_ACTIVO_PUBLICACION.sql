--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20190508
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-5779
--## PRODUCTO=NO
--## Finalidad: Añadir nuevas columnas APU_FECHA_CAMB_PUBL_VENTA, APU_FECHA_CAMB_PUBL_ALQ, VAL_FECHA_CAMB_VENTA y VAL_FECHA_CAMB_ALQ en la tabla ACT_APU_ACTIVO_PUBLICACION.
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref
    V_COLUMN_NAME_0 VARCHAR2(30):= 'APU_FECHA_CAMB_PUBL_VENTA'; -- Vble. para el nombre de las columnas.
    V_COMMENT_TABLE_0 VARCHAR2(500 CHAR):= 'Indica la fecha del último cambio de publicación de venta del activo.'; -- Vble. para los comentarios de las tablas
    V_COLUMN_NAME_1 VARCHAR2(30):= 'APU_FECHA_CAMB_PUBL_ALQ'; -- Vble. para el nombre de las columnas.
    V_COMMENT_TABLE_1 VARCHAR2(500 CHAR):= 'Indica la fecha del último cambio de publicación de alquiler del activo.'; -- Vble. para los comentarios de las tablas
    V_COLUMN_NAME_2 VARCHAR2(30):= 'APU_FECHA_CAMB_PREC_VENTA'; -- Vble. para el nombre de las columnas.
    V_COMMENT_TABLE_2 VARCHAR2(500 CHAR):= 'Indica la fecha del último cambio del precio de venta del activo.'; -- Vble. para los comentarios de las tablas
    V_COLUMN_NAME_3 VARCHAR2(30):= 'APU_FECHA_CAMB_PREC_ALQ'; -- Vble. para el nombre de las columnas.
    V_COMMENT_TABLE_3 VARCHAR2(500 CHAR):= 'Indica la fecha del último cambio del precio de alquiler del activo.'; -- Vble. para los comentarios de las tablas
    
BEGIN
	-- Comprobar si existe la columna ACT_FECHA_CAMBIO_TIPO_ACT.
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
	
	COMMIT;
	
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
	
	COMMIT;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_2||' DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||' IS '''||V_COMMENT_TABLE_2||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Creada');
	END IF;
	
	COMMIT;
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_3||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_3||' DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||' IS '''||V_COMMENT_TABLE_3||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||'... Creada');
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