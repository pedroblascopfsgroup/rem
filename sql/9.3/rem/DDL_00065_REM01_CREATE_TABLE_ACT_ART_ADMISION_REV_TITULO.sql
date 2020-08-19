--/*
--##########################################
--## AUTOR=Jonathan Ovalle
--## FECHA_CREACION=20200630
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10491
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
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'ACT_ART_ADMISION_REV_TITULO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'ART'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el diccionario de tipo periodicidad'; -- Vble. para los comentarios de las tablas
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

	/* -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 						CAMPO FK 				TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_ART_ACT_ACTIVO',					'ACT_ID',				V_ESQUEMA||'.ACT_ACTIVO',					'ACT_ID'),
		T_FK(	'FK_ART_DD_SIN_SINO_REVISADO',			'ART_REVISADO',			V_ESQUEMA_M||'.DD_SIN_SINO',					'DD_SIN_ID'),
		T_FK(	'FK_ART_DD_SNA_RAT',					'ART_RATIFICACION',		V_ESQUEMA||'.DD_SNA_SI_NO_NA',				'DD_SNA_ID'),
		T_FK(	'FK_ART_DD_SNA_INST_LIB',				'ART_INST_LIB_ARRENDATARIA',V_ESQUEMA||'.DD_SNA_SI_NO_NA',		'DD_SNA_ID'),
		T_FK(	'FK_ART_DD_SII_SIT_INI_INSCRIPCION',	'ART_SIT_INI_INSCRIPCION',	V_ESQUEMA||'.DD_SII_SIT_INI_INSCRIPCION',	'DD_SII_ID'),
		T_FK(	'FK_ART_DD_SPI_SIT_POSESORIA_INI',		'ART_POSESORIA_INI',	V_ESQUEMA||'.DD_SPI_SIT_POSESORIA_INI',		'DD_SPI_ID'),
		T_FK(	'FK_ART_DD_SIC_SIT_INI_CARGAS',			'ART_SIT_INI_CARGAS',	V_ESQUEMA||'.DD_SIC_SIT_INI_CARGAS',		'DD_SIC_ID'),
		T_FK(	'FK_ART_DD_TTI_TIPO_TITULARIDAD',		'ART_TIPO_TITULARIDAD',	V_ESQUEMA||'.DD_TTI_TIPO_TITULARIDAD',		'DD_TTI_ID'),
		T_FK(	'FK_ART_DD_AUT_AUTORIZ_TRANSMISION',	'ART_AUTORIZ_TRANSMISION',V_ESQUEMA||'.DD_AUT_AUTORIZ_TRANSMISION',	'DD_AUT_ID'),
		T_FK(	'FK_ART_DD_ANC_ANOTACION_CONCURSO',		'ART_ANOTACION_CONCURSO',V_ESQUEMA||'.DD_ANC_ANOTACION_CONCURSO',	'DD_ANC_ID'),
		T_FK(	'FK_ART_DD_ESG_ART_EST_GES_CA',			'ART_EST_GES_CA',		V_ESQUEMA||'.DD_ESG_ESTADO_GESTION',		'DD_ESG_ID'),
		T_FK(	'FK_ART_DD_SIN_ART_CONS_FIS',			'ART_CONS_FISICA',		V_ESQUEMA_M||'.DD_SIN_SINO',					'DD_SIN_ID'),
		T_FK(	'FK_ART_DD_SIN_ART_CONS_JUR',			'ART_CONS_JURIDICA',	V_ESQUEMA_M||'.DD_SIN_SINO',					'DD_SIN_ID'),
		T_FK(	'FK_ART_DD_CFO_CERTIFICADO_FIN_OBRA',	'ART_AFO_ACTA_FIN_OBRA',V_ESQUEMA||'.DD_CFO_CERTIFICADO_FIN_OBRA',	'DD_CFO_ID'),
		T_FK(	'FK_ART_DD_AFO_ACTA_FIN_OBRA',			'ART_AFO_ACTA_FIN_OBRA',V_ESQUEMA||'.DD_AFO_ACTA_FIN_OBRA',			'DD_AFO_ID'),
		T_FK(	'FK_ART_DD_LPO_LIC_PRIMERA_OCUPACION',	'ART_LIC_PRIMERA_OCIPACION',V_ESQUEMA||'.DD_LPO_LIC_PRIMERA_OCUPACION','DD_LPO_ID'),
		T_FK(	'FK_ART_DD_BOL_BOLETINESS',				'ART_BOLETINES',		V_ESQUEMA||'.DD_BOL_BOLETINES',				'DD_BOL_ID'),
		T_FK(	'FK_ART_DD_SDC_SEGURO_DECENAL',			'ART_SEGURO_DECENAL',	V_ESQUEMA||'.DD_SDC_SEGURO_DECENAL',		'DD_SDC_ID'),
		T_FK(	'FK_ART_DD_CEH_CEDULA_HABITABILIDAD',	'ART_CEDULA_HABITABILIDAD',V_ESQUEMA||'.DD_CEH_CEDULA_HABITABILIDAD','DD_CEH_ID'),
		T_FK(	'FK_ART_DD_TIA_TIPO_ARRENDAMIENTO',		'ART_TIPO_ARRENDAMIENTO',V_ESQUEMA||'.DD_TIA_TIPO_ARRENDAMIENTO',	'DD_TIA_ID'),
		T_FK(	'FK_ART_APR_AUX_DD_SIN_SINO',			'ART_NOTIF_ARRENDATARIOS',V_ESQUEMA||'.APR_AUX_DD_SIN_SINO',		'DD_SIN_ID'),
		T_FK(	'FK_ART_DDD_TEA_TIPO_EXP_ADM',			'ART_TIPO_EXP_ADM',		V_ESQUEMA||'.DD_TEA_TIPO_EXP_ADM',			'DD_TEA_ID'),
		T_FK(	'FK_ART_DD_ESG_GES_EA',			        'ART_EST_GES_EA',		V_ESQUEMA||'.DD_ESG_ESTADO_GESTION',		'DD_ESG_ID'),
		T_FK(	'FK_ART_DD_TIR_TIPO_INCI_REGISTRAL',	'ART_TIPO_INCI_REGISTRAL',V_ESQUEMA||'.DD_TIR_TIPO_INCI_REGISTRAL',	'DD_TIR_ID'),
		T_FK(	'FK_ART_DD_ESG_GES_CR',					'ART_EST_GES_CR',		V_ESQUEMA||'.DD_ESG_ESTADO_GESTION',		'DD_ESG_ID'),
		T_FK(	'FK_ART_DD_TOL_TIPO_OCUPACION_LEGAL',	'ART_TIPO_OCUPACION_LEGAL',V_ESQUEMA||'.DD_TOL_TIPO_OCUPACION_LEGAL','DD_TOL_ID'),
		T_FK(	'FK_ART_DD_ESG_GES_IL',					'ART_EST_GES_IL',		V_ESQUEMA||'.DD_ESG_ESTADO_GESTION',		'DD_ESG_ID'),
		T_FK(	'FK_ART_DD_ESG_GES_OT',					'ART_EST_GES_OT',		V_ESQUEMA||'.DD_ESG_ESTADO_GESTION',		'DD_ESG_ID')

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
			ART_ID 										NUMBER(16,0),
			ACT_ID 										NUMBER(16,0), 				
			ART_REVISADO 								NUMBER(16,0), 				
			ART_FECHA_REVISION_TITULO 					DATE, 				
			ART_RATIFICACION 							NUMBER(16,0), 				
			ART_INST_LIB_ARRENDATARIA 					NUMBER(16,0),
			ART_SIT_INI_INSCRIPCION 					NUMBER(16,0),
			ART_POSESORIA_INI 							NUMBER(16,0),
			ART_SIT_INI_CARGAS 							NUMBER(16,0),
			ART_PORC_PROPIEDAD 							NUMBER(3,2),
			ART_TIPO_TITULARIDAD 						NUMBER(16,0),
			ART_OBSERVACIONES				 			VARCHAR(250 CHAR),
			ART_AUTORIZ_TRANSMISION 					NUMBER(16,0),
			ART_ANOTACION_CONCURSO 						NUMBER(16,0),
			ART_EST_GES_CA 								NUMBER(16,0),
			ART_CONS_FISICA 							NUMBER(16,0),
			ART_PORC_CONS_TASACION_CF 					NUMBER(3,2),
			ART_CONS_JURIDICA 							NUMBER(16,0),
			ART_PORC_CONS_TASACION_CJ 					NUMBER(3,2), 
			ART_CERTIFICADO_FIN_OBRA 					NUMBER(16,0), 
			ART_AFO_ACTA_FIN_OBRA 						NUMBER(16,0), 
			ART_LIC_PRIMERA_OCIPACION 					NUMBER(16,0),  				
			ART_BOLETINES 								NUMBER(16,0), 
			ART_SEGURO_DECENAL 							NUMBER(16,0), 
			ART_CEDULA_HABITABILIDAD 					NUMBER(16,0), 
			ART_FECHA_CONTRATO_ALQ 						DATE, 
			ART_LEGISLACION_APLICABLE_ALQ 				VARCHAR2(250 CHAR), 
			ART_DURACION_CONTRATO_ALQ 					VARCHAR2(250 CHAR), 
			ART_TIPO_ARRENDAMIENTO 						NUMBER(16,0), 
			ART_NOTIF_ARRENDATARIOS 					NUMBER(16,0), 
			ART_TIPO_EXP_ADM 							NUMBER(16,0),
			ART_EST_GES_EA 								NUMBER(16,0),
			ART_TIPO_INCI_REGISTRAL 					NUMBER(16,0),
			ART_EST_GES_CR 								NUMBER(16,0),
			ART_TIPO_OCUPACION_LEGAL 					NUMBER(16,0),
			ART_TIPO_INCI_ILOC 							VARCHAR2(250 CHAR),
			ART_EST_GES_IL 								NUMBER(16,0),
			ART_DETERIORO_GRAVE 						VARCHAR2(250 CHAR), 
			ART_TIPO_INCI_OTROS 						VARCHAR2(250 CHAR), 
			ART_EST_GES_OT 								NUMBER(16,0),
			VERSION 									NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 								VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
			FECHACREAR 									TIMESTAMP (6) 				NOT NULL ENABLE, 
			USUARIOMODIFICAR 							VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 								TIMESTAMP (6), 
			USUARIOBORRAR 								VARCHAR2(50 CHAR), 
			FECHABORRAR 								TIMESTAMP (6), 
			BORRADO 									NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING'
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
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... SECVencia creada');
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

 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_ID IS ''Clave principal''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ACT_ID IS ''Campo que relaciona con el  activo''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_REVISADO IS ''Campo que indica si esta revisado''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_FECHA_REVISION_TITULO IS ''Indica la fecha de revisión del titulo''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_RATIFICACION IS ''Campo que si ratificación es si, no o no aplica''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_INST_LIB_ARRENDATARIA IS ''Campo que indica si la arrendataria es si o no ''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_SIT_INI_INSCRIPCION IS ''Campo que indica la situación inicial de inscripción''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_POSESORIA_INI IS '' Campo que indica la situación inicial de posesoria''';	

  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_SIT_INI_CARGAS IS '' Campo que indica la situación inicial de las cargas''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_PORC_PROPIEDAD IS ''Campo del porcentaje de la propiedad''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_TITULARIDAD IS ''Campo que indica el tipo de titularidad''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_OBSERVACIONES IS ''Campo de observaciones''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_AUTORIZ_TRANSMISION IS '' Campo que indica la autorización de la trasmisión ''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_ANOTACION_CONCURSO IS ''Campo para las anotaciones en curso''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_EST_GES_CA IS ''Campo que indica el estado de la gestión concurso acreedores''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_CONS_FISICA IS ''Campo que indica en constancia fisica si o no''';

  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_PORC_CONS_TASACION_CF IS ''Porcentaje construcción según tasación constructiva física''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_CONS_JURIDICA IS ''Campo que indica si o no en constancia juridica''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_PORC_CONS_TASACION_CJ IS ''Porcentaje construcción según tasacion constructiva juridica''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_CERTIFICADO_FIN_OBRA IS ''Campo que indica el certificado de fin de obra''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_AFO_ACTA_FIN_OBRA IS ''Campo que indica el acta de fin de obra''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_LIC_PRIMERA_OCIPACION IS ''Campo que indica la primera ocupación''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_BOLETINES IS ''Campo para boletines''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_SEGURO_DECENAL IS ''Campo para seguro decenal''';

  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_CEDULA_HABITABILIDAD IS ''Campo que indica la cédula de habitabilidad''';  
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_FECHA_CONTRATO_ALQ IS ''Campo de fecha de contrato del alquiler''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_LEGISLACION_APLICABLE_ALQ IS ''Campo de legislación aplicable de alquiler''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_DURACION_CONTRATO_ALQ IS ''Campo que indica la duración del contrato de alquiler''';

 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_ARRENDAMIENTO IS ''Campo que indica el tipo de arrendamiento''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_NOTIF_ARRENDATARIOS IS ''Campo que indica si o no han sido notificados los arrendatarios''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_EXP_ADM IS ''Campo que indica el expediente de admisión''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_EST_GES_EA IS ''Campo que indica el estado de la gestión expediente administrativo''';

  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_INCI_REGISTRAL IS ''Campo que indica el tipo de incidencia registral''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_EST_GES_CR IS ''Campo que indica el estado de la gestión contingencia registral ''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_OCUPACION_LEGAL IS ''Campo que indica el tipo de ocupación legal''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_INCI_ILOC IS ''Campo para el tipo de incidencia ilocalizada''';

   EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_EST_GES_IL IS ''Campo para el estado de la gestión ilocalizada''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_DETERIORO_GRAVE IS ''Campo de deterioro grave ''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_TIPO_INCI_OTROS IS ''Campo que indica otro tipo de incidencia''';
 EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.ART_EST_GES_OT IS ''Campo que indica el estado de la gestión otros''';	


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