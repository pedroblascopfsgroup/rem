--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160913
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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE_0 VARCHAR2(500 CHAR):= 'Fecha de inicio alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_1 VARCHAR2(500 CHAR):= 'Fecha de fin alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_2 VARCHAR2(500 CHAR):= 'Importe renta alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_3 VARCHAR2(500 CHAR):= 'Numero de contrato alquiler'; -- Vble. para los comentarios de las tablas
--    V_COMMENT_TABLE_4 VARCHAR2(500 CHAR):= 'Situación contrato alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_5 VARCHAR2(500 CHAR):= 'Plazo de opción de compra del alquiler.'; -- Vble. para los comentarios de las tablas
	V_COMMENT_TABLE_6 VARCHAR2(500 CHAR):= 'Prima de opción de compra del alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_7 VARCHAR2(500 CHAR):= 'Precio de opción de compra del alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_8 VARCHAR2(500 CHAR):= 'Condiciones de opción de compra del alquiler.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_9 VARCHAR2(500 CHAR):= 'Conflictos de intereses.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_10 VARCHAR2(500 CHAR):= 'Riesgo reputacional.'; -- Vble. para los comentarios de las tablas

    V_COLUMN_NAME_0 VARCHAR2(40):= 'ECO_FECHA_INICIO_ALQUILER'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_1 VARCHAR2(40):= 'ECO_FECHA_FIN_ALQUILER'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_2 VARCHAR2(40):= 'ECO_IMPORTE_RENTA_ALQUILER'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_3 VARCHAR2(40):= 'ECO_NUMERO_CONTRATO_ALQUILER'; -- Vble. para el nombre de las columnas.
--    V_COLUMN_NAME_4 VARCHAR2(26):= 'dd_SITUACION_CONTRATO_ALQUILER'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_5 VARCHAR2(40):= 'ECO_PLAZO_OPCION_COMPRA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_6 VARCHAR2(40):= 'ECO_PRIMA_OPCION_COMPRA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_7 VARCHAR2(40):= 'ECO_PRECIO_OPCION_COMPRA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_8 VARCHAR2(40):= 'ECO_CONDICIONES_OPCION_COMPRA'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_9 VARCHAR2(40):= 'ECO_CONFLICTO_INTERESES'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_10 VARCHAR2(40):= 'ECO_RIESGO_REPUTACIONAL'; -- Vble. para el nombre de las columnas.
    
BEGIN
	-- Comprobar si existe la columna ECO_FECHA_INICIO_ALQUILER.
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
	
		-- Comprobar si existe la columna ECO_FECHA_FIN_ALQUILER.
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
	
			-- Comprobar si existe la columna ECO_IMPORTE_RENTA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_2||' NUMBER(16,2))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||' IS '''||V_COMMENT_TABLE_2||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Creada');
	END IF;
	
				-- Comprobar si existe la columna ECO_NUMERO_CONTRATO_ALQUILER.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_3||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_3||' NUMBER(16,0))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||' IS '''||V_COMMENT_TABLE_3||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_3||'... Creada');
	END IF;
	
	
	
	
--					-- Comprobar si existe la columna CEX_FECHA_RESOLUCION.
--	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_4||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
--	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
--
--	IF V_NUM_TABLAS > 0 THEN
--		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_4||'... Ya existe. Se continua.');
--	ELSE
--		-- Se crea la columna y se le agrega un comentario.
--		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_4||' DATE)';
--		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_4||' IS '''||V_COMMENT_TABLE_4||'''';
--		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_4||'... Creada');
--	END IF;
	
						-- Comprobar si existe la columna ECO_PLAZO_OPCION_COMPRA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_5||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_5||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_5||' DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_5||' IS '''||V_COMMENT_TABLE_5||'''';
--		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_INFOCOMER_DD_UPO_POBL FOREIGN KEY('||V_COLUMN_NAME_2||') REFERENCES '||V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL(DD_UPO_ID) ENABLE';

		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_5||'... Creada');
	END IF;
	
				-- Comprobar si existe la columna ECO_PRIMA_OPCION_COMPRA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_6||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_6||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_6||' NUMBER(16,2))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_6||' IS '''||V_COMMENT_TABLE_6||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_6||'... Creada');
	END IF;
	
					-- Comprobar si existe la columna ECO_PRECIO_OPCION_COMPRA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_7||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_7||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_7||' NUMBER(16,2))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_7||' IS '''||V_COMMENT_TABLE_7||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_7||'... Creada');
	END IF;
	
						-- Comprobar si existe la columna ECO_CONDICIONES_OPCION_COMPRA.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_8||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_8||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_8||' VARCHAR2(256 CHAR))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_8||' IS '''||V_COMMENT_TABLE_8||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_8||'... Creada');
	END IF;
	
	-- Comprobar si existe la columna ECO_CONFLICTO_INTERESES.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_9||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_9||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_9||' NUMBER(1,0))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_9||' IS '''||V_COMMENT_TABLE_9||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_9||'... Creada');
	END IF;
	
	-- Comprobar si existe la columna ECO_RIESGO_REPUTACIONAL.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_10||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_10||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_10||' NUMBER(1,0))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_10||' IS '''||V_COMMENT_TABLE_10||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_10||'... Creada');
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