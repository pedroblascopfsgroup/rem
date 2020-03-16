--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9116
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla DD_TPG_TIPOLOGIAS_PROVISIONES
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
    V_TABLA VARCHAR2(50 CHAR) := 'DD_TPG_TIPOLOGIAS_PROVISIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9116';
    
    
 BEGIN
 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
 
	IF V_COUNT = 0 THEN	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
		EXECUTE IMMEDIATE V_SQL;        
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);
	ELSE    
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la secuencia S_'||V_TABLA);		  
	END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
	END IF; 	
	
	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				DD_TPG_ID NUMBER(16,0) NOT NULL
			, DD_TPG_CODIGO VARCHAR2(50 CHAR) NOT NULL
			, DD_TPG_DESCRIPCION VARCHAR2(100 CHAR)
			, DD_TPG_DESCRIPCION_LARGA VARCHAR2(250 CHAR)
			, DD_TGA_ID NUMBER(16,0)
			, DD_STG_ID NUMBER(16, 0)
			, VERSION NUMBER(1,0) DEFAULT 0 NOT NULL
			, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
			, FECHACREAR TIMESTAMP(6) NOT NULL
			, USUARIOMODIFICAR VARCHAR2(50 CHAR)
			, FECHAMODIFICAR TIMESTAMP(6)
			, USUARIOBORRAR VARCHAR2(50 CHAR)
			, FECHABORRAR TIMESTAMP(6)
			, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
			, CONSTRAINT FK_TPG_ID PRIMARY KEY (DD_TPG_ID)
			)
			';
              
		EXECUTE IMMEDIATE V_SQL; 
        V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD CONSTRAINT FK_DD_TGA_ID FOREIGN KEY (DD_TGA_ID) ' ||
        '  REFERENCES  ' || V_ESQUEMA || '.DD_TGA_TIPOS_GASTO (DD_TGA_ID)';
		EXECUTE IMMEDIATE V_SQL; 
        
        V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD CONSTRAINT FK_DD_STG_ID FOREIGN KEY (DD_STG_ID) ' ||
        '  REFERENCES  ' || V_ESQUEMA || '.DD_STG_SUBTIPOS_GASTO (DD_STG_ID)';
		EXECUTE IMMEDIATE V_SQL; 
        
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPG_ID IS ''Indica el código identificador único del registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPG_CODIGO IS ''Código que admite duplicados.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPG_DESCRIPCION IS ''Descripción corta.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPG_DESCRIPCION_LARGA IS ''Descripción larga.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TGA_ID IS ''ID tipo gasto (no necesariamente único).''';
		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_STG_ID IS ''ID subtipo gasto (no necesariamente único).''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión de la modificación del registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que ha creado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se ha creado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que ha modificado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se ha modificado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que ha borrado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se ha borrado el registro.''';
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indica si hay borrado lógico del registro.''';
		EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.PUT_LINE('[INFO] COMENTARIOS CREADOS');

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
