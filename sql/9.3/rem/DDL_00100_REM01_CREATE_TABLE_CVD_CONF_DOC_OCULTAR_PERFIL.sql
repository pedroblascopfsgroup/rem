--/*
--##########################################
--## AUTOR=Carlos Augusto
--## FECHA_CREACION=20210210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13072
--## PRODUCTO=NO
--## Finalidad: Creación diccionario CVD_CONF_DOC_OCULTAR_PERFIL
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'CVD_CONF_DOC_OCULTAR_PERFIL'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_TPG_TPO_DOC_GASTO_ASOC *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TPG_TPO_DOC_GASTO_ASOC
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la tabla se crea
    IF V_NUM_TABLAS = 1 THEN 
                		    
          -- Verificar si la tabla ya existe
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                    CVD_ID                     NUMBER(16,0)              NOT NULL
				  , PEF_ID                         NUMBER(16,0)              NOT NULL
                  , DD_TDO_ID                      NUMBER(16,0)              NOT NULL
				  , VERSION                        NUMBER(1,0)               DEFAULT 0
				  , USUARIOCREAR                   VARCHAR2(50 CHAR) 
				  , FECHACREAR                     TIMESTAMP(6)              DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR               VARCHAR2(50 CHAR) 
				  , FECHAMODIFICAR                 TIMESTAMP(6)
				  , USUARIOBORRAR                  VARCHAR2(50 CHAR)
				  , FECHABORRAR                    TIMESTAMP(6)
				  , BORRADO                        NUMBER(1,0)               DEFAULT 0
                  , CONSTRAINT PK_CVD_ID         PRIMARY KEY (CVD_ID)
                  , CONSTRAINT FK_PEF_ID        FOREIGN KEY (PEF_ID) REFERENCES PEF_PERFILES(PEF_ID )
                  , CONSTRAINT FK_DD_TDO_ID        FOREIGN KEY (DD_TDO_ID) REFERENCES DD_TDO_TIPO_DOC_ENTIDAD(DD_TDO_ID)
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');
		
		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
		 IF V_NUM_TABLAS = 1 THEN 
	    	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
			EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		END IF;
				
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		    EXECUTE IMMEDIATE V_MSQL;		
		    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||' creada');
 
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL IS ''Tabla de Configuracion Ocultar Perfil Documento''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.CVD_ID IS ''PK Identificador único de Configuracion Ocultar Perfil Documento''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.PEF_ID IS ''FK a PEF_PERFILES''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.DD_TDO_ID IS ''FK a DD_TDO_TIPO_DOC_ENTIDAD''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.VERSION IS ''Indica la versión del registro''';  
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CVD_CONF_DOC_OCULTAR_PERFIL.BORRADO IS ''Indicador de borrado''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.CVD_CONF_DOC_OCULTAR_PERFIL... OK');
   

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
