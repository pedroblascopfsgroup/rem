--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20201110
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
    T_COL('BORRADO_GGE', 'GGE_GASTOS_GESTION'),
    T_COL('BORRADO_GIC', 'GIC_GASTOS_INFO_CONTABILIDAD'),
    T_COL('DROP_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GASTOS_DETALLE_ECONOMICO'),
    T_COL('CREATE_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GASTOS_DETALLE_ECONOMICO','GPV_ID, FECHABORRAR, BORRADO', 'T1.GPV_ID = T2.GPV_ID AND T1.FECHABORRAR = T2.FECHABORRAR AND T1.BORRADO = T2.BORRADO'),
    T_COL('DROP_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'CK_GDE_GASTOS_DETALLE_ECONOMICO'),
    T_COL('ADD_CHECK_CONSTRAINT', 'GDE_GASTOS_DETALLE_ECONOMICO', 'CK_GDE_GASTOS_DETALLE_ECONOMICO','(BORRADO = 0 AND FECHABORRAR IS NULL) OR BORRADO = 1'),
    T_COL('DROP_CONSTRAINT', 'GGE_GASTOS_GESTION', 'UK_GGE_GASTOS_GESTION'),
    T_COL('CREATE_CONSTRAINT', 'GGE_GASTOS_GESTION', 'UK_GGE_GASTOS_GESTION','GPV_ID, FECHABORRAR, BORRADO', 'T1.GPV_ID = T2.GPV_ID AND T1.FECHABORRAR = T2.FECHABORRAR AND T1.BORRADO = T2.BORRADO'),
    T_COL('DROP_CONSTRAINT', 'GGE_GASTOS_GESTION', 'CK_GGE_GASTOS_GESTION'),
    T_COL('ADD_CHECK_CONSTRAINT', 'GGE_GASTOS_GESTION', 'CK_GGE_GASTOS_GESTION','(BORRADO = 0 AND FECHABORRAR IS NULL) OR BORRADO = 1'),
    T_COL('DROP_CONSTRAINT', 'GIC_GASTOS_INFO_CONTABILIDAD', 'UK_GIC_GASTOS_INFO_CONTABILIDAD'),
    T_COL('CREATE_CONSTRAINT', 'GIC_GASTOS_INFO_CONTABILIDAD', 'UK_GIC_GASTOS_INFO_CONTABILIDAD','GPV_ID, FECHABORRAR, BORRADO', 'T1.GPV_ID = T2.GPV_ID AND T1.FECHABORRAR = T2.FECHABORRAR AND T1.BORRADO = T2.BORRADO'),
    T_COL('DROP_CONSTRAINT', 'GIC_GASTOS_INFO_CONTABILIDAD', 'CK_GIC_GASTOS_INFO_CONTABILIDAD'),
    T_COL('ADD_CHECK_CONSTRAINT', 'GIC_GASTOS_INFO_CONTABILIDAD', 'CK_GIC_GASTOS_INFO_CONTABILIDAD','(BORRADO = 0 AND FECHABORRAR IS NULL) OR BORRADO = 1'),
    T_COL('CREATE_INDEX', 'GDE_GASTOS_DETALLE_ECONOMICO', 'UK_GDE_GASTOS_DETALLE_ECONOMICO', 'GPV_ID, FECHABORRAR, BORRADO'),
    T_COL('CREATE_INDEX', 'GGE_GASTOS_GESTION', 'UK_GGE_GASTOS_GESTION', 'GPV_ID, FECHABORRAR, BORRADO'),
    T_COL('CREATE_INDEX', 'GIC_GASTOS_INFO_CONTABILIDAD', 'UK_GIC_GASTOS_INFO_CONTABILIDAD', 'GPV_ID, FECHABORRAR, BORRADO')
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
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Limpieza previa a creación de UK '||V_TMP_COL(3)||'');
                    EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||' WHERE ('||V_TMP_COL(4)||') IN (SELECT '||V_TMP_COL(4)||' FROM '||V_ESQUEMA||'.'||V_TMP_COL(2)||' GROUP BY '||V_TMP_COL(4)||' HAVING COUNT(1) > 1)';
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo UK '||V_TMP_COL(3)||'');
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

        IF 'ADD_CHECK_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_CHECK_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo CK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' CHECK ('||V_TMP_COL(4)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'... No existe.');
            END IF;    
        END IF;

        IF 'BORRADO_GGE' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [BORRADO_GGE]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION T1
                            USING (
                                WITH DUPLICADOS AS (
                                    SELECT GPV_ID
                                    FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION
                                    WHERE BORRADO = 0
                                    GROUP BY GPV_ID
                                    HAVING COUNT(1) > 1
                                )
                                SELECT GPV.GPV_NUM_GASTO_HAYA, EGA.DD_EGA_DESCRIPCION, GGE.GGE_ID, ROW_NUMBER() OVER(PARTITION BY GPV.GPV_ID ORDER BY GGE.FECHACREAR) RN
                                FROM '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE
                                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GGE.GPV_ID
                                JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                                JOIN DUPLICADOS DUP ON DUP.GPV_ID = GGE.GPV_ID
                            ) T2
                            ON (T1.GGE_ID = T2.GGE_ID AND T2.RN > 1)
                            WHEN MATCHED THEN UPDATE SET
                                T1.USUARIOBORRAR = ''HREOS-10527''
                                , T1.FECHABORRAR = CURRENT_TIMESTAMP(6)
                                , T1.BORRADO = 1';
                EXECUTE IMMEDIATE V_SQL;        
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'... No existe.');
            END IF;    
        END IF;

        IF 'BORRADO_GIC' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [BORRADO_GIC]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD T1
                    USING (
                        WITH DUPLICADOS AS (
                            SELECT GPV_ID
                            FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD
                            WHERE BORRADO = 0
                            GROUP BY GPV_ID
                            HAVING COUNT(1) > 1
                        )
                        SELECT GPV.GPV_NUM_GASTO_HAYA, EGA.DD_EGA_DESCRIPCION, GIC.GIC_ID, ROW_NUMBER() OVER(PARTITION BY GPV.GPV_ID ORDER BY GIC.FECHACREAR) RN
                        FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
                        JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GIC.GPV_ID
                        JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID
                        JOIN DUPLICADOS DUP ON DUP.GPV_ID = GIC.GPV_ID
                    ) T2
                    ON (T1.GIC_ID = T2.GIC_ID AND T2.RN > 1)
                    WHEN MATCHED THEN UPDATE SET
                        T1.USUARIOBORRAR = ''HREOS-10527''
                        , T1.FECHABORRAR = CURRENT_TIMESTAMP(6)
                        , T1.BORRADO = 1';
                EXECUTE IMMEDIATE V_SQL;        
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
