--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para almacenar la información de alta de activos procedentes de fichero.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para almacenar la información de alta de activos procedentes de fichero.'; -- Vble. para los comentarios de las tablas

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
		APR_ID 						NUMBER(16,0)   			NOT NULL, 
		ACT_NUMERO_ACTIVO 			NUMBER(16,0)   			NOT NULL, 
		ACT_NUMERO_UVEM 			NUMBER(16,0), 
		ACT_NUMERO_PRINEX 			NUMBER(16,0), 
		ACT_NUMERO_SAREB 			VARCHAR2(55 CHAR),
		DD_CARTERA 					VARCHAR2(20 CHAR)		NOT NULL, 
		PROP_CIF 					VARCHAR2(20 CHAR)		NOT NULL,   
		DD_ENTIDAD_ORIGEN 			VARCHAR2(20 CHAR)		NOT NULL,  
		DD_ENTIDAD_ORIGEN_ANT		VARCHAR2(20 CHAR), 
		ACT_DIVISION_HORIZONTAL 	NUMBER(1,0),
		ACT_FECHA_REV_CARGAS 		DATE, 
		ACT_CON_CARGAS 				NUMBER(1,0), 
		DD_TIPO_ACTIVO 				VARCHAR2(20 CHAR)		NOT NULL,
		DD_SUBTIPO_ACTIVO 			VARCHAR2(20 CHAR)		NOT NULL, 
		DD_ESTADO_ACTIVO 			VARCHAR2(20 CHAR),
		DD_USO_ACTIVO 				VARCHAR2(20 CHAR), 
		DD_TIPO_TITULO 				VARCHAR2(20 CHAR), 
		DD_SUBTIPO_TITULO 			VARCHAR2(20 CHAR), 
		ACT_VPO 					NUMBER(1,0), 
		ADN_FECHA_TITULO 			DATE, 
		ADN_FECHA_FIRMA_TITULO 		DATE, 
		ADN_VALOR_ADQUISICION 		NUMBER(16,2), 
		AJD_VALOR_ADJUDICACION		NUMBER(16,2), 
		TAS_FECHA_FIN_TASACION		DATE,
		TAS_IMPORTE_TAS_FIN			NUMBER(16,2), 
		ADN_TRAMITADOR_TITULO		VARCHAR2(250 CHAR),
		ADN_NUM_REFERENCIA			VARCHAR2(250 CHAR),
		SPS_OCUPADO					NUMBER(1,0),
		SPS_CON_TITULO				NUMBER(1,0),
		DD_MUNICIPIO_REGISTRO		VARCHAR2(20 CHAR),
		REG_NUM_REGISTRO			VARCHAR2(50 CHAR),
		REG_TOMO					VARCHAR2(50 CHAR),
		REG_LIBRO					VARCHAR2(50 CHAR),
		REG_FOLIO					VARCHAR2(50 CHAR),
		REG_NUM_FINCA				VARCHAR2(50 CHAR)		NOT NULL,
		CAT_REF_CATASTRAL			VARCHAR2(50 CHAR),
		REG_SUPERFICIE				NUMBER(16,2),
		REG_SUPERFICIE_CONST		NUMBER(16,2),
		REG_SUPERFICIE_UTIL			NUMBER(16,2),
		DD_TIPO_VIA					VARCHAR2(20 CHAR),
		LOC_NOMBRE_VIA				VARCHAR2(100 CHAR)		NOT NULL,
		LOC_NUMERO_DOMICILIO		VARCHAR2(100 CHAR),
		LOC_ESCALERA				VARCHAR2(10 CHAR),
		LOC_PISO					VARCHAR2(10 CHAR),
		LOC_PUERTA					VARCHAR2(10 CHAR),
		LOC_COD_POST				VARCHAR2(20 CHAR),
		DD_MUNICIPIO				VARCHAR2(20 CHAR)		NOT NULL,
		DD_PROVINCIA				VARCHAR2(20 CHAR)		NOT NULL,
		ACT_GESTION_HRE				NUMBER(1,0)				NOT NULL,
		ACT_LLV_LLAVES_HRE			NUMBER(1,0),
		ACT_LLV_NUM_JUEGOS			NUMBER(8,0),
		ACT_LLV_FECHA_RECEPCION		DATE,
		FECHA_EXTRACCION			DATE		
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(APR_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (APR_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	
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