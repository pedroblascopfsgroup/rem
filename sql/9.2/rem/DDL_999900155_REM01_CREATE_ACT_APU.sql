--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20180320
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3897
--## PRODUCTO=NO
--##
--## Finalidad:            
--## INSTRUCCIONES: 
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
	ELSE 
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
			APU_ID           			NUMBER(16,0) NOT NULL,
			ACT_ID        				NUMBER(16,0) NOT NULL,
			DD_TPU_ID				NUMBER(16,0),
			DD_EPV_ID				NUMBER(16,0),
			DD_EPA_ID                               NUMBER(16,0),
			DD_TCO_ID                               NUMBER(1,0) NOT NULL,
			DD_MTO_V_ID				NUMBER(16,0),
<<<<<<< HEAD
			APU_MOT_OCULTACION_MANUAL_V		VARCHAR2(250 CHAR),
			APU_CHECK_PUBLICAR_V			NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_OCULTAR_V			NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_OCULTAR_PRECIO_V		NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_PUB_SIN_PRECIO_V		NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			DD_MTO_A_ID				NUMBER(16,0),
			APU_MOT_OCULTACION_MANUAL_A		VARCHAR2(250 CHAR),
			APU_CHECK_PUBLICAR_A			NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_OCULTAR_A			NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_OCULTAR_PRECIO_A		NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
			APU_CHECK_PUB_SIN_PRECIO_A		NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
=======
			APU_MOT_OCULTACION_DESC_V		VARCHAR2(250 CHAR),
			APU_CHECK_PUBLICAR_V			NUMBER(1,0),
			APU_CHECK_OCULTAR_V			NUMBER(1,0),
			APU_CHECK_OCULT_PRECIO_V		NUMBER(1,0),
			APU_CHECK_PUB_SIN_PRECIO_V		NUMBER(1,0),
			DD_MTO_A_ID				NUMBER(16,0),
			APU_MOT_OCULTACION_DESC_A		VARCHAR2(250 CHAR),
			APU_CHECK_PUBLICAR_A			NUMBER(1,0),
			APU_CHECK_OCULTAR_A			NUMBER(1,0),
			APU_CHECK_OCULT_PRECIO_A		NUMBER(1,0),
			APU_CHECK_PUB_SIN_PRECIO_A		NUMBER(1,0),
>>>>>>> b64dfb9... Revert "Comentarios añadidos"
			APU_FECHA_INI_VENTA			DATE,
			APU_FECHA_INI_ALQUILER			DATE,
			VERSION 				NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 				VARCHAR2(50 CHAR) NOT NULL ENABLE, 
			FECHACREAR 				TIMESTAMP (6) NOT NULL ENABLE, 
			USUARIOMODIFICAR 			VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 				TIMESTAMP (6), 
			USUARIOBORRAR 				VARCHAR2(50 CHAR), 
			FECHABORRAR 				TIMESTAMP (6), 
			BORRADO 				NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
		)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (APU_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

		--Creamos foreign keys
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_ACT_ID_APU FOREIGN KEY (ACT_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.ACT_ACTIVO (ACT_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_ACT_ID creada.');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_TPU_ID_APU FOREIGN KEY (DD_TPU_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION (DD_TPU_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_TPU_ID creada.');
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_EPV_ID_APU FOREIGN KEY (DD_EPV_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA (DD_EPV_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_EPV_ID creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_EPA_ID_APU FOREIGN KEY (DD_EPA_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER (DD_EPA_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_EPA_ID creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_TCO_ID_APU FOREIGN KEY (DD_TCO_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION (DD_TCO_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_TCO_ID creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_MTO_V_ID_APU FOREIGN KEY (DD_MTO_V_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION (DD_MTO_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_MTO_V_ID creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DD_MTO_A_ID_APU FOREIGN KEY (DD_MTO_A_ID) '||
        	'  REFERENCES  '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION (DD_MTO_ID)';
        	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] FK_DD_MTO_A_ID creada.');
	
<<<<<<< HEAD
		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
		  
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		END IF;
		
		-- Creamos comentarios
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla de la publicación de los activos.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la tabla creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_ID IS ''Código identificador único de la publicación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_ID creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_ID IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna ACT_ID creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TPU_ID IS ''Código identificador único de la tabla tipo de publicación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TPU_ID creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_EPV_ID IS ''Código identificador único de la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_EPV_ID creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_EPA_ID IS ''Código identificador único del alquiler.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_EPA_ID creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TCO_ID IS ''Código identificador único de la comercialización.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TCO_ID creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_MTO_V_ID IS ''Código identificador único del motivo de la ocultación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_MTO_V_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_MOT_OCULTACION_MANUAL_V IS ''Descripción del motivo de la ocultación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_MOT_OCULTACION_MANUAL_V creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_PUBLICAR_V IS ''Check de publicar la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_PUBLICAR_V creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_OCULTAR_V IS ''Check de ocultar la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_OCULTAR_V creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_OCULTAR_PRECIO_V IS ''Check de publicar precio de la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_OCULT_PRECIO_V creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_PUB_SIN_PRECIO_V IS ''Check de publicación sin precio de la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_PUB_SIN_PRECIO_V creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_MTO_A_ID IS ''Código identificador único del motivo de la ocultación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_MTO_A_ID creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_MOT_OCULTACION_MANUAL_A IS ''Descripción del motivo de la ocultación.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_MOT_OCULTACION_MANUAL_A creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_PUBLICAR_A IS ''Check de publicar el alquiler.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_PUBLICAR_A creado.');	
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_OCULTAR_A IS ''Check de ocultar el alquiler.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_OCULTAR_A creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_OCULTAR_PRECIO_A IS ''Check de publicar precio del alquilera.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_OCULT_PRECIO_A creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_CHECK_PUB_SIN_PRECIO_A IS ''Check de publicación sin precio del alquiler.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_CHECK_PUB_SIN_PRECIO_A creado.');	

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_FECHA_INI_VENTA IS ''Fecha inicio de la venta.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_FECHA_INI_VENTA creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.APU_FECHA_INI_ALQUILER IS ''Fecha inicio del alquiler.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna APU_FECHA_INI_ALQUILER creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');
		
=======
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

>>>>>>> b64dfb9... Revert "Comentarios añadidos"
		COMMIT;
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

EXIT
