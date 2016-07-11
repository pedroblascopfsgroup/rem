--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar los propietarios de los activos.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar los propietarios de los activos.'; -- Vble. para los comentarios de las tablas

    
    
    
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
		PRO_ID           			NUMBER(16)                  NOT NULL,
		DD_LOC_ID					NUMBER(16),
		DD_PRV_ID					NUMBER(16),
		PRO_CODIGO_UVEM				NUMBER(16),
		DD_TPE_ID					NUMBER(16),
		PRO_NOMBRE		       		VARCHAR2(100 CHAR),
		PRO_APELLIDO1	       		VARCHAR2(100 CHAR),
		PRO_APELLIDO2	       		VARCHAR2(100 CHAR),
		DD_TDI_ID					NUMBER(16,0),
		PRO_DOCIDENTIF				VARCHAR2(20 CHAR),
		PRO_DIR						VARCHAR2(250 CHAR),
		PRO_TELF					VARCHAR2(20 CHAR),
		PRO_EMAIL					VARCHAR2(50 CHAR),	
		PRO_CP						NUMBER(8,0),	
		DD_LOC_ID_CONT				NUMBER(16),
		DD_PRV_ID_CONT				NUMBER(16),		
		PRO_CONTACTO_NOM			VARCHAR2(100 CHAR),			
		PRO_CONTACTO_TELF1			VARCHAR2(20 CHAR),	
		PRO_CONTACTO_TELF2			VARCHAR2(20 CHAR),		
		PRO_CONTACTO_EMAIL			VARCHAR2(50 CHAR),	
		PRO_CONTACTO_DIR			VARCHAR2(250 CHAR),	
		PRO_CONTACTO_CP				NUMBER(8,0),		
		PRO_OBSERVACIONES			VARCHAR2(1000 CHAR),
		PRO_PAGA_EJECUTANTE			NUMBER(1,0),
		VERSION 					NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 				VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 					TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 			VARCHAR2(10 CHAR), 
		FECHAMODIFICAR 				TIMESTAMP (6), 
		USUARIOBORRAR 				VARCHAR2(10 CHAR), 
		FECHABORRAR 				TIMESTAMP (6), 
		BORRADO 					NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(PRO_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (PRO_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	
	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

	-- Creamos foreign key DD_LOC_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROP_DDLOCALIDAD FOREIGN KEY (DD_LOC_ID) REFERENCES '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD (DD_LOC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROP_DDLOCALIDAD... Foreign key creada.');
	
	-- Creamos foreign key DD_PRV_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROP_DDPROVINCIA FOREIGN KEY (DD_PRV_ID) REFERENCES '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA (DD_PRV_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROP_DDPROVINCIA... Foreign key creada.');
	
	-- Creamos foreign key DD_LOC_ID_CONT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROPCONT_DDLOCALIDAD FOREIGN KEY (DD_LOC_ID_CONT) REFERENCES '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD (DD_LOC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROPCONT_DDLOCALIDAD... Foreign key creada.');
	
	-- Creamos foreign key DD_PRV_ID_CONT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROPCONT_DDPROVINCIA FOREIGN KEY (DD_PRV_ID_CONT) REFERENCES '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA (DD_PRV_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROPCONT_DDPROVINCIA... Foreign key creada.');
	
	-- Creamos foreign key DD_TPE_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROP_DDTPERSONA FOREIGN KEY (DD_TPE_ID) REFERENCES '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA (DD_TPE_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROP_DDTPERSONA... Foreign key creada.');
	
	-- Creamos foreign key DD_TDI_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PROP_DDTIPODOCIDENT FOREIGN KEY (DD_TDI_ID) REFERENCES '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PROVEEDOR_DDTIPODOCIDENT... Foreign key creada.');
	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	

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