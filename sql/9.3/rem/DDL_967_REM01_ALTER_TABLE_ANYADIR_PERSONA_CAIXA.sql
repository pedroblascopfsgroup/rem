--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20211003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-8672
--## PRODUCTO=NO
--## Finalidad: Ampliar varias tablas
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_CAMPO VARCHAR(1000 CHAR); -- Vble para concatenar campos;

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 


	/* -- ARRAY CON LAS TABLAS EN LAS QUE SE VA ACREAR */
    TYPE T_TABLES IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TABLES IS TABLE OF T_TABLES;
    V_TABLES T_ARRAY_TABLES := T_ARRAY_TABLES(
    					-- NOMBRE TABLA					NOMBRE AÑADIDO CAMPO							ACCION A HACER (C = CREATE, CA = CREATE ALL, U = UPDATE)
    	T_TABLES(  'CEX_COMPRADOR_EXPEDIENTE',					'CEX_',												'C'),
    	T_TABLES(  'IOC_INTERLOCUTOR_PBC_CAIXA',				'IOC_',												'U'	),
    	T_TABLES(  'OFR_TIA_TITULARES_ADICIONALES',				'TIA_',												'CA'	),
    	T_TABLES(  'CLC_CLIENTE_COMERCIAL',						'CLC_',												'CA'),
    	T_TABLES(  'IAP_INFO_ADC_PERSONA',						'IAP_',												'C'	),
    	T_TABLES(  'COM_COMPRADOR',								'COM_',												'C'	)
		);
    V_T_TABLES T_TABLES;

    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			-- NOMBRE CAMPO						TIPO CAMPO							DESCRIPCION
    	T_ALTER(  'ID_PERSONA_HAYA_CAIXA',			'VARCHAR2(50 CHAR)',			'Identificador único de la persona para la cartera Caixa'	),
    	T_ALTER(  'ID_PERSONA_HAYA_CAIXA_REPR',			'VARCHAR2(50 CHAR)',			'Id persona Haya del representante para la cartera Caixa'	)
		);
    V_T_ALTER T_ALTER;


BEGIN


	FOR I IN V_TABLES.FIRST .. V_TABLES.LAST
	LOOP

		V_T_TABLES := V_TABLES(I);
	
		DBMS_OUTPUT.PUT_LINE('********' ||V_T_TABLES(1)|| '********'); 
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_T_TABLES(1)||'... Comprobaciones previas *************************************************');

		-- Bucle que CREA las nuevas columnas 
		FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
		LOOP

			V_T_ALTER := V_ALTER(I);
			V_MSQL := 'SELECT CONCAT('''||V_T_TABLES(2)||''', '''||V_T_ALTER(1)||''') FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_CAMPO;	
			DBMS_OUTPUT.PUT_LINE('[0] '||V_CAMPO);

			IF V_T_TABLES(3) = 'CA' THEN

				-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
				V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_CAMPO||''' and TABLE_NAME = '''||V_T_TABLES(1)||''' and owner = '''||V_ESQUEMA||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
				IF V_NUM_TABLAS = 0 THEN
					--No existe la columna y la creamos
					DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'['||V_T_ALTER(1)||'] -------------------------------------------');
					V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_T_TABLES(1)|| ' 
							   ADD ('||V_CAMPO||' '||V_T_ALTER(2)||' )
					';

					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
					DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

					-- Creamos comentario	
					V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_TABLES(1)||'.'||V_CAMPO||' IS '''||V_T_ALTER(3)||'''';		
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
					DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'... Comentario en columna creado.');
				END IF;

			ELSIF V_T_TABLES(3) = 'C' THEN

                IF V_T_ALTER(1) = 'ID_PERSONA_HAYA_CAIXA' AND V_T_TABLES(1) != 'CEX_COMPRADOR_EXPEDIENTE' THEN
                    -- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
                    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_CAMPO||''' and TABLE_NAME = '''||V_T_TABLES(1)||''' and owner = '''||V_ESQUEMA||'''';
                    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                    IF V_NUM_TABLAS = 0 THEN
                        --No existe la columna y la creamos
                        DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'['||V_T_ALTER(1)||'] -------------------------------------------');
                        V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_T_TABLES(1)|| '
                                   ADD ('||V_CAMPO||' '||V_T_ALTER(2)||' )
                        ';

                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
                        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

                        -- Creamos comentario
                        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_TABLES(1)||'.'||V_CAMPO||' IS '''||V_T_ALTER(3)||'''';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
                        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'... Comentario en columna creado.');
                    END IF;

				ELSIF V_T_TABLES(1) = 'CEX_COMPRADOR_EXPEDIENTE' THEN
                    -- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
                    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_CAMPO||''' and TABLE_NAME = '''||V_T_TABLES(1)||''' and owner = '''||V_ESQUEMA||'''';
                    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
                    IF V_NUM_TABLAS = 0 THEN
                        --No existe la columna y la creamos
                        DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'['||V_T_ALTER(1)||'] -------------------------------------------');
                        V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_T_TABLES(1)|| '
                                   ADD ('||V_CAMPO||' '||V_T_ALTER(2)||' )
                        ';

                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
                        DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

                        -- Creamos comentario
                        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_TABLES(1)||'.'||V_CAMPO||' IS '''||V_T_ALTER(3)||'''';
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
                        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'... Comentario en columna creado.');
                    END IF;
				END IF;

			ELSIF V_T_TABLES(3) = 'U' THEN

				-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)

				V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''IOC_ID_PERSONA_HAYA'' and TABLE_NAME = '''||V_T_TABLES(1)||''' and owner = '''||V_ESQUEMA||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
				V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_CAMPO||''' and TABLE_NAME = '''||V_T_TABLES(1)||''' and owner = '''||V_ESQUEMA||'''';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS2;	
				IF V_NUM_TABLAS > 0 AND V_NUM_TABLAS2 = 0 THEN 
					--No existe la columna y la creamos
					DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||'['||V_T_ALTER(1)||'] -------------------------------------------');
					V_MSQL := 'ALTER TABLE ' ||V_ESQUEMA||'.'||V_T_TABLES(1)|| ' 
							   RENAME COLUMN IOC_ID_PERSONA_HAYA TO '||V_CAMPO||'
					';

					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
					DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));
				END IF;

			END IF;

		END LOOP;

	END LOOP;

	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_TABLES(1)||' AMPLIADA CON COLUMNAS NUEVAS Y FKs ... OK *************************************************');
	--COMMIT;
	ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
	


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('[ERROR] ...KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
		  DBMS_OUTPUT.PUT_LINE(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT