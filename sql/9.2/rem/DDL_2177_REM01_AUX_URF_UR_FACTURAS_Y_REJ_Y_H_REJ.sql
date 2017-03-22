--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20170317
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1727
--## PRODUCTO=NO
--## Finalidad: Creación de tablas auxiliar para carga del fichero URFACVE2.txt, tabla de rejects del mismo fichero y tabla historia de rechazos
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
  
  V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas
  V_COLUMN_TABLE_UNIQUE VARCHAR2(500 CHAR):= ''; -- Vble. para un campo que debe ser unico en la tabla

  V_COL_TABLE_FK VARCHAR2(500 CHAR):= ''; -- Vble. para indicar un campo que es FK
  V_COL_TABLE_FK_TAB_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la tabla referencia de un campo que es FK
  V_COL_TABLE_FK_COL_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la columna referencia de un campo que es FK


BEGIN

	-- AUX_URF_UR_FACTURAS
	V_TEXT_TABLA := 'AUX_URF_UR_FACTURAS'; 
	V_COMMENT_TABLE := 'Tabla auxiliar de entrada para carga del fichero URFACVE2.txt'; 
	V_COLUMN_TABLE_UNIQUE := '';

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		IDFREM		VARCHAR2(20 CHAR),
		COACES		NUMBER(9,0),
		COSUFA		VARCHAR2(1 CHAR),
		NUDNIR 		VARCHAR2(10 CHAR),
		FEEMFA		DATE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.IDFREM IS ''IDENTIFICADOR FACTURA REM'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COACES IS ''IDENTIFICADOR ACTIVO ESPECIAL'' ';         
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COSUFA IS ''CODIGO SUBTIPO DE FACTURA'' ';            
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NUDNIR IS ''CIF / DNI DEL ARRENDATARIO'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FEEMFA IS ''FECHA EMISION FACTURA'' ';

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	COMMIT;

	-- AUX_URF_UR_FACTURAS_REJ 
	V_TEXT_TABLA := 'AUX_URF_UR_FACTURAS_REJ'; 
	V_COMMENT_TABLE := 'Tabla auxiliar para rechazos de la carga del fichero URFACVE2.txt'; 
	V_COLUMN_TABLE_UNIQUE := '';

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
		IDFREM		VARCHAR2 (20 CHAR),
		COACES		VARCHAR2 (9 CHAR),
		COSUFA		VARCHAR2 (1 CHAR),
		NUDNIR 		VARCHAR2 (10 CHAR),
		FEEMFA		VARCHAR2 (8 CHAR),
		DD_MRF_ID 	NUMBER (16,0),
		ERRORCODE	VARCHAR2 (512 CHAR),
		ERRORMESSAGE	VARCHAR2 (1024 CHAR)
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.IDFREM IS ''IDENTIFICADOR FACTURA REM'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COACES IS ''IDENTIFICADOR ACTIVO ESPECIAL'' ';         
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COSUFA IS ''CODIGO SUBTIPO DE FACTURA'' ';            
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NUDNIR IS ''CIF / DNI DEL ARRENDATARIO'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FEEMFA IS ''FECHA EMISION FACTURA'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ERRORCODE IS ''CODIGO DE ERROR AL COMPROBAR LA VALIDEZ DEL REGISTRO'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ERRORMESSAGE IS ''MENSAJE DE ERROR AL COMPROBAR LA VALIDEZ DEL REGISTRO'' ';

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	COMMIT;


	-- H_AUX_URF_UR_FACTURAS_REJ 
	V_TEXT_TABLA := 'H_AUX_URF_UR_FACTURAS_REJ'; 
	V_COMMENT_TABLE := 'Tabla historica con los rechazos de carga del fichero URFACVE2.txt'; 
	V_COLUMN_TABLE_UNIQUE := '';

	V_COL_TABLE_FK := 'DD_MRF_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRF_MOTIVO_RECH_FACT_UR'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRF_ID'; -- Vble. para la columna referencia de un campo que es FK

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... La tabla ya existe revisar definición de la misma.');
	ELSE 
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
						
			H_URF_REJ_ID 		NUMBER (16, 0),			
			IDFREM			VARCHAR2 (20 CHAR),
			COACES			VARCHAR2 (9 CHAR),
			COSUFA			VARCHAR2 (1 CHAR),
			NUDNIR 			VARCHAR2 (10 CHAR),
			FEEMFA			VARCHAR2 (8 CHAR),
			ERRORCODE		VARCHAR2 (512 CHAR),
			ERRORMESSAGE		VARCHAR2 (1024 CHAR),
			FICHERO 		VARCHAR2 (200 CHAR),
			USUARIOCREAR 		VARCHAR2 (100 CHAR),
			FECHACREAR 		DATE, 
			USUARIOMODIFICAR	VARCHAR2 (100 CHAR),
			FECHAMODIFICAR		DATE, 
			USUARIOBORRAR		VARCHAR2 (100 CHAR),
			FECHABORRAR 		DATE, 
			BORRADO 		NUMBER (1,0),
			DD_MRF_ID 		NUMBER (16,0)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

		-- Verificar si la secuencia ya existe y borrarla
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
			EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		END IF;
	
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	
		-- Creamos foreing key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT MRF_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada ('||V_COL_TABLE_FK||').');

		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
		
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.H_URF_REJ_ID IS ''ID UNICO DE LA TABLA'' ';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.IDFREM IS ''IDENTIFICADOR FACTURA REM'' ';	
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COACES IS ''IDENTIFICADOR ACTIVO ESPECIAL'' ';         
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COSUFA IS ''CODIGO SUBTIPO DE FACTURA'' ';            
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ERRORCODE IS ''CIF / DNI DEL ARRENDATARIO'' ';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ERRORMESSAGE IS ''FECHA EMISION FACTURA'' ';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FICHERO IS ''FICHERO DE CARGA DEL REGISTRO RECHAZADO'' ';

		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

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
