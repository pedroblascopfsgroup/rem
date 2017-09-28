--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2878
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado físico de ciertas tablas
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

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  TYPE VALCURTYP IS REF CURSOR;
  V_VAL_CURSOR VALCURTYP;
  V_STMT_VAL VARCHAR2(4000 CHAR);
  TABLA VARCHAR2(63 CHAR);
  CLAVE_TABLA VARCHAR(140 CHAR);
  TABLA_REF VARCHAR2(63 CHAR);
  CLAVE_REF VARCHAR(140 CHAR);
  CANTIDAD_INSERCIONES NUMBER (16);
  SIN_AUDITORIA EXCEPTION;
  PRAGMA EXCEPTION_INIT(SIN_AUDITORIA, -904);
  BORRADO_FK EXCEPTION;
  PRAGMA EXCEPTION_INIT(BORRADO_FK, -1407);
  ACTIVOS NUMBER(6);
  NUMERO_BORRAR NUMBER(6) := 1000;--Numero de activos a borrar en una pasada
  ORDEN NUMBER(2) := 2;
  V_TABLA VARCHAR2(30 CHAR) := 'ACT_TBJ_TRABAJO'; -- Variable para tabla de salida para el borrado

  PROCEDURE BORRADO (ORDEN IN NUMBER, NUMERO_INSERTADO OUT NUMBER) IS
  BEGIN
    V_STMT_VAL := '
        INSERT INTO REM01.ACTIVOS_A_BORRAR
        SELECT REM01.S_ACTIVOS_A_BORRAR.NEXTVAL, TABLA, CLAVE_TABLA, ORDEN, TABLA_REF, CLAVE_REF, ORDEN_REF 
        FROM (
            WITH DEPENDENCIAS AS (
            SELECT T1.OWNER ESQUEMA, T1.TABLE_NAME TABLE_NAME, T1.CONSTRAINT_NAME, T3.COLUMN_NAME COLUMN_NAME, T3.POSITION POSITION_KEY
             , T2.OWNER ESQUEMA_REF, T2.TABLE_NAME TABLE_REFERENCED, T2.CONSTRAINT_NAME CONSTRAINT_REFERENCED, T4.COLUMN_NAME COLUMN_REFERENCED, T4.POSITION POSITION_KEY_REFERENCED
            FROM ALL_CONSTRAINTS T1
            JOIN ALL_CONSTRAINTS T2 ON T2.CONSTRAINT_NAME = T1.R_CONSTRAINT_NAME
             AND T2.CONSTRAINT_TYPE IN (''P'', ''U'')
            JOIN ACTIVOS_A_BORRAR T5 ON T5.TABLA = T2.OWNER||''.''||T2.TABLE_NAME
            JOIN ALL_CONS_COLUMNS T3 ON T1.CONSTRAINT_NAME = T3.CONSTRAINT_NAME
            JOIN ALL_CONS_COLUMNS T4 ON T2.CONSTRAINT_NAME = T4.CONSTRAINT_NAME
            WHERE T1.CONSTRAINT_TYPE = ''R'' AND T1.STATUS = ''ENABLED''
                AND NOT EXISTS (SELECT 1 FROM ACTIVOS_A_BORRAR AUX WHERE AUX.TABLA_REF = T2.OWNER||''.''||T2.TABLE_NAME))        
            SELECT D.ESQUEMA||''.''||D.TABLE_NAME TABLA, ''T1.''||LISTAGG(D.COLUMN_NAME, ''||T1.'') WITHIN GROUP (ORDER BY D.POSITION_KEY) CLAVE_TABLA
            , '||ORDEN||' + 1 ORDEN
            , D.ESQUEMA_REF||''.''||D.TABLE_REFERENCED TABLA_REF, ''T2.''||LISTAGG(D.COLUMN_REFERENCED, ''||T2.'') WITHIN GROUP (ORDER BY D.POSITION_KEY_REFERENCED) CLAVE_REF
            , '||ORDEN||' ORDEN_REF
            FROM DEPENDENCIAS D
            GROUP BY D.ESQUEMA, D.TABLE_NAME, D.CONSTRAINT_NAME, D.ESQUEMA_REF, D.TABLE_REFERENCED, D.CONSTRAINT_REFERENCED)';
    EXECUTE IMMEDIATE V_STMT_VAL;
    NUMERO_INSERTADO := SQL%ROWCOUNT;
  END;

BEGIN
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACTIVOS_A_BORRAR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.ACTIVOS_A_BORRAR_2';
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de borrado lógico de trabajos duplicados.');
    DBMS_OUTPUT.PUT_LINE('');

    V_STMT_VAL := '
        INSERT INTO REM01.ACTIVOS_A_BORRAR
        SELECT REM01.S_ACTIVOS_A_BORRAR.NEXTVAL, TABLA, CLAVE_TABLA, ORDEN, TABLA_REF, CLAVE_REF, ORDEN_REF 
        FROM (
            WITH DEPENDENCIAS AS (
             SELECT T1.OWNER ESQUEMA, T1.TABLE_NAME TABLE_NAME, T1.CONSTRAINT_NAME, T3.COLUMN_NAME COLUMN_NAME, T3.POSITION POSITION_KEY
                 , T2.OWNER ESQUEMA_REF, T2.TABLE_NAME TABLE_REFERENCED, T2.CONSTRAINT_NAME CONSTRAINT_REFERENCED, T4.COLUMN_NAME COLUMN_REFERENCED, T4.POSITION POSITION_KEY_REFERENCED
             FROM ALL_CONSTRAINTS T1
             JOIN ALL_CONSTRAINTS T2 ON T2.CONSTRAINT_NAME = T1.R_CONSTRAINT_NAME
                 AND T2.CONSTRAINT_TYPE IN (''P'', ''U'')
                 AND T2.TABLE_NAME IN ('''||V_TABLA||''')
                 AND T2.OWNER = '''||V_ESQUEMA||'''
             JOIN ALL_CONS_COLUMNS T3 ON T1.CONSTRAINT_NAME = T3.CONSTRAINT_NAME
             JOIN ALL_CONS_COLUMNS T4 ON T2.CONSTRAINT_NAME = T4.CONSTRAINT_NAME
             WHERE T1.CONSTRAINT_TYPE = ''R'' AND T1.STATUS = ''ENABLED'')        
            SELECT D.ESQUEMA||''.''||D.TABLE_NAME TABLA, ''T1.''||LISTAGG(D.COLUMN_NAME, ''||T1.'') WITHIN GROUP (ORDER BY D.POSITION_KEY) CLAVE_TABLA
               , 1 ORDEN
               , D.ESQUEMA_REF||''.''||D.TABLE_REFERENCED TABLA_REF, ''T2.''||LISTAGG(D.COLUMN_REFERENCED, ''||T2.'') WITHIN GROUP (ORDER BY D.POSITION_KEY_REFERENCED) CLAVE_REF
               , 0 ORDEN_REF
            FROM DEPENDENCIAS D
            GROUP BY D.ESQUEMA, D.TABLE_NAME, D.CONSTRAINT_NAME, D.ESQUEMA_REF, D.TABLE_REFERENCED, D.CONSTRAINT_REFERENCED)';
    EXECUTE IMMEDIATE V_STMT_VAL;

    BORRADO(ORDEN, CANTIDAD_INSERCIONES);
    WHILE CANTIDAD_INSERCIONES > 0
    LOOP
       ORDEN := ORDEN + 2;
       BORRADO(ORDEN, CANTIDAD_INSERCIONES);
    END LOOP;

    V_MSQL := 'INSERT INTO REM01.ACTIVOS_A_BORRAR
      SELECT S_ACTIVOS_A_BORRAR.NEXTVAL, ''REM01.TAC_TAREAS_ACTIVOS'', ''T1.TRA_ID'', T1.ORDEN_TABLA, T1.TABLA_REF, T1.CLAVE_REF, T1.ORDEN_TABLA_REF
      FROM REM01.ACTIVOS_A_BORRAR T1
      WHERE T1.TABLA_REF = ''REM01.ACT_TRA_TRAMITE'' AND T1.CLAVE_REF = ''T2.TRA_ID'' ';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'INSERT INTO REM01.ACTIVOS_A_BORRAR
      SELECT S_ACTIVOS_A_BORRAR.NEXTVAL, ''REM01.TAR_TAREAS_NOTIFICACIONES'', ''T1.TAR_ID'', T1.ORDEN_TABLA + 2, T1.TABLA, ''T2.TAR_ID'', T1.ORDEN_TABLA_REF + 2
      FROM REM01.ACTIVOS_A_BORRAR T1
      WHERE T1.TABLA = ''REM01.TAC_TAREAS_ACTIVOS'' AND T1.CLAVE_TABLA = ''T1.TRA_ID'' ';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'INSERT INTO REM01.ACTIVOS_A_BORRAR_2
      SELECT DISTINCT TABLA, ORDEN_TABLA FROM ACTIVOS_A_BORRAR
      UNION SELECT DISTINCT TABLA_REF, ORDEN_TABLA_REF FROM ACTIVOS_A_BORRAR';
    EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;
    
    LOOP
        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
            USING (SELECT T3.TBJ_ID, ROW_NUMBER() OVER(PARTITION BY T1.ACT_ID ORDER BY T3.FECHACREAR ASC) RN
              FROM REM01.ACT_AGA_AGRUPACION_ACTIVO T1
              JOIN REM01.ACT_TBJ T2 ON T1.ACT_ID = T2.ACT_ID
              JOIN '||V_ESQUEMA||'.'||V_TABLA||' T3 ON T3.TBJ_ID = T2.TBJ_ID
              WHERE T1.AGR_ID = 2861 AND T3.USUARIOCREAR <> ''MIG_SAREB'' AND ROWNUM <= '||NUMERO_BORRAR||'
                AND T3.BORRADO = 0) T2
            ON (T1.TBJ_ID = T2.TBJ_ID AND T2.RN > 1)
            WHEN MATCHED THEN UPDATE SET
                T1.USUARIOBORRAR = ''HREOS-2878'', T1.BORRADO = 1, T1.FECHABORRAR = SYSDATE';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        EXIT WHEN SQL%ROWCOUNT = 0;

        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOBORRAR = ''HREOS-2878'' AND BORRADO = 1';
        EXECUTE IMMEDIATE V_MSQL INTO ACTIVOS;
        DBMS_OUTPUT.PUT_LINE('[CON_AUDITORIA {A   BORRAR}]: TABLA '||V_ESQUEMA||'.'||V_TABLA||' - '||ACTIVOS||' registros marcados para posterior borrado.');
    
        OPEN V_VAL_CURSOR FOR SELECT TABLA, CLAVE_TABLA, TABLA_REF, CLAVE_REF FROM REM01.ACTIVOS_A_BORRAR ORDER BY ID ASC;
            LOOP
            FETCH V_VAL_CURSOR INTO TABLA, CLAVE_TABLA, TABLA_REF, CLAVE_REF;
            EXIT WHEN V_VAL_CURSOR%NOTFOUND;
            
            DECLARE
                SIN_AUDITORIA EXCEPTION;
                PRAGMA EXCEPTION_INIT(SIN_AUDITORIA, -904);
            BEGIN
                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||TABLA||' T1 
                    USING (SELECT '||CLAVE_REF||' 
                        FROM '||TABLA_REF||' T2 
                        WHERE T2.USUARIOBORRAR = ''HREOS-2878'' AND T2.BORRADO = 1) T2 
                    ON ('||CLAVE_TABLA||' = '||CLAVE_REF||')
                    WHEN MATCHED THEN UPDATE SET
                        T1.USUARIOBORRAR = ''HREOS-2878'', T1.BORRADO = 1, t1.FECHABORRAR = SYSDATE';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[CON_AUDITORIA {A   BORRAR}]: TABLA '||TABLA||' - '||SQL%ROWCOUNT||' registros marcados para posterior borrado.');
            EXCEPTION
                WHEN SIN_AUDITORIA THEN
                DECLARE
                    SIN_AUDITORIA EXCEPTION;
                    PRAGMA EXCEPTION_INIT(SIN_AUDITORIA, -904);
                BEGIN
                    V_MSQL := 'DELETE FROM '||TABLA||' T1 WHERE EXISTS (SELECT 1 FROM '||TABLA_REF||' T2 WHERE '||CLAVE_REF||' = '||CLAVE_TABLA||' AND T2.USUARIOBORRAR = ''HREOS-2878'' AND T2.BORRADO = 1)';
                    --EXECUTE IMMEDIATE V_MSQL;
                    --DBMS_OUTPUT.PUT_LINE('[SIN_AUDITORIA {A   BORRAR}]: TABLA '||TABLA||' - '||SQL%ROWCOUNT||' registros borrados directamente');
                EXCEPTION
                    WHEN SIN_AUDITORIA THEN
                    V_MSQL := 'MERGE INTO '||TABLA||' T1
                        USING (SELECT '||CLAVE_TABLA||'
                            FROM '||TABLA||' T1
                            LEFT JOIN '||TABLA_REF||' T2 ON '||CLAVE_REF||' = '||CLAVE_TABLA||'
                            WHERE '||CLAVE_REF||' IS NULL) T2
                        ON ('||CLAVE_TABLA||' = ''T2.''||SUBSTR('||CLAVE_TABLA||',4) )
                        WHEN MATCHED THEN UPDATE SET
                            T1.USUARIOBORRAR = ''HREOS-2878'', T1.BORRADO = 1, T1.FECHABORRAR = SYSDATE';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[SIN_AUDITORIA {REFERENCIA}]: TABLA '||TABLA_REF||' - '||SQL%ROWCOUNT||' registros huérfanos borrados directamente.');
                END;
            END;
    
            END LOOP;
        CLOSE V_VAL_CURSOR;

        COMMIT;
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN] Borrado lógico de trabajos');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(TABLA);
      ROLLBACK;
      RAISE;
END;
/
EXIT;