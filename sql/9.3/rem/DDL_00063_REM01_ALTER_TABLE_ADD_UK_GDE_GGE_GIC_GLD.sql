--/*
--######################################### 
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200716
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10527
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir constraints a tablas de gastos.
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
    T_COL('DROP_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GPV_ID'),
    T_COL('DROP_INDEX', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GPV_ID'),
    T_COL('DROP_INDEX', 'GGE_GASTOS_GESTION', 'GEE_GASTOS_GESTION_IDX2'),
    T_COL('DROP_INDEX', 'GIC_GASTOS_INFO_CONTABILIDAD', 'GIC_GASTON_INFO_CONT_IDX'),
    T_COL('DROP_INDEX', 'GGE_GASTOS_GESTION', 'GGE_GASTOS_GESTION_IDX1'),
    T_COL('CREATE_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GASTOS_DETALLE_ECONOMICO', 'GPV_ID, BORRADO'),
    T_COL('CREATE_CONSTRAINT', 'GGE_GASTOS_GESTION', 'UK_GGE_GASTOS_GESTION', 'GPV_ID, BORRADO'),
    T_COL('CREATE_CONSTRAINT', 'GIC_GASTOS_INFO_CONTABILIDAD', 'UK_GIC_GASTOS_INFO_CONTABILIDAD', 'GPV_ID, BORRADO'),
    T_COL('CREATE_CONSTRAINT', 'GLD_GASTOS_LINEA_DETALLE', 'UK_GLD_GASTOS_LINEA_DETALLE', 'GPV_ID, DD_STG_ID, BORRADO'),
    T_COL('CREATE_INDEX', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GASTOS_DETALLE_ECONOMICO', 'GPV_ID, BORRADO'),
    T_COL('CREATE_INDEX', 'GGE_GASTOS_GESTION', 'UK_GGE_GASTOS_GESTION', 'GPV_ID, BORRADO'),
    T_COL('CREATE_INDEX', 'GIC_GASTOS_INFO_CONTABILIDAD', 'UK_GIC_GASTOS_INFO_CONTABILIDAD', 'GPV_ID, BORRADO'),
    T_COL('CREATE_INDEX', 'GLD_GASTOS_LINEA_DETALLE', 'UK_GLD_GASTOS_LINEA_DETALLE', 'GPV_ID, DD_STG_ID, BORRADO')
  );  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'CREATE_INDEX' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
                V_SQL := 'SELECT COUNT(*) FROM ALL_INDEXES WHERE INDEX_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo índice '||V_TMP_COL(3)||'');		 
                    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TMP_COL(3)||' ON '||V_ESQUEMA|| '.'||V_TMP_COL(2)||'('||V_TMP_COL(4)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;           
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');
            END IF; 
        END IF;   

        IF 'DROP_INDEX' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN
                V_SQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando índice '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'DROP INDEX  '||V_TMP_COL(3)||'';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El índice '||V_TMP_COL(3)||' ya está borrado.');
                END IF; 
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');
            END IF;            
        END IF;

        IF 'CREATE_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo FK '||V_TMP_COL(3)||'');
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' UNIQUE ('||V_TMP_COL(4)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');
            END IF;   
        END IF;   

        IF 'DROP_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
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
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya está borrada.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... No existe.');
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
