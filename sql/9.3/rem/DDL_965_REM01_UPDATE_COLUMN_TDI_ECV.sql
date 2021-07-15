--/*
--######################################### 
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14607
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir columnas .
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene los registros que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('ADD_COLUMN', 'DD_TDI_TIPO_DOCUMENTO_ID', 'DD_TDI_CODIGO_C4C', 'VARCHAR2(20)', '0'),
    T_COL('ADD_COLUMN', 'DD_ECV_ESTADOS_CIVILES', 'DD_ECV_CODIGO_C4C', 'VARCHAR2(20)', '0')
  );  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'MOVE_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
                V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(4)||''' AND COLUMN_NAME = '''||V_TMP_COL(5)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo campo '||V_TMP_COL(3)||'');		 
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(4)||' ADD '||V_TMP_COL(5)||' '||V_TMP_COL(6);
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(3)||' ya existe. Se rellenará.');
                END IF;
                
                V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TMP_COL(4)||' T1
                	USING (
                		SELECT GPV.GPV_ID, GPV.'||V_TMP_COL(3)||'
                		FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||' GPV
                		WHERE EXISTS (
                			SELECT GPV2.GPV_ID
                			FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||' GPV2
                			JOIN '||V_ESQUEMA||'.'||V_TMP_COL(4)||' GLD ON GLD.GPV_ID = GPV2.GPV_ID
                				AND GLD.BORRADO = 0
                			WHERE GPV2.GPV_ID = GPV.GPV_ID
                			GROUP BY GPV2.GPV_ID
                			HAVING COUNT(1) = 1
                		)
                	) T2
                	ON (T1.GPV_ID = T2.GPV_ID)
                	WHEN MATCHED THEN UPDATE SET
                		T1.'||V_TMP_COL(5)||' = NVL(T2.'||V_TMP_COL(3)||', 0)';

                DBMS_OUTPUT.PUT_LINE(V_SQL);
                EXECUTE IMMEDIATE V_SQL;

                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP COLUMN '||V_TMP_COL(3);

            ELSE

                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(3)||' no existe.');
            
            END IF;

        END IF;

        IF 'DROP_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN

            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 1 THEN

                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando restricción única '||V_TMP_COL(3)||'');         
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA|| '.'||V_TMP_COL(2)||' DROP CONSTRAINT '||V_TMP_COL(3);     

                END IF;    

            ELSE
                
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');
            
            END IF; 

        END IF;

        IF 'DROP_COLUMN' = ''||V_TMP_COL(1)||'' AND ''||V_TMP_COL(4)||'' = '0' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
            	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP COLUMN '||V_TMP_COL(3);
            	DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha borrado el campo '||V_TMP_COL(3)||'.');         
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] No existe el campo '||V_TMP_COL(3)||'.');
            END IF; 

        ELSIF 'DROP_COLUMN' = ''||V_TMP_COL(1)||'' AND ''||V_TMP_COL(4)||'' = '1' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                --Comprobacion de la tabla
                V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'_BACKUP''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS = 0 THEN

                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||'_BACKUP VARCHAR2(50 CHAR)';
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha creado el campo '||V_TMP_COL(3)||'_BACKUP.'); 

                END IF;

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' SET '||V_TMP_COL(3)||'_BACKUP = '||V_TMP_COL(3);
                EXECUTE IMMEDIATE V_MSQL;

                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP COLUMN '||V_TMP_COL(3);
                DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha borrado el campo '||V_TMP_COL(3)||'.');      

            ELSE

                DBMS_OUTPUT.PUT_LINE('  [INFO] No existe el campo '||V_TMP_COL(3)||'.');
            
            END IF;         

        END IF;  
    
        IF 'ADD_COLUMN' = ''||V_TMP_COL(1)||'' AND ''||V_TMP_COL(5)||'' = '0' THEN
            --Comprobacion de la tabla
 			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4);
                DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha creado el campo '||V_TMP_COL(3)||'.');		         
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(3)||' ya existe.');
            END IF; 

        ELSIF 'ADD_COLUMN' = ''||V_TMP_COL(1)||'' AND ''||V_TMP_COL(5)||'' = '1' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN

                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4);
                DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha creado el campo '||V_TMP_COL(3)||'.');     

                V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' SET '||V_TMP_COL(3)||' = '||V_TMP_COL(3)||'_BACKUP';
                EXECUTE IMMEDIATE V_MSQL;

                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP COLUMN '||V_TMP_COL(3)||'_BACKUP';
                DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha borrado el campo '||V_TMP_COL(3)||'_BACKUP.');   

            ELSE
                
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(3)||' ya existe.');
            
            END IF; 

        END IF;

        IF 'ADD_UK' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN

                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo restricción única '||V_TMP_COL(3)||'');         
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA|| '.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' UNIQUE ('||V_TMP_COL(4)||')';       

                END IF;    

            ELSE
                
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');
            
            END IF; 
        
        END IF;

        IF 'ADD_FK' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN

                V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN

                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo clave foránea '||V_TMP_COL(3)||'');		 
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' FOREIGN KEY ('||V_TMP_COL(5)||') REFERENCES '||V_ESQUEMA||'.'||V_TMP_COL(4)||' ('||V_TMP_COL(5)||')';
                
                ELSE

                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                
                END IF;    

            ELSE

                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');

            END IF; 

        END IF;

    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
    
    COMMIT;  
    
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
