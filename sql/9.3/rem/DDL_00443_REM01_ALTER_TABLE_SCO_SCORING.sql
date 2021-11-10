--/*
--##########################################
--## AUTOR= Lara Pablo Flores
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14714
--## PRODUCTO=NO
--## Finalidad: Alter table SCO_SCORING
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una columna.  
    V_NUM NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'SCO_SCORING'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_PREF_TABLA VARCHAR2(2400 CHAR) := 'SCO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(											--Nombre en la tabla fk
			T_TIPO_DATA('DD_RSE_ID', 'NUMBER(16,0)', 'Rating scoring servicer', 		'DD_RSE_ID', 'DD_RSE_RESULTADO_SCORING_SERVICER'),
			T_TIPO_DATA('DD_RAT_ID', 'NUMBER(16,0)', 'Resultado scoring servicer', 		'DD_RAT_ID', 'DD_RAT_RATING_SCORING_SERVICER'),
			T_TIPO_DATA('DD_GAO_ID', 'NUMBER(16,0)', 'Garantías adicionales oferta', 	'DD_GAO_ID', 'DD_GAO_GARANTIAS_ADICIONALES_OFERTA')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
    TYPE T_ALTER IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
   			--   NOMBRE CAMPO						TIPO CAMPO			DESCRIPCION
		T_ALTER('SCO_IMPORTE_GARANTIAS_AD',		'NUMBER(16,2)',		'Importe Garantías adicionales oferta')	    	    	    	
	);
    V_T_ALTER T_ALTER;

    
    
    
    
BEGIN

	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP      
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
          
      --Comprobacion de la tabla referencia
      V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = UPPER('''||TRIM(V_TMP_TIPO_DATA(5))||''')';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

      IF V_NUM_TABLAS > 0 THEN
        -- Comprobamos si existe columna      
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = UPPER('''||V_TEXT_TABLA||''') and owner = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si existe la columna cambiamos/establecemos solo la FK
          IF V_NUM_TABLAS = 1 THEN
              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'''... Ya existe, la modificamos');
              
              V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = UPPER('''||V_TEXT_TABLA||''') AND CONSTRAINT_NAME = ''FK_'|| V_PREF_TABLA ||'_'||TRIM(V_TMP_TIPO_DATA(1))||'''';
              EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
              
              IF V_NUM_TABLAS = 0 THEN
 				 V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_'|| V_PREF_TABLA ||'_'||TRIM(V_TMP_TIPO_DATA(1))||' FOREIGN KEY ('||TRIM(V_TMP_TIPO_DATA(1))||') REFERENCES '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(5))||' ('||TRIM(V_TMP_TIPO_DATA(4))||') ON DELETE SET NULL)';
	              EXECUTE IMMEDIATE V_MSQL;
	              DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... FK Modificada');
	          END IF;
          
          --Si no existe la columna, la creamos y establecemos la FK
          ELSE
              V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');

              V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_'||TRIM(V_TMP_TIPO_DATA(1))||' FOREIGN KEY ('||TRIM(V_TMP_TIPO_DATA(1))||') REFERENCES '||V_ESQUEMA||'.'||TRIM(V_TMP_TIPO_DATA(5))||' ('||TRIM(V_TMP_TIPO_DATA(4))||') ON DELETE SET NULL)';
              EXECUTE IMMEDIATE V_MSQL;
              DBMS_OUTPUT.PUT_LINE('[INFO] Constraint Creada');     

            EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';   
          END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('No se puede añadir el campo porque la tabla a la que hace referencia no existe, hay que lanzar el DDL previo');
      END IF;

    END LOOP;
    
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