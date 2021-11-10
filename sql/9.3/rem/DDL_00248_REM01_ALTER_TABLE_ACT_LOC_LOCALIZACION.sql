--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20210513
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13938
--## PRODUCTO=NO
--## Finalidad: Actualizamos/Creamos columnas en ACT_LOC_LOCALIZACION
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_LOC_LOCALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO							TIPO CAMPO					DESCRIPCION												FK								TABLE_FK											Referencia
    	T_ALTER(  'DD_PLN_ID',	'NUMBER (16,0)',	'Identificador único FK a DD_PLN_PLANTA_EDIFICIO',		'FK_DD_PLN_ID',		''||V_ESQUEMA||'.DD_PLN_PLANTA_EDIFICIO',		'DD_PLN_ID'),
    	T_ALTER(  'DD_ESE_ID',	'NUMBER (16,0)',	'Identificador único FK a DD_ESE_ESCALERA_EDIFICIO',	'FK_DD_ESE_ID',		''||V_ESQUEMA||'.DD_ESE_ESCALERA_EDIFICIO',		'DD_ESE_ID')
	);
	V_T_ALTER T_ALTER;

    
BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *********');

	
	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	

		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||'... Ya existe. Se continua.');
		ELSE
			-- Se crea la columna y se le agrega un comentario.
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||')';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||'... Creada');
			
			IF V_T_ALTER(4) = '0' THEN
				DBMS_OUTPUT.PUT_LINE('No hay que crear fk');
			ELSE
				V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= '''||V_T_ALTER(4)||''' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
				
				IF V_NUM_TABLAS = 1 THEN
					DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(4)||'... Ya existe. No hacemos nada.');		
				ELSE
		            V_SQL :='ALTER TABLE '||V_TEXT_TABLA||' ADD CONSTRAINT '||V_T_ALTER(4)||' FOREIGN KEY ('||V_T_ALTER(1)||') REFERENCES '||V_T_ALTER(5)||' ('||V_T_ALTER(6)||')';
		            DBMS_OUTPUT.PUT_LINE(V_SQL);
		            EXECUTE IMMEDIATE V_SQL;
		       END IF;
		    END IF;
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
