--/*
--##########################################
--## AUTOR= Luis Caballero
--## FECHA_CREACION=20170720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2448
--## PRODUCTO=NO
--## Finalidad: Eliminar columna arrendamiento en CCC_CONFIG_CTAS_CONTABLES
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
	
	/* -- ARRAY CON COLUMNAS A BORRAR */
    TYPE T_DROP IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DROP IS TABLE OF T_DROP;
    V_DROP T_ARRAY_DROP := T_ARRAY_DROP(
    			-- NOMBRE CAMPO						
    	T_DROP(  'CCC_CUENTA_ANYO_CURSO'				),
    	T_DROP(  'CCC_CUENTA_ANYOS_ANTERIORES'			)
	);
	V_T_DROP T_DROP;
    
BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	 -- Mientras sea una tabla de configuración de la que extraemos información y no haya ninguna FK apuntando a su id, 
    -- podemos borrar la tabla completa y volver a generar la configuración.
    V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'|| V_TEXT_TABLA; 
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TRUNCADA');
    
	-- Bucle que BORRAS las columnas del array T_ARRAY_DROP
	FOR I IN V_DROP.FIRST .. V_DROP.LAST
	LOOP

		V_T_DROP := V_DROP(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, se borrará (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_DROP(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS > 0 THEN
			--Existe la columna y la borramos
			DBMS_OUTPUT.PUT_LINE('[INFO] Borrar columna ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_DROP(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   DROP COLUMN '||V_T_DROP(1);

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_DROP(1)||' Columna borrada en tabla');

		END IF;

	END LOOP;	
	
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