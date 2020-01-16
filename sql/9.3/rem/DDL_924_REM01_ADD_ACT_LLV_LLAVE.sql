--/*
--##########################################
--## AUTOR=Lara Pablo Flores
--## FECHA_CREACION=20200115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9033
--## PRODUCTO=NO
--## Finalidad: Añadir una columnas a ACT_LLV_LLAVE
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_LLV_LLAVE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'DD_TTE_ID_POSEEDOR',		 		'NUMBER(16,0)',					'TIPO TENEDOR DE LA LLAVE.'	),
    	T_ALTER(  'LLV_COD_TENEDOR_POSEEDOR',		'NUMBER(16,0)',					'CODIGO REM TENEDOR DE LA LLAVE.'	),
    	T_ALTER(  'LLV_COD_TENEDOR_NO_PVE',		 	'VARCHAR2(100 CHAR)',			'CODIGO TENEDOR DE LA LLAVE CUANDO TENEDOR NO ES PROVEEDOR.'),	
    	
    	T_ALTER(  'LLV_FECHA_ANILLADO',		 		'TIMESTAMP(6)',					'FECHA DE ANILLADO DE LA LLAVE.'	),
    	T_ALTER(  'LLV_FECHA_RECEPCION',		 	'TIMESTAMP(6)',					'FECHA DE RECEPCIÓN DE LA LLAVE.'	),
    	T_ALTER(  'LLV_CODE',		 				'VARCHAR2(256 CHAR)',			'CÓDIGO QR DEL LLAVERO.'),
    	T_ALTER(  'LLV_COMPLETO',		 			'NUMBER(1)',					'LLAVERO COMPLETO.'	),
    	T_ALTER(  'LLV_OBSERVACIONES',		 		'VARCHAR2(100 CHAR)',			'OBSERVACIONES DEL LLAVERO.'	)
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
		
		V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE  CONSTRAINT_NAME = ''FK_LLV_DD_TTE_ID_POSEEDOR''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_LLV_DD_TTE_ID_POSEEDOR FOREIGN KEY (DD_TTE_ID_POSEEDOR) REFERENCES '||V_ESQUEMA||'.DD_TTE_TIPO_TENEDOR (DD_TTE_ID))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] FK_LLV_DD_TTE_ID_POSEEDOR creada.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] LA FK_LLV_DD_TTE_ID_POSEEDOR ya existe .');
		END IF;
		
		V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE  CONSTRAINT_NAME = ''FK_LLV_LLV_COD_TENEDOR_POSEEDOR''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_LLV_LLV_COD_TENEDOR_POSEEDOR FOREIGN KEY (LLV_COD_TENEDOR_POSEEDOR) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] FK_LLV_LLV_COD_TENEDOR_POSEEDOR creada.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] LA FK_LLV_LLV_COD_TENEDOR_POSEEDOR ya existe .');
		END IF;
		
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS LOS REGISTROS PARA PODER METER LAS RESTRICCIONES');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET LLV_COD_TENEDOR_NO_PVE = ''N/A''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS MODIFICADOS CORRECTAMENTE');
          
		
		
			V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE  CONSTRAINT_NAME = ''FK_LLV_RESTRICCION_POSEEDOR_NO_NULL''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_LLV_RESTRICCION_POSEEDOR_NO_NULL CHECK ((LLV_COD_TENEDOR_NO_PVE is not NULL AND LLV_COD_TENEDOR_POSEEDOR is NULL) OR (LLV_COD_TENEDOR_POSEEDOR is not NULL AND LLV_COD_TENEDOR_NO_PVE is NULL ) )';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] FK_LLV_RESTRICCION_POSEEDOR_NO_NULL creada.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] LA FK_LLV_RESTRICCION_POSEEDOR_NO_NULL ya existe .');
		END IF;
	
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' NO EXISTE');
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