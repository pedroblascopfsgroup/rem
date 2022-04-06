--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220410
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17597
--## PRODUCTO=NO
--## Finalidad: Tabla que contiene la relación entre proveedores y especialidades
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
	V_COUNT NUMBER(16); -- Vble. para contar.
 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'PVE_PROVEEDOR_ESPECIALIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla que contiene la relación entre proveedores y especialidades.'; -- Vble. para los comentarios de las tablas
	
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
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		PVE_ESP_ID						NUMBER(16,0)				NOT NULL
		, PVE_ID								NUMBER(16,0)				NOT NULL
		,DD_ESP_ID 								NUMBER(16,0)				NOT NULL
		, VERSION NUMBER(1,0) DEFAULT 0 NOT NULL
		, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
		, FECHACREAR TIMESTAMP(6) NOT NULL
		, USUARIOMODIFICAR VARCHAR2(50 CHAR)
		, FECHAMODIFICAR TIMESTAMP(6)
		, USUARIOBORRAR VARCHAR2(50 CHAR)
		, FECHABORRAR TIMESTAMP(6)
		, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

		-- Comprobamos sequence
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la secuencia');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 

	IF V_COUNT = 0 THEN
	 
		-- Creamos sequence	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TEXT_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TEXT_TABLA);	
	  
	END IF;
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (PVE_ESP_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
		
	-- Creamos foreign key PVE_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PVE_ESP_PVE_ID FOREIGN KEY (PVE_ID) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PVE_DD_ESP_ID... Foreign key creada.');
	
		-- Creamos foreign key DD_ESP_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_PVE_ESP_DD_ESP FOREIGN KEY  (DD_ESP_ID) REFERENCES '||V_ESQUEMA||'.DD_ESP_ESPECIALIDAD (DD_ESP_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PVE_DD_ESP_ID... Foreign key creada.');
	
	
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