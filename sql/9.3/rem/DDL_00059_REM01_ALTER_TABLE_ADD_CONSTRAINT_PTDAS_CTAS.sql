--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10527
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir constraints a tabla de cuentas contables y partidas presupuestarias.
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
      -- Recordatorios
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_PTDAS_PREP', 'FK_CPP_DD_CRA_ID', 'DD_CRA_ID', 'DD_CRA_CARTERA', 'DD_CRA_ID'),
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_PTDAS_PREP', 'FK_CPP_DD_SCR_ID', 'DD_SCR_ID', 'DD_SCR_SUBCARTERA', 'DD_SCR_ID'),
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_PTDAS_PREP', 'FK_CPP_EJE_ID', 'EJE_ID', 'ACT_EJE_EJERCICIO', 'EJE_ID'),
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_CTAS_CONTABLES', 'FK_CCC_DD_CRA_ID', 'DD_CRA_ID', 'DD_CRA_CARTERA', 'DD_CRA_ID'),
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_CTAS_CONTABLES', 'FK_CCC_DD_SCR_ID', 'DD_SCR_ID', 'DD_SCR_SUBCARTERA', 'DD_SCR_ID'),
    T_COL(''||V_ESQUEMA||'', 'ACT_CONFIG_CTAS_CONTABLES', 'FK_CCC_EJE_ID', 'EJE_ID', 'ACT_EJE_EJERCICIO', 'EJE_ID')
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
        
        --Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_TMP_COL(1)||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN              
            -- Verificar si el campo ya existe
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_TMP_COL(1)||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(4)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 1 THEN
                V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo FK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_COL(1)||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' FOREIGN KEY ('||V_TMP_COL(4)||') REFERENCES '||V_TMP_COL(1)||'.'||V_TMP_COL(5)||'('||V_TMP_COL(6)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(4)||'... No existe.');
            END IF;    
      
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] ' ||V_TMP_COL(1)|| '.'||V_TMP_COL(2)||'... No existe.');  
        END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS]');
  
    
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
