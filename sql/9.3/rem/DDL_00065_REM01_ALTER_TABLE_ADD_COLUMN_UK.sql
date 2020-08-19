--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10745
--## PRODUCTO=NO
--## 
--## Finalidad: Añadircolumnas y UK a tablas de gastos
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
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_SUBCUENTA_BASE', 'VARCHAR(50 CHAR)', 'Subcuenta Base'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_APARTADO_BASE', 'VARCHAR(50 CHAR)', 'Apartado Base'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_CAPITULO_BASE', 'VARCHAR(50 CHAR)', 'Capítulo Base'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_SUBCUENTA_RECARGO', 'VARCHAR(50 CHAR)', 'Subcuenta Recargo'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_APARTADO_RECARGO', 'VARCHAR(50 CHAR)', 'Apartado Recargo'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_CAPITULO_RECARGO', 'VARCHAR(50 CHAR)', 'Capítulo Recargo'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_SUBCUENTA_TASA', 'VARCHAR(50 CHAR)', 'Subcuenta Tasa'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_APARTADO_TASA', 'VARCHAR(50 CHAR)', 'Apartado Tasa'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_CAPITULO_TASA', 'VARCHAR(50 CHAR)', 'Capítulo Tasa'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_SUBCUENTA_INTERESES', 'VARCHAR(50 CHAR)', 'Subcuenta Intereses'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_APARTADO_INTERESES', 'VARCHAR(50 CHAR)', 'Apartado Intereses'),
    T_COL('CREATE_COLUMN', 'GLD_GASTOS_LINEA_DETALLE', 'GLD_CAPITULO_INTERESES', 'VARCHAR(50 CHAR)', 'Capítulo Intereses'),
    T_COL('CREATE_COLUMN', 'ACT_CONFIG_PTDAS_PREP', 'DD_TBE_ID', 'NUMBER(16)', 'Tipo de activo BDE'),
    T_COL('CREATE_COLUMN', 'ACT_CONFIG_PTDAS_PREP', 'CPP_APARTADO', 'VARCHAR(50 CHAR)', 'Apartado partida presupuestaria'),
    T_COL('CREATE_COLUMN', 'ACT_CONFIG_PTDAS_PREP', 'CPP_CAPITULO', 'VARCHAR(50 CHAR)', 'Capítulo partida presupuestaria'),
    T_COL('ADD_CONSTRAINT', 'ACT_CONFIG_PTDAS_PREP', 'FK_CPP_DD_TBE', 'DD_TBE_ID','DD_TBE_TIPO_ACTIVO_BDE','DD_TBE_ID'),
    T_COL('CREATE_COLUMN', 'ACT_CONFIG_CTAS_CONTABLES', 'DD_TBE_ID', 'NUMBER(16)', 'Tipo de activo BDE'),
    T_COL('CREATE_COLUMN', 'ACT_CONFIG_CTAS_CONTABLES', 'CCC_SUBCUENTA_CONTABLE', 'VARCHAR(50 CHAR)', 'Subcuenta contable'),
    T_COL('ADD_CONSTRAINT', 'ACT_CONFIG_CTAS_CONTABLES', 'FK_CCC_DD_TBE', 'DD_TBE_ID','DD_TBE_TIPO_ACTIVO_BDE','DD_TBE_ID'),
    T_COL('DROP_CONSTRAINT', 'GLD_GASTOS_LINEA_DETALLE', 'UK_GLD_GASTOS_LINEA_DETALLE'),
    T_COL('ADD_UK', 'GLD_GASTOS_LINEA_DETALLE', 'UK_GLD_GASTOS_LINEA_DETALLE','GPV_ID, DD_STG_ID, DD_TIT_ID, GLD_IMP_IND_TIPO_IMPOSITIVO, BORRADO')
  );  
  V_TMP_COL T_COL;

 
BEGIN
    	
    -----------------------
    ---     CAMPOS      ---
    -----------------------

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'CREATE_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [CREATE_COLUMN]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo Columna '||V_TMP_COL(3)||'');
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4)||''; 

                    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TMP_COL(2)||'.'||V_TMP_COL(3)||' IS '''||V_TMP_COL(5)||'''';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna '||V_TMP_COL(3)||' creado.');      
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... ya existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');  
            END IF;
        END IF;

        IF 'DROP_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [DROP_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando FK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' DROP CONSTRAINT '||V_TMP_COL(3)||'';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' no existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'.. No existe.');
            END IF;    
        END IF;

        IF 'ADD_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiento FK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' FOREIGN KEY('||V_TMP_COL(4)||') REFERENCES '||V_TMP_COL(5)||'('||V_TMP_COL(6)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' no existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'... No existe.');
            END IF;    
        END IF;

        IF 'ADD_UK' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_UK]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo UK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' UNIQUE ('||V_TMP_COL(4)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' no existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'... No existe.');
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
