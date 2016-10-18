--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-962
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'ACT_HAL_HIST_ALQUILERES'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_HAL_HIST_ALQUILERES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el histórico de alquileres.'; -- Vble. para los comentarios de las tablas

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
        HAL_ID                                                       NUMBER(16,0)			                NOT NULL,
        ACT_ID                                                         NUMBER(16,0)			                NOT NULL,
        HAL_NUMERO_CONTRATO_ALQUILER              NUMBER(16,0),
        DD_ESC_ID                                                   NUMBER(16,0),
        HAL_FECHA_INICIO_CONTRATO                      DATE,
        HAL_FECHA_FIN_CONTRATO                          DATE,
        HAL_FECHA_RESOLUCION_CONTRATO             DATE,
        HAL_IMPORTE_RENTA_CONTRATO                  NUMBER(16,2),
        HAL_PLAZO_OPCION_COMPRA                         DATE,
        HAL_PRIMA_OPCION_COMPRA                         NUMBER(16,2),
        HAL_PRECIO_OPCION_COMPRA                        NUMBER(16,2),
        HAL_CONDICIONES_OPCION_COMPRA               VARCHAR(256 CHAR),
        HAL_IND_CONFLICTO_INTERESES                     NUMBER(1,0),
        HAL_IND_RIESGO_REPUTACIONAL                   NUMBER(1,0),
        HAL_GASTOS_IBI                                            NUMBER(16,2),
        DD_TPC_ID_IBI                                               NUMBER(16,0),
        HAL_GASTOS_COMUNIDAD                             NUMBER(16,2),
        DD_TPC_ID_COM                                            NUMBER(16,0),
        DD_TPC_ID_SUMINISTRO                                 NUMBER(16,0),
        VERSION                                               NUMBER(38,0) 			                DEFAULT 0 NOT NULL ENABLE, 
        USUARIOCREAR                                      VARCHAR2(50 CHAR) 		        NOT NULL ENABLE, 
        FECHACREAR                                       TIMESTAMP (6) 			                NOT NULL ENABLE, 
        USUARIOMODIFICAR                                  VARCHAR2(50 CHAR), 
        FECHAMODIFICAR                                   TIMESTAMP (6), 
        USUARIOBORRAR                                     VARCHAR2(50 CHAR), 
        FECHABORRAR                                       TIMESTAMP (6), 
        BORRADO                                             NUMBER(1,0) 			                  DEFAULT 0 NOT NULL ENABLE 
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(HAL_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (HAL_ID) USING INDEX)';
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

	--Comprobamos si existe foreign key FK_HAL_ACT_ID
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_HAL_ACT_ID'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID... Ya existe. No hacemos nada.');		
	ELSE
        -- Creamos foreign key FK_HAL_ACT_ID
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_HAL_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID) ON DELETE SET NULL)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_HAL_ACT_ID... Foreign key creada.');
	END IF;  
  
	--Comprobamos si existe foreign key FK_DD_TPC_ID_IBI
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_DD_TPC_ID_IBI'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_IBI... Ya existe. No hacemos nada.');		
	ELSE
        -- Creamos foreign key FK_DD_TPC_ID_IBI
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_TPC_ID_IBI FOREIGN KEY (DD_TPC_ID_IBI) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_TPC_ID_IBI... Foreign key creada.');
	END IF;  
  
  	--Comprobamos si existe foreign key FK_DD_TPC_ID_COM
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_DD_TPC_ID_COM'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_COM... Ya existe. No hacemos nada.');		
	ELSE
        -- Creamos foreign key FK_DD_TPC_ID_COM
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_TPC_ID_COM FOREIGN KEY (DD_TPC_ID_COM) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_TPC_ID_COM... Foreign key creada.');
	END IF;
    
  	--Comprobamos si existe foreign key FK_DD_TPC_ID_SUMINISTRO
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_DD_TPC_ID_SUMINISTRO'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_SUMINISTRO... Ya existe. No hacemos nada.');		
	ELSE
        -- Creamos foreign key FK_DD_TPC_ID_SUMINISTRO
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_TPC_ID_SUMINISTRO FOREIGN KEY (DD_TPC_ID_SUMINISTRO) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_TPC_ID_SUMINISTRO... Foreign key creada.');
	END IF; 
  
  -- Comentarios
  V_TEXT1 := 'Código identificador único del alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_ID IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Código identificador único del activo.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Numero de contrato alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_NUMERO_CONTRATO_ALQUILER IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Código del Estado del Contrato.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ESC_ID IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Fecha de Inicio del Contrato de Alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_FECHA_INICIO_CONTRATO IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Fecha de Fin del Contrato de Alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_FECHA_FIN_CONTRATO IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Fecha de Efectiva de Resolucion del Contrato de Alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_FECHA_RESOLUCION_CONTRATO IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Importe de la Renta del Alquiler.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_IMPORTE_RENTA_CONTRATO IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Fecha del Plazo para Opción de Compra.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_PLAZO_OPCION_COMPRA IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Importe de la Prima de la Opción de Compra.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_PRIMA_OPCION_COMPRA IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Importe del Precio de la Opción de Compra.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_PRECIO_OPCION_COMPRA IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Condiciones de la Opción de Compra.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_CONDICIONES_OPCION_COMPRA IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Indicador de si hay Conflicto de Intereses.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_IND_CONFLICTO_INTERESES IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Indicador de si hay Riesgo Reputacional.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_IND_RIESGO_REPUTACIONAL IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Importe de los Gastos del IBI.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_GASTOS_IBI IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Código del tipo por cuenta de la persona o ley de Otros Gastos.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_IBI IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Importe de los Gastos de la Comunidad.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.HAL_GASTOS_COMUNIDAD IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Código del tipo por cuenta de la persona o ley de Otros Gastos.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_COM IS '''||V_TEXT1||'''  ';
  
  V_TEXT1 := 'Código del tipo por cuenta de la persona o ley de Otros Gastos.';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPC_ID_SUMINISTRO IS '''||V_TEXT1||'''  ';
  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';

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
