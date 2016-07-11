--/*
--##########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Modificar el nombre de la columna TBJ_ID a APR_ID y añadir la columna TBJ_ID en la tabla APR_AUX_ACT_TBJ_TRABAJO.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar que almacena las peticiones de trabajo que llegan del proceso ETL.'; -- Vble. para los comentarios de las tablas

BEGIN
	
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
  
  	-- Comprobamos si existe la columna APR_ID
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''APR_ID'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APR_ID... Ya existe');
	ELSE
    -- Eliminamos la PK e índice correspondientes a TBJ_ID
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a eliminar la PK y su correspondiente índice de '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_ID');    
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP PRIMARY KEY DROP INDEX';
    DBMS_OUTPUT.PUT_LINE('[INFO] PK e índice de '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_ID... Eliminados');          
    
    -- Creamos el campo APR_ID
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a crear el campo '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APR_ID');  
    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (APR_ID NUMBER(16,0) NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APR_ID... Creado');
    
    -- Creamos indice	de APR_ID
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a crear el índice '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK (APR_ID)');  
    V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(APR_ID) TABLESPACE '||V_TABLESPACE_IDX;			
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK (APR_ID)... Indice creado.');    
    
    -- Creamos primary key de APR_ID
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a crear la PK '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK (APR_ID)');  
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (APR_ID) USING INDEX)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK (APR_ID)... PK creada.');
	END IF;  
  
  -- Comprobamos si la columna TBJ_ID es nullable
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''TBJ_ID'' and DATA_TYPE = ''NUMBER'' and NULLABLE = ''Y'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_ID... Existe como NULLABLE. No hace falta hacer nada.');		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_ID... Existe como NOT NULLABLE. Lo pasamos a NULLABLE.');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY (TBJ_ID NUMBER(16,0) NULL)';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_ID... Cambiado a NULLABLE.');
	END IF;
  
  -- Comprobamos si existe la columna TBJ_NUM_TRABAJO
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''TBJ_NUM_TRABAJO'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_NUM_TRABAJO... Ya existe');
	ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a crear el campo '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_NUM_TRABAJO');  
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (TBJ_NUM_TRABAJO NUMBER(16,0) NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.TBJ_NUM_TRABAJO... Creado');
	END IF; 
  	 
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
