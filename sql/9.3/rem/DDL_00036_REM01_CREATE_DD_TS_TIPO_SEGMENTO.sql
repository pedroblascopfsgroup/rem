--/*
--##########################################
--## AUTOR=Joaquín Bahamonde
--## FECHA_CREACION=20200210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9320
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla DD_TS_TIPO_SEGMENTO
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'DD_TS_TIPO_SEGMENTO'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_TS_TIPO_SEGMENTO *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TS_TIPO_SEGMENTO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existe la tabla no se hace nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... La Tabla YA EXISTE.');    		
	  END IF;
     
    	 --Creamos la tabla
      DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                    DD_TS_ID                      NUMBER(16,0)              GENERATED BY DEFAULT AS IDENTITY
				  , DD_TS_CODIGO                  VARCHAR2(20 CHAR)         NOT NULL
				  , DD_TS_DESCRIPCION             VARCHAR2(100 CHAR)        NOT NULL
				  , DD_TS_DESCRIPCION_LARGA       VARCHAR2(250 CHAR)        NOT NULL
				  , VERSION                       NUMBER(1,0)               DEFAULT 0
				  , USUARIOCREAR                  VARCHAR2(50 CHAR) 
				  , FECHACREAR                    TIMESTAMP(6)              DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
				  , FECHAMODIFICAR                TIMESTAMP(6)
				  , USUARIOBORRAR                 VARCHAR2(50 CHAR)
				  , FECHABORRAR                   TIMESTAMP(6)
				  , BORRADO                       NUMBER(1,0)               DEFAULT 0
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');

        -- Creamos primary key
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P'''
		INTO V_NUM_TABLAS; 
		
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('  [INFO] La PK PK_'||V_TEXT_TABLA||'... Ya existe.');                 
		ELSE    
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (DD_TS_ID))';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
        END IF;
		
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO IS ''DICCIONARIO TIPO SEGMENTO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.DD_TS_ID IS ''ID único del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.DD_TS_CODIGO IS ''Código único del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.DD_TS_DESCRIPCION IS ''Descripción del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.DD_TS_DESCRIPCION_LARGA IS ''Descripción larga del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.VERSION IS ''Indica la versión del registro''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_TS_TIPO_SEGMENTO.BORRADO IS ''Indicador de borrado''';
  
    DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.DD_TS_TIPO_SEGMENTO... OK');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    
    
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
