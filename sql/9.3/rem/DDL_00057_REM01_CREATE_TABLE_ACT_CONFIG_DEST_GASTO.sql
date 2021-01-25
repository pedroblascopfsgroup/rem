--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12525
--## PRODUCTO=NO
--## Finalidad: Creación diccionario ACT_CONFIG_DEST_GASTO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_DEST_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla en la que se almacenarán las configuraciones de los destinos de los gastos.'; -- Vble. para los comentarios de las tablas

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
	    "DGA_ID"                		NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DGA_FECHA_INICIO"			TIMESTAMP(6)
	    	NOT NULL ENABLE
	    , "DGA_FECHA_FIN"				TIMESTAMP(6)
	    	NOT NULL ENABLE
	    , "DD_STR_ID"                   NUMBER(16, 0)
	    , "DD_CRA_ID"                   NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DD_SCR_ID"                   NUMBER(16, 0)
	    , "DD_IRE_ID"                   NUMBER(16, 0)
	    	NOT NULL ENABLE
	    , "PRO_ID"                      NUMBER(16, 0)	
	    , "PVE_ID"                      NUMBER(16, 0)
	    , "DGA_ARRENDAMIENTO_SOCIAL"    NUMBER(1, 0)
	    , "DD_DEG_ID"            		NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "VERSION"                     NUMBER(38, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "USUARIOCREAR"                VARCHAR2(50 CHAR)
	        NOT NULL ENABLE
	    , "FECHACREAR"                  TIMESTAMP(6) DEFAULT SYSDATE
	        NOT NULL ENABLE
	    , "USUARIOMODIFICAR"            VARCHAR2(50 CHAR)
	    , "FECHAMODIFICAR"              TIMESTAMP(6)
	    , "USUARIOBORRAR"               VARCHAR2(50 CHAR)
	    , "FECHABORRAR"                 TIMESTAMP(6)
	    , "BORRADO"                     NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , CONSTRAINT "PK_'||V_TEXT_TABLA||'" PRIMARY KEY ("DGA_ID")
	    	ENABLE
	    , CONSTRAINT "UK_'||V_TEXT_TABLA||'" UNIQUE (
	    	"DGA_FECHA_INICIO"
	    	, "DGA_FECHA_FIN"
	    	, "DD_STR_ID"
		    , "DD_CRA_ID"
		    , "DD_SCR_ID"
		    , "DD_IRE_ID"
		    , "PRO_ID"
		    , "PVE_ID"
		    , "DGA_ARRENDAMIENTO_SOCIAL"
		    , "FECHABORRAR"
		    , "BORRADO"
			)
	    	ENABLE
	    , CONSTRAINT "CK_'||V_TEXT_TABLA||'" CHECK ((BORRADO = 0 AND FECHABORRAR IS NULL) OR BORRADO = 1)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_DD_STR_ID" FOREIGN KEY (DD_STR_ID) REFERENCES '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO (DD_STR_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_DD_CRA_ID" FOREIGN KEY (DD_CRA_ID) REFERENCES '||V_ESQUEMA||'.DD_CRA_CARTERA (DD_CRA_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_DD_SCR_ID" FOREIGN KEY (DD_SCR_ID) REFERENCES '||V_ESQUEMA||'.DD_SCR_SUBCARTERA (DD_SCR_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_DD_IRE_ID" FOREIGN KEY (DD_IRE_ID) REFERENCES '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM (DD_IRE_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_PRO_ID" FOREIGN KEY (PRO_ID) REFERENCES '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (PRO_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_PVE_ID" FOREIGN KEY (PVE_ID) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID)
	    	ENABLE
	    , CONSTRAINT "FK_DGA_DD_DEG_ID" FOREIGN KEY (DD_DEG_ID) REFERENCES '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO (DD_DEG_ID)
	    	ENABLE
	)
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');		

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DGA_ID IS ''Identificador único''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DGA_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_STR_ID IS ''Identificador único del subtipo de trabajo''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_STR_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_CRA_ID IS ''Identificador único de la cartera a la que pertenece la configuración''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_CRA_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SCR_ID IS ''Identificador único de la subcartera a la que pertenece la configuración''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_SCR_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRO_ID IS ''Identificador único del propietario''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna PRO_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_IRE_ID IS ''Identificador único REAM''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_IRE_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PVE_ID IS ''Identificador único del proveedor''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna PVE_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DGA_ARRENDAMIENTO_SOCIAL IS ''Marca si el pagador del gasto es por arrendamiento social''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DGA_ARRENDAMIENTO_SOCIAL creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_DEG_ID IS ''Identificador único del destinatario del gasto''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_DEG_ID creado.');

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
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe.');  
	ELSE
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
