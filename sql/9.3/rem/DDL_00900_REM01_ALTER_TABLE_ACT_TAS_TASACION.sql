--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16362
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

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
		T_ALTER(  'APROV_PARCELA_SUELO',		'NUMBER(10,2)',					'Aprovechamiento de la parcela en m2 (suelo) - Campo APRV Flesb'	),
		T_ALTER(  'SUPERFICIE_ADOPTADA',		'NUMBER(6,2)',					'Superficie adoptada (metros cuadrados) - Campo SAD en FlesB'	),
		T_ALTER(  'APROVECHAMIENTO',			'NUMBER(15,2)',					'Aprovechamiento (m2)'	),
		T_ALTER(  'COSTE_EST_TER_OBRA',			'NUMBER(15,2)',					'Coste estimado para terminar la obra'	),
		T_ALTER(  'COSTE_DEST_PROPIO',			'NUMBER(15,2)',					'Coste por el que se destina a uso propio'	),
		T_ALTER(  'MET_RES_DIN_TAS_ANU',		'NUMBER(5,2)',					'Método residual dinámico. Tasa anualizada homogénea [%]'	),
		T_ALTER(  'MET_RES_DIN_TIPO_ACT',		'NUMBER(5,2)',					'Método residual dinámico. Tipo de Actualización [%]'	),
		T_ALTER(  'MET_RES_EST_MAR_PROM',		'NUMBER(5,2)',					'Método residual estático. Margen de beneficio del promotor [%]'	),
		T_ALTER(  'PORC_URB_EJECUTADO',			'NUMBER(7,2)',					'Porcentaje de la urbanización ejecutado (%)'	),
		T_ALTER(  'PORC_AMBITO_VAL_ENT',		'NUMBER(7,2)',					'Porcentaje del ámbito valorado (%) Sin decimales (Entero)'	),
		T_ALTER(  'SUPERFICIE_TERRENO',			'NUMBER(15,2)',					'Superficie del terreno (m2)'	),
		T_ALTER(  'TAS_ANU_VAR_MERCADO',		'NUMBER(5,2)',					'Tasa anual media de variación del precio de mercado del activo [%]'	),
		T_ALTER(  'VALOR_TERRENO',				'NUMBER(15,2)',					'Valor del terreno'	),
		T_ALTER(  'VALOR_TERRENO_AJUS',			'NUMBER(15,2)',					'Valor del terreno ajustado'	),
		T_ALTER(  'VAL_HIPO_EDI_TERM',			'NUMBER(15,2)',					'Valor en hipótesis de edificio terminado'	),
		T_ALTER(  'VALOR_HIPOTECARIO',			'NUMBER(15,2)',					'Valor hipotecario'	)
		);
    V_T_ALTER T_ALTER;

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
		IF V_NUM_TABLAS = 1 THEN
			--No existe la columna modificamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   MODIFY '||V_T_ALTER(1)||' '||V_T_ALTER(2)||'
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

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFICADAS COLUMNAS NUEVAS ... OK *************************************************');
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