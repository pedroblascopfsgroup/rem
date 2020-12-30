--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10482
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_ASA_AGENDA_SANEAMIENTO
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'ACT_ASA_AGENDA_SANEAMIENTO'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** ACT_ASA_AGENDA_SANEAMIENTO *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_ASA_AGENDA_SANEAMIENTO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si no existe la tabla se crea
    IF V_NUM_TABLAS = 0 THEN 
                		    
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                    ASA_ID                         	NUMBER(16,0)              NOT NULL
				  , ACT_ID					   	   	NUMBER(16,0)              NOT NULL
				  , DD_TAS_ID                  		NUMBER(16,0)              NOT NULL
				  , DD_SAS_ID                  		NUMBER(16,0)              NOT NULL
				  , ASA_OBSERVACIONES             	CLOB
				  , ASA_FECHA_ALTA       			DATE
				  , VERSION                        	NUMBER(1,0)               DEFAULT 0
				  , USUARIOCREAR                   	VARCHAR2(50 CHAR) 
				  , FECHACREAR                     	TIMESTAMP(6)              DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR               	VARCHAR2(50 CHAR) 
				  , FECHAMODIFICAR                 	TIMESTAMP(6)
				  , USUARIOBORRAR                  	VARCHAR2(50 CHAR)
				  , FECHABORRAR                    	TIMESTAMP(6)
				  , BORRADO                        	NUMBER(1,0)               DEFAULT 0
                  , CONSTRAINT PK_ASA_ID       	   	PRIMARY KEY (ASA_ID)
				  , CONSTRAINT FK_ASA_ACT_ID       	FOREIGN KEY (ACT_ID) REFERENCES ACT_ACTIVO(ACT_ID)
				  , CONSTRAINT FK_ASA_DD_TAS_ID     FOREIGN KEY (DD_TAS_ID) REFERENCES DD_TAS_TIPO_AGENDA_SAN(DD_TAS_ID)
				  , CONSTRAINT FK_ASA_DD_SAS_ID     FOREIGN KEY (DD_SAS_ID) REFERENCES DD_SAS_SUBTIPO_AGENDA_SAN(DD_SAS_ID)
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
             
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO IS ''DICCIONARIO TIPO AGENDA SANEAMIENTO''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.ASA_ID IS ''Id agenda saneamiento''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.ACT_ID IS ''FK a ACT_ACTIVO''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.DD_TAS_ID IS ''FK a DD_TAS_TIPO_AGENDA_SAN''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.DD_SAS_ID IS ''FK a DD_SAS_SUBTIPO_AGENDA_SAN''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.ASA_OBSERVACIONES IS ''Observaciones agenda saneamiento''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.ASA_FECHA_ALTA IS ''Fecha alta saneamiento''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.VERSION IS ''Indica la versión del registro''';  
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ACT_ASA_AGENDA_SANEAMIENTO.BORRADO IS ''Indicador de borrado''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.ACT_ASA_AGENDA_SANEAMIENTO... OK');
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
