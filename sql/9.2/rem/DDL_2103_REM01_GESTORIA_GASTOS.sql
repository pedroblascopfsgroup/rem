-/*
--######################################### 
--## AUTOR=Joaquin_Arnal 
--## FECHA_CREACION=20161025
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1089
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

	/***** APR_AUX_GES_GASTOS_GR *****/
	
	V_TABLA := 'APR_AUX_GES_GASTOS_GR';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar el fichero de gastos que recibimos de las agencias.';

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
			COD_GESTORIA 				NUMBER (16,0) 		NOT NULL 	
			, COD_ACTIVO 				NUMBER (16,0) 		NOT NULL 	
			, COD_GASTO_GESTORIA 			NUMBER (16,0) 		NOT NULL 	
			, COD_GASTO_REM 			NUMBER (16,0)					
			, COD_GASTO_UVEM 			NUMBER (16,0)					
			, COD_GASTO_SAREB 			NUMBER (16,0) 					
			, REF_EMISOR 				VARCHAR2 (150 CHAR)				
			, TIPO_GASTO 				VARCHAR2 (20 CHAR) 	NOT NULL 	
			, SUBTIPO_GASTO  			VARCHAR2 (20 CHAR) 	NOT NULL 	
			, REF_CATASTRAL 			VARCHAR2 (50 CHAR)			 	
			, TIPO_OPERACION   			VARCHAR2 (20 CHAR)  	NOT NULL 	
			, CONCEPTO  				VARCHAR2 (100 CHAR) 		 	
			, PERIO_REAL 				VARCHAR2 (20 CHAR)  	NOT NULL 	
			, PERIO_ESPECIAL 			VARCHAR2 (20 CHAR) 			 	
			, FECHA_DEVENGO_REAL    		DATE 			NOT NULL 	
			, FECHA_DEVENGO_ESPECIAL 		DATE 				  			
			, PARTIDA_PRESU_ESPECIAL 		VARCHAR2 (20 CHAR) 	 			
			, CUENTA_CONTABLE_ESPECIAL 		VARCHAR2 (50 CHAR)  		 	
			, FECHA_TOPE_PAGO 			DATE  			NOT NULL 	
			, FECHA_INICIO_EMISION 			DATE 							
			, FECHA_FIN_EMISION 			DATE 							
			, ID_PRIMER_GASTO_SERIE			NUMBER (16,0) 					
			, PRINCIPAL 				NUMBER (16,2)  		NOT NULL 	
			, RECARGO 				NUMBER (16,2)	 				
			, INT_DEMORA 				NUMBER (16,2)					
			, COSTAS 				NUMBER (16,2)	 				
			, OTROS_INCREMENTOS 			NUMBER (16,2) 					
			, PROVISIONES_Y_SUPL			NUMBER (16,2)					
			, NIF_PROVEEDOR  			VARCHAR2 (17 CHAR) 		NOT NULL 	
			, NIF_DESTINATARIO 			VARCHAR2 (20 CHAR) 	NOT NULL	
			, TIPO_ENVIO				VARCHAR2 (20 CHAR)  	NOT NULL 	
			, FECHA_ANULACION 			DATE 							
			, MOTIVO_ANULACION 			VARCHAR2 (20 CHAR) 				
			, OBSERVACIONES 			VARCHAR2 (400 CHAR)				
			, IMPORTE_PAGADO			NUMBER (16,2) 					
			, FECHA_PAGO 				DATE							
			, PAGADO_POR				VARCHAR2 (20 CHAR)				
			, REEMBOLSAR_A_GES 			NUMBER(1)			
			, ID_GASTO_ABONADO 			NUMBER(16,0)						
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_GESTORIA IS ''ID gestoría'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_ACTIVO IS ''ID activo'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_GASTO_GESTORIA IS ''ID gasto gestoría'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_GASTO_REM IS ''ID gasto REM'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_GASTO_UVEM IS ''ID gasto UVEM'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COD_GASTO_SAREB IS ''ID gasto SAREB'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.REF_EMISOR IS ''Referencia emisor'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_GASTO IS ''Tipo de gasto'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.SUBTIPO_GASTO IS ''Subtipo de gasto'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.REF_CATASTRAL IS ''Referencia catastral'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_OPERACION  IS ''Tipo de operación'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CONCEPTO IS ''Concepto'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PERIO_REAL IS ''Periodicidad real'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PERIO_ESPECIAL IS ''Periodicidad especial'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_DEVENGO_REAL IS ''Fecha devengo real'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_DEVENGO_ESPECIAL IS ''Fecha devengo especial. Obligatorio si se ha cumplimentado el campo “periodicidad especial”'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PARTIDA_PRESU_ESPECIAL IS ''Partida presupuestaria especial	X(20)	VARCHAR2 (20 CHAR)	Obligatorio si se ha cumplimentado el campo “periodicidad especial”'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.CUENTA_CONTABLE_ESPECIAL IS ''Cuenta contable especial	X(50)	VARCHAR2 (50 CHAR)	Obligatorio si se ha cumplimentado el campo “periodicidad especial”'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_TOPE_PAGO IS ''Fecha tope pago'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_INICIO_EMISION IS ''Fecha inicio emisión'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_FIN_EMISION IS ''Fecha fin emisión'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_PRIMER_GASTO_SERIE IS ''ID primer gasto de la serie. Se utiliza el ID del gasto de la gestoría (campo 3) y permite que REM compruebe que este gasto está ya autorizado. Si no tiene contenido REM entiende que es el primer gasto de la serie y lo somete a autorización.'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PRINCIPAL  IS ''Principal no sujeto a impuesto'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.RECARGO IS ''Recargo'' ';	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.INT_DEMORA IS ''Interés de demora'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.COSTAS IS ''Costas'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.OTROS_INCREMENTOS IS ''Otros incrementos'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PROVISIONES_Y_SUPL IS ''Provisiones y suplidos'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NIF_PROVEEDOR  IS ''NIF Proveedor'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.NIF_DESTINATARIO  IS ''NIF destinatario'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.TIPO_ENVIO IS ''Tipo envío'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_ANULACION IS ''Fecha anulación'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.MOTIVO_ANULACION IS ''Motivo anulación. Obligatorio si se ha cumplimentado el campo fecha anulación.'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.OBSERVACIONES IS ''Observaciones'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.IMPORTE_PAGADO IS ''Importe pagado. Obligatorio si se ha cumplimentado el campo fecha de pago.'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.FECHA_PAGO IS ''Fecha de pago.	Obligatorio si se ha cumplimentado el campo importe pagado'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.PAGADO_POR IS ''Pagado por. Obligatorio si se ha cumplimentado el campo importe pagado'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.REEMBOLSAR_A_GES IS ''Reembolsar a gestoría.'' ';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN  '||V_ESQUEMA||'.'||V_TABLA||'.ID_GASTO_ABONADO IS ''Identificador del gasto referencia que ha creado el abono.'' ';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' Ponemos comentario en los campos de la tabla.'); 

	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	COMMIT;

	
	/***** APR_AUX_GES_GASTOS_GR_REJ *****/
	
	V_TABLA := 'APR_AUX_GES_GASTOS_GR_REJ';
	V_COMMENT_TABLE := 'Tabla auxiliar para cargar los rechazos generados en la carga del fichero de gastos que recibimos de las agencias.';
	V_COL_TABLE_FK := 'DD_MRG_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRG_ID'; -- Vble. para la columna referencia de un campo que es FK

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
			COD_GESTORIA 				VARCHAR2 (17 CHAR) 		 	
			, COD_ACTIVO 				VARCHAR2 (17 CHAR) 		 	
			, COD_GASTO_GESTORIA 			VARCHAR2 (17 CHAR) 		 	
			, COD_GASTO_REM 			VARCHAR2 (17 CHAR)					
			, COD_GASTO_UVEM 			VARCHAR2 (17 CHAR)					
			, COD_GASTO_SAREB 			VARCHAR2 (17 CHAR) 					
			, REF_EMISOR 				VARCHAR2 (150 CHAR)				
			, TIPO_GASTO 				VARCHAR2 (20 CHAR) 	 	
			, SUBTIPO_GASTO  			VARCHAR2 (20 CHAR) 	 	
			, REF_CATASTRAL 			VARCHAR2 (50 CHAR)			 	
			, TIPO_OPERACION   			VARCHAR2 (20 CHAR)   	
			, CONCEPTO  				VARCHAR2 (100 CHAR) 		 	
			, PERIO_REAL 				VARCHAR2 (20 CHAR)   	
			, PERIO_ESPECIAL 			VARCHAR2 (20 CHAR) 			 	
			, FECHA_DEVENGO_REAL    		VARCHAR2 (10 CHAR)				 	
			, FECHA_DEVENGO_ESPECIAL 		VARCHAR2 (10 CHAR)				  			
			, PARTIDA_PRESU_ESPECIAL 		VARCHAR2 (20 CHAR) 	 			
			, CUENTA_CONTABLE_ESPECIAL 		VARCHAR2 (50 CHAR)  		 	
			, FECHA_TOPE_PAGO 			VARCHAR2 (10 CHAR) 			     	
			, FECHA_INICIO_EMISION 			VARCHAR2 (10 CHAR)							
			, FECHA_FIN_EMISION 			VARCHAR2 (10 CHAR)							
			, ID_PRIMER_GASTO_SERIE			VARCHAR2 (17 CHAR) 					
			, PRINCIPAL 				VARCHAR2 (17 CHAR)  		 	
			, RECARGO 				VARCHAR2 (17 CHAR)	 				
			, INT_DEMORA 				VARCHAR2 (17 CHAR)					
			, COSTAS 				VARCHAR2 (17 CHAR)	 				
			, OTROS_INCREMENTOS 			VARCHAR2 (17 CHAR) 					
			, PROVISIONES_Y_SUPL			VARCHAR2 (17 CHAR)					
			, NIF_PROVEEDOR  			VARCHAR2 (17 CHAR) 		 	
			, NIF_DESTINATARIO 			VARCHAR2 (20 CHAR) 		
			, TIPO_ENVIO				VARCHAR2 (20 CHAR)   	
			, FECHA_ANULACION 			VARCHAR2 (10 CHAR)							
			, MOTIVO_ANULACION 			VARCHAR2 (20 CHAR) 				
			, OBSERVACIONES 			VARCHAR2 (400 CHAR)				
			, IMPORTE_PAGADO			VARCHAR2 (17 CHAR) 					
			, FECHA_PAGO 				VARCHAR2 (10 CHAR)							
			, PAGADO_POR				VARCHAR2 (20 CHAR)				
			, REEMBOLSAR_A_GES 			VARCHAR2 (2 CHAR)
			, ID_GASTO_ABONADO 			VARCHAR2 (17 CHAR)
			, ERRORCODE				VARCHAR2 (512 CHAR)
			, ERRORMESSAGE				VARCHAR2 (1024 CHAR)
			, DD_MRG_ID 				NUMBER (16)
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

	/***** H_GGR_GES_GASTOS_RECH *****/
	
	V_TABLA := 'H_GGR_GES_GASTOS_RECH';
	V_COMMENT_TABLE := 'Tabla historica con los gastos rechazados en la carga de ficheros de gastos que recibimos de las agencias.';
	V_COL_TABLE_FK := 'DD_MRG_ID'; -- Vble. para indicar un campo que es FK
	V_COL_TABLE_FK_TAB_PARENT := 'DD_MRG_MOTIVO_RECHAZO_GASTO'; -- Vble. para la tabla referencia de un campo que es FK
	V_COL_TABLE_FK_COL_PARENT := 'DD_MRG_ID'; -- Vble. para la columna referencia de un campo que es FK

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
					H_GGR_ID				NUMBER (16)
					, DD_GRF_ID 			NUMBER (16)
					, DD_MRG_ID 			NUMBER (16)
					, FICHERO 			VARCHAR2 (200 CHAR)
					, USUARIOCREAR 			VARCHAR2 (100 CHAR)
					, FECHACREAR 			DATE 
					, ERRORCODE			VARCHAR2 (512 CHAR)
					, ERRORMESSAGE			VARCHAR2 (1024 CHAR)			 
					, COD_GESTORIA 			VARCHAR2 (17 CHAR) 		 	
					, COD_ACTIVO 			VARCHAR2 (17 CHAR) 		 	
					, COD_GASTO_GESTORIA 		VARCHAR2 (17 CHAR) 		 	
					, COD_GASTO_REM 		VARCHAR2 (17 CHAR)					
					, COD_GASTO_UVEM 		VARCHAR2 (17 CHAR)					
					, COD_GASTO_SAREB 		VARCHAR2 (17 CHAR) 					
					, REF_EMISOR 			VARCHAR2 (150 CHAR)				
					, TIPO_GASTO 			VARCHAR2 (20 CHAR) 	 	
					, SUBTIPO_GASTO  		VARCHAR2 (20 CHAR) 	 	
					, REF_CATASTRAL 		VARCHAR2 (50 CHAR)			 	
					, TIPO_OPERACION   		VARCHAR2 (20 CHAR)   	
					, CONCEPTO  			VARCHAR2 (100 CHAR) 		 	
					, PERIO_REAL 			VARCHAR2 (20 CHAR)   	
					, PERIO_ESPECIAL 		VARCHAR2 (20 CHAR) 			 	
					, FECHA_DEVENGO_REAL    	VARCHAR2 (10 CHAR)				 	
					, FECHA_DEVENGO_ESPECIAL 	VARCHAR2 (10 CHAR)				  			
					, PARTIDA_PRESU_ESPECIAL 	VARCHAR2 (20 CHAR) 	 			
					, CUENTA_CONTABLE_ESPECIAL 	VARCHAR2 (50 CHAR)  		 	
					, FECHA_TOPE_PAGO 		VARCHAR2 (10 CHAR) 			     	
					, FECHA_INICIO_EMISION 		VARCHAR2 (10 CHAR)							
					, FECHA_FIN_EMISION 		VARCHAR2 (10 CHAR)							
					, ID_PRIMER_GASTO_SERIE		VARCHAR2 (17 CHAR) 					
					, PRINCIPAL 			VARCHAR2 (17 CHAR)  		 	
					, RECARGO 			VARCHAR2 (17 CHAR)	 				
					, INT_DEMORA 			VARCHAR2 (17 CHAR)					
					, COSTAS 			VARCHAR2 (17 CHAR)	 				
					, OTROS_INCREMENTOS 		VARCHAR2 (17 CHAR) 					
					, PROVISIONES_Y_SUPL		VARCHAR2 (17 CHAR)					
					, NIF_PROVEEDOR  		VARCHAR2 (17 CHAR) 		 	
					, NIF_DESTINATARIO 		VARCHAR2 (20 CHAR) 		
					, TIPO_ENVIO			VARCHAR2 (20 CHAR)   	
					, FECHA_ANULACION 		VARCHAR2 (10 CHAR)							
					, MOTIVO_ANULACION 		VARCHAR2 (20 CHAR) 				
					, OBSERVACIONES 		VARCHAR2 (400 CHAR)				
					, IMPORTE_PAGADO		VARCHAR2 (17 CHAR) 					
					, FECHA_PAGO 			VARCHAR2 (10 CHAR)							
					, PAGADO_POR			VARCHAR2 (20 CHAR)				
					, REEMBOLSAR_A_GES 		VARCHAR2 (2 CHAR)
					, ID_GASTO_ABONADO 		VARCHAR2 (17 CHAR)
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
			V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(H_GGR_ID) TABLESPACE '||V_TABLESPACE_IDX;		
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
	
	
			-- Creamos primary key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (H_GGR_ID) USING INDEX)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');


			-- Creamos foreing key
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_GGR_FK_'||V_COL_TABLE_FK||' FOREIGN KEY ('||V_COL_TABLE_FK||') REFERENCES '||V_COL_TABLE_FK_TAB_PARENT||'  ('||V_COL_TABLE_FK_COL_PARENT||') )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_FK... PK creada ('||V_COL_TABLE_FK||').');

			-- Creamos foreing key2
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT H_GGR_FK_'||V_COL2_TABLE_FK||' FOREIGN KEY ('||V_COL2_TABLE_FK||') REFERENCES '||V_COL2_TABLE_FK_TAB_PARENT||'  ('||V_COL2_TABLE_FK_COL_PARENT||') )';
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

