--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20220419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17668
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar LOS OPERADORES DE LA REST API DE REM 3
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Aumenar tamaño campo IP
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'RST_PETICION_R3'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla de gestión de los operadores de la rest api REM3.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 

	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		RST_PETICION_ID           				NUMBER(16)                  NOT NULL,
		RST_PETICION_TOKEN				        VARCHAR2(20 CHAR) 			NULL,	
		RST_BROKER_ID           				NUMBER(16)      			NULL,
		RST_PETICION_IP					        VARCHAR2(50 CHAR) 			NOT NULL,
		RST_PETICION_METODO				        VARCHAR2(50 CHAR) 			NOT NULL,
		RST_PETICION_QUERY				        VARCHAR2(300 CHAR) 			NOT NULL,
		RST_PETICION_DATA				        CLOB 			            NULL,
		RST_PETICION_RESULT				        VARCHAR2(5 CHAR) 			NOT NULL,
		RST_PETICION_ERROR_DESC				    VARCHAR2(200 CHAR) 			NULL,	
		VERSION 								NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 							VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 								TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 						VARCHAR2(10 CHAR), 
		FECHAMODIFICAR 							TIMESTAMP (6), 
		USUARIOBORRAR 							VARCHAR2(10 CHAR), 
		FECHABORRAR 							TIMESTAMP (6), 
		BORRADO 								NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE,
		RST_PETICION_RESPONSE                   CLOB 			            NULL
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla de fechas de arras''';		
	EXECUTE IMMEDIATE V_MSQL;

    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_ID IS ''Id de la tabla''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_TOKEN IS ''Token de la petición''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_BROKER_ID IS ''Id del broker''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_IP IS ''IP de la petición''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_METODO IS ''Tipo de endpoint de la petición''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_QUERY IS ''Endpoint de la petición''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_DATA IS ''Datos que se reciben en la petición''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_RESULT IS ''Resultado del endpoint OK/KO''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_ERROR_DESC IS ''Descripción del error''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Versión del registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Fecha crear del registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Usuario que crea el registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Fecha de modificación del registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Usuario que modifica el registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Usuario que borra el registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Fecha de borrado del registro''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Flag que indica si está borrado o no''';
    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.RST_PETICION_RESPONSE IS ''Respuesta del servicio''';
    EXECUTE IMMEDIATE V_SQL;
	

	-- Creamos indice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(RST_PETICION_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (RST_PETICION_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

	-- Creamos foreign key RST_BROKER_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_RST_BROKER_ID_R3 FOREIGN KEY  (RST_BROKER_ID) REFERENCES '||V_ESQUEMA||'.RST_BROKER (RST_BROKER_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_RST_BROKER_ID... Foreign key creada.');
	
	
	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');	
	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	
COMMIT;



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT