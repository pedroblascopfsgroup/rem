--/*
--##########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20190901
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7441
--## PRODUCTO=No
--## Finalidad: DDL Creación de la tabla ACT_AHT_HIST_TRAM_TITULO
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
    V_TABLE_NAME VARCHAR2(1024 CHAR) := 'ACT_AHT_HIST_TRAM_TITULO'; --Vble. contenedora de
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
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLE_NAME||'';   
    END IF;  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'|| V_TABLE_NAME ||' (
        AHT_ID                        NUMBER(16,0)            NOT NULL ENABLE, 
				TIT_ID                        NUMBER(16,0)            NOT NULL ENABLE,
        AHT_FECHA_PRES_REGISTRO       DATE                    NOT NULL ENABLE,
        AHT_FECHA_CALIFICACION        DATE                    , 
        AHT_FECHA_INSCRIPCION         DATE                    ,
        DD_ESP_ID                     NUMBER(16,0)            NOT NULL ENABLE,
        AHT_OBSERVACIONES             VARCHAR2(400 CHAR)      ,
				VERSION                       NUMBER(*,0)             DEFAULT 0 NOT NULL ENABLE, 
				USUARIOCREAR                  VARCHAR2(10 CHAR)       NOT NULL ENABLE, 
				FECHACREAR                    TIMESTAMP (6)           NOT NULL ENABLE, 
				USUARIOMODIFICAR              VARCHAR2(10 CHAR)       , 
				FECHAMODIFICAR                TIMESTAMP (6)           , 
				USUARIOBORRAR                 VARCHAR2(10 CHAR)       ,   
				FECHABORRAR                   TIMESTAMP (6)           , 
				BORRADO                       NUMBER(1,0)             DEFAULT 0 NOT NULL ENABLE,
  				CONSTRAINT PK_'|| V_TABLE_NAME ||' PRIMARY KEY (AHT_ID),
          CONSTRAINT FK_ACT_TIT_TITULO FOREIGN KEY (TIT_ID) REFERENCES '|| V_ESQUEMA ||'.ACT_TIT_TITULO,
          CONSTRAINT FK_DD_ESP_ESTADO_PRESENTACION FOREIGN KEY (DD_ESP_ID) REFERENCES '|| V_ESQUEMA ||'.DD_ESP_ESTADO_PRESENTACION
               )';
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
 
-- Creamos comentarios
V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLE_NAME||' IS ''Tabla de documentos adjuntos de plusvalias.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.AHT_ID IS ''Código identificador único del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna AHT_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.TIT_ID IS ''Codigo identificador del titulo del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna TIT_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.AHT_FECHA_PRES_REGISTRO IS ''Fecha de presentación del registro del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna AHT_FECHA_PRES_REGISTRO creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.AHT_FECHA_CALIFICACION IS ''Fecha de calificación del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna AHT_FECHA_CALIFICACION creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.AHT_FECHA_INSCRIPCION IS ''Fecha de inscripión del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna AHT_FECHA_INSCRIPCION creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.DD_ESP_ID IS ''Codigo del estado de presentación del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_ESP_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.AHT_OBSERVACIONES IS ''Observaciones del histórico de tramitación de titulo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna AHT_OBSERVACIONES creado.');

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
