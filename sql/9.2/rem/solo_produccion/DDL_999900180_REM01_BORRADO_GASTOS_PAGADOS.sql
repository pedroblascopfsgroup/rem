--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171130
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.9
--## INCIDENCIA_LINK=HREOS-????
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado físico de gastos pagados
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

    V_MSQL VARCHAR2(2500 CHAR);
    TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;          
    V_TEMP_TABLAS  T_TABLAS;
    C_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS(
        T_TABLAS('REM01','GPV_GASTOS_PROVEEDOR','BACKUP_GPV_GASTOS_PROVEEDOR'),
        T_TABLAS('REM01','GPV_ACT','BACKUP_GPV_ACT'),
        T_TABLAS('REM01','GPV_TBJ','BACKUP_GPV_TBJ'),
        T_TABLAS('REM01','AVG_AVISOS_GASTOS','BACKUP_AVG_AVISOS_GASTOS'),
        T_TABLAS('REM01','ADG_ADJUNTOS_GASTO','BACKUP_ADG_ADJUNTOS_GASTO'),
        T_TABLAS('REM01','DGG_DOC_GES_GASTOS','BACKUP_DGG_DOC_GES_GASTOS'),
        T_TABLAS('REM01','GGE_GASTOS_GESTION','BACKUP_GGE_GASTOS_GESTION'),
        T_TABLAS('REM01','EPF_ESTADOS_PROV_FOND','BACKUP_EPF_ESTADOS_PROV_FOND'),
        T_TABLAS('REM01','GDE_GASTOS_DETALLE_ECONOMICO','BACKUP_GDE_GASTOS_DETALLE_ECO'),
        T_TABLAS('REM01','GIC_GASTOS_INFO_CONTABILIDAD','BACKUP_GIC_GASTOS_INFO_CONTAB'));           
    V_ESQUEMA VARCHAR2(30 CHAR) := 'REM01';
    V_EXISTS NUMBER(24);
    COUNTER NUMBER(24) := 0;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrado de gastos pagados anteriores a 2016.');
    --SE CREAN TABLAS BACKUP
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**CREAMOS TABLAS BACKUP**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        V_TEMP_TABLAS := C_TABLA(I);
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEMP_TABLAS(2);
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
        IF V_EXISTS > 0 THEN
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEMP_TABLAS(3)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
            IF V_EXISTS = 1 THEN
                V_MSQL := 'DROP TABLE '||V_TEMP_TABLAS(3)||' PURGE';
                EXECUTE IMMEDIATE V_MSQL;
            END IF;
            V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEMP_TABLAS(3)||' AS SELECT * FROM '||V_ESQUEMA||'.'||V_TEMP_TABLAS(2);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Tabla backup '||V_TEMP_TABLAS(3)||' creada.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Tabla origen, '||V_TEMP_TABLAS(2)||', vacía. No se borrará tabla backup, '||V_TEMP_TABLAS(3)||', en caso de existir.');
        END IF;
    END LOOP;
    
    --DESACTIVAMOS CLAVES
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        BEGIN
            V_TEMP_TABLAS := C_TABLA(I);  
            FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
            LOOP
                BEGIN
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Restricción clave ajena '||J.CONSTRAINT_NAME||' desactivada.');
                END;    
            END LOOP;    
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        BEGIN
            V_TEMP_TABLAS := C_TABLA(I); 
            FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
            LOOP
                BEGIN
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';
                    DBMS_OUTPUT.PUT_LINE('[INFO] Restricción clave primaria '||J.CONSTRAINT_NAME||' desactivada.');
                END;    
            END LOOP;    
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
    END LOOP;
    
    --TRUNCAMOS TABLAS DE ORIGEN
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**TRUNCAMOS TABLAS ORIGEN**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        V_TEMP_TABLAS := C_TABLA(I);
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEMP_TABLAS(2)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
        IF V_EXISTS = 1 THEN
            V_MSQL := 'TRUNCATE TABLE '||V_TEMP_TABLAS(2);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Tabla origen '||V_TEMP_TABLAS(2)||' truncada.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Tabla origen '||V_TEMP_TABLAS(2)||' no existe.');
        END IF;
    END LOOP;
    
    --INSERTAMOS EN GPV TODOS LOS GASTOS EXCEPTO LO PAGADOS ANTERIORES A 2016
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**RECARGAMOS TABLAS ORIGEN**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        V_TEMP_TABLAS := C_TABLA(I);
        COUNTER := 0;
        IF V_TEMP_TABLAS(2) = 'GPV_GASTOS_PROVEEDOR' THEN 
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
                SELECT GPV.*
                FROM '||V_ESQUEMA||'.BACKUP_GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO = ''05''
                JOIN '||V_ESQUEMA||'.BACKUP_GDE_GASTOS_DETALLE_ECO GDE ON GDE.GPV_ID = GPV.GPV_ID
                WHERE GDE.GDE_FECHA_PAGO > TO_DATE(''31/12/2015'',''DD/MM/YYYY'')';
            EXECUTE IMMEDIATE V_MSQL;
            COUNTER := SQL%ROWCOUNT;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
                SELECT GPV.*
                FROM '||V_ESQUEMA||'.BACKUP_GPV_GASTOS_PROVEEDOR GPV
                JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO <> ''05''
                WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR AUX WHERE AUX.GPV_ID = GPV.GPV_ID)';
            EXECUTE IMMEDIATE V_MSQL;
            COUNTER := COUNTER + SQL%ROWCOUNT;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||COUNTER||' gastos cargados en tabla GPV_GASTOS_PROVEEDOR');
        ELSE
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEMP_TABLAS(3)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
            IF V_EXISTS = 1 THEN
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEMP_TABLAS(2)||'
                    SELECT T1.*
                    FROM '||V_ESQUEMA||'.'||V_TEMP_TABLAS(3)||' T1
                    JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T2 ON T1.GPV_ID = T2.GPV_ID';
                EXECUTE IMMEDIATE V_MSQL;
                COUNTER := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE('[INFO] '||COUNTER||' registros cargados en tabla '||V_TEMP_TABLAS(2));
            END IF;
        END IF;
    END LOOP;
    
    --ACTIVAMOS CLAVES
    DBMS_OUTPUT.PUT_LINE('********************' );
    DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
    DBMS_OUTPUT.PUT_LINE('********************' );
    
    FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
    LOOP
        V_TEMP_TABLAS := C_TABLA(I);
        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
            AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
        LOOP
            BEGIN                
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                DBMS_OUTPUT.PUT_LINE('[INFO] Se activó la restricción '||J.CONSTRAINT_NAME);
            EXCEPTION WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] No se pudo activar la restricción '||J.CONSTRAINT_NAME);
            END;
        END LOOP;            
    END LOOP; 
    
    DBMS_OUTPUT.PUT_LINE('*******************************' );
    DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
    DBMS_OUTPUT.PUT_LINE('*******************************' );
    
    FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
        FROM SYS.USER_CONSTRAINTS
        WHERE STATUS='DISABLED')
    LOOP
        BEGIN                
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se activó la restricción '||J.CONSTRAINT_NAME);
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] No se pudo activar la restricción '||J.CONSTRAINT_NAME);
        END;
    END LOOP;  
    
    FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
        FROM SYS.USER_CONSTRAINTS
        WHERE STATUS='DISABLED')
    LOOP
        BEGIN                
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
            DBMS_OUTPUT.PUT_LINE('[INFO] Se activó la restricción '||J.CONSTRAINT_NAME);
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] No se pudo activar la restricción '||J.CONSTRAINT_NAME);
        END;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] Proceso borrado de gastos.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        ROLLBACK;
        RAISE;
END;
/
EXIT