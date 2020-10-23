--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10433
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla DD_MBS_MOTIVO_BAJA_SUM
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'DD_MBS_MOTIVO_BAJA_SUM'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_MBS_MOTIVO_BAJA_SUM *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_MBS_MOTIVO_BAJA_SUM
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si no existe la tabla se crea
    IF V_NUM_TABLAS = 0 THEN 
                		    
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                    DD_MBS_ID                      NUMBER(16,0)              NOT NULL
				  , DD_MBS_CODIGO                  VARCHAR2(20 CHAR)         NOT NULL
				  , DD_MBS_DESCRIPCION             VARCHAR2(100 CHAR)        NOT NULL
				  , DD_MBS_DESCRIPCION_LARGA       VARCHAR2(250 CHAR)        NOT NULL
				  , VERSION                        NUMBER(1,0)               DEFAULT 0
				  , USUARIOCREAR                   VARCHAR2(50 CHAR) 
				  , FECHACREAR                     TIMESTAMP(6)              DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR               VARCHAR2(50 CHAR) 
				  , FECHAMODIFICAR                 TIMESTAMP(6)
				  , USUARIOBORRAR                  VARCHAR2(50 CHAR)
				  , FECHABORRAR                    TIMESTAMP(6)
				  , BORRADO                        NUMBER(1,0)               DEFAULT 0
                  , CONSTRAINT PK_DD_MBS_ID        PRIMARY KEY (DD_MBS_ID)
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');
		
		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 0 THEN
				
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		    EXECUTE IMMEDIATE V_MSQL;		
		    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||' creada');

		END IF;

             
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM IS ''DICCIONARIO MOTIVO BAJA SUMINISTRO''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.DD_MBS_ID IS ''ID único del registro del diccionario''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.DD_MBS_CODIGO IS ''Código único del registro del diccionario''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.DD_MBS_DESCRIPCION IS ''Descripción del registro del diccionario''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.DD_MBS_DESCRIPCION_LARGA IS ''Descripción larga del registro del diccionario''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.VERSION IS ''Indica la versión del registro''';  
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_MBS_MOTIVO_BAJA_SUM.BORRADO IS ''Indicador de borrado''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.DD_MBS_MOTIVO_BAJA_SUM... OK');
    ELSE
        -- Si existe la tabla no se hace nada
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... La Tabla YA EXISTE.');
    END IF;

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
