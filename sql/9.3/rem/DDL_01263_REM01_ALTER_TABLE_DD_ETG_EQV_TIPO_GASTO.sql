--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20211215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16615
--## PRODUCTO=NO
--## Finalidad: MODIFICACION DE COLUMNAS DE DD_ETG_EQV_TIPO_GASTO
--##           
--## INSTRUCCIONES:
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ETG_EQV_TIPO_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER('DD_SED_ID',		 				'NUMBER(16,0)',						'FK a la tabla DD_SED_SUBPARTIDA_EDIFICACION.')
		);
    V_T_ALTER T_ALTER;
    
          /* ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 							CAMPO FK 					TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_ETG_SED_ID',				'DD_SED_ID',				V_ESQUEMA||'.DD_SED_SUBPARTIDA_EDIFICACION',				'DD_SED_ID'			)
    );
    V_T_FK T_FK;
    

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');
	
	-- Verificar si la FK ya existe. Si ya existe, se elimina
		V_MSQL := 'SELECT COUNT(1) FROM all_constraints WHERE OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_ETG_SED_ID''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS > 0 THEN
			--Si existe no se hace nada.
			DBMS_OUTPUT.PUT_LINE('[INFO] ... FK existe. ');
		END IF;
		
		-- Verificar si la columna ya existe. Si ya existe la columna, se elimina.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''DD_SED_ID'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS > 0 THEN
			--Si existe no se hace nada
			DBMS_OUTPUT.PUT_LINE('[INFO] ... Columna ya existe');
		END IF;

	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
		
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' )';

			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] ... Columna INSERTADA en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' correcto');

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;

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
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'-------------------------------------------');
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
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_FK(1)||' creada en tabla: FK en columna '||V_T_FK(2)||' hacia '||V_T_FK(3)||'.'||V_T_FK(4)||'... OK');

			END IF;

		END LOOP;

	END IF;

	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS Y FKS .... OK *************************************************');
	
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