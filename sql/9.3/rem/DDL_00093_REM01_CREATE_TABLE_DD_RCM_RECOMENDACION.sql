--/*
--##########################################
--## AUTOR=Juan Beltrán	
--## FECHA_CREACION=20200921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8069
--## PRODUCTO=NO
--## FINALIDAD: DDL Creación de la tabla DD_RCM_RECOMENDACION           
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
    V_TABLA VARCHAR2(150 CHAR):= 'DD_RCM_RECOMENDACION'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_RCM_RECOMENDACION *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_RCM_RECOMENDACION
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
               (DD_RCM_ID NUMBER (16,0) NOT NULL
              , DD_RCM_CODIGO VARCHAR2(20 CHAR) NOT NULL
              , DD_RCM_DESCRIPCION VARCHAR2(100 CHAR) NOT NULL
              , DD_RCM_DESCRIPCION_LARGA VARCHAR2(100 CHAR) NOT NULL
              , VERSION NUMBER(1,0) DEFAULT 0
              , USUARIOCREAR VARCHAR2 (50 CHAR) 
              , FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
              , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
              , FECHAMODIFICAR TIMESTAMP(6)
              , USUARIOBORRAR VARCHAR2 (50 CHAR)
              , FECHABORRAR TIMESTAMP(6)
              , BORRADO NUMBER(1,0) DEFAULT 0
              , CONSTRAINT PK_DD_RCM_ID PRIMARY KEY(DD_RCM_ID)
              , CONSTRAINT UK_DD_RCM_CODIGO UNIQUE (DD_RCM_CODIGO)
            )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		-- Creamos la secuencia
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_'||V_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada correctamente.');
		
		-- execute immediate 'grant select, insert, delete, update, REFERENCES(DD_RCM_ID) on ' || V_ESQUEMA || '.'||V_TABLA||' to '||V_ESQUEMA||'';
		
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION IS ''DICCIONARIO RECOMENDACION''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.DD_RCM_ID IS ''ID único del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.DD_RCM_CODIGO IS ''Código único del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.DD_RCM_DESCRIPCION IS ''Descripción del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.DD_RCM_DESCRIPCION_LARGA IS ''Descripción larga del registro del diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.VERSION IS ''Indica la versión del registro''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.DD_RCM_RECOMENDACION.BORRADO IS ''Indicador de borrado''';
  
    DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.DD_RCM_RECOMENDACION... OK');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');

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
