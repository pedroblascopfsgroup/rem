--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20170109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1329
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar el bloqueo de expedientes en su formalización.
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_BEX_BLOQ_EXP_FORMALIZAR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el bloqueo de expedientes en su formalización.'; -- Vble. para los comentarios de las tablas


BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');


	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS >= 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se continua.');
	ELSE
		-- Creamos la tabla.
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
				ACT_BEX_ID           				NUMBER(16,0)                NOT NULL,
				DD_ABL_ID          					NUMBER(16,0)                NOT NULL,
				DD_TBL_ID          					NUMBER(16,0)                NOT NULL,
				ACT_BEX_ECO_ID          			NUMBER(16,0)                NOT NULL,
				VERSION 							NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
				USUARIOCREAR 						VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
				FECHACREAR 							TIMESTAMP (6) 				NOT NULL ENABLE, 
				USUARIOMODIFICAR 					VARCHAR2(10 CHAR), 
				FECHAMODIFICAR 						TIMESTAMP (6), 
				USUARIOBORRAR 						VARCHAR2(10 CHAR), 
				FECHABORRAR 						TIMESTAMP (6), 
				BORRADO 							NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Creamos indice.
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ACT_BEX_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');	

		-- Creamos primary key.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (ACT_BEX_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

		-- Creamos comentario de tabla.
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

		-- Creamos comentario de columnas.
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_BEX_ID IS ''ID del bloqueo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ABL_ID IS ''ID del área del bloqueo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TBL_ID IS ''ID del tipo del área del bloqueo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_BEX_ECO_ID IS ''ID del expediente comercial asociado al bloqueo.''';
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentarios en las columnas creados.');

		-- Creamos foreign key DD_ABL_ID.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_BEX_DD_ABL_ID FOREIGN KEY (DD_ABL_ID) REFERENCES '||V_ESQUEMA||'.DD_ABL_AREA_BLOQUEOS (DD_ABL_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_BEX_DD_ABL_ID... Foreign key creada.');

		-- Creamos foreign key DD_TBL_ID.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_BEX_DD_TBL_ID FOREIGN KEY (DD_TBL_ID) REFERENCES '||V_ESQUEMA||'.DD_TBL_TIPO_BLOQUEOS (DD_TBL_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_BEX_DD_TBL_ID... Foreign key creada.');

		-- Creamos foreign key ACT_BEX_EXP_ID.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_BEX_ECO_ID FOREIGN KEY (ACT_BEX_ECO_ID) REFERENCES '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (ECO_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_ACT_BEX_ECO_ID... Foreign key creada.');

	END IF;

	-- Comprobamos si existe la secuencia.
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS >= 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se continua.');  
	ELSE
		-- Creamos secuencia.
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN]');


	COMMIT;


EXCEPTION
     WHEN OTHERS THEN
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