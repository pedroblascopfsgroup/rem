--/*
--##########################################
--## AUTOR=Javier Urbán 
--## FECHA_CREACION=20201204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12365
--## PRODUCTO=NO
--## Finalidad: Añadir nuevas columnas BBVA_ID_PROCESO_ORIGEN y BBVA_CDPEN en la tabla ACT_BBVA_ACTIVOS Si no existen, si existen, copiaremos los datos en una columna nueva,
--##           borraremos la primera columna, la crearemos con un nuevo tipo y le volcaremos los datos anteriores.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_BBVA_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref
    V_COLUMN_NAME VARCHAR2(50):= 'BBVA_ID_PROCESO_ORIGEN'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_2 VARCHAR2(50):= 'BBVA_CDPEN'; -- Vble. para el nombre de las columnas.
    V_COLUMN_NAME_3 VARCHAR2(50):= 'BBVA_ID_PROCESO_ORIGEN_COPIA';
    V_COLUMN_NAME_4 VARCHAR2(50):= 'BBVA_CDPEN_COPIA';
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Identificador del proceso de origen.'; -- Vble. para los comentarios de las tablas
    V_COMMENT_TABLE_2 VARCHAR2(500 CHAR):= 'Identificador del codigo PEN.'; -- Vble. para los comentarios de las tablas
    
BEGIN
	-- Comprobar si existe la columna BBVA_ID_PROCESO_ORIGEN.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Ya existe. Se modifica.');
        -- CREAR NUEVA COLUMNA
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_3||' VARCHAR2(20 CHAR))';
        DBMS_OUTPUT.PUT_LINE('1');
        -- COPIAR VIEJA COLUMNA A NUEVA COLUMNA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME_3||' = '||V_COLUMN_NAME||'' ;
        DBMS_OUTPUT.PUT_LINE('2');
        -- VACIAR COLUMNA VIEJA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME||' = NULL' ;
        DBMS_OUTPUT.PUT_LINE('3');
        -- CAMBIARLE EL TIPO
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_COLUMN_NAME||' VARCHAR2(20 CHAR))';
        DBMS_OUTPUT.PUT_LINE('4');
        -- RELLENAR LOS DATOS DE LA COLUMNA VIEJA CON LA COLUMNA NUEVA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME||' = '||V_COLUMN_NAME_3||'' ;
        DBMS_OUTPUT.PUT_LINE('5');
        -- ELIMINAR COLUMNA NUEVA
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_COLUMN_NAME_3||'';
        DBMS_OUTPUT.PUT_LINE('6');

		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||' IS '''||V_COMMENT_TABLE||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Modificada');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME||' VARCHAR2(20 CHAR))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||' IS '''||V_COMMENT_TABLE||'''';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Creada');
	END IF;

    -- Comprobar si existe la columna BBVA_CDPEN.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME_2||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Ya existe. Se modifica.');
        -- CREAR NUEVA COLUMNA
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_4||' VARCHAR2(20 CHAR))';
        -- COPIAR VIEJA COLUMNA A NUEVA COLUMNA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME_4||' = '||V_COLUMN_NAME_2||'' ;
        -- VACIAR COLUMNA VIEJA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME_2||' = NULL' ;
        -- CAMBIARLE EL TIPO
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY ('||V_COLUMN_NAME_2||' VARCHAR2(20 CHAR))';
        -- RELLENAR LOS DATOS DE LA COLUMNA VIEJA CON LA COLUMNA NUEVA
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_COLUMN_NAME_2||' = '||V_COLUMN_NAME_4||'' ;
        -- ELIMINAR COLUMNA NUEVA
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP COLUMN '||V_COLUMN_NAME_4||'';

        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||' IS '''||V_COMMENT_TABLE_2||'''';
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||'... Modificada');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME_2||' VARCHAR2(20 CHAR))';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME_2||' IS '''||V_COMMENT_TABLE_2||'''';
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
