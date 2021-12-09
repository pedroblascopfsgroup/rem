--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16568
--## PRODUCTO=NO
--##
--## Finalidad:        Anyadir columna y FK    
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una columna.  
    V_NUM NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GLD_ENT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('DD_TCO_ID'         , 'NUMBER(16,0)'     , 'ID destino comercial'           ,'DD_TCO_TIPO_COMERCIALIZACION'),
			T_TIPO_DATA('DD_EAL_ID'         , 'NUMBER(16,0)'     , 'ID estado alquiler'             ,'DD_EAL_ESTADO_ALQUILER'),
			T_TIPO_DATA('DD_TTR_ID'         , 'NUMBER(16,0)'     , 'ID tipo transmisión'            ,'DD_TTR_TIPO_TRANSMISION'),
			T_TIPO_DATA('PRIM_TOMA_POSESION', 'NUMBER(1,0)'      , 'Indicador de primera posesión'  ,'ACT_TBJ_TRABAJO'),
			T_TIPO_DATA('GRUPO'             , 'VARCHAR2(2 CHAR)' , 'Grupo'                          ,'DD_ETG_EQV_TIPO_GASTO'),
			T_TIPO_DATA('TIPO'              , 'VARCHAR2(2 CHAR)' , 'Tipo'                           ,'DD_ETG_EQV_TIPO_GASTO'),
			T_TIPO_DATA('SUBTIPO'           , 'VARCHAR2(2 CHAR)' , 'Subtipo'                        ,'DD_ETG_EQV_TIPO_GASTO')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN

      -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
        FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP      
          V_TMP_TIPO_DATA := V_TIPO_DATA(I);
              
          --Comprobacion de la tabla referencia
          V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_TIPO_DATA(4)||'''';
          EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

          IF V_NUM_TABLAS > 0 THEN
            -- Comprobamos si existe columna      
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||TRIM(V_TMP_TIPO_DATA(1))||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
            -- Si existe la columna cambiamos/establecemos solo la FK, si es distinta de GRUPO, TIPO, SUBTIPO o PRIM_TOMA_POSESION
              IF V_NUM_TABLAS = 1 AND (V_TMP_TIPO_DATA(1) = 'DD_TCO_ID' OR V_TMP_TIPO_DATA(1)= 'DD_EAL_ID' OR V_TMP_TIPO_DATA(1) = 'DD_TTR_ID') THEN
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'... Ya existe, modificamos la FK');
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP CONSTRAINT FK_GEN_'||V_TMP_TIPO_DATA(1)||'';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... FK Dropeada');
                  
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_GEN_'||V_TMP_TIPO_DATA(1)||' FOREIGN KEY 
                                        ('||V_TMP_TIPO_DATA(1)||') REFERENCES '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(4)||' ('||V_TMP_TIPO_DATA(1)||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... FK Modificada');
              
              --Si no existe la columna, la creamos y establecemos la FK, si es distinta de GRUPO, TIPO, SUBTIPO o PRIM_TOMA_POSESION
              ELSIF V_NUM_TABLAS = 0  AND (V_TMP_TIPO_DATA(1) = 'DD_TCO_ID' OR V_TMP_TIPO_DATA(1)= 'DD_EAL_ID' OR V_TMP_TIPO_DATA(1) = 'DD_TTR_ID') THEN
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' )';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');

                  -- Creamos comentario	
                  V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';		
                  EXECUTE IMMEDIATE V_MSQL;
                  
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');

                  -- Creamos FK	
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_GEN_'||V_TMP_TIPO_DATA(1)||' FOREIGN KEY 
                                        ('||V_TMP_TIPO_DATA(1)||') REFERENCES '||V_ESQUEMA||'.'||V_TMP_TIPO_DATA(4)||' ('||V_TMP_TIPO_DATA(1)||') ON DELETE SET NULL)';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Constraint Creada');      
            
              -- Si existe la columna GRUPO, TIPO, SUBTIPO o PRIM_TOMA_POSESION
              ELSIF V_NUM_TABLAS = 1 AND (V_TMP_TIPO_DATA(1) = 'GRUPO' OR V_TMP_TIPO_DATA(1) = 'TIPO' OR V_TMP_TIPO_DATA(1) = 'SUBTIPO' OR V_TMP_TIPO_DATA(1) = 'PRIM_TOMA_POSESION') THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||TRIM(V_TMP_TIPO_DATA(1))||'... Ya existe');
              
              --Si no existe la columna GRUPO, TIPO, SUBTIPO o PRIM_TOMA_POSESION , la creamos
              ELSE 
                  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
                  EXECUTE IMMEDIATE V_MSQL;
                  DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||'... Creada');

                  -- Creamos comentario	
                  V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(3)||'''';		
                  EXECUTE IMMEDIATE V_MSQL;
                  
                  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');        

              END IF;
          ELSE
            DBMS_OUTPUT.PUT_LINE('No se puede añadir el campo porque la tabla a la que hace referencia no existe');
          END IF;

        END LOOP;
    COMMIT;
	
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