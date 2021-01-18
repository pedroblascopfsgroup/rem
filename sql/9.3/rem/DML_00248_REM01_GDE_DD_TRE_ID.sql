--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20201109
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12016
--## PRODUCTO=NO
--## 
--## Finalidad: Rellenar y activar CK
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
    T_COL('FILL_COLUMN', 'GDE_GASTOS_DETALLE_ECONOMICO', 'DD_TRE_ID', 'DESP'),
    T_COL('ADD_CK','GDE_GASTOS_DETALLE_ECONOMICO','CK_GDE_DD_TRE_ID', '(DD_TRE_ID IS NOT NULL AND GDE_RET_GAR_APLICA = 1) OR (DD_TRE_ID IS NULL AND NVL(GDE_RET_GAR_APLICA, 0) = 0)')
  );  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'FILL_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
            	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TMP_COL(2)||' T1
                    USING (
                        SELECT GDE.GDE_ID
                            , CASE
                                WHEN GDE.'||V_TMP_COL(3)||' IS NULL AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1 THEN DES.'||V_TMP_COL(3)||'
                                WHEN GDE.'||V_TMP_COL(3)||' IS NOT NULL AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 0 THEN NULL
                                END '||V_TMP_COL(3)||'
                        FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||' GDE
                        JOIN '||V_ESQUEMA||'.DD_TRE_TIPO_RETENCION DES ON DES.DD_TRE_CODIGO = '''||V_TMP_COL(4)||'''
                            AND DES.BORRADO = 0
                        WHERE (GDE.'||V_TMP_COL(3)||' IS NULL AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1) 
                            OR (GDE.'||V_TMP_COL(3)||' IS NOT NULL AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 0)
                    ) T2
                    ON (T1.GDE_ID = T2.GDE_ID)
                    WHEN MATCHED THEN 
                        UPDATE SET T1.'||V_TMP_COL(3)||' = T2.'||V_TMP_COL(3)||'';
                EXECUTE IMMEDIATE V_MSQL;
            	DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha rellenado el campo '||V_TMP_COL(3)||'.');         
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] No existe el campo '||V_TMP_COL(3)||'.');
            END IF; 
        END IF;  
    
        IF 'ADD_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
 			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 0 THEN
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4);
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha creado el campo '||V_TMP_COL(3)||'.');		         
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(3)||' ya existe.');
            END IF; 
        END IF;

        IF 'ADD_CK' = ''||V_TMP_COL(1)||'' THEN
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
                V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo check constraint '||V_TMP_COL(3)||'');		 
                    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' CHECK ('||V_TMP_COL(4)||')';
                    EXECUTE IMMEDIATE V_MSQL;
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;           
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TMP_COL(2)||' no existe.');
            END IF; 
        END IF;

        IF 'ADD_FK' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] Se intentará añadir la restricción '||V_TMP_COL(3)||'.');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS = 1 THEN
                V_SQL := 'SELECT COUNT(1) 
                    FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''
                    AND CONSTRAINT_TYPE = ''R''';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo clave foránea '||V_TMP_COL(3)||'');		 
                    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' FOREIGN KEY ('||V_TMP_COL(5)||') REFERENCES '||V_ESQUEMA||'.'||V_TMP_COL(4)||' ('||V_TMP_COL(5)||')';
                    EXECUTE IMMEDIATE V_MSQL;
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
    DBMS_OUTPUT.put_line(V_MSQL);
    DBMS_OUTPUT.put_line(V_SQL);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
