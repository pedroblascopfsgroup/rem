--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170615
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2264
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado lógico por cartera
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

create or replace PROCEDURE BORRADO_LOGICO_CARTERA ( cartera REM01.DD_CRA_CARTERA.DD_CRA_DESCRIPCION%TYPE ) AUTHID CURRENT_USER IS

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
  CARTERA_COD REM01.DD_CRA_CARTERA.DD_CRA_CODIGO%TYPE;
  CARTERA_DESC REM01.DD_CRA_CARTERA.DD_CRA_DESCRIPCION%TYPE;

BEGIN
    
    V_MSQL := 'SELECT DD_CRA_CODIGO, UPPER(DD_CRA_DESCRIPCION) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE UPPER(DD_CRA_DESCRIPCION) = UPPER('''||cartera||''')';
    EXECUTE IMMEDIATE V_MSQL INTO CARTERA_COD, CARTERA_DESC;
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de borrado lógico de cartera '||CARTERA_DESC);
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
        USING '||V_ESQUEMA||'.DD_CRA_CARTERA T2
        ON (T1.DD_CRA_ID = T2.DD_CRA_ID AND T2.DD_CRA_CODIGO = '''||CARTERA_COD||''')
        WHEN MATCHED THEN UPDATE SET
            T1.USUARIOBORRAR = ''BORRADO_LOGICO_CARTERA_'||CARTERA_DESC||'''
            , T1.FECHABORRAR = SYSTIMESTAMP, T1.BORRADO = 1
        WHERE T1.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han desactivado '||SQL%ROWCOUNT||' filas en '||V_ESQUEMA||'.ACT_ACTIVO');
    
    V_STMT_VAL := 'WITH DEPENDENCIAS AS (
            SELECT T1.OWNER ESQUEMA, T1.TABLE_NAME TABLE_NAME, T1.CONSTRAINT_NAME, T3.COLUMN_NAME COLUMN_NAME, T3.POSITION POSITION_KEY
                , T2.OWNER ESQUEMA_REF, T2.TABLE_NAME TABLE_REFERENCED, T2.CONSTRAINT_NAME CONSTRAINT_REFERENCED, T4.COLUMN_NAME COLUMN_REFERENCED, T4.POSITION POSITION_KEY_REFERENCED
            FROM ALL_CONSTRAINTS T1
            JOIN ALL_CONSTRAINTS T2 ON T2.CONSTRAINT_NAME = T1.R_CONSTRAINT_NAME
                AND T2.CONSTRAINT_TYPE IN (''P'', ''U'') 
                AND T2.TABLE_NAME IN (''ACT_ACTIVO'',''ACT_TBJ_TRABAJO'',''ACT_AGR_AGRUPACION'',''ACT_TRA_TRAMITE'')
            JOIN ALL_CONS_COLUMNS T3 ON T1.CONSTRAINT_NAME = T3.CONSTRAINT_NAME
            JOIN ALL_CONS_COLUMNS T4 ON T2.CONSTRAINT_NAME = T4.CONSTRAINT_NAME
            JOIN ALL_TAB_COLUMNS T5 ON T5.TABLE_NAME = T1.TABLE_NAME AND T5.COLUMN_NAME = ''BORRADO''
            WHERE T1.CONSTRAINT_TYPE = ''R'' AND T1.STATUS = ''ENABLED'')
        SELECT D.ESQUEMA||''.''||D.TABLE_NAME TABLA, ''T1.''||LISTAGG(D.COLUMN_NAME, ''|T1.'') WITHIN GROUP (ORDER BY D.POSITION_KEY) CLAVE_TABLA
            , D.ESQUEMA_REF||''.''||D.TABLE_REFERENCED TABLA_REF, ''T2.''||LISTAGG(D.COLUMN_REFERENCED, ''|T2.'') WITHIN GROUP (ORDER BY D.POSITION_KEY_REFERENCED) CLAVE_REF
        FROM DEPENDENCIAS D
        GROUP BY D.ESQUEMA, D.TABLE_NAME, D.CONSTRAINT_NAME, D.ESQUEMA_REF, D.TABLE_REFERENCED, D.CONSTRAINT_REFERENCED
        ORDER BY DECODE(D.TABLE_REFERENCED,''ACT_ACTIVO'',0,''ACT_AGR_AGRUPACION'',1,''ACT_TBJ_TRABAJO'',2,''ACT_TRA_TRAMITE'',3)';

    OPEN V_VAL_CURSOR FOR V_STMT_VAL;
        LOOP
        FETCH V_VAL_CURSOR INTO TABLA, CLAVE_TABLA, TABLA_REF, CLAVE_REF;
        EXIT WHEN V_VAL_CURSOR%NOTFOUND;

        BEGIN

            V_MSQL := 'MERGE INTO '||TABLA||' T1
                USING (SELECT '||CLAVE_REF||' CLAVE_REF
                    FROM '||TABLA_REF||' T2
                    WHERE T2.BORRADO = 1 AND T2.USUARIOBORRAR = ''BORRADO_LOGICO_CARTERA_'||CARTERA_DESC||''') T2
                ON ('||CLAVE_TABLA||' = T2.CLAVE_REF)
                WHEN MATCHED THEN UPDATE SET
                    T1.USUARIOBORRAR = ''BORRADO_LOGICO_CARTERA_'||CARTERA_DESC||'''
                    , T1.FECHABORRAR = SYSTIMESTAMP, T1.BORRADO = 1
                WHERE T1.BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('      [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han desactivado '||SQL%ROWCOUNT||' filas en '||TABLA||'');

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('      [ERROR] No se encuentra la clave para '||TABLA||': '||CLAVE_TABLA||'.');
        END;
        END LOOP;

    CLOSE V_VAL_CURSOR;
    
    TABLA := 'REM01.TAR_TAREAS_NOTIFICACIONES';
    CLAVE_TABLA := 'T1.TAR_ID';
    TABLA_REF := 'REM01.TAC_TAREAS_ACTIVOS';
    CLAVE_REF := 'T2.TAR_ID';
    V_MSQL := 'MERGE INTO '||TABLA||' T1
        USING (SELECT '||CLAVE_REF||' CLAVE_REF
            FROM '||TABLA_REF||' T2
            WHERE T2.BORRADO = 1 AND T2.USUARIOBORRAR = ''BORRADO_LOGICO_CARTERA_'||CARTERA_DESC||''') T2
        ON ('||CLAVE_TABLA||' = T2.CLAVE_REF)
        WHEN MATCHED THEN UPDATE SET
            T1.USUARIOBORRAR = ''BORRADO_LOGICO_CARTERA_'||CARTERA_DESC||'''
            , T1.FECHABORRAR = SYSTIMESTAMP, T1.BORRADO = 1
        WHERE T1.BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('      [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han desactivado '||SQL%ROWCOUNT||' filas en '||TABLA||'');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Borrado lógico de la cartera: '||CARTERA_DESC);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] No se ha proporcionado una cartera válida: '||cartera);
  	WHEN OTHERS THEN
    	DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    	DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
    	DBMS_OUTPUT.PUT_LINE(SQLERRM);
    	DBMS_OUTPUT.PUT_LINE(TABLA);
    	ROLLBACK;
    	RAISE;
END;
/
EXIT