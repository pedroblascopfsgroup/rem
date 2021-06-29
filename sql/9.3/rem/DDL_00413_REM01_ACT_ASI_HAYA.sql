--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-14371
--## PRODUCTO=NO
--## Finalidad: Interfaz Stock REM - UVEM - Tabla asignacion numero activo HAYA 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-1826] - Teresa Alonso
--##        0.2 Añadir campo ACT_NUM_ACTIVO_CAIXA como PK e insertar con los datos de ACT_ASI_HAYA_BACKUP- [HREOS-14371] - Alejandra García
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2( 25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2( 4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER( 16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER( 16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2( 2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2( 2400 CHAR) := 'ACT_ASI_HAYA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2( 500 CHAR):= 'Tabla asignación para un activo de Caixa, el número activo HAYA.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT( 1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	-- Comprobamos si existe la secuencia
--	V_SQL := 'SELECT COUNT( 1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
--	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
--	IF V_NUM_TABLAS = 1 THEN
--		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
--		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
--		
--	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(	
		ACT_NUM_ACTIVO_CAIXA 			VARCHAR2(8 CHAR),
		ACT_NUM_ACTIVO_UVEM				NUMBER(16,0),
		ACT_NUM_ACTIVO					NUMBER(16,0), 
		FEC_ASIGNACION					DATE,
		FEC_ALTA_ACTIVO					DATE,
		VERSION							NUMBER(38,0)  		DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR					VARCHAR2(50 CHAR) 	NOT NULL ENABLE, 
		FECHACREAR						TIMESTAMP(6) 		NOT NULL ENABLE, 
		USUARIOMODIFICAR				VARCHAR2(50 CHAR),
		FECHAMODIFICAR					TIMESTAMP(6),
		USUARIOBORRAR					VARCHAR2(50 CHAR),
		FECHABORRAR						TIMESTAMP(6),
		BORRADO							NUMBER(1,0) 		DEFAULT 0

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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.ACT_NUM_ACTIVO_CAIXA_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ACT_NUM_ACTIVO_CAIXA) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_NUM_ACTIVO_CAIXA_PK... Indice creado.');	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT ACT_NUM_ACTIVO_CAIXA_PK PRIMARY KEY (ACT_NUM_ACTIVO_CAIXA) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_NUM_ACTIVO_CAIXA_PK ... PK creada.');	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_NUM_ACTIVO_CAIXA IS ''Código identificador único del activo en Caixa.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_NUM_ACTIVO_UVEM IS ''Código identificador único del activo en UVEM.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_NUM_ACTIVO IS ''Código identificador único del activo en HAYA.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEC_ASIGNACION IS ''Fecha asignación por parte de HAYA.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEC_ALTA_ACTIVO IS ''Fecha alta del activo en REM (se asignará automaticamente , Haya no tiene que poner ninguna fecha).''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VERSION IS ''Indica la version del registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
   	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
	
	COMMIT;

	--Ahora rellenamos la tabla con la ACT_ASi_HAYA_BACKUP 
	--(En ACT_NUM_ACTIVO_CAIXA metemos el ACT_NUM_ACTIVO_UVEM porque todavía no han enviado el ACT_NUM_ACTIVO_CAIXA correspondiente)
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
							 (   ACT_NUM_ACTIVO_CAIXA
								,ACT_NUM_ACTIVO_UVEM	
								,ACT_NUM_ACTIVO		
								,FEC_ASIGNACION		
								,FEC_ALTA_ACTIVO		
								,VERSION				
								,USUARIOCREAR		
								,FECHACREAR	
								,USUARIOMODIFICAR	
								,FECHAMODIFICAR		
								,USUARIOBORRAR		
								,FECHABORRAR			
								,BORRADO	
							  )
							SELECT 
								 BK.ACT_NUM_ACTIVO_UVEM
								,BK.ACT_NUM_ACTIVO_UVEM
								,BK.ACT_NUM_ACTIVO
								,BK.FEC_ASIGNACION
								,BK.FEC_ALTA_ACTIVO
								,BK.VERSION				
								,BK.USUARIOCREAR		
								,BK.FECHACREAR	
								,BK.USUARIOMODIFICAR	
								,BK.FECHAMODIFICAR		
								,BK.USUARIOBORRAR		
								,BK.FECHABORRAR			
								,BK.BORRADO
							 FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_BACKUP BK';
		    	
	EXECUTE IMMEDIATE V_MSQL;


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

EXIT;
