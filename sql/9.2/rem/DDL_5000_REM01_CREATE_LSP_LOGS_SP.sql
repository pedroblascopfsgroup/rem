--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20180314
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=HREOS-3866
--## PRODUCTO=NO
--## Finalidad: Se crea la tabla diccionario LSP_LOGS_SP y su secuencia.
--## 
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE.
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuración Tablespace de Índices.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'LSP_LOGS_SP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(5 CHAR) := 'LSP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla de trazas para los procesos que utilicen SP'; -- Vble. para los comentarios de las tablas.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN

		-- Crear la tabla.
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
			(
				'||V_TEXT_CHARS||'_ID           			NUMBER(16)                  NOT NULL,
				'||V_TEXT_CHARS||'_FECHA           			TIMESTAMP(6)                NOT NULL,
				'||V_TEXT_CHARS||'_PROCESO				    VARCHAR2(50 CHAR)			NOT NULL,
				'||V_TEXT_CHARS||'_PASO					    VARCHAR2(50 CHAR),
				'||V_TEXT_CHARS||'_COMENTARIO			    VARCHAR2(500 CHAR),
				'||V_TEXT_CHARS||'_NUMFILAS				    NUMBER(16),
				'||V_TEXT_CHARS||'_ERROR				    VARCHAR2(500 CHAR)
			)
			LOGGING 
			NOCOMPRESS 
			NOCACHE
			NOPARALLEL
			NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... Ya existe.'); 
	END IF;

    --Comprobamos si existe el índice en esa tabla
    V_MSQL := '
            SELECT COUNT(1)
              FROM( SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
                      FROM ALL_IND_COLUMNS
                     WHERE table_name = ''''||'''||V_TEXT_TABLA||'''
                       AND index_owner='''' ||'''||V_ESQUEMA||'''
                     GROUP BY index_name
                  ) sqli
               WHERE sqli.columnas = '''||V_TEXT_CHARS||'_ID''
             ';
        
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
		-- Crear índice	.
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'('||V_TEXT_CHARS||'_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice ya existe.');
	END IF;
	
    --Comprobamos si existen PK de esa tabla
    V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
		-- Crear primary key.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY ('||V_TEXT_CHARS||'_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK Ya existe.');
	END IF;

	-- Comprobar si existe la secuencia.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
	
	IF V_NUM_TABLAS = 0 THEN
		-- Crear sequence.
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');	
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe.');  
	END IF; 

	-- Crear comentario.
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_ID IS ''Clave principal con su correspondiente secuencia''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_ID ... Comentario creado.');
        
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_FECHA IS ''Texto libre''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_FECHA ... Comentario creado.');         

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_PROCESO IS ''Proceso ejecutado''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_PROCESO ... Comentario creado.');  

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_PASO IS ''Paso del proceso''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_PASO ... Comentario creado.');  

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_COMENTARIO IS ''Comentario libre''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_COMENTARIO ... Comentario creado.');  
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_NUMFILAS IS ''Número de filas''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_NUMFILAS ... Comentario creado.');  
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_ERROR IS ''Mensaje de error''';      
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_CHARS||'_ERROR ... Comentario creado.');  
            
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
