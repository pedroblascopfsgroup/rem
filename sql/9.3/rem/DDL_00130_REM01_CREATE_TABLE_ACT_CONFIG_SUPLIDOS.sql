--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-10216
--## PRODUCTO=NO
--##
--## Finalidad:            
--## INSTRUCCIONES: 
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_SUPLIDOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	
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
			SUP_ID           				NUMBER(16,0) NOT NULL,
			DD_CRA_ID        				NUMBER(16,0) NOT NULL,
			DD_SCR_ID						NUMBER(16,0),
			DD_TGA_ID                       NUMBER(16,0) NOT NULL,
			DD_STG_ID 						NUMBER(16,0),			
			VERSION 						NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 					VARCHAR2(50 CHAR) NOT NULL ENABLE, 
			FECHACREAR 						TIMESTAMP (6) NOT NULL ENABLE, 
			USUARIOMODIFICAR 				VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 					TIMESTAMP (6), 
			USUARIOBORRAR 					VARCHAR2(50 CHAR), 
			FECHABORRAR 					TIMESTAMP (6), 
			BORRADO 						NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
		)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (SUP_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
		
		--Creamos foreign keys
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_CRA_ID_SUP FOREIGN KEY (DD_CRA_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_CRA_CARTERA (DD_CRA_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_CRA_ID_SUP creada.');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_SCR_ID_SUP FOREIGN KEY (DD_SCR_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA (DD_SCR_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_SCR_ID_SUP creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_TGA_ID_SUP FOREIGN KEY (DD_TGA_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_TGA_TIPOS_GASTO (DD_TGA_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_TGA_ID_SUP creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_STG_ID_SUP FOREIGN KEY (DD_STG_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO (DD_STG_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_STG_ID_SUP creada.');
	
		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		END IF;

		-- Creamos comentarios
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla para configurar en qué gastos se muestran los campos Nº factura principal y Suplidos vinculados.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');		
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.SUP_ID IS ''Código identificador único de la configuración de gastos suplidos.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna SUP_ID creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_CRA_ID IS ''Código identificador único de la cartera del gasto.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_CRA_ID creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SCR_ID IS ''Código identificador único de la subcartera del gasto.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_SCR_ID creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TGA_ID IS ''Código identificador único del tipo de gasto.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TGA_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_STG_ID IS ''Código identificador único del subtipo de gasto.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_STG_ID creado.');

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
		
		COMMIT;
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

EXIT
