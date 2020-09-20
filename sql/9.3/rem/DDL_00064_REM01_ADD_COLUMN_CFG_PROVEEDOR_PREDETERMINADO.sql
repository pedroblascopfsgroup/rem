--/*
--##########################################
--## AUTOR=Daniel Algba
--## FECHA_CREACION=20200921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11239
--## PRODUCTO=NO
--## Finalidad: Ampliar la tabla CFG_PVE_PREDETERMINADO
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.
	V_TRUNCAR VARCHAR2(2 CHAR) := 'SI';
	V_BORRAR_UK VARCHAR2(2 CHAR) := 'SI';
	V_INS_UK VARCHAR2(2 CHAR) := 'SI';
	V_DROP_COLUMN VARCHAR2(2 CHAR) := 'SI';

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'DD_PRV_ID',			'NUMBER(16,0) NOT NULL',			'Identificador único de la provincia'	)
		);
    V_T_ALTER T_ALTER;

	/* -- ARRAY CON BORRAR COLUMNAS */
    TYPE T_DROP IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_DROP IS TABLE OF T_DROP;
    V_DROP T_ARRAY_DROP := T_ARRAY_DROP(
    			-- NOMBRE CAMPO
    	T_DROP(  'DD_STR_ID'),
		T_DROP(  'PROVEEDOR_DEFECTO')
		);
    V_T_DROP T_DROP;
    
	/* -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 						CAMPO FK 				TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_CPP_PRV',			'DD_PRV_ID',		V_ESQUEMA_M||'.DD_PRV_PROVINCIA',				'DD_PRV_ID')
    );
    V_T_FK T_FK;

	/* -- ARRAY CON BORRADOS DE UKs o FKs */
    TYPE T_BUK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_BUK IS TABLE OF T_BUK;
    V_BUK T_ARRAY_BUK := T_ARRAY_BUK(
    			--NOMBRE UK 
    	T_BUK(	'CPP_STR_FK'),
		T_BUK(	'UK_CPP_CRA_SCR_TTR_STR_PVE_BORRADO'),
		T_BUK(	'UK_CPP_CRA_SCR_TTR_PRV_PVE_BORRADO')
    );
    V_T_BUK T_BUK;

	/* -- ARRAY CON NUEVAS UKs */
    TYPE T_UK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_UK IS TABLE OF T_UK;
    V_UK T_ARRAY_UK := T_ARRAY_UK(
    			--NOMBRE FK 						CAMPOS UK
    	T_UK(	'UK_CPP_CRA_SCR_TTR_PRV_PVE_BORRADO',	'DD_TTR_ID, PVE_ID, DD_PRV_ID, DD_CRA_ID, DD_SCR_ID, BORRADO')
    );
    V_T_UK T_UK;


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	IF V_TRUNCAR = 'SI' THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||', TRUNCAMOS EL CONTENIDO DE PRUEBAS');
		V_MSQL := 'TRUNCATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;
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

	IF V_BORRAR_UK = 'SI' THEN

		-- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
		FOR I IN V_BUK.FIRST .. V_BUK.LAST
		LOOP

			V_T_BUK := V_BUK(I);	

			-- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
			V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_BUK(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 1 THEN
				--No existe la FK y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_BUK(1)||'] -------------------------------------------');
				V_MSQL := '
					ALTER TABLE '||V_TEXT_TABLA||'
					DROP CONSTRAINT '||V_T_BUK(1)||'';

				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_BUK(1)||' borrada UK... OK');
			END IF;

		END LOOP;

	END IF;

	IF V_DROP_COLUMN = 'SI' THEN

		-- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
		FOR I IN V_DROP.FIRST .. V_DROP.LAST
		LOOP

			V_T_DROP := V_DROP(I);	

			-- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
			V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_DROP(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 1 THEN
				--No existe la FK y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_DROP(1)||'] -------------------------------------------');
				V_MSQL := '
					ALTER TABLE '||V_TEXT_TABLA||'
					DROP COLUMN '||V_T_DROP(1)||'';

				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_DROP(1)||' borrada UK... OK');
			END IF;

		END LOOP;

	END IF;

	IF V_INS_UK = 'SI' THEN

		-- Bucle que CREA las FK de las nuevas columnas del INFORME COMERCIAL
		FOR I IN V_UK.FIRST .. V_UK.LAST
		LOOP

			V_T_UK := V_UK(I);	

			-- Verificar si la FK ya existe. Si ya existe la FK, no se hace nada.
			V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_UK(1)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
			IF V_NUM_TABLAS = 0 THEN
				--No existe la FK y la creamos
				DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_UK(1)||'] -------------------------------------------');
				V_MSQL := '
					ALTER TABLE '||V_TEXT_TABLA||'
					ADD CONSTRAINT '||V_T_UK(1)||' UNIQUE
					(
					  '||V_T_UK(2)||'
					)
				';

				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE('[3] '||V_MSQL);
				DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_UK(1)||' añadida en UK... OK');
			END IF;

		END LOOP;

	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' AMPLIADA CON COLUMNAS NUEVAS, FKs y UKs ... OK *************************************************');
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