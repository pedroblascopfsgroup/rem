--/*
--##########################################
--## AUTOR=Ramon Llinares
--## FECHA_CREACION=20170712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2396
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar los avisos de los gastos
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AVG_AVISOS_GASTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'TTabla para gestionar los avisos de los gastos'; -- Vble. para los comentarios de las tablas
    
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
		AVG_ID									NUMBER(16,0)					NOT NULL,
		GPV_ID                                  NUMBER(16,0)					NOT NULL,
		AVG_COMPRADOR  							NUMBER(1,0),                  
		AVG_IBI_EXENTO  						NUMBER(1,0),
		AVG_IMPUESTO  						   	NUMBER(1,0),
		AVG_PRIMER_PAGO  						NUMBER(1,0),
		AVG_INCR_IMPORTE  						NUMBER(1,0),
		AVG_DIF_IMPORTE  						NUMBER(1,0),
		AVG_PROVEEDOR_BAJA  					NUMBER(1,0),
		AVG_PROVEEDOR_SINSALDO  				NUMBER(1,0),
		AVG_SIN_PER_ADMINISTRACION  			NUMBER(1,0),
		VERSION 								NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 							VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 								TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 						VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 							TIMESTAMP (6), 
		USUARIOBORRAR 							VARCHAR2(50 CHAR), 
		FECHABORRAR 							TIMESTAMP (6), 
		BORRADO 								NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE				
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(AVG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (AVG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	
	-- Creamos sequence -> No hace falta porque es una clase heredada
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

	
	
	-- Creamos foreign key ECO_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_AVG_GPV_GASTOS_PROVEEDOR FOREIGN KEY (GPV_ID) REFERENCES '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_AVG_GPV_GASTOS_PROVEEDOR... Foreign key creada.');

	

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_COMPRADOR IS ''Corresponde al comprador''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_IBI_EXENTO IS ''IBI exento''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_COMPRADOR IS ''Corresponde al comprador''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_IMPUESTO IS ''No se devenga el impuesto''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_PRIMER_PAGO IS ''Primer pago''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_INCR_IMPORTE IS ''Incremento en el importe''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_DIF_IMPORTE IS ''Importe diferente''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_PROVEEDOR_BAJA IS ''Proveedor de baja''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_PROVEEDOR_SINSALDO IS ''Proveedor sin saldo''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.AVG_SIN_PER_ADMINISTRACION IS ''Fuera de perímetro de administración''';
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/


EXIT;
