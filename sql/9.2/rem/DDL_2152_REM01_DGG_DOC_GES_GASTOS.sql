-/*
--######################################### 
--## AUTOR=Joaquin_Arnal 
--## FECHA_CREACION=20170118
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1449
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas auxiliares de aprovisionamiento para fichero de gestorias NOMGESTORIA_DOCUMENTOS_RG_YYYYMMDD.dat y NOMGESTORIA_DOCUMENTOS_RESUL_GR_YYYYMMDD.dat
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

	/***** APR_AUX_DGG_DOC_GES_GASTOS *****/
	
	V_TABLA := 'APR_AUX_DGG_DOC_GES_GASTOS';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar el fichero de documentos que recibimos de las agencias.';

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
			ID_GESTORIA 		VARCHAR2 (17 CHAR) 		
			, ID_GASTO_GESTORIA 	VARCHAR2 (17 CHAR) 		
			, ID_GASTO_REM 		VARCHAR2 (17 CHAR) 		
			, ID_ACTIVO 		VARCHAR2 (17 CHAR)		
			, TIPO_DOC_GES_DOCU 	VARCHAR2 (20 CHAR)
			, RUTA			VARCHAR2 (255 CHAR)
			, RESULTADO 		VARCHAR2 (3 CHAR)
			, T_ID_GESTORIA 	NUMBER (16,0)		
			, T_ID_GASTO_GESTORIA 	NUMBER (16,0)
			, T_ID_GASTO_REM 	NUMBER (16,0)
			, T_ID_ACTIVO 		NUMBER (16,0)
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_GESTORIA IS ''ID Gestoría'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_GASTO_GESTORIA IS ''ID Gasto Gestoria'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_GASTO_REM IS ''ID Gasto Rem'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_ACTIVO IS ''Numero Activo HAYA'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_DOC_GES_DOCU IS ''ID gasto UVEM'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.RUTA IS ''Ruta del documento'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.RESULTADO IS ''Codigo del resultado a enviar a la gestoria'' ';
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' Ponemos comentario en los campos de la tabla.'); 

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

	/***** DGG_DOC_GES_GASTOS *****/
	
	V_TABLA := 'DGG_DOC_GES_GASTOS';
	V_COMMENT_TABLE := 'Tabla con documentos enviados por las gestorias.';

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
					DGG_ID				NUMBER (16,0)
					, DD_GRF_ID 			NUMBER (16,0)
					, DD_MRD_ID 			NUMBER (16,0)
					, FICHERO 			VARCHAR2 (200 CHAR)
					, USUARIOCREAR 			VARCHAR2 (100 CHAR)
					, FECHACREAR 			DATE 
					, USUARIOMODIFICAR		VARCHAR2 (100 CHAR)
					, FECHAMODIFICAR		DATE 
					, USUARIOBORRAR			VARCHAR2 (100 CHAR)
					, FECHABORRAR 			DATE 
					, BORRADO 			NUMBER (1,0)
					, ERRORCODE			VARCHAR2 (512 CHAR)
					, ERRORMESSAGE			VARCHAR2 (1024 CHAR)
					, VALIDO			NUMBER (1)
					, PVE_ID_GESTORIA 		NUMBER (16,0)
					, GPV_ID 			NUMBER (16,0)		
					, ACT_ID 			NUMBER (16,0)
					, DD_TPD_ID			NUMBER (16,0)		
					, F_ID_GESTORIA 		VARCHAR2 (17 CHAR) 		
					, F_ID_GASTO_GESTORIA 		VARCHAR2 (17 CHAR) 		
					, F_ID_GASTO_REM 		VARCHAR2 (17 CHAR) 		
					, F_ID_ACTIVO 			VARCHAR2 (17 CHAR)		
					, F_TIPO_DOC_GES_DOCU 		VARCHAR2 (20 CHAR)		
					, F_RUTA			VARCHAR2 (255 CHAR)		
					, F_RESULTADO 			VARCHAR2 (3 CHAR)
					, USUARIOENVIO 			VARCHAR2 (100 CHAR) 
					, FECHAENVIO 			DATE
				)
				';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');

			-- Creamos indice	
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(DGG_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');	
			
			-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DGG_ID) USING INDEX)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

			-- Creamos foreing key (1)
			V_COL_TABLE_FK := 'DD_MRD_ID'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'DD_MRD_MOTIVO_RECH_DOCU_DGG'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'DD_MRD_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (1) creada ('||V_COL_TABLE_FK||').');

			-- Creamos foreing key (2)
			V_COL_TABLE_FK := 'DD_GRF_ID'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'DD_GRF_GESTORIA_RECEP_FICH'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'DD_GRF_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (2) creada ('||V_COL_TABLE_FK||').');
			
			-- Creamos foreing key (3)
			V_COL_TABLE_FK := 'PVE_ID_GESTORIA'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'ACT_PVE_PROVEEDOR'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'PVE_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (3) creada ('||V_COL_TABLE_FK||').');
			
			-- Creamos foreing key (4)
			V_COL_TABLE_FK := 'GPV_ID'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'GPV_GASTOS_PROVEEDOR'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'GPV_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (4) creada ('||V_COL_TABLE_FK||').');
			
			-- Creamos foreing key (5)
			V_COL_TABLE_FK := 'ACT_ID'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'ACT_ACTIVO'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'ACT_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (5) creada ('||V_COL_TABLE_FK||').');
			
			-- Creamos foreing key (6)
			V_COL_TABLE_FK := 'DD_TPD_ID'; -- Vble. para indicar un campo que es FK
			V_COL_TABLE_FK_TAB_PARENT := 'DD_TPD_TIPOS_DOCUMENTO_GASTO'; -- Vble. para la tabla referencia de un campo que es FK
			V_COL_TABLE_FK_COL_PARENT := 'DD_TPD_ID'; -- Vble. para la columna referencia de un campo que es FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT DGG_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... FK (6) creada ('||V_COL_TABLE_FK||').');

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
			
			
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DGG_ID IS ''Id documento-gasto'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_GRF_ID IS ''DD - Gestoria que enviar el doumento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_MRD_ID IS ''DD - Motivo de rechazo del documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FICHERO IS ''Fichero que incluyo este adjunto'' ';	
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Usuario que creo el registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Fecha de creación del registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Usuario que modifico el registro por ultima vez'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Fecha de modificación del registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Usuario que ha borrado el registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Fecha en la que se borro el registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indica si el registro esta borrado'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ERRORCODE IS ''Indica el codigo de validación del registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ERRORMESSAGE IS ''Indica el motivo de rechazo del registro'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.PVE_ID_GESTORIA IS ''Identificador del proveedor gestoria del documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_ID IS ''Identificador del gasto al que hace referencia el documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID IS ''Identificador del activo al que hace referencia el documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPD_ID IS ''Identificador del tipo de documento al que hace referencia el documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_ID_GESTORIA IS ''Dato enviado en el fichero - ID Gestoría'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_ID_GASTO_GESTORIA IS ''Dato enviado en el fichero - ID Gasto Gestoria'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_ID_GASTO_REM IS ''Dato enviado en el fichero - ID Gasto Rem'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_ID_ACTIVO IS ''Dato enviado en el fichero - Numero Activo HAYA'' ';	
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_TIPO_DOC_GES_DOCU IS ''Dato enviado en el fichero - ID gasto UVEM'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_RUTA IS ''Dato enviado en el fichero - Ruta del documento'' ';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.F_RESULTADO IS ''Dato a enviar por REM con el resultado de la validación dle registro'' ';				
	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' Ponemos comentario en los campos de la tabla.'); 
	
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

