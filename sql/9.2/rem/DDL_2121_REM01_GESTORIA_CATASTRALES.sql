-/*
--######################################### 
--## AUTOR=Joaquin_Arnal 
--## FECHA_CREACION=20161201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1210
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas de tablas auxiliares de aprovisionamiento para fichero de gestorias NOMGESTORIA_GASTOS_GR_YYYYMMDD.dat
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
	V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
	V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
	V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	table_count number(3); -- Vble. para validar la existencia de las Tablas.

    TABLE_COUNT NUMBER(1,0) := 0;
    V_TABLA VARCHAR2(40 CHAR) := '';
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
   	V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas
    
    V_COL_TABLE_FK VARCHAR2(500 CHAR):= ''; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la columna referencia de un campo que es FK

	V_COL2_TABLE_FK VARCHAR2(500 CHAR):= ''; -- Vble. para indicar un campo que es FK_2
	V_COL2_TABLE_FK_TAB_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la tabla referencia de un campo que es FK_2
	V_COL2_TABLE_FK_COL_PARENT VARCHAR2(500 CHAR):= ''; -- Vble. para la columna referencia de un campo que es FK_2

BEGIN

	/***** APR_AUX_CAT_CATASTRAL_GR *****/
	
	V_TABLA := 'APR_AUX_CAT_CATASTRAL_GR';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar el fichero de catastrales que dan de alta las agencias';

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
		(
			ID_ACTIVO 		NUMBER (16,0) 		NOT NULL 	
			, REF_CATASTRAL 	VARCHAR2 (50 CHAR) 	NOT NULL 	
			, VAL_CATRASTAL_SUELO 	NUMBER (16,2)	
			, VAL_CATRASTAL_CONST 	NUMBER (16,2)			
			, FECHA_REV_VALOR_CAST 	DATE
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

	
	/***** APR_AUX_CAT_CATASTRAL_GR_REJ *****/
	
	V_TABLA := 'APR_AUX_CAT_CATASTRAL_GR_REJ';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar los rechazos generados en la carga del fichero de catastrales que dan de alta las agencias.';
	V_COL_TABLE_FK := 'DD_MRC_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRC_MOTIVO_RECH_CATAS'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRC_ID'; -- Vble. para la columna referencia de un campo que es FK

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
	END IF;
	
	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
		(
			ID_ACTIVO 		VARCHAR2 (17 CHAR) 		
			, REF_CATASTRAL 	VARCHAR2 (50 CHAR) 	
			, VAL_CATRASTAL_SUELO 	VARCHAR2 (17 CHAR) 	
			, VAL_CATRASTAL_CONST 	VARCHAR2 (17 CHAR) 				
			, FECHA_REV_VALOR_CAST 	VARCHAR2 (8 CHAR) 	
			, ERRORCODE		VARCHAR2 (512 CHAR)
			, ERRORMESSAGE		VARCHAR2 (1024 CHAR)
			, DD_MRC_ID 		NUMBER (16)
	)';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada');  

	-- Creamos foreing key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT APR_AUX_GG_REJ_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_MSQL||'.');
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... PK creada.');

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

	/***** H_CAR_CAT_CATRASTAL_RECH *****/
	
	V_TABLA := 'H_CAR_CAT_CATRASTAL_RECH';
	V_COMMENT_TABLE := 'Tabla historica con los gastos rechazados en la carga de ficheros de gastos que recibimos de las agencias.';
	V_COL_TABLE_FK := 'DD_MRC_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRC_MOTIVO_RECH_CATAS'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRC_ID'; -- Vble. para la columna referencia de un campo que es FK

	V_COL2_TABLE_FK := 'DD_GRF_ID'; -- Vble. para indicar un campo que es FK
	V_COL2_TABLE_FK_TAB_PARENT := 'DD_GRF_GESTORIA_RECEP_FICH'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL2_TABLE_FK_COL_PARENT := 'DD_GRF_ID'; -- Vble. para la columna referencia de un campo que es FK

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Revisar definicion de la tabla para comprobar la tabla.');
	ELSE 
		EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				(	
					H_CAR_ID		NUMBER (16)
					, DD_GRF_ID 		NUMBER (16)
					, DD_MRC_ID 		NUMBER (16)
					, FICHERO 		VARCHAR2 (200 CHAR)
					, USUARIOCREAR 		VARCHAR2 (100 CHAR)
					, FECHACREAR 		DATE 
					, ERRORCODE		VARCHAR2 (512 CHAR)
					, ERRORMESSAGE		VARCHAR2 (1024 CHAR)		
					, ID_ACTIVO 		VARCHAR2 (17 CHAR) 		
					, REF_CATASTRAL 	VARCHAR2 (50 CHAR) 	
					, VAL_CATRASTAL_SUELO 	VARCHAR2 (17 CHAR) 	
					, VAL_CATRASTAL_CONST 	VARCHAR2 (17 CHAR) 				
					, FECHA_REV_VALOR_CAST 	VARCHAR2 (8 CHAR) 
				)
				LOGGING 
				NOCOMPRESS 
				NOCACHE
				NOPARALLEL
				NOMONITORING
				';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	

			-- Creamos indice	
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(H_CAR_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
	
	
			-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (H_CAR_ID) USING INDEX)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');


			-- Creamos foreing key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_CAR_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK creada ('||V_COL_TABLE_FK||').');

			-- Creamos foreing key2
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_CAR_FK_'||V_COL2_TABLE_FK||' FOREIGN KEY ('||V_COL2_TABLE_FK||') REFERENCES '||V_COL2_TABLE_FK_TAB_PARENT||'  ('||V_COL2_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... PFK creada ('||V_COL2_TABLE_FK||').');

			-- Verificar si la secuencia ya existe y borrarla
			V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 1 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Ya existe. Se borrará.');
				EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
			END IF;
		
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');

	
			-- Creamos comentario	
			V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');


			COMMIT;
	END IF;
	
	


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

