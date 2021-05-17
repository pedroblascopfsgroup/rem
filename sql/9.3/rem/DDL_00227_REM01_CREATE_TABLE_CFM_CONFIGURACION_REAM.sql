--/*
--##########################################
--## AUTOR= Sento Visiedo Rubio
--## FECHA_CREACION=20210222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13133
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla CFM_CONFIGURACION_REAM
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'CFM_CONFIGURACION_REAM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

    DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 

    IF V_NUM_TABLAS = 1 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||' borrada.');
    END IF;

    V_MSQL := 'SELECT COUNT(*) FROM all_tab_columns where owner = '''||V_ESQUEMA||''' and table_name = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        -- Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
        V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
        (
            CFM_ID                          NUMBER(16,0) NOT NULL,
            DD_CRA_ID                       NUMBER(16,0) NOT NULL,
            DD_SCR_ID        	            NUMBER(16,0),
            PRO_ID		             		NUMBER(16,0),
			CFM_CARTERA_MAC                 NUMBER(1,0),
            VERSION                         NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
            USUARIOCREAR                    VARCHAR2(50 CHAR) NOT NULL ENABLE, 
            FECHACREAR                      TIMESTAMP (6) NOT NULL ENABLE, 
            USUARIOMODIFICAR                VARCHAR2(50 CHAR), 
            FECHAMODIFICAR                  TIMESTAMP (6), 
            USUARIOBORRAR                   VARCHAR2(50 CHAR), 
            FECHABORRAR                     TIMESTAMP (6), 
            BORRADO                         NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
        )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');

        -- Creamos primary key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (CFM_ID))';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT CFM_DD_CRA_ID_FK 
        FOREIGN KEY (DD_CRA_ID)
        REFERENCES '||V_ESQUEMA||'.DD_CRA_CARTERA (DD_CRA_ID)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] CFM_DD_CRA_ID_FK ... FK creada.');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT CFM_DD_SCR_ID_FK 
        FOREIGN KEY (DD_SCR_ID)
        REFERENCES '||V_ESQUEMA||'.DD_SCR_SUBCARTERA (DD_SCR_ID)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] CFM_DD_SCR_ID_FK ... FK creada.');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT CFM_PRO_ID_FK 
        FOREIGN KEY (PRO_ID)
        REFERENCES '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (PRO_ID)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] CFM_PRO_ID_FK ... FK creada.');

        -- Comprobamos si existe la secuencia
        V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
            
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 0 THEN
            -- Creamos sequence
            V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';        
            EXECUTE IMMEDIATE V_MSQL;       
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
        END IF;
        
        -- Creamos el comentario de las columnas
        V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla de activo historico ocupado titulo''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');      

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.CFM_ID IS ''Código identificador único.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CFM_ID creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_CRA_ID IS ''FK a DD_CRA_ID''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_CRA_ID creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_SCR_ID IS ''FK a DD_SCR_ID''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_SCR_ID creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.PRO_ID IS ''FK a ACT_PRO_ID''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ACT_PRO_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.CFM_CARTERA_MAC IS ''Campo para Cartera MAC''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CFM_CARTERA_MAC creado.');    

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión del registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
        
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe.');  
    END IF;

    COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT