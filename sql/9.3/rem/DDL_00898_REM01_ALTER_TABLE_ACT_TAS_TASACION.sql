--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15894
--## PRODUCTO=NO
--## Finalidad: Ampliar la tabla ACT_TAS_TASACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TAS_TASACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'GASTO_COM_TASACION',			'NUMBER(16,2)',					'Costes comerciales de la tasación'	),
		T_ALTER(  'REF_TASADORA',				'VARCHAR2(20 CHAR)',			'Identificador de la tasación de la tasadora'	),
		T_ALTER(  'PORC_COSTE_DEFECTO',			'NUMBER(1,0)',					'Indicador gasto comercialización tasación es valor por defecto'	),
		T_ALTER(  'APROV_PARCELA_SUELO',		'NUMBER(10,0)',					'Aprovechamiento de la parcela en m2 (suelo) - Campo APRV Flesb'	),
		T_ALTER(  'DD_DSP_ID',					'NUMBER(16,0)',					'Desarrollo del planeamiento - Campo DES en Flesb'	),
		T_ALTER(  'DD_FSG_ID',					'NUMBER(16,0)',					'Fase de gestión - Campo FGES en FLESB'	),
		T_ALTER(  'ACOGIDA_NORMATIVA',			'NUMBER(1,0)',					'Acogida normativa - Campo IECO Flesb'	),
		T_ALTER(  'NUM_VIVIENDAS',				'NUMBER(3,0)',					'Número de viviendas - Campo NUDS FlesB'	),
		T_ALTER(  'PORC_AMBITO_VAL',			'NUMBER(7,2)',					'Porcentaje de ámbito valorado - Campo PAVA Flesb'	),
		T_ALTER(  'DD_PRD_ID',					'NUMBER(16,0)',					'Producto a desarrollar - Campo TPRD en FlesB'	),
		T_ALTER(  'DD_PNU_ID',					'NUMBER(16,0)',					'Proximidad respecto a núcleo urbano - Campo PROX en FlesB'	),
		T_ALTER(  'DD_SGT_ID',					'NUMBER(16,0)',					'Sistema de gestión - Campo SGES en FlesB'	),
		T_ALTER(  'SUPERFICIE_ADOPTADA',		'NUMBER(3,0)',					'Superficie adoptada (metros cuadrados) - Campo SAD en FlesB'	),
		T_ALTER(  'DD_SAC_ID',					'NUMBER(16,0)',					'Tipo de suelo - Campo TSU en FlesB'	),
		T_ALTER(  'VAL_HIPO_EDI_TERM_PROM',		'NUMBER(16,2)',					'Valor en hipótesis de edificio terminado (promociones) - Campo THET en FlesB'	),
		T_ALTER(  'ADVERTENCIAS',				'NUMBER(1,0)',					'Advertencias'	),
		T_ALTER(  'APROVECHAMIENTO',			'NUMBER(16,0)',					'Aprovechamiento (m2)'	),
		T_ALTER(  'COD_SOCIEDAD_TAS_VAL',		'VARCHAR2(10 CHAR)',			'Código de la sociedad de tasación/valoración'	),
		T_ALTER(  'CONDICIONANTES',				'NUMBER(1,0)',					'Condicionantes'	),
		T_ALTER(  'COSTE_EST_TER_OBRA',			'NUMBER(16,0)',					'Coste estimado para terminar la obra'	),
		T_ALTER(  'COSTE_DEST_PROPIO',			'NUMBER(16,0)',					'Coste por el que se destina a uso propio'	),
		T_ALTER(  'FEC_ULT_AVANCE_EST',			'DATE',							'Fecha del último grado de avance estimado'	),
		T_ALTER(  'FEC_EST_TER_OBRA',			'DATE',							'Fecha estimada para terminar la obra'	),
		T_ALTER(  'FINCA_RUS_EXP_URB',			'NUMBER(1,0)',					'Finca rústica con expectativas urbanísticas'	),
		T_ALTER(  'DD_MTV_ID',					'NUMBER(16,0)',					'Método de valoración'	),
		T_ALTER(  'MET_RES_DIN_MAX_COM',		'NUMBER(3,0)',					'Método residual dinámico. Plazo máximo para finalizar a la comercialización (meses)'	),
		T_ALTER(  'MET_RES_DIN_MAX_CONS',		'NUMBER(3,0)',					'Método residual dinámico. Plazo máximo para finalizar la construcción (meses)'	),
		T_ALTER(  'MET_RES_DIN_TAS_ANU',		'NUMBER(5,0)',					'Método residual dinámico. Tasa anualizada homogénea [%]'	),
		T_ALTER(  'MET_RES_DIN_TIPO_ACT',		'NUMBER(5,0)',					'Método residual dinámico. Tipo de Actualización [%]'	),
		T_ALTER(  'MET_RES_EST_MAR_PROM',		'NUMBER(5,0)',					'Método residual estático. Margen de beneficio del promotor [%]'	),
		T_ALTER(  'PARALIZACION_URB',			'NUMBER(1,0)',					'Paralización de la urbanización'	),
		T_ALTER(  'PORC_URB_EJECUTADO',			'NUMBER(5,0)',					'Porcentaje de la urbanización ejecutado (%)'	),
		T_ALTER(  'PORC_AMBITO_VAL_ENT',		'NUMBER(5,0)',					'Porcentaje del ámbito valorado (%) Sin decimales (Entero)'	),
		T_ALTER(  'DD_PRD_ID_PREV',				'NUMBER(16,0)',					'Producto que se prevé desarrollar'	),
		T_ALTER(  'PROYECTO_OBRA',				'NUMBER(1,0)',					'Proyecto de obra'	),
		T_ALTER(  'SUPERFICIE_TERRENO',			'NUMBER(16,0)',					'Superficie del terreno (m2)'	),
		T_ALTER(  'TAS_ANU_VAR_MERCADO',		'NUMBER(5,0)',					'Tasa anual media de variación del precio de mercado del activo [%]'	),
		T_ALTER(  'DD_TDU_ID',					'NUMBER(16,0)',					'Tipo de datos utilizados de inmuebles comparables'	),
		T_ALTER(  'VALOR_TERRENO',				'NUMBER(16,0)',					'Valor del terreno'	),
		T_ALTER(  'VALOR_TERRENO_AJUS',			'NUMBER(16,0)',					'Valor del terreno ajustado'	),
		T_ALTER(  'VAL_HIPO_EDI_TERM',			'NUMBER(16,0)',					'Valor en hipótesis de edificio terminado'	),
		T_ALTER(  'VALOR_HIPOTECARIO',			'NUMBER(16,0)',					'Valor hipotecario'	),
		T_ALTER(  'VISITA_ANT_INMUEBLE',		'NUMBER(1,0)',					'Visita al interior del inmueble'	)
		);
    V_T_ALTER T_ALTER;
    
	/* -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 						CAMPO FK 				TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_DD_DSP_TAS',			'DD_DSP_ID',		V_ESQUEMA||'.DD_DSP_DESARROLLO_PLANTEAMIENTO',				'DD_DSP_ID'),
		T_FK(	'FK_DD_FSG_TAS',			'DD_FSG_ID',		V_ESQUEMA||'.DD_FSG_FASE_GESTION',							'DD_FSG_ID'),
		T_FK(	'FK_DD_PRD_TAS',			'DD_PRD_ID',		V_ESQUEMA||'.DD_PRD_PRODUCTO_DESARROLLAR',					'DD_PRD_ID'),
		T_FK(	'FK_DD_PNU_TAS',			'DD_PNU_ID',		V_ESQUEMA||'.DD_PNU_PROX_RESP_NUCLEO_URB',					'DD_PNU_ID'),
		T_FK(	'FK_DD_SGT_TAS',			'DD_SGT_ID',		V_ESQUEMA||'.DD_SGT_SISTEMA_GESTION',						'DD_SGT_ID'),
		T_FK(	'FK_DD_SAC_TAS',			'DD_SAC_ID',		V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO',						'DD_SAC_ID'),
		T_FK(	'FK_DD_MTV_TAS',			'DD_MTV_ID',		V_ESQUEMA||'.DD_MTV_METODO_VALORACION',						'DD_MTV_ID'),
		T_FK(	'FK_DD_PRD_PREV_TAS',		'DD_PRD_ID_PREV',	V_ESQUEMA||'.DD_PRD_PRODUCTO_DESARROLLAR',					'DD_PRD_ID'),
		T_FK(	'FK_DD_TDU_TAS',			'DD_TDU_ID',		V_ESQUEMA||'.DD_TDU_TIPO_DAT_UTI_INM_COMP',					'DD_TDU_ID')
    );
    V_T_FK T_FK;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' )
			';

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');
		END IF;

	END LOOP;


	
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
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKs ... OK *************************************************');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	


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