--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9964
--## PRODUCTO=NO
--## Finalidad: Creación diccionario H_OEB_OFR_EXCLUSION_BULK
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
	V_SQL_VALOR VARCHAR2(2400 CHAR);

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'H_OEB_OFR_EXCLUSION_BULK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla histórica de exclusión Bulk Advisory Note'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN

		V_SQL := 'SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02''';
		EXECUTE IMMEDIATE V_SQL INTO V_SQL_VALOR;
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] CREAMOS LA TABLA' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
			OEB_ID	 	          		NUMBER(16)                  NOT NULL,
			OFR_ID	        			NUMBER(16)			        NOT NULL,
			OEB_EXCLUSION_BULK			NUMBER(16)			        DEFAULT '|| V_SQL_VALOR ||' NOT NULL,
			USU_ID	        			NUMBER(16),
			OEB_FECHA_INI				TIMESTAMP (6) 		    	DEFAULT current_timestamp NOT NULL ENABLE,
			OEB_FECHA_FIN				TIMESTAMP (6),
			VERSION 					NUMBER(38,0) 		    	DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 				VARCHAR2(50 CHAR) 	    	NOT NULL ENABLE, 
			FECHACREAR 					TIMESTAMP (6) 		    	NOT NULL ENABLE, 
			USUARIOMODIFICAR 			VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 				TIMESTAMP (6), 
			USUARIOBORRAR 				VARCHAR2(50 CHAR), 
			FECHABORRAR 				TIMESTAMP (6), 
			BORRADO 					NUMBER(1,0) 		    	DEFAULT 0 NOT NULL ENABLE
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');


		-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(OEB_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');

		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (OEB_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(*) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 0 THEN
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE LA SECUENCIA' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		END IF;

			
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla configuración envio correo report Bulk Advisory Note''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');		

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OEB_ID IS ''Identificador único ''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OEB_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OFR_ID IS ''Relación con Tipo de Bulk AN''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OFR_ID creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OEB_EXCLUSION_BULK IS ''FK diccionario DD_SIN_SINO''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OEB_EXCLUSION_BULK creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USU_ID IS ''FK tabla USU_USUARIOS''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USU_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OEB_FECHA_INI IS ''Fecha de inicio de registro''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OEB_FECHA_INI creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OEB_FECHA_FIN IS ''Fecha de fin de registro''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OEB_FECHA_FIN creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');

		-- Verificar si la tabla ya existe
		V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_OEB_OFR''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_OEB_OFR FOREIGN KEY (OFR_ID) REFERENCES '||V_ESQUEMA||'.OFR_OFERTAS (OFR_ID)';
				
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA FK_OEB_OFR');
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE FK_OEB_OFR');
		END IF;

		-- Verificar si la tabla ya existe
		V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_OEB_EXCLUSION_BULK''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_OEB_EXCLUSION_BULK FOREIGN KEY (OEB_EXCLUSION_BULK) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID)';
				
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA FK_OEB_EXCLUSION_BULK');
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE FK_OEB_EXCLUSION_BULK');
		END IF;

		-- Verificar si la tabla ya existe
		V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_OFR_FEC_FIN_BORRADO''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT UK_OFR_FEC_FIN_BORRADO UNIQUE (OFR_ID,OEB_FECHA_FIN,BORRADO)';
				
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDA UK_OFR_FEC_FIN_BORRADO');
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE UK_OFR_FEC_FIN_BORRADO');
		END IF;
		
	END IF; 

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

EXIT;
