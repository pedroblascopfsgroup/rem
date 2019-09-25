--/*
--##########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20190920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7645
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla DD_TDJ_TIPO_DOC_JUNTAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadir campos nuevos para vincular una junta con un activo
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_TDJ_TIPO_DOC_JUNTAS';  -- Tabla a modificar   
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'DD_TDJ_TIPO_DOC_JUNTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Diccionario para gestionar el tipo doc juntas'; -- Vble. para los comentarios de las tablas

    BEGIN

    -- ******** DD_TDJ_TIPO_DOC_JUNTAS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TDJ_TIPO_DOC_JUNTAS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
               (DD_TDJ_ID NUMBER (16,0) NOT NULL ENABLE
				  , DD_TDJ_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE
				  , DD_TDJ_DESCRIPCION VARCHAR2(100 CHAR) NOT NULL ENABLE
				  , DD_TDJ_DESCRIPCION_LARGA VARCHAR2(250 CHAR) NOT NULL ENABLE
				  , VERSION NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE
				  , USUARIOCREAR VARCHAR2 (50 CHAR) NOT NULL ENABLE
				  , FECHACREAR TIMESTAMP(6) NOT NULL ENABLE
				  , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				  , FECHAMODIFICAR TIMESTAMP(6)
				  , USUARIOBORRAR VARCHAR2 (50 CHAR)
				  , FECHABORRAR TIMESTAMP(6)
				  , BORRADO NUMBER(1,0) DEFAULT 0
				  , DD_TDJ_MATRICULA_GD VARCHAR2(20 CHAR)
				  , DD_TDJ_VINCULABLE NUMBER(1,0)
				  , DD_TDJ_TPD_ID NUMBER(16,0)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');

		--Comprobamos si existen PK de esa tabla
    	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;
    	-- Si existe la PK
    	IF V_NUM_TABLAS = 1 THEN 
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... ya existe claves primaria');	
    		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (DD_TDJ_ID)';
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
		END IF;

		-- Creamos foreign key JCM_ID
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_TDJ_TIPO_JUNTA_TPD_TIPO_DOC FOREIGN KEY (DD_TDJ_TPD_ID) REFERENCES '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO (DD_TPD_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_TDJ_TIPO_JUNTA_TPD_TIPO_DOC... Foreign key creada.');


		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_ID IS ''ID único del registro del diccionario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_CODIGO IS ''Código único del registro del diccionario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_DESCRIPCION IS ''Descripción del registro del diccionario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_DESCRIPCION_LARGA IS ''Descripción larga del registro del diccionario''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_MATRICULA_GD IS ''ID de matricula''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_VINCULABLE IS ''Si se vincula a los activos o no''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDJ_TPD_ID IS ''Campo que relaciona los tipos de documentos vinculables''';

		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Comentarios añadidos corerctamente.');
		
    END IF;


    -- Comprobamos si existe la secuencia
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
			
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||' creada');

		END IF;
    
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
