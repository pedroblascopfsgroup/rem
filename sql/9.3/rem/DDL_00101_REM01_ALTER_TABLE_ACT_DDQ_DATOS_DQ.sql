--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11700
--## PRODUCTO=NO
--## Finalidad: Actualizamos/Creamos columnas en ACT_DDQ_DATOS_DQ
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_DDQ_DATOS_DQ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(				
    	T_ALTER('DESCRIPCION','VARCHAR2(2000 CHAR)'),
		T_ALTER('ANYO_CONSTRUCCION','NUMBER(8,0)'),
		T_ALTER('DDQ_IDUFIR','VARCHAR2(2000 CHAR)'),
		T_ALTER('DESCRIPCION_CARGAS','VARCHAR2(2000 CHAR)'),
		T_ALTER('MENSAJE_IMAGENES','VARCHAR2(2000 CHAR)'),
		T_ALTER('MENSAJE_CEE','VARCHAR2(2000 CHAR)'),
		T_ALTER('EST_IMAGENES','VARCHAR2(100 CHAR)'),
		T_ALTER('EST_CEE','VARCHAR2(100 CHAR)')	
	);
    V_T_ALTER T_ALTER;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS > 0 THEN
	-- Bucle que CREA las nuevas columnas 
		FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
		LOOP
	
			V_T_ALTER := V_ALTER(I);
	
			-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS > 0 THEN
				--No existe la columna y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
				V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' MODIFY ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' )';
	
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));
	
			END IF;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' cambiada');
		END LOOP;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	END IF;
	


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
