--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20161104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Ampliar la tabla que contiene los gastos de proveedor
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_DIS_DISTRIBUCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_CREAR_FK VARCHAR2(2 CHAR) := 'SI'; -- [SI, NO] Vble. para indicar al script si debe o no crear tambien las relaciones Foreign Keys.

	/* -- ARRAY NOMBRES COLUMNAS AUXILIARES */
	TYPE T_ALTER_RENAME IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER_RENAME IS TABLE OF T_ALTER_RENAME;
    V_ALTER_RENAME T_ARRAY_ALTER_RENAME := T_ARRAY_ALTER_RENAME(
    				--  NOMBRE NUEVO	--FK del nombre antiguo para borrar
    	T_ALTER_RENAME(  'ICO_AUX', 	'FK_DIST_VIVIENDA'	)
		);
    V_T_ALTER_RENAME T_ALTER_RENAME;
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'ICO_ID',		 					'NUMBER(16,0)',						'Código identificador único de la información comercial'	)
		);
    V_T_ALTER T_ALTER;
    
    
      /* TABLA: ACT_ICO_INFO_COMERCIAL -- ARRAY CON NUEVAS FOREIGN KEYS */
    TYPE T_FK IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    			--NOMBRE FK 							CAMPO FK 				TABLA DESTINO FK 							CAMPO DESTINO FK
    	T_FK(	'FK_INFOCOMER_VIVIENDA',				'ICO_ID',		V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL',					'ICO_ID'			)
    );
    V_T_FK T_FK;




BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	-- Renombramos columna, para luego copiar sus datos en la nueva columna, y borrarla finalmente.
	
	
	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);
		V_T_ALTER_RENAME := V_ALTER_RENAME(I);
		
		

		-- Verificar si la columna ya existe. Si ya existe la columna, la renombramos.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN -- Si existe, renombramos la columna
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] renombrar a: ['||V_T_ALTER_RENAME(1)||' ]-------------------------------------------');
			V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA|| ' 
					   RENAME COLUMN '||V_T_ALTER(1)||' TO '||V_T_ALTER_RENAME(1)||' 
			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Columna renombrada.');
			
			
		END IF;
		
		-- Comprobado FK de la columna antigua
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = '''||V_T_ALTER_RENAME(2)||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN -- Si existe, borramos la fk
			--Borramos su FK
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] borrar su FK: ['||V_T_ALTER_RENAME(2)||' ]-------------------------------------------');
			V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA|| ' 
					   DROP CONSTRAINT '||V_T_ALTER_RENAME(2)||' 
			';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER_RENAME(2)||'... FK BORRADA.');
		
		END IF;
		
		--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] ADD COLUMN------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||')
			';

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));
			

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');

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
	
	-- Bucle para volcar los datos de la columna auxiliar a la nueva, y luego borra la auxiliar
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP
	
		V_T_ALTER := V_ALTER(I);
		V_T_ALTER_RENAME := V_ALTER_RENAME(I);
	
		-- Verificar que existe la columna auxiliar, para volcar los datos de la original
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER_RENAME(1)||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;		
		IF V_NUM_TABLAS = 1 THEN -- Si existe, volcamos los datos de la auxiliar, a la nueva creada
			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR DATOS EN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
			V_MSQL := 'UPDATE '||V_TEXT_TABLA|| ' 
					   SET '||V_T_ALTER(1)||' = '||V_T_ALTER_RENAME(1)||' 
			';
			EXECUTE IMMEDIATE V_MSQL;
			
			-- Hacemos que la columna no pueda ser nula
			DBMS_OUTPUT.PUT_LINE('[INFO] hacer no nula la columna nueva ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   MODIFY '||V_T_ALTER(1)||' NOT NULL ENABLE
			';
			EXECUTE IMMEDIATE V_MSQL;
			
			--Quitamos la UK existente para poder borrar la columna auxiliar, y luego la crearemos con la nueva columna
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DROP CONSTRAINT UK_DIST_PLANTA_HAB ';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.UK_DIST_PLANTA_HAB... Unique key creada.');
			
			
			DBMS_OUTPUT.PUT_LINE('[INFO] BORRAR COLUMNA AUXILIAR ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'['||V_T_ALTER_RENAME(1)||'] -------------------------------------------');
			V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA|| ' 
					   DROP COLUMN '||V_T_ALTER_RENAME(1)||' 
			';
			EXECUTE IMMEDIATE V_MSQL;
			
			-- Creamos unique key (ICO_ID, DIS_NUM_PLANTA, DD_TPH_ID)
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION ADD CONSTRAINT UK_DIST_PLANTA_HAB UNIQUE (ICO_ID, DIS_NUM_PLANTA, DD_TPH_ID) ENABLE';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.UK_DIST_PLANTA_HAB... Unique key creada.');
			
		END IF;
		
	END LOOP;
	
	
	
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