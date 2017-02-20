--/*
--##########################################
--## AUTOR=Joaquin_Arnal
--## FECHA_CREACION=20160212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1508
--## PRODUCTO=NO
--## Finalidad: Creación de tablas auxiliares y historicas con la respuesta de cabecera de los datos de salida de información ASPRO
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

BEGIN

  -- AUX_H_ASPRO_RESPUESTA 
  V_TEXT_TABLA := 'AUX_H_ASPRO_RESPUESTA'; 
  V_COMMENT_TABLE := 'Tabla auxiliar de entrada para respuesta fichero gastos ASPRO'; 
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
		IDNOPE		VARCHAR2(15 CHAR),
		CODREG		VARCHAR2(1 CHAR),
		COENTV		VARCHAR2(7 CHAR),
		ERCOD9		VARCHAR2(3 CHAR)
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
		
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.IDNOPE IS ''IDENTIFICADOR NUMERO DE OPERAC'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CODREG IS ''CODIGO DE REGISTRO'' ';         
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.COENTV IS ''COD. ENTIDAD URSUS'' ';            
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ERCOD9 IS ''NUMERO DEL ERROR PRODUCIDO'' ';

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
