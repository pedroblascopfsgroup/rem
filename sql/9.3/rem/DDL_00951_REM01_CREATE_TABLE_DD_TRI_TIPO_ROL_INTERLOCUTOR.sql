--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210509
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14267
--## PRODUCTO=NO
--##
--## Finalidad: DDL Creación de la tabla DD_TRI_TIPO_ROL_INTERLOCUTOR
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'DD_TRI_TIPO_ROL_INTERLOCUTOR'; -- Vble. con el nombre de la tabla.
    V_CODIGO_TABLA VARCHAR2(3 CHAR):= 'TRI';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_TRI_TIPO_ROL_INTERLOCUTOR *******º
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TRI_TIPO_ROL_INTERLOCUTOR
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE');
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
               (DD_'||V_CODIGO_TABLA||'_ID NUMBER (16,0) 
				  , DD_'||V_CODIGO_TABLA||'_CODIGO VARCHAR2(20 CHAR) 
				  , DD_'||V_CODIGO_TABLA||'_DESCRIPCION VARCHAR2(150 CHAR) 
				  , DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA VARCHAR2(250 CHAR) 
				  , VERSION NUMBER(1,0) DEFAULT 0
				  , USUARIOCREAR VARCHAR2 (50 CHAR) 
				  , FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				  , FECHAMODIFICAR TIMESTAMP(6)
				  , USUARIOBORRAR VARCHAR2 (50 CHAR)
				  , FECHABORRAR TIMESTAMP(6)
				  , BORRADO NUMBER(1,0) DEFAULT 0
				  , CONSTRAINT PK_DD_'||V_CODIGO_TABLA||'_ID PRIMARY KEY(DD_'||V_CODIGO_TABLA||'_ID)
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		
	
		-- execute immediate 'grant select, insert, delete, update, REFERENCES(DD_TDG_ID) on ' || V_ESQUEMA || '.'||V_TABLA||' to '||V_ESQUEMA||'';
		
    END IF;
    
    -- Creamos la secuencia
    -- Comprobamos si existe la secuencia   
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la secuencia no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia YA EXISTE'); 
    ELSE
    	execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_'||V_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada correctamente.');
	END IF;
	
    -- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla para gestionar los tipos de documentos de las agrupaciones.''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado sobre la tabla.');

	-- Comentarios sobre las columnas
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_'||V_CODIGO_TABLA||'_ID IS ''Código identificador único.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_'||V_CODIGO_TABLA||'_CODIGO IS ''Código único.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_'||V_CODIGO_TABLA||'_DESCRIPCION IS ''Descripción breve.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_'||V_CODIGO_TABLA||'_DESCRIPCION_LARGA IS ''Descripción larga.''';
	


	-- Comentarios auditoría
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Versión del registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados sobre las columnas de la tabla.');
    
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
