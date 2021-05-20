--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13938
--## PRODUCTO=NO
--## Finalidad: Creación diccionario ACT_ACTIVO_CAIXA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla en la que se almacenarán las configuraciones de los activos de la caixa.'; -- Vble. para los comentarios de las tablas

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PURGE';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;

	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		CBX_ID										NUMBER(16,0)				NOT NULL,
		ACT_ID										NUMBER(16,0)				NOT NULL,
		DD_ECA_ID									NUMBER(16,0),
		DD_ECV_ID									NUMBER(16,0),
		DD_EAT_ID									NUMBER(16,0),
		VERSION 									NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 								VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 									TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 							VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 								TIMESTAMP (6), 
		USUARIOBORRAR 								VARCHAR2(50 CHAR), 
		FECHABORRAR 								TIMESTAMP (6), 
		BORRADO 									NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
	)'
	;
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (CBX_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

	-- Creamos foreign keys
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_ACTIVO_CAIXA FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_ACT_ACTIVO_CAIXA... Foreign key creada.');

	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_ECA_ID FOREIGN KEY (DD_ECA_ID) REFERENCES '||V_ESQUEMA||'.DD_ECA_EST_COM_ALQUILER (DD_ECA_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_ECA_ID... Foreign key creada.');

	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_ECV_ID FOREIGN KEY (DD_ECV_ID) REFERENCES '||V_ESQUEMA||'.DD_ECV_EST_COM_VENTA (DD_ECV_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_ECV_ID... Foreign key creada.');

	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_EAT_ID FOREIGN KEY (DD_EAT_ID) REFERENCES '||V_ESQUEMA||'.DD_EAT_EST_TECNICO (DD_EAT_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EAT_ID... Foreign key creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');		

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CBX_ID IS ''Identificador único''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CBX_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID IS ''Identificador único del activo''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ACT_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ECA_ID IS ''Identificador único del estado comercial alquiler del activo''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_ECA_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ECV_ID IS ''Identificador único del estado comercial venta del activo''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_ECV_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_EAT_ID IS ''Identificador único del estado tecnico del activo''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_EAT_ID creado.');

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

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe');
	ELSIF V_NUM_TABLAS = 0 THEN
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
	END IF;

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
