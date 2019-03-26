--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2043
--## PRODUCTO=NO
--## 
--## Finalidad: Se crea la tabla 'VALIDACIONES_FUNCIONALES'
--##      
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'VALIDACIONES_FUNCIONALES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_PK VARCHAR2(2400 CHAR) := 'PK_VALIDACIONES_FUNCIONALES'; -- Vble. auxiliar para almacenar el nombre de la PK.    
    V_TEXT_SEQ VARCHAR2(2400 CHAR) := 'S_VALIDACIONES_FUNCIONALES'; -- Vble. auxiliar para almacenar el nombre de la Sequencia.
    
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla que almacena las validaciones funcionales de la migración de REM'; -- Vble. para los comentarios de las tablas

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
    
    
    -- Verificar si la tabla ya existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... borrada.');
	END IF;     
	-- Creamos la tabla
	V_MSQL := '
		CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
			VALIDACION_ID      NUMBER(16,0)           NOT NULL ENABLE,  
			CODIGO             VARCHAR2(10 CHAR), 
			SEVERIDAD          NUMBER(1,0),   
			VALIDACION         VARCHAR2(4000 CHAR),
			NOMBRE_INTERFAZ    VARCHAR2(30 CHAR),
			QUERY              VARCHAR2(4000 CHAR),
			BORRADO            NUMBER(1,0)            DEFAULT 0 NOT NULL ENABLE 
		)
	'
	; 
	
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
	-- Creamos indice 
	EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_PK||' ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||' (VALIDACION_ID) TABLESPACE '||V_TABLESPACE_IDX;    
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_PK||'... Indice creado.');
	
	-- Creamos PK   
	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_PK||' PRIMARY KEY (VALIDACION_ID) USING INDEX)';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_PK||'... PK creada.');



    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||V_TEXT_SEQ||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_SEQ||'... Ya existe.');    
    ELSE
        -- Creamos sequence 
        V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||V_TEXT_SEQ||' MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE';
        EXECUTE IMMEDIATE V_MSQL;   
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_SEQ||'... Secuencia creada');
    END IF;   
  
    -- Creamos comentario 
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';   
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario de tabla creado.');
    
    
    -- Comentarios
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VALIDACION_ID IS ''Secuencial identificador del registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CODIGO IS ''Código identificador del registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.SEVERIDAD IS ''Severidad de la validación [0:Baja], [1:Alta]''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VALIDACION IS ''Breve explicación de la validación funcional''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NOMBRE_INTERFAZ IS ''Interfaz principal sobre la que actua la validación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.QUERY IS ''Query de la validación funcional''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado''';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentarios creados.');
    
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
