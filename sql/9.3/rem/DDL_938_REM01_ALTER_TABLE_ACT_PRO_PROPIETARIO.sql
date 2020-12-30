--/*
--######################################### 
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20200930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11270
--## PRODUCTO=NO
--## 
--## Finalidad: Incluir campos en la tabla ACT_PRO_PROPIETARIO.
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

    T_COL(''||V_ESQUEMA||'', 'ACT_PRO_PROPIETARIO', 'PRO_CODIGO_ENTIDAD', 'VARCHAR(20 CHAR)', 'Codigo de la entidad'),
    T_COL(''||V_ESQUEMA||'', 'ACT_PRO_PROPIETARIO', 'PRO_TITULIZADO', 'VARCHAR(20 CHAR)', 'Titulizado')
 
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
        DBMS_OUTPUT.PUT_LINE(V_SQL);  
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN              
            -- Verificar si el campo ya existe
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_TMP_COL(1)||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Creando el campo '||V_TMP_COL(3)||' junto a su comentario...');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_COL(1)||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4)||'';
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.'||V_TMP_COL(2)||'.'||V_TMP_COL(3)||' IS '''||V_TMP_COL(5)||'''';        
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... Ya existe.');
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
