--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14508
--## PRODUCTO=NO
--## Finalidad:  
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

    V_MSQL VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2( 25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2( 4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER( 16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER( 16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2( 2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2( 2400 CHAR) := 'HCC_HIST_CAMPANYA_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT( 1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(	
		HCC_ID							NUMBER(16,0),
		ACT_ID 							NUMBER(16,0),
		ID_CAMPANYA						VARCHAR2(8 CHAR),
		TIPOLOGIA						VARCHAR2(10 CHAR), 
		ID_FASE							VARCHAR2(8 CHAR),
		FECHA_INICIO_FASE				DATE,
		FECHA_FIN_FASE					DATE,
		TIEMPO_COSECHA					NUMBER(3,0),
		VERSION							NUMBER(38,0)  		DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR					VARCHAR2(50 CHAR) 	NOT NULL ENABLE, 
		FECHACREAR						TIMESTAMP(6) 		NOT NULL ENABLE, 
		USUARIOMODIFICAR				VARCHAR2(50 CHAR),
		FECHAMODIFICAR					TIMESTAMP(6),
		USUARIOBORRAR					VARCHAR2(50 CHAR),
		FECHABORRAR						TIMESTAMP(6),
		BORRADO							NUMBER(1,0) 		DEFAULT 0

  	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	-- Creamos indice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.HCC_HIST_CAMPANYA_CAIXA_UK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ACT_ID,ID_CAMPANYA,TIPOLOGIA,ID_FASE,FECHA_INICIO_FASE,FECHA_FIN_FASE) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HCC_HIST_CAMPANYA_CAIXA_UK... Indice creado.');	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT HCC_HIST_CAMPANYA_CAIXA_PK PRIMARY KEY (HCC_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HCC_HIST_CAMPANYA_CAIXA_PK ... PK creada.');

	-- Creamos FKs
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_ACTIVO_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_ACT_ACTIVO_ID... Foreign key creada.');

/*	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CAMPANYA_CAMP FOREIGN KEY (ID_CAMPANYA) REFERENCES '||V_ESQUEMA||'.AUX_APR_BCR_CAMPANYA_CAMP (ID_CAMPANYA))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CAMPANYA_CAMP... Foreign key creada.');

	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CAMPANYA_FASE FOREIGN KEY (ID_FASE) REFERENCES '||V_ESQUEMA||'.AUX_APR_BCR_CAMPANYA_FASE (ID_FASE))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CAMPANYA_FASE... Foreign key creada.');
*/
	-- Comprobamos si existe la secuencia
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe.');  
	ELSE
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	END IF;	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla histórica de negocio de las campañas.''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.HCC_ID IS ''Id de la histórica.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_ID IS ''Código identificador único del activo.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ID_CAMPANYA IS ''Código de la campaña.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TIPOLOGIA IS ''Tipología de la Campaña.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ID_FASE IS ''Código de la fase.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHA_INICIO_FASE IS ''Fecha inicio prevista.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHA_FIN_FASE IS ''Fecha fin real.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TIEMPO_COSECHA IS ''Tiempo cosecha.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VERSION IS ''Indica la version del registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
	
	COMMIT;

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

EXIT;
