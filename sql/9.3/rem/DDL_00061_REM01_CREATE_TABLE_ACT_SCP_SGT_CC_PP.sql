--/*
--##########################################
--## AUTOR=Jonathan Ovalle
--## FECHA_CREACION=20200715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10602
--## PRODUCTO=NO
--## Finalidad: Creación diccionario ACT_SCP_SGT_CC_PP
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_SCP_SGT_CC_PP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla que tendrá las relaciones entre un subtipo de gasto con uno o varios subtipos de trabajo.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
	ELSE
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
			SCP_ID           		     NUMBER(16) NOT NULL,
			SGT_ID             		     NUMBER(16),
			CCC_CTAS_ID   		         NUMBER(16),
			CPP_PTDAS_ID             	 NUMBER(16),
			SGT_PRINCIPAL             	 NUMBER(1,0)                DEFAULT 0,
			VERSION 					 NUMBER(38,0) 		    	DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 				 VARCHAR2(50 CHAR) 	    	NOT NULL ENABLE, 
			FECHACREAR 					 TIMESTAMP (6) 		    	NOT NULL ENABLE, 
			USUARIOMODIFICAR 			 VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 				 TIMESTAMP (6), 
			USUARIOBORRAR 				 VARCHAR2(50 CHAR), 
			FECHABORRAR 				 TIMESTAMP (6), 
			BORRADO 					 NUMBER(1,0) 		    	DEFAULT 0 NOT NULL ENABLE
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
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_ACT_SCP_SGT_CC_PP ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(SCP_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_ACT_SCP_SGT_CC_PP... Indice creado.');
		
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT PK_ACT_SCP_SGT_CC_PP PRIMARY KEY (SCP_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.PK_ACT_SCP_SGT_CC_PP... PK creada.');

		-- Creamos FK constraint
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_SCP_SGT_ID FOREIGN KEY (SGT_ID) REFERENCES '||V_ESQUEMA||'.ACT_SGT_SUBTIPO_GPV_TBJ(SGT_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_SCP_SGt_ID... FK creada.');

		-- Creamos FK constraint
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_SCP_CCC_CTAS_ID FOREIGN KEY (CCC_CTAS_ID) REFERENCES '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES(CCC_CTAS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_SCP_CCC_CTAS_ID... FK creada.');

		-- Creamos FK constraint
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_SCP_CPP_PTDAS_ID FOREIGN KEY (CPP_PTDAS_ID) REFERENCES '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP(CPP_PTDAS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_SCP_CPP_PTDAS_ID... FK creada.');

		
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');		

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.SCP_ID IS ''Identificador único''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna SCP_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.SGT_ID IS ''Relaciona con la tabla ACT_SGT_SUBTIPO_GPV_TBJ''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna SGT_ID IS creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CCC_CTAS_ID IS ''Campo para mostarar la configuracion de cuentas contables''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CCC_CTAS_ID IS creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CPP_PTDAS_ID IS ''Campo que relaciona con  ACT_CONFIG_PTDAS_PREP''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CPP_PTDAS_ID creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.SGT_PRINCIPAL IS ''Campo de si o no para subtipología de trabajo principal''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna SGT_PRINCIPAL creado.');	


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
		
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe.');  
	ELSE
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
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
