--/*
--##########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20191004
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7820
--## PRODUCTO=No
--## Finalidad: DDL Creación de la tabla ACT_GCP_GESTION_CCPP
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLE_NAME VARCHAR2(1024 CHAR) := 'ACT_GCP_GESTION_CCPP'; --Vble. contenedora de
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN


    DBMS_OUTPUT.PUT_LINE('******** '|| V_TABLE_NAME ||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'|| V_TABLE_NAME ||'... Comprobaciones previas'); 
  
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''|| V_TABLE_NAME ||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'|| V_TABLE_NAME ||'... La tabla ya existe');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'|| V_TABLE_NAME ||' (
        GCP_ID                        NUMBER(16,0)            NOT NULL, 
				CPR_ID                        NUMBER(16,0)            NOT NULL,
        DD_ELO_ID                     NUMBER(16,0)            ,
        DD_SEG_ID                     NUMBER(16,0)            ,
        USU_ID                        NUMBER(16,0)            NOT NULL,

        GCP_FECHA_INI                 DATE                    NOT NULL,
        GCP_FECHA_FIN                 DATE                    , 
        
				VERSION                       NUMBER(*,0)             DEFAULT 0 NOT NULL, 
				USUARIOCREAR                  VARCHAR2(50 CHAR)       NOT NULL, 
				FECHACREAR                    TIMESTAMP (6)           NOT NULL, 
				USUARIOMODIFICAR              VARCHAR2(50 CHAR)       , 
				FECHAMODIFICAR                TIMESTAMP (6)           , 
				USUARIOBORRAR                 VARCHAR2(50 CHAR)       ,   
				FECHABORRAR                   TIMESTAMP (6)           , 
				BORRADO                       NUMBER(1,0)             DEFAULT 0 NOT NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Tabla creada');
		
			 V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'|| V_TABLE_NAME ||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la secuencia no hacemos nada
 IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('la secuencia ya existe');
      	ELSE
		
  		execute immediate 'CREATE SEQUENCE '|| V_ESQUEMA ||'.S_'|| V_TABLE_NAME ||' MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'|| V_TABLE_NAME ||'... Secuencia creada correctamente.');  	
  		  		
    END IF;

    -- Creamos constraints
    V_MSQL :='ALTER TABLE '|| V_ESQUEMA || '.'|| V_TABLE_NAME ||' ADD CONSTRAINT PK_'|| V_TABLE_NAME ||' PRIMARY KEY (GCP_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Constraint PK creado');

    V_MSQL :='ALTER TABLE '|| V_ESQUEMA || '.'|| V_TABLE_NAME ||' ADD CONSTRAINT FK_GCP_ACT_CPR_COM_PROPIETARIOS FOREIGN KEY (CPR_ID) REFERENCES '|| V_ESQUEMA ||'.ACT_CPR_COM_PROPIETARIOS (CPR_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Constraint FK creado');

    V_MSQL :='ALTER TABLE '|| V_ESQUEMA || '.'|| V_TABLE_NAME ||' ADD CONSTRAINT FK_GCP_DD_ELO_ESTADO_LOCALIZACION FOREIGN KEY (DD_ELO_ID) REFERENCES '|| V_ESQUEMA ||'.DD_ELO_ESTADO_LOCALIZACION (DD_ELO_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Constraint FK creado');

    V_MSQL :='ALTER TABLE '|| V_ESQUEMA || '.'|| V_TABLE_NAME ||' ADD CONSTRAINT FK_GCP_DD_SEG_SUBESTADO_GESTION FOREIGN KEY (DD_SEG_ID) REFERENCES '|| V_ESQUEMA ||'.DD_SEG_SUBESTADO_GESTION (DD_SEG_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Constraint FK creado');

    V_MSQL :='ALTER TABLE '|| V_ESQUEMA || '.'|| V_TABLE_NAME ||' ADD CONSTRAINT FK_GCP_USU_USUARIOS FOREIGN KEY (USU_ID) REFERENCES '|| V_ESQUEMA_M ||'.USU_USUARIOS (USU_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Constraint FK creado');


-- Creamos comentarios
V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLE_NAME||' IS ''Tabla de documentos adjuntos de plusvalias.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.GCP_ID IS ''Código identificador único de la gestión del CCPP.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna GCP_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.CPR_ID IS ''Codigo identificador de la comunidad de propietarios.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CPR_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.DD_ELO_ID IS ''Codigo identificador del estado de la localización.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_ELO_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.DD_SEG_ID IS ''Codigo identificador del subestado de la gestión.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_SEG_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.USU_ID IS ''Codigo identificador del usuario.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna TIT_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.GCP_FECHA_INI IS ''Fecha de inicio de la gestión del CCPP.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna GCP_FECHA_INI creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.GCP_FECHA_FIN IS ''Fecha de finalización de la gestión del CCPP.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna GCP_FECHA_FIN creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.VERSION IS ''Indica la versión del registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

V_MSQL :=  'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.BORRADO IS ''Indicador de borrado''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');

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
