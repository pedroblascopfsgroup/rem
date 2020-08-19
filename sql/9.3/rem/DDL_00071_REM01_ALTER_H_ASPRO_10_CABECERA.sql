--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10690
--## PRODUCTO=NO
--## Finalidad: Crear una nueva columna en la tabla H_ASPRO_10_CABECERA
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'H_ASPRO_10_CABECERA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
	-- ARRAY CON NUEVAS COLUMNAS
	TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
	TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
	V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    	-- NOMBRE CAMPO, TIPO CAMPO, DESCRIPCION
		T_ALTER('IMBGAR', 'VARCHAR2(15 CHAR)', 'Importe Base retención por garantía'),
		T_ALTER('PORGAR', 'VARCHAR2(5 CHAR)', 'Porcentaje Retención por Garantía'),
		T_ALTER('IMPGAR', 'VARCHAR2(15 CHAR)', 'Importe de la Retención por Garantía'),
		T_ALTER('FECGAR', 'VARCHAR2(8 CHAR)', 'Fecha Liberación de la Retención por Garantía')

	);
	V_T_ALTER T_ALTER;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('******** ' ||V_TEXT_TABLA|| ' ********'); 
	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP
		V_T_ALTER := V_ALTER(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' Comprobando si ya existe...');
		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[ OK ] No existe '''||V_T_ALTER(1)||'''. Insertando...');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||')';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] El campo '''||V_T_ALTER(1)||''' ha sido insertado correctamente en la tabla, con tipo '''||V_T_ALTER(2)||'''.');

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			
		END IF;

	END LOOP;
	
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
