--/*
--##########################################
--## AUTOR=Alejandro Valverde Herrera
--## FECHA_CREACION=20180924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4530
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva OKU_DEMANDA_OCUPACION_ILEGAL
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'OKU_DEMANDA_OCUPACION_ILEGAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.    
    
BEGIN
	

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Ya existe.');
	ELSE	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
			OKU_ID           						NUMBER(16,0),
			ACT_ID								NUMBER(16,0),
			OKU_NUM_ASUNTO							NUMBER(16,0),
			OKU_FECHA_INICIO_ASUNTO						DATE,
			OKU_FECHA_FIN_ASUNTO						DATE,
			OKU_FECHA_LANZAMIENTO						DATE,
			DD_TAO_ID							NUMBER(16,0),
			DD_TCO_ID							NUMBER(16,0),
			VERSION 							NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 							VARCHAR2(50 CHAR) NOT NULL ENABLE, 
			FECHACREAR 							TIMESTAMP (6) NOT NULL ENABLE, 
			USUARIOMODIFICAR 						VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 							TIMESTAMP (6), 
			USUARIOBORRAR 							VARCHAR2(50 CHAR), 
			FECHABORRAR 							TIMESTAMP (6), 
			BORRADO 							NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE			
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	END IF;

	--Comprobamos si existen PK de esa tabla
    	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME=''OKU_ID_PK'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;
    	-- Si existe la PK
    	IF V_NUM_TABLAS = 1 THEN  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Ya existe clave primaria');	
    	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT OKU_ID_PK PRIMARY KEY (OKU_ID)';
		DBMS_OUTPUT.PUT_LINE('[INFO] OKU_ID_PK... PK creada.');
	END IF;
	
	-- Comprobamos si existe la secuencia
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 
	-- Si existe la secuencia
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA || '.'||V_TEXT_TABLA||'... la secuencia ya existe');
	ELSE
		EXECUTE IMMEDIATE 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.S_'||V_TEXT_TABLA||'... Secuencia creada correctamente.');    
	END IF;

	-- Comprobamos si ya existe la FK
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME=''FK_TAO_DD_TAO_ID'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FK_TAO_DD_TAO_ID... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_TAO_DD_TAO_ID FOREIGN KEY (DD_TAO_ID) REFERENCES DD_TAO_OKU_TIPO_ASUNTO (DD_TAO_ID))';
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD FK_TAO_DD_TAO_ID ... OK');
	END IF;

	-- Comprobamos si ya existe la FK
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME=''FK_TCO_DD_TCO_ID'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'.FK_TCO_DD_TCO_ID... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_TCO_DD_TCO_ID FOREIGN KEY (DD_TCO_ID) REFERENCES DD_TCO_OKU_TIPO_ACTUACION (DD_TCO_ID))';
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD FK_TCO_DD_TCO_ID ... OK');
	END IF;

	-- Comprobamos si ya existe la FK
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME=''FK_ACT_ACT_ID'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'.FK_ACT_ACT_ID... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES ACT_ACTIVO (ACT_ID))';
		DBMS_OUTPUT.PUT_LINE('ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD FK_ACT_ACT_ID ... OK');
	END IF;

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OKU_ID IS ''ID único identificador de la ocupación''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID IS ''Código único del activo ocupado''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OKU_NUM_ASUNTO IS ''Numero del asunto''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OKU_FECHA_INICIO_ASUNTO IS ''Fecha de inicio del asunto''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OKU_FECHA_FIN_ASUNTO IS ''Fecha fin del aasunto''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.OKU_FECHA_LANZAMIENTO IS ''Fecha de lanzamiento''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TAO_ID IS ''Tipo de asunto de la ocupación''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TCO_ID IS ''Tipo de actuación de la ocupación''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado''';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Comentarios añadidos correctamente.');	

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
