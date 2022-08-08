--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20220808
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18480
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
--## INSTRUCCIONES: Crear tabla para Conductas Inapropiadas ACI_ADJUNTO_CONDUCTAS_INAPROPIADAS
--## VERSIONES:
--##        0.1 Versión inicial HREOS-18480
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACI_ADJUNTO_CONDUCTAS_INAPROPIADAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla en la que se almacenarán ACI_ADJUNTO_CONDUCTAS_INAPROPIADAS.'; -- Vble. para los comentarios de las tablas

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe la tabla.');

	ELSE
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.' || V_TEXT_TABLA || ' (
            ACI_ID							    NUMBER(16,0),
            DD_TDC_ID						    NUMBER(16,0),
            ADJ_ID		                        NUMBER(16,0),
            ACI_NOMBRE 					        VARCHAR2(255 CHAR),
            ACI_CONTENT_TYPE 			        VARCHAR2(100 CHAR) ,
            ACI_LENGTH 			                NUMBER(16,0) ,
            ACI_DESCRIPCION                     VARCHAR2(1024 CHAR),            
            ACI_FECHA_DOCUMENTO                 DATE,
            ACI_ID_DOCUMENTO_REST               NUMBER(16,0),
            VERSION                             NUMBER(1,0)               DEFAULT 0,
            USUARIOCREAR					    VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
            FECHACREAR						    TIMESTAMP (6)		NOT NULL ENABLE, 
            USUARIOMODIFICAR				    VARCHAR2(50 CHAR), 
            FECHAMODIFICAR					    TIMESTAMP (6), 
            USUARIOBORRAR					    VARCHAR2(50 CHAR), 
            FECHABORRAR						    TIMESTAMP (6), 
            BORRADO							    NUMBER(1,0)			DEFAULT 0 NOT NULL ENABLE,

			CONSTRAINT PK_ADJUNTO_CONDUCTAS_INAPROPIADAS_ID PRIMARY KEY (ACI_ID),     
            CONSTRAINT FK_ACI_TDC_TIPO_DOCUMENTO_CONDUCTAS_INAPROPIADAS FOREIGN KEY (DD_TDC_ID) REFERENCES DD_TDC_TIPO_DOCUMENTO_CONDUCTAS_INAPROPIADAS(DD_TDC_ID),
            CONSTRAINT FK_ACI_CONDUCTAS_INAPROPIADAS_ADJ_ADJUNTOS FOREIGN KEY (ADJ_ID) REFERENCES ADJ_ADJUNTOS(ADJ_ID),
            CONSTRAINT UNIQUE_ACI_CONDUCTAS_INAPROPIADAS_ADJ_ID UNIQUE (ADJ_ID),
			CONSTRAINT UNIQUE_ACI_CONDUCTAS_INAPROPIADAS_ACI_ID UNIQUE (ACI_ID_DOCUMENTO_REST)
			)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
	--Creamos comentario
EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.' || V_TEXT_TABLA || ' IS ''Tabla para adjuntos de auto propiedad.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_ID IS ''PK Identificador único del adjunto gasto asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.DD_TDC_ID IS ''FK con DD_TDC_TIPO_DOCUMENTO_CONDUCTAS_INAPROPIADAS''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ADJ_ID IS ''identificador del adjunto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_NOMBRE IS ''nombre adjunto gasto asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_CONTENT_TYPE IS ''Tipo de contenido del documento gasto asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_LENGTH IS ''identificador del adjunto''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_DESCRIPCION IS ''Descripción breve del documento gasto asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_FECHA_DOCUMENTO IS ''Fecha de subida del documento gasto asociado''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.ACI_ID_DOCUMENTO_REST IS ''Identificador gestor documental''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.VERSION IS ''Indica la versión del registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.' || V_TEXT_TABLA || '.BORRADO IS ''Indicador de borrado''';

END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe la secuencia.');  
	ELSE
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
	END IF;


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

EXIT;