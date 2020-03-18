--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200317
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6606
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla para gestionar los gastos con IVA
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU_SIN_PROV'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el diccionario de TIPOS de gasto de REM a UVEM para separar tipos de gasto.'; -- Vble. para los comentarios de las tablas


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
	
	
  --Creamos la tabla
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'(

  DD_ETG_ID          			        NUMBER(16,0)            NOT NULL,          	
  DD_TGA_ID			                  NUMBER(16,0)            NOT NULL,
  DD_STG_ID		  	                NUMBER(16,0)            NOT NULL,
  DD_ETG_CODIGO   			          VARCHAR2(20 CHAR)       NOT NULL,
  DD_ETG_DESCRIPCION_POS	        VARCHAR2(100 CHAR),
  DD_ETG_DESCRIPCION_LARGA_POS		VARCHAR2(250 CHAR),
  DD_TPR_ID                       NUMBER(16,0)            NOT NULL,
  CORUG_POS                 			NUMBER(16,0),
  COTACA_POS			                NUMBER(16,0),
  COSBAC_POS              				NUMBER(16,0),
  DD_ETG_DESCRIPCION_NEG	        VARCHAR2(100 CHAR),
  DD_ETG_DESCRIPCION_LARGA_NEG		VARCHAR2(250 CHAR),
  CORUG_NEG                 			NUMBER(16,0),
  COTACA_NEG			                NUMBER(16,0),
  COSBAC_NEG              				NUMBER(16,0),
  VERSION                         NUMBER(38,0)            DEFAULT 0 NOT NULL ENABLE,
  USUARIOCREAR                    VARCHAR2(50 CHAR)       NOT NULL ENABLE,
  FECHACREAR                      TIMESTAMP(6)            NOT NULL ENABLE,
  USUARIOMODIFICAR                VARCHAR2(50 CHAR),
  FECHAMODIFICAR                  TIMESTAMP(6),
  USUARIOBORRAR                   VARCHAR2(50 CHAR),
  FECHABORRAR                     TIMESTAMP(6),
  BORRADO                         NUMBER(1,0)             DEFAULT 0 NOT NULL ENABLE
  )'; 
    


  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

  -- Creamos indice	
  V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(DD_ETG_ID) TABLESPACE '||V_TABLESPACE_IDX;		
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');


  -- Creamos primary key
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (DD_ETG_ID) USING INDEX)';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');


  -- Creamos sequence
  V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
  EXECUTE IMMEDIATE V_MSQL;		
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

  -- Creamos foreign key
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ETQ_TGA_SIN_PROV FOREIGN KEY (DD_TGA_ID) REFERENCES '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO (DD_TGA_ID) ON DELETE SET NULL)';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_ETQ_TGA... Foreign key creada.');

	-- Creamos foreign key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ETQ_STA_SIN_PROV FOREIGN KEY (DD_STG_ID) REFERENCES '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO (DD_STG_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_ETQ_TGA... Foreign key creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');


EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_ETG_ID IS ''Código único tipo gasto con IVA (único)''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_TGA_ID IS ''ID tipo gasto.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_STG_ID IS ''ID subtipo gasto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_ETG_CODIGO IS ''Código''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_ETG_DESCRIPCION_POS IS ''Descripción corta Positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_ETG_DESCRIPCION_LARGA_POS IS ''Descripción larga Positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.CORUG_POS IS ''Código del grupo positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.COTACA_POS IS ''Código del tipo positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.COSBAC_POS IS ''Código del subtipo positivo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_ETG_DESCRIPCION_NEG IS ''Descripción corta negativo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_ETG_DESCRIPCION_LARGA_NEG IS ''Descripción larga negativo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.CORUG_NEG IS ''Código del grupo negativo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.COTACA_NEG IS ''Código del tipo negativo''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA ||'.'||V_TEXT_TABLA||'.COSBAC_NEG IS ''Código del subtipo negativo''';

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
