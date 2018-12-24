--/*
--##########################################
--## AUTOR=Jose Luis Barba Ribera
--## FECHA_CREACION=20180926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4484
--## PRODUCTO=NO
--## Finalidad: Creacion de tabla para el calculo de honorarios de activos en alquiler
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TRF_HONORARIO_ALQUILER'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

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
			TRF_ID           		NUMBER(16, 0) NOT NULL,
			TRF_LLAVES_HRE        		NUMBER(1,0),
			DD_TPR_CODIGO			VARCHAR2(20 CHAR),
			TRF_PRC_COLAB			NUMBER(5,2),
			TRF_PRC_PRESC			NUMBER(5,2),
			VERSION 			NUMBER(38,0) 		   DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 			VARCHAR2(50 CHAR) 	   NOT NULL ENABLE, 
			FECHACREAR 			TIMESTAMP (6) 		   NOT NULL ENABLE, 
			USUARIOMODIFICAR 		VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 			TIMESTAMP (6), 
			USUARIOBORRAR 			VARCHAR2(50 CHAR), 
			FECHABORRAR 			TIMESTAMP (6), 
			BORRADO 			NUMBER(1,0) 		   DEFAULT 0 NOT NULL ENABLE
		)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (TRF_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
		  
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		END IF;

		
		-- Creamos el comentario de las columnas
		DBMS_OUTPUT.PUT_LINE('[INFO] Inicio añadir Comentarios de la columna COMMENTS.');
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TRF_LLAVES_HRE IS ''Código es custodio de llaves o no''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.DD_TPR_CODIGO IS ''Código tipo de proveedor''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TRF_PRC_COLAB IS ''Código identificador colaboración''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TRF_PRC_PRESC IS ''Código identificador prescripción''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VERSION IS ''Indica la version del registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
   		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
		DBMS_OUTPUT.PUT_LINE('[INFO] Fin añadir Comentarios de la columna COMMENTS.');
		COMMIT;
	END IF;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
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
