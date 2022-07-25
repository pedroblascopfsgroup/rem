--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17599
--## PRODUCTO=NO
--## Finalidad: Creacion diccionario DD_CCI_CAT_CONDUC_INAPROP
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_CCI_CAT_CONDUC_INAPROP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla de categorias de conductas inapropiadas'; -- Vble. para los comentarios de las tablas
    V_CREAR_FK NUMBER(1) := 1; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    /* -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
                --NOMBRE FK                         CAMPO FK                TABLA DESTINO FK                           
        T_FK(   'FK_DD_TCI',                   'DD_TCI_ID',             V_ESQUEMA||'.DD_TCI_TIPO_CONDUC_INAPROP'),
        T_FK(   'FK_DD_NCI',                   'DD_NCI_ID',             V_ESQUEMA||'.DD_NCI_NIVEL_CONDUC_INAPROP')
    );
    V_T_FK T_FK;

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
                DD_CCI_ID          		    NUMBER(16,0)                  NOT NULL,
                DD_TCI_ID          		    NUMBER(16,0)                  NOT NULL,
                DD_NCI_ID          		    NUMBER(16,0)                  NOT NULL,
                DD_CCI_CODIGO               VARCHAR2(20 CHAR),
                DD_CCI_DESCRIPCION          VARCHAR2(50 CHAR),
                DD_CCI_DESCRIPCION_LARGA    VARCHAR2(100 CHAR),
                VERSION 			        NUMBER(16,0) 		    DEFAULT 0 NOT NULL ENABLE, 
                USUARIOCREAR 			    VARCHAR2(50 CHAR) 	    NOT NULL ENABLE, 
                FECHACREAR 			        TIMESTAMP (6) 		    NOT NULL ENABLE, 
                USUARIOMODIFICAR 		    VARCHAR2(50 CHAR), 
                FECHAMODIFICAR 			    TIMESTAMP (6), 
                USUARIOBORRAR 			    VARCHAR2(50 CHAR), 
                FECHABORRAR 			    TIMESTAMP (6), 
                BORRADO 			        NUMBER(1,0) 		    DEFAULT 0 NOT NULL ENABLE
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
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DD_CCI_ID) USING INDEX)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

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
            V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';
		    EXECUTE IMMEDIATE V_MSQL;	
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_CCI_ID IS ''Id de la tabla''';
            EXECUTE IMMEDIATE V_MSQL;	
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_TCI_ID IS ''FK de la tabla DD_TCI_TIPO_CONDUC_INAPROP''';
            EXECUTE IMMEDIATE V_MSQL;	
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_NCI_ID IS ''FK de la tabla DD_NCI_NIVEL_CONDUC_INAPROP''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_CCI_CODIGO IS ''Código del diccionario''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_CCI_DESCRIPCION IS ''Descripción del diccionario''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.DD_CCI_DESCRIPCION_LARGA IS ''Descripción larga del diccionario''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Versión del registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Fecha crear del registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Usuario que crea el registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Fecha de modificación del registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Usuario que modifica el registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Usuario que borra el registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Fecha de borrado del registro''';
            EXECUTE IMMEDIATE V_MSQL;
            V_MSQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Flag que indica si está borrado o no''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados.');

            IF V_CREAR_FK = 1 THEN

                -- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
                FOR I IN V_FK.FIRST .. V_FK.LAST
                LOOP

                    V_T_FK := V_FK(I);  

                    -- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
                    V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TABLA||''' and constraint_name = '''||V_T_FK(1)||'''';
                    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                    IF V_NUM_TABLAS = 0 THEN
                        --No existe la FK y la creamos
                        DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TABLA||'['||V_T_FK(1)||'] -------------------------------------------');
                        V_MSQL := '
                            ALTER TABLE '||V_TABLA||'
                            ADD CONSTRAINT '||V_T_FK(1)||' FOREIGN KEY
                            ('||V_T_FK(2)||') REFERENCES '||V_T_FK(3)||'
                            ('||V_T_FK(2)||' ) ON DELETE SET NULL ENABLE';

                        EXECUTE IMMEDIATE V_MSQL;
                        --DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
                        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_FK(1)||' creada en tabla: FK en columna '||V_T_FK(2)||'... OK');

                    END IF;

                END LOOP;

            END IF;
                
            DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

        END IF;

	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE(V_SQL);
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;
