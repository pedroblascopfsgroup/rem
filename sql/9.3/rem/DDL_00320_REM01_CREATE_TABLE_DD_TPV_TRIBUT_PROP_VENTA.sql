--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14380
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla DD_TPV_TRIBUT_PROP_VENTA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_TPV_TRIBUT_PROP_VENTA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CHARS VARCHAR2(6 CHAR) := 'TPV';
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-14380';
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Diccionario para la Tributación propuesta venta'; -- Vble. para los comentarios de las tablas
    
    
 BEGIN
 
 	-- Comprobación tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe la tabla '||V_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la tabla '||V_TABLA);
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				  DD_'||V_CHARS||'_ID NUMBER(16,0) NOT NULL
				, DD_'||V_CHARS||'_CODIGO VARCHAR2(10 CHAR) NOT NULL
				, DD_'||V_CHARS||'_DESCRIPCION VARCHAR2(100 CHAR) NOT NULL
				, DD_'||V_CHARS||'_DESCRIPCION_LARGA VARCHAR2(250 CHAR) NOT NULL
				, VERSION NUMBER(1,0) DEFAULT 0 NOT NULL
				, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
				, FECHACREAR TIMESTAMP(6) NOT NULL
				, USUARIOMODIFICAR VARCHAR2(50 CHAR)
				, FECHAMODIFICAR TIMESTAMP(6)
				, USUARIOBORRAR VARCHAR2(50 CHAR)
				, FECHABORRAR TIMESTAMP(6)
				, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
				)
			  ';

		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

        	-- Creamos el comentario de las columnas
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPV_ID IS ''Código identificador único''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPV_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPV_CODIGO IS ''Código de tipo tributacion propuesta venta''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPV_CODIGO creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPV_DESCRIPCION IS ''Descripción de tipo tributacion propuesta venta''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPV_DESCRIPCION creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPV_DESCRIPCION_LARGA IS ''Descripción de tipo tributacion propuesta venta''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPV_DESCRIPCION_LARGA creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión del registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
	
	END IF;

	-- Creamos primary key
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la PK');
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DD_TPV_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_PK creada.');

	-- Comprobamos sequence
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la secuencia');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 

	IF V_COUNT = 0 THEN
	 
		-- Creamos sequence	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
	  
	END IF;

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');


    	
	

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
