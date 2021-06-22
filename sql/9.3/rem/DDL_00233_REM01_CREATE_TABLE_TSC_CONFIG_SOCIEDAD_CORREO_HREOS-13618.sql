--/*
--##########################################
--## AUTOR=Daniel Gallego
--## FECHA_CREACION=20210401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13618
--## PRODUCTO=NO
--## Finalidad: Creacion Tabla TSC_CONFIG_SOCIEDAD_CORREO
--##           
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'TSC_CONFIG_SOCIEDAD_CORREO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe.');
		
    ELSE
            -- Creamos la tabla
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
            V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
            (
                TSC_ID           		    NUMBER(16)                  NOT NULL,
                DD_TSP_ID        		    NUMBER(16)                  NOT NULL ,
                TSC_TIPO_CORREO		        NUMBER (1,0)               NOT NULL ,
                TSC_CORREO		            VARCHAR(50)               NOT NULL ,
                VERSION 			        NUMBER(38,0) 		        DEFAULT 0 NOT NULL ENABLE, 
                USUARIOCREAR 			    VARCHAR2(50 CHAR) 	        NOT NULL ENABLE, 
                FECHACREAR 			        TIMESTAMP (6) 		        NOT NULL ENABLE, 
                USUARIOMODIFICAR 		    VARCHAR2(50 CHAR), 
                FECHAMODIFICAR 			    TIMESTAMP (6), 
                USUARIOBORRAR 			    VARCHAR2(50 CHAR), 
                FECHABORRAR 			    TIMESTAMP (6), 
                BORRADO 			        NUMBER(1,0) 		        DEFAULT 0 NOT NULL ENABLE
            )
            LOGGING 
            NOCOMPRESS 
            NOCACHE
            NOPARALLEL
            NOMONITORING
            ';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
            
            -- Creamos primary key
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (TSC_ID) USING INDEX)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

            -- Creamos foreign keys
		    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_TSC_TIPO_CORREO FOREIGN KEY (DD_TSP_ID) REFERENCES '||V_ESQUEMA||'.DD_TSP_TIPO_CORREO (DD_TSP_ID) ON DELETE SET NULL)';
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_TPA... Foreign key creada.');

            -- Comprobamos si existe la secuencia
            V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
            IF V_NUM_TABLAS = 1 THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe.');  
            ELSE
            
            -- Creamos sequence
                V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
                EXECUTE IMMEDIATE V_MSQL;		
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
            END IF;

            -- Creamos comentario
            V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla  TSC_CONFIG_SOCIEDAD_CORREO.''';
		    EXECUTE IMMEDIATE V_MSQL;	
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.TSC_ID IS ''Clave primaria''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_TSP_ID IS ''Fk a la tabla DD_TSP_TIPO_CORREO''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.TSC_TIPO_CORREO IS ''Columna que indica si es destinatario o es copia.''';
            EXECUTE IMMEDIATE V_SQL;
            V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.TSC_CORREO IS ''Correo''';
            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados.');
            
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

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

EXIT;