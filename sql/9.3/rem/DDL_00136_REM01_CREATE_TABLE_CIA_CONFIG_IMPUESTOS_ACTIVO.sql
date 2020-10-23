--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10862
--## PRODUCTO=NO
--## Finalidad: Tabla diccionario para periodicidad
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una sECVencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CIA_CONFIG_IMPUESTOS_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'CIA'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar la configuracion de los impuestos.'; -- Vble. para los comentarios de las tablas
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

	/* -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK, CAMPO FK, TABLA DESTINO FK, CAMPO DESTINO FK
    	T_FK(	'FK_CIA_DD_LOC', 'CIA_LOCALIDAD', V_ESQUEMA_M||'.DD_LOC_LOCALIDAD', 'DD_LOC_ID'),
		T_FK(	'FK_CIA_DD_UPO', 'CIA_MUNICIPIO', V_ESQUEMA_M||'.DD_UPO_UNID_POBLACIONAL', 'DD_UPO_ID'),
		T_FK(	'FK_CIA_DD_STG', 'DD_STG_ID', V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO', 'DD_STG_ID'),
		T_FK(	'FK_CIA_DD_TPE', 'DD_TPE_ID',V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD', 'DD_TPE_ID'),
		T_FK(	'FK_CIA_DD_CAI', 'DD_CAI_ID', V_ESQUEMA||'.DD_CAI_CALCULO_IMPUESTO', 'DD_CAI_ID')
    );
    V_T_FK T_FK;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS >= 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se continua.');
	ELSE
		-- Crear la tabla.
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		(
			CIA_ID 										NUMBER(16,0),
			CIA_LOCALIDAD 								NUMBER(16,0), 				
			CIA_MUNICIPIO 								NUMBER(16,0), 				
			DD_STG_ID 									NUMBER(16,0), 				
			CIA_FECHA_INICIO 							DATE, 					
			CIA_FECHA_FIN 								DATE, 				
			DD_TPE_ID 									NUMBER(16,0),
			DD_CAI_ID 									NUMBER(16,0),
			VERSION 									NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 								VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
			FECHACREAR 									TIMESTAMP (6) 				NOT NULL ENABLE, 
			USUARIOMODIFICAR 							VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 								TIMESTAMP (6), 
			USUARIOBORRAR 								VARCHAR2(50 CHAR), 
			FECHABORRAR 								TIMESTAMP (6), 
			BORRADO 									NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
		)'
		;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
		
		-- Crear el indice.
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'('||V_TEXT_CHARS||'_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
		
		
		-- Crear primary key.
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY ('||V_TEXT_CHARS||'_ID) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
		
		
		-- Crear comentario.
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	END IF;

	-- Comprobar si existe la sECVencia.
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS >= 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se continua.');  
	ELSE
		-- Crear la sequencia.
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	END IF; 

    -- Creamos comentarios columnas
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado''';

 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.CIA_ID IS ''Clave principal''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.CIA_LOCALIDAD IS ''Campo que relaciona con la localidad, tabla DD_LOC_LOCALIDAD''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.CIA_MUNICIPIO IS ''Campo que indica el municipio, tabla DD_UPO_UNID_POBLACIONAL''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_STG_ID IS ''Campo que indica el subtipo de gasto, tabla DD_STG_SUBTIPOS_GASTO''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.CIA_FECHA_INICIO IS ''Campo que indica la fecha de inicio''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.CIA_FECHA_FIN IS ''Campo que indica la decha de fin''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_TPE_ID IS ''Campo que indica el tipo de periodicidad, tabla DD_TPE_TIPOS_PERIOCIDAD''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.DD_CAI_ID IS ''Campo que indica el calculo del impuesto, tabla DD_CAI_CALCULO_IMPUESTO''';

			-- Solo si esta activo el indicador de creacion FK, el script creara tambien las FK
	IF V_CREAR_FK = 'SI' THEN

		-- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
		FOR I IN V_FK.FIRST .. V_FK.LAST
		LOOP

			V_T_FK := V_FK(I);	

			-- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
			V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_FK(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 0 THEN
				--No existe la FK y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_FK(1)||'] -------------------------------------------');
				V_MSQL := '
					ALTER TABLE '||V_TEXT_TABLA||'
					ADD CONSTRAINT '||V_T_FK(1)||' FOREIGN KEY
					(
					  '||V_T_FK(2)||'
					)
					REFERENCES '||V_T_FK(3)||'
					(
					  '||V_T_FK(4)||' 
					)
					ON DELETE SET NULL ENABLE
				';

				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_FK(1)||' creada en tabla: FK en columna '||V_T_FK(2)||' hacia '||V_T_FK(3)||'.'||V_T_FK(4)||'... OK');

			END IF;

		END LOOP;

	END IF;
	
	
	COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT