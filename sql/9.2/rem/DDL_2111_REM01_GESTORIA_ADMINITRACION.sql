-/*
--######################################### 
--## AUTOR=Joaquin_Arnal 
--## FECHA_CREACION=20161122
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1091
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

	/***** APR_AUX_ENT_ENTIDADES_GR *****/
	
	V_TABLA := 'APR_AUX_ENT_ENTIDADES_GR';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar el fichero de entidades que dan de alta las agencias';

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
			TIPO_ENTIDAD 				VARCHAR2 (20 CHAR) 		NOT NULL 	
			, SUBTIPO_ENTIDAD 			VARCHAR2 (20 CHAR) 		NOT NULL 	
			, NIF_ENTIDAD 				VARCHAR2 (50 CHAR) 	
			, ID_ENTIDAD_GESTORIA 		NUMBER (9,0)			
			, NOMBRE_ENTIDAD 			VARCHAR2 (250 CHAR)
			, LOCALIZADA 				NUMBER (1,0) 			NOT NULL				
			, ESTADO 					VARCHAR2 (20 CHAR)
			, FECHA_CONSTITUCION 		DATE 
			, CUENTA_BANC 				VARCHAR2 (50 CHAR)			 	
			, TITULAR_CUENTA_BANC   	VARCHAR2 (50 CHAR)  	 	
			, CONTACTO_PRINCIPAL  		NUMBER (1,0) 		 	
			, NOMBRE_CONTACTO			VARCHAR2 (50 CHAR)
			, APELL_1_CONTACTO 			VARCHAR2 (50 CHAR)  	
			, APELL_2_CONTACTO 			VARCHAR2 (50 CHAR) 			 	
			, CARGO_CONTACTO    		VARCHAR2 (20 CHAR) 			
			, NIF_CONTACTO 				VARCHAR2 (50 CHAR) 				  			
			, CODIGO_USUARIO_CONTACTO	VARCHAR2 (20 CHAR) 	 			
			, TELEFONO_CONTACTO			VARCHAR2 (20 CHAR)  		 	
			, EMAIL_CONTACTO			VARCHAR2 (50 CHAR) 	
			, DIRECCION_CONTACTO		VARCHAR2 (250 CHAR) 							
			, FECHA_ALTA_CONTACTO		DATE
			, FECHA_BAJA_CONTACTO		DATE
			, OBSERVACIONES_CONTACTO	VARCHAR2 (400 CHAR)
			, DOCU_NIF_CONTACTO			VARCHAR2 (20 CHAR)
			, ESTADO_CONTACTO			VARCHAR2 (20 CHAR)
			, ID_ACTIVO 				NUMBER (16,0)
			, PORCEN_PARTICIPACION 		NUMBER (5,2)
			, FECHA_INCLUSION  			DATE
			, FECHA_EXCLUSION 			DATE
			, MOTIVO_EXCLUSION			VARCHAR2 (400 CHAR)
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_ENTIDAD IS ''Según diccionario. Se utilizará solo para proveedores del tipo -entidad-. '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.SUBTIPO_ENTIDAD IS ''Según diccionario (34). Obligatorio'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NIF_ENTIDAD IS ''NIF de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_ENTIDAD_GESTORIA IS ''Si no se dispone de NIF, la gestoría generará un autonumérico de 9 dígitos único para cada caso, donde los dos primeros dígitos serán la clave de la gestoría.'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NOMBRE_ENTIDAD IS ''Nombre Entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.LOCALIZADA IS ''0: NO / 1:SI'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ESTADO IS ''Según diccionario para entidades (tabla 18 funcional administración). - Pendiente de constitución: a tramitar - Pendiente de constitución: no tramitar - En proceso de constitución - Vigente - En liquidación - Disuelta - Baja como proveedor'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_CONSTITUCION IS ''Fecha de constitucion de la empresa'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CUENTA_BANC IS ''IBAN'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TITULAR_CUENTA_BANC IS ''Titular cuenta bancaria'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CONTACTO_PRINCIPAL  IS ''0: NO / 1:SI. Indicador de que la persona es el contacto principal de la entidad. Solo uno por entidad.'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NOMBRE_CONTACTO IS ''Nombre del contacto de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.APELL_1_CONTACTO IS ''Primer apellido del contacto de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.APELL_2_CONTACTO IS ''Segundo apellido del contacto de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CARGO_CONTACTO IS ''Presidente, Secretario, Tesorero, Administrador, Otro... '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NIF_CONTACTO IS ''NIF del contacto de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CODIGO_USUARIO_CONTACTO IS ''Para proveedores con acceso a REM'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TELEFONO_CONTACTO IS ''Telefono de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.EMAIL_CONTACTO IS ''Telefono de la entidad'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.DIRECCION_CONTACTO IS ''Direccion de la entidad'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_ALTA_CONTACTO IS ''Fecha de alta de la entidad'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_BAJA_CONTACTO IS ''Fecha de baja de la entidad'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.OBSERVACIONES_CONTACTO IS ''Observaciones'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.DOCU_NIF_CONTACTO IS ''Según diccionario: - NIF - Cuenta bancaria - Escritura constitución - Escritura modificación estatutos'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ESTADO_CONTACTO IS ''Según diccionario: - No obtenido - Reclamado - Reclamado por burofax - Obtenido'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_ACTIVO IS '' '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PORCEN_PARTICIPACION IS '' '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_INCLUSION IS '' '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_EXCLUSION IS '' '' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.MOTIVO_EXCLUSION IS ''Texto libre'' ';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' Ponemos comentario en los campos de la tabla.'); 

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

	
	/***** APR_AUX_ENT_ENTIDADES_GR_REJ *****/
	
	V_TABLA := 'APR_AUX_ENT_ENTIDADES_GR_REJ';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar los rechazos generados en la carga del fichero de entidades que dan de alta las agencias.';
	V_COL_TABLE_FK := 'DD_MRE_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRE_MOTIVO_RECH_ENTIDAD'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRE_ID'; -- Vble. para la columna referencia de un campo que es FK

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
			TIPO_ENTIDAD 				VARCHAR2 (20 CHAR)  	
			, SUBTIPO_ENTIDAD 			VARCHAR2 (20 CHAR) 	 	
			, NIF_ENTIDAD 				VARCHAR2 (50 CHAR) 
			, ID_ENTIDAD_GESTORIA 		VARCHAR2 (10 CHAR)			
			, NOMBRE_ENTIDAD 			VARCHAR2 (250 CHAR)
			, LOCALIZADA 				VARCHAR2 (2 CHAR) 						
			, ESTADO 					VARCHAR2 (20 CHAR)
			, FECHA_CONSTITUCION 		VARCHAR2 (10 CHAR) 
			, CUENTA_BANC 				VARCHAR2 (50 CHAR)			 	
			, TITULAR_CUENTA_BANC   	VARCHAR2 (50 CHAR)  	 	
			, CONTACTO_PRINCIPAL  		VARCHAR2 (2 CHAR) 		 	
			, NOMBRE_CONTACTO			VARCHAR2 (50 CHAR)
			, APELL_1_CONTACTO 			VARCHAR2 (50 CHAR)  	
			, APELL_2_CONTACTO 			VARCHAR2 (50 CHAR) 			 	
			, CARGO_CONTACTO    		VARCHAR2 (20 CHAR) 			
			, NIF_CONTACTO 				VARCHAR2 (50 CHAR) 				  			
			, CODIGO_USUARIO_CONTACTO	VARCHAR2 (20 CHAR) 	 			
			, TELEFONO_CONTACTO			VARCHAR2 (20 CHAR)  		 	
			, EMAIL_CONTACTO			VARCHAR2 (50 CHAR) 	
			, DIRECCION_CONTACTO		VARCHAR2 (250 CHAR) 							
			, FECHA_ALTA_CONTACTO		VARCHAR2 (10 CHAR)
			, FECHA_BAJA_CONTACTO		VARCHAR2 (10 CHAR)
			, OBSERVACIONES_CONTACTO	VARCHAR2 (400 CHAR)
			, DOCU_NIF_CONTACTO			VARCHAR2 (20 CHAR)
			, ESTADO_CONTACTO			VARCHAR2 (20 CHAR)
			, ID_ACTIVO 				VARCHAR2 (17 CHAR)
			, PORCEN_PARTICIPACION 		VARCHAR2 (8 CHAR)
			, FECHA_INCLUSION  			VARCHAR2 (10 CHAR)
			, FECHA_EXCLUSION 			VARCHAR2 (10 CHAR)
			, MOTIVO_EXCLUSION			VARCHAR2 (400 CHAR)
			, ERRORCODE					VARCHAR2 (512 CHAR)
			, ERRORMESSAGE				VARCHAR2 (1024 CHAR)
			, DD_MRE_ID 				NUMBER (16)
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

	/***** H_EER_ENT_ENTIDAD_RECH *****/
	
	V_TABLA := 'H_EER_ENT_ENTIDAD_RECH';
	V_COMMENT_TABLE := 'Tabla historica con los gastos rechazados en la carga de ficheros de gastos que recibimos de las agencias.';
	V_COL_TABLE_FK := 'DD_MRE_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRE_MOTIVO_RECH_ENTIDAD'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRE_ID'; -- Vble. para la columna referencia de un campo que es FK

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
					H_EER_ID					NUMBER (16)
					, DD_GRF_ID 				NUMBER (16)
					, DD_MRE_ID 				NUMBER (16)
					, FICHERO 					VARCHAR2 (200 CHAR)
					, USUARIOCREAR 				VARCHAR2 (100 CHAR)
					, FECHACREAR 				DATE 
					, ERRORCODE					VARCHAR2 (512 CHAR)
					, ERRORMESSAGE				VARCHAR2 (1024 CHAR)		
					, TIPO_ENTIDAD 				VARCHAR2 (20 CHAR)  	
					, SUBTIPO_ENTIDAD 			VARCHAR2 (20 CHAR) 	 	
					, NIF_ENTIDAD 				VARCHAR2 (50 CHAR) 
					, ID_ENTIDAD_GESTORIA 		VARCHAR2 (10 CHAR)			
					, NOMBRE_ENTIDAD 			VARCHAR2 (250 CHAR)
					, LOCALIZADA 				VARCHAR2 (2 CHAR) 						
					, ESTADO 					VARCHAR2 (20 CHAR)
					, FECHA_CONSTITUCION 		VARCHAR2 (10 CHAR) 
					, CUENTA_BANC 				VARCHAR2 (50 CHAR)			 	
					, TITULAR_CUENTA_BANC   	VARCHAR2 (50 CHAR)  	 	
					, CONTACTO_PRINCIPAL  		VARCHAR2 (2 CHAR) 		 	
					, NOMBRE_CONTACTO			VARCHAR2 (50 CHAR)
					, APELL_1_CONTACTO 			VARCHAR2 (50 CHAR)  	
					, APELL_2_CONTACTO 			VARCHAR2 (50 CHAR) 			 	
					, CARGO_CONTACTO    		VARCHAR2 (20 CHAR) 			
					, NIF_CONTACTO 				VARCHAR2 (50 CHAR) 				  		
					, CODIGO_USUARIO_CONTACTO	VARCHAR2 (20 CHAR) 	 			
					, TELEFONO_CONTACTO 		VARCHAR2 (20 CHAR)  		 	
					, EMAIL_CONTACTO 			VARCHAR2 (50 CHAR) 	
					, DIRECCION_CONTACTO 		VARCHAR2 (250 CHAR) 							
					, FECHA_ALTA_CONTACTO 		VARCHAR2 (10 CHAR)
					, FECHA_BAJA_CONTACTO		VARCHAR2 (10 CHAR)
					, OBSERVACIONES_CONTACTO	VARCHAR2 (400 CHAR)
					, DOCU_NIF_CONTACTO			VARCHAR2 (20 CHAR)
					, ESTADO_CONTACTO			VARCHAR2 (20 CHAR)
					, ID_ACTIVO 				VARCHAR2 (17 CHAR)
					, PORCEN_PARTICIPACION 		VARCHAR2 (8 CHAR)
					, FECHA_INCLUSION  			VARCHAR2 (10 CHAR)
					, FECHA_EXCLUSION 			VARCHAR2 (10 CHAR)
					, MOTIVO_EXCLUSION			VARCHAR2 (400 CHAR)
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
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(H_EER_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
	
	
			-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (H_EER_ID) USING INDEX)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');


			-- Creamos foreing key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_EER_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... PK creada ('||V_COL_TABLE_FK||').');

			-- Creamos foreing key2
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_EER_FK_'||V_COL2_TABLE_FK||' FOREIGN KEY ('||V_COL2_TABLE_FK||') REFERENCES '||V_COL2_TABLE_FK_TAB_PARENT||'  ('||V_COL2_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... PK creada ('||V_COL2_TABLE_FK||').');
	
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

