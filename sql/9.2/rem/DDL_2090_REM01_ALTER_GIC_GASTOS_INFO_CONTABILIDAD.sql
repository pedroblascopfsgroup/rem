--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20161110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    
  
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'GIC_CUENTA_CONTABLE',		 		'VARCHAR2(50 CHAR)',					'Cuenta contable del gasto'),
    	T_ALTER(  'GIC_PTDA_PRESUPUESTARIA',		 	'VARCHAR2(50 CHAR)',					'Partida presupuestaria del gasto'),
    	T_ALTER(  'GIC_CUENTA_CONTABLE_ESP',	 	'VARCHAR2(50 CHAR)',					'Cuenta contable especial del gasto'),
    	T_ALTER(  'GIC_PTDA_PRESUPUESTARIA_ESP',	'VARCHAR2(50 CHAR)',					'Partida presupuestaria especial del gasto')
		);
    V_T_ALTER T_ALTER;
    
    /* -- ARRAY CON COLUMNAS A BORRAR */
    TYPE T_ARRAY_ALTER_DROP IS TABLE OF T_ALTER;
    V_ALTER_DROP T_ARRAY_ALTER_DROP := T_ARRAY_ALTER_DROP(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'DD_CCO_ID'),
    	T_ALTER(  'DD_PPR_ID'),
    	T_ALTER(  'DD_CCO_ID_ESPECIAL'),
    	T_ALTER(  'DD_PPR_ID_ESPECIAL')
		);
    V_T_ALTER_DROP T_ALTER;
       
    
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Borramos columnas de T_ARRAY_ALTER_DROP *************************************************');

	-- Bucle que BORRA las columnas de 
	FOR I IN V_ALTER_DROP.FIRST .. V_ALTER_DROP.LAST
	LOOP

		V_T_ALTER_DROP := V_ALTER_DROP(I);

		-- Verificar si la columna existe. Si existe LA BORRAMOS.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER_DROP(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS != 0 THEN
			--Existe la columna y la borramos
			DBMS_OUTPUT.PUT_LINE('[INFO] Borramos ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER_DROP(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   DROP COLUMN '||V_T_ALTER_DROP(1)||'';

			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER_DROP(1)||' Columna '||V_T_ALTER_DROP(1)||' BORRADA');
		END IF;

	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Añadimos columnas de T_ARRAY_ALTER *************************************************');
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
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' ALTER TABLA  OK *************************************************');
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	
	
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

EXIT