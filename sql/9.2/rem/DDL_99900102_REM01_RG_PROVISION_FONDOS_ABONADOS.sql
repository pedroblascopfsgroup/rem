--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170329
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=X.X
--## INCIDENCIA_LINK=HREOS-1834
--## PRODUCTO=NO
--## Finalidad: Tablas para la interfaz REM-GESTORIAS de PROVISIONES DE FONDOS ABONADOS
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
  V_TEXT_TABLA VARCHAR2(50 CHAR); -- Vble. auxiliar para nombre de tabla.
  V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar.
  V_COMMENT_TABLE VARCHAR2(500 CHAR); -- Vble. para los comentarios de las tablas

BEGIN

  --EPF_ESTADOS_PROV_FOND
	V_TEXT_TABLA := 'EPF_ESTADOS_PROV_FOND';
  V_COMMENT_TABLE := 'Tabla histórica para guardar los estados (enviado/no enviado) de las provisiones de fondos abonados de las distintas gestorías';
	DBMS_OUTPUT.PUT_LINE('******** ' ||V_TEXT_TABLA|| ' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
    (
        EPF_ID           	NUMBER (16,0),
        GPV_ID            NUMBER (16,0),
        EPF_FECHA_ENVIO   TIMESTAMP (6),
        EPF_ENVIADO       NUMBER (1,0) DEFAULT 0 NOT NULL ENABLE,
        VERSION 					NUMBER (38,0) DEFAULT 0 NOT NULL ENABLE, 
        USUARIOCREAR 			VARCHAR2(50 CHAR) NOT NULL ENABLE, 
        FECHACREAR 				TIMESTAMP (6) NOT NULL ENABLE, 
        USUARIOMODIFICAR  VARCHAR2(50 CHAR), 
        FECHAMODIFICAR 		TIMESTAMP (6), 
        USUARIOBORRAR 		VARCHAR2(50 CHAR), 
        FECHABORRAR 			TIMESTAMP (6), 
        BORRADO 					NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
    )';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	

	-- Creamos índice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(EPF_ID) TABLESPACE '||V_TABLESPACE_IDX;
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Índice creado.');	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (EPF_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
  
  -- Creamos foreign key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT '||V_TEXT_TABLA||'_FK FOREIGN KEY (GPV_ID) REFERENCES '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID)';
  EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

  -- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario TABLA creado.');
	
	-- Creamos comentarios sobre las columnas
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.EPF_ID IS ''Código identificador único de los estados de las provisiones de fondos abonados''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.GPV_ID IS ''Código identificador único del gasto''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.EPF_FECHA_ENVIO IS ''Fecha de envío de la provisión de fondos abonados a su respectiva gestoría''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.EPF_ENVIADO IS ''Flag que indica si la provisón de fondo abonado está enviada a su gestoría o no''';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentarios de las columnas creados.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
  
  --APR_AUX_RG_PROV_FONDOS_ABONADOS
	V_TEXT_TABLA := 'APR_AUX_RG_PROV_FOND_ABON';
  V_COMMENT_TABLE := 'Tabla auxiliar para el tratamiento de provisión de fondos abonados de las gestorías';
  DBMS_OUTPUT.PUT_LINE(''); 
	DBMS_OUTPUT.PUT_LINE('******** ' ||V_TEXT_TABLA|| ' ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
    (
        NUM_GASTO_GESTORIA    NUMBER (16,0),
        NUM_GASTO_HAYA        NUMBER (16,0),
        NUM_PROVISION_FONDOS  VARCHAR2 (20 CHAR), 
        IMPORTE_TOTAL         NUMBER (16,2), 
        DD_GRF_ID           	NUMBER (16,0)
    )';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');	
		
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario TABLA creado.');
	
	-- Creamos comentarios sobre las columnas
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NUM_GASTO_GESTORIA IS ''Número identificador para la gestoria del gasto.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NUM_GASTO_HAYA IS ''Número identificador rem del gasto.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.NUM_PROVISION_FONDOS IS ''Referencia UVEM: NUPROF''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.IMPORTE_TOTAL IS ''Importe total del gasto''';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentarios de las columnas creados.');
		
	DBMS_OUTPUT.PUT_LINE('[FIN] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	
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
