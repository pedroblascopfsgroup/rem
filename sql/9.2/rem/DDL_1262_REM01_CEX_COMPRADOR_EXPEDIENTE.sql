--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=201608010
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla que contiene la relación entre compradores y expediente comercial
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CEX_COMPRADOR_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla que contiene la relación entre compradores y expedientes.'; -- Vble. para los comentarios de las tablas
	
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
		COM_ID												NUMBER(16,0)				NOT NULL,
		ECO_ID 												NUMBER(16,0)				NOT NULL,
		DD_ECV_ID											NUMBER(16,0),
		DD_REM_ID											NUMBER(16,0),
		CEX_DOCUMENTO_CONYUGE								VARCHAR2(50 CHAR),
		CEX_ANTIGUO_DEUDOR									NUMBER(1),
		CEX_RELACION_ANT_DEUDOR								NUMBER(1),
		DD_UAC_ID											NUMBER(16),
		CEX_IMPTE_PROPORCIONAL_OFERTA						NUMBER(16,2),
		CEX_IMPTE_FINANCIADO								NUMBER(16,2),
		CEX_RESPONSABLE_TRAMITACION							VARCHAR2(256 CHAR),
		CEX_PORCION_COMPRA									NUMBER(16,2),
		CEX_TITULAR_RESERVA									NUMBER(1),
		CEX_TITULAR_CONTRATACION							NUMBER(1),	
		CEX_NOMBRE_RTE							VARCHAR2(256 CHAR),
		CEX_APELLIDOS_RTE							VARCHAR2(256 CHAR),						
		DD_TDI_ID											NUMBER(16,0),
		CEX_DOCUMENTO_RTE							VARCHAR2(50 CHAR),
		CEX_TELEFONO1_RTE							VARCHAR2(50 CHAR),
		CEX_TELEFONO2_RTE							VARCHAR2(50 CHAR),
		CEX_EMAIL_RTE								VARCHAR2(50 CHAR),
		CEX_DIRECCION_RTE							VARCHAR2(256 CHAR),
		CEX_MUNICIPIO_RTE							VARCHAR2(50 CHAR),
		CEX_CODIGO_POSTAL_RTE						VARCHAR2(5 CHAR),
		CEX_PROVINCIA_RTE					VARCHAR2(50 CHAR),
		VERSION 											NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (COM_ID, ECO_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
		
	-- Creamos foreign key COM_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_COM_ID FOREIGN KEY (COM_ID) REFERENCES '||V_ESQUEMA||'.COM_COMPRADOR (COM_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_COM_ID... Foreign key creada.');
	
		-- Creamos foreign key ECO_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_ECO_ID FOREIGN KEY  (ECO_ID) REFERENCES '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (ECO_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_ECO_ID... Foreign key creada.');
		
			-- Creamos foreign key DD_ECV_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_ECV_ID FOREIGN KEY (DD_ECV_ID) REFERENCES '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES (DD_ECV_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_ECV_ID... Foreign key creada.');

			-- Creamos foreign key DD_REM_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_REM_ID FOREIGN KEY (DD_REM_ID) REFERENCES '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES (DD_REM_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_REM_ID... Foreign key creada.');
	
			-- Creamos foreign key DD_UAC_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_UAC_ID FOREIGN KEY (DD_UAC_ID) REFERENCES '||V_ESQUEMA||'.DD_UAC_USOS_ACTIVO (DD_UAC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_UAC_ID... Foreign key creada.');
	
			-- Creamos foreign key DD_TDI_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_CEX_TDI_ID FOREIGN KEY (DD_TDI_ID) REFERENCES '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID (DD_TDI_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_CEX_TDI_ID... Foreign key creada.');
	
	
	
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