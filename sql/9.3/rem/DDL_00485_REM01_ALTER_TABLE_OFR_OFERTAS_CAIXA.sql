--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210906
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15058
--## PRODUCTO=NO
--## Finalidad: Anyadir FK a la OFR_OFERTAS_CAIXA
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    
    
    /* -- ARRAY CON NUEVAS COLUMNAS */
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    			--NOMBRE CAMPO	    --TIPO CAMPO		--DESCRIPCION			--Nombre FK		        -Tabla de dónde viene           -Campo a FK  -Tabla
        T_ALTER('DD_TVB_ID'     ,'NUMBER(16,0)' ,'FK a DD_TVB_TIPOLOGIA_VENTA_BC' ,'FK_DD_TVB_ID'     ,'DD_TVB_TIPOLOGIA_VENTA_BC', 'DD_TVB_ID','OFR_OFERTAS_CAIXA')
    );
    V_T_ALTER T_ALTER;

BEGIN
	
	
	-- Bucle que CREA las nuevas columnas 
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST
	LOOP

		V_T_ALTER := V_ALTER(I);

		DBMS_OUTPUT.PUT_LINE('********' ||V_T_ALTER(7)|| '********'); 
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_T_ALTER(7)||'... Comprobaciones previas ');


		-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = '''||V_T_ALTER(1)||''' and TABLE_NAME = '''||V_T_ALTER(7)||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			--No existe la columna y la creamos
			DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_T_ALTER(7)||'['||V_T_ALTER(1)||'] ');
			V_MSQL := 'ALTER TABLE '||V_T_ALTER(7)|| ' 
					   ADD ('||V_T_ALTER(1)||' '||V_T_ALTER(2)||' )';

			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ... '||V_T_ALTER(1)||' Columna INSERTADA en tabla, con tipo '||V_T_ALTER(2));

			-- Creamos comentario	
			V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_T_ALTER(7)||'.'||V_T_ALTER(1)||' IS '''||V_T_ALTER(3)||'''';		
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE('[2] '||V_MSQL);
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(7)||'... Comentario en columna creado.');

			-- Creamos FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_T_ALTER(7)||' ADD CONSTRAINT '||V_T_ALTER(4)||' FOREIGN KEY 
						('||V_T_ALTER(1)||') REFERENCES '||V_ESQUEMA||'.'||V_T_ALTER(5)||'('||V_T_ALTER(6)||')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  '''||V_T_ALTER(4)||'''... FK creada.');

		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]  La columna '||V_T_ALTER(1)||', ya existe.');

		END IF;

	END LOOP;

	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_T_ALTER(7)||' AMPLIADA CON COLUMNAS NUEVAS... OK ');
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