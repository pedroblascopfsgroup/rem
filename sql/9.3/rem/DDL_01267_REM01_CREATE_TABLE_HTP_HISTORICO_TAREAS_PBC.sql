--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20211224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16673
--## PRODUCTO=NO
--##
--## Finalidad: create HTP_HISTORICO_TAREAS_PBC
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el diccionario de tipos de tareas PBC.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('******** HTP_HISTORICO_TAREAS_PBC ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''HTP_HISTORICO_TAREAS_PBC'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.HTP_HISTORICO_TAREAS_PBC... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC CASCADE CONSTRAINTS';
		
	END IF;
	
	
	--Verificar si la secuencia existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_HTP_HISTORICO_TAREAS_PBC'' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_SEQ;	
	
	IF V_NUM_SEQ = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_HTP_HISTORICO_TAREAS_PBC... Ya existe. Se borrara.');
		EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_HTP_HISTORICO_TAREAS_PBC';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.HTP_HISTORICO_TAREAS_PBC...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC
	(
		HTP_ID           						NUMBER(16)                  NOT NULL,
		OFR_ID									NUMBER(16)                  NOT NULL,
		DD_TPB_ID								NUMBER(16)                  NOT NULL,
		HTP_ACTIVA 								NUMBER(1,0) 				DEFAULT 1 NOT NULL,
		HTP_APROBACION							NUMBER(1,0), 
		HTP_FECHA_SANCION						TIMESTAMP (6), 		
		HTP_INFORME		  						VARCHAR2(250 CHAR),
		HTP_FECHA_SOLICITUD_CALCULO_RIESGO		TIMESTAMP (6),
		HTP_FECHA_COMUNICACION_RIESGO			TIMESTAMP (6),
		HTP_FECHA_ENVIO_DOCUMENTACION_BC		TIMESTAMP (6), 		 		
		VERSION 								NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 							VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 								TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 						VARCHAR2(10 CHAR), 
		FECHAMODIFICAR 							TIMESTAMP (6), 
		USUARIOBORRAR 							VARCHAR2(10 CHAR), 
		FECHABORRAR 							TIMESTAMP (6), 
		BORRADO 								NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC... Tabla creada.');
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC... Tabla creada.');
	
	-- Creamos indice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC_PK ON '||V_ESQUEMA|| '.HTP_HISTORICO_TAREAS_PBC(HTP_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC_PK... Indice creado.');
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC ADD (CONSTRAINT HTP_HISTORICO_TAREAS_PBC_PK PRIMARY KEY (HTP_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC_PK... PK creada.');

	-- Creamos clave ajena
	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.HTP_HISTORICO_TAREAS_PBC ADD CONSTRAINT FK_HTP_OFR_ID FOREIGN KEY (OFR_ID)' ||
    '  REFERENCES  ' || V_ESQUEMA || '.OFR_OFERTAS (OFR_ID)';
	EXECUTE IMMEDIATE V_SQL; 
        
    V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.HTP_HISTORICO_TAREAS_PBC ADD CONSTRAINT FK_HTP_DD_TPB_ID FOREIGN KEY (DD_TPB_ID)' ||
    '  REFERENCES  ' || V_ESQUEMA || '.DD_TPB_TIPO_TAREA_PBC (DD_TPB_ID)';
	EXECUTE IMMEDIATE V_SQL; 
	
	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_HTP_HISTORICO_TAREAS_PBC';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_HTP_HISTORICO_TAREAS_PBC... Secuencia creada');
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC... OK');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'HistoricoTareasAS_PBC.HTP_ID IS ''Identificador único ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_ID creado.');
			
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.OFR_ID IS ''FK a OFR_OFERTAS ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OFR_ID creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.DD_TPB_ID IS ''FK a DD_TPB_TIPO_TAREA_PBC ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPB_ID creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_ACTIVA IS ''activo historico ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_ACTIVA creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_ACTIVA IS ''activo historico ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_ACTIVA creado.');
			
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_APROBACION IS ''esta aprobado o no ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_APROBACION creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_FECHA_SANCION IS ''fecha de la sancion ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_FECHA_SANCION creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_INFORME IS ''informe del PBC ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_INFORME creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_FECHA_SOLICITUD_CALCULO_RIESGO IS ''fecha de la solicitud del calculo de riesgo ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_FECHA_SOLICITUD_CALCULO_RIESGO creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_FECHA_COMUNICACION_RIESGO IS ''fecha de la solicitud de comunicacion de riesgo ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_FECHA_COMUNICACION_RIESGO creado.');
			
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.HTP_FECHA_ENVIO_DOCUMENTACION_BC IS ''fecha de encio de documentacion BC ''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna HTP_FECHA_ENVIO_DOCUMENTACION_BC creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.VERSION IS ''Indica la versión del registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
			
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.HTP_HISTORICO_TAREAS_PBC.BORRADO IS ''Indicador de borrado.''';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');
	 


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