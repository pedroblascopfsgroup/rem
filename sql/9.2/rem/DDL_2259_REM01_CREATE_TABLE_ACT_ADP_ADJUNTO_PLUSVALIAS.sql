--/*
--##########################################
--## AUTOR=JULIAN DOLZ
--## FECHA_CREACION=20190820
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7360
--## PRODUCTO=No
--## Finalidad: DDL Creación de la tabla ACT_ADP_ADJUNTO_PLUSVALIAS
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
    V_TABLE_NAME VARCHAR2(1024 CHAR) := 'ACT_ADP_ADJUNTO_PLUSVALIAS'; --Vble. contenedora de
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
          ADP_ID NUMBER(16,0) NOT NULL ENABLE, 
          PLS_ID NUMBER(16,0) NOT NULL ENABLE,
          DD_TDU_ID NUMBER(16,0) NOT NULL ENABLE,
          ADJ_ID NUMBER(16,0),
          ADP_NOMBRE VARCHAR2(255 CHAR),
          ADP_CONTENT_TYPE VARCHAR2(100 CHAR),
          ADP_LENGTH NUMBER(16,0),
          ADP_DESCRIPCION VARCHAR2(1024 CHAR), 
          ADP_FECHA_DOCUMENTO DATE, 
          VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
          USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
          FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
          USUARIOMODIFICAR VARCHAR2(10 CHAR), 
          FECHAMODIFICAR TIMESTAMP (6), 
          USUARIOBORRAR VARCHAR2(10 CHAR), 
          FECHABORRAR TIMESTAMP (6), 
          BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
          ADP_ID_DOCUMENTO_REST NUMBER(16,0),
            CONSTRAINT PK_'|| V_TABLE_NAME ||' PRIMARY KEY (ADP_ID),
            CONSTRAINT FK_ACT_PLS_PLUSVALIA FOREIGN KEY (PLS_ID) REFERENCES '|| V_ESQUEMA ||'.ACT_PLS_PLUSVALIA,
            CONSTRAINT FK_DD_TDU_TIPO_DOC_PLUSVALIAS FOREIGN KEY (DD_TDU_ID) REFERENCES '|| V_ESQUEMA ||'.DD_TDU_TIPO_DOC_PLUSVALIAS,
            CONSTRAINT FK_ADJ_ADJUNTO FOREIGN KEY (ADJ_ID) REFERENCES '|| V_ESQUEMA ||'.ADJ_ADJUNTOS
                )';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'|| V_TABLE_NAME ||'... Tabla creada');
    END IF;
		
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

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_ID IS ''Código identificador único del documento adjunto al activo.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.DD_TDU_ID IS ''Código identificador del tipo de documento.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TDU_ID creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.PLS_ID IS ''Código identificador de la plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna PLS_ID creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADJ_ID IS ''Código identificador del documento adjunto.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADJ_ID creado.');	

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_NOMBRE IS ''Nombre del documento adjunto plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_NOMBRE creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_CONTENT_TYPE IS ''Tipo del documento adjunto plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_CONTENT_TYPE creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_LENGTH IS ''Tamaño del documento adjunto plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_LENGTH creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_DESCRIPCION IS ''Descripción del documento adjunto plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_DESCRIPCION creado.');

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_FECHA_DOCUMENTO IS ''Fecha del documento adjunto plusvalia.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_FECHA_DOCUMENTO creado.');

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

V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLE_NAME||'.ADP_ID_DOCUMENTO_REST IS ''Identificador de la llamada al gestor documental.''';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ADP_ID_DOCUMENTO_REST creado.');

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
