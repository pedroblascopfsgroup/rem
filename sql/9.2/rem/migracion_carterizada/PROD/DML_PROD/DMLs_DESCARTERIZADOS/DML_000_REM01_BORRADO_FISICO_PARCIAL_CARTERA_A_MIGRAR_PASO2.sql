--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170727
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2565
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

  --Array que contiene las tablas que se van a borrar
  TYPE T_VAR is table of VARCHAR2(250); 
  TYPE T_ARRAY IS TABLE OF T_VAR;
  V_FUN T_ARRAY := T_ARRAY(
    -------------   TABLA  --------------
    T_VAR('REM01.ACT_VAL_VALORACIONES'),
    T_VAR('REM01.ACT_AGR_AGRUPACION'),
    T_VAR('REM01.ACT_LLV_LLAVE'),
    T_VAR('REM01.ACT_TBJ_TRABAJO'),
    T_VAR('REM01.BIE_CAR_CARGAS')
  );
  V_TMP_VAR T_VAR;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de borrado físico de interfaces a cargar desde cero');
    DBMS_OUTPUT.PUT_LINE('');

    V_STMT_VAL := 'WITH DEPENDENCIAS AS (
         SELECT T1.OWNER ESQUEMA, T1.TABLE_NAME TABLE_NAME, T1.CONSTRAINT_NAME, T3.COLUMN_NAME COLUMN_NAME, T3.POSITION POSITION_KEY
             , T2.OWNER ESQUEMA_REF, T2.TABLE_NAME TABLE_REFERENCED, T2.CONSTRAINT_NAME CONSTRAINT_REFERENCED, T4.COLUMN_NAME COLUMN_REFERENCED, T4.POSITION POSITION_KEY_REFERENCED
         FROM ALL_CONSTRAINTS T1
         JOIN ALL_CONSTRAINTS T2 ON T2.CONSTRAINT_NAME = T1.R_CONSTRAINT_NAME
             AND T2.CONSTRAINT_TYPE IN (''P'', ''U'')
             AND T2.TABLE_NAME IN (''ACT_ONV_OBRA_NUEVA'',''ACT_AGR_AGRUPACION'',''ACT_VAL_VALORACIONES'',''ACT_LLV_LLAVE'',''ACT_TBJ_TRABAJO'',''BIE_CAR_CARGAS'')
         JOIN ALL_CONS_COLUMNS T3 ON T1.CONSTRAINT_NAME = T3.CONSTRAINT_NAME
         JOIN ALL_CONS_COLUMNS T4 ON T2.CONSTRAINT_NAME = T4.CONSTRAINT_NAME
         WHERE T1.CONSTRAINT_TYPE = ''R'' AND T1.STATUS = ''ENABLED'')        
        SELECT D.ESQUEMA||''.''||D.TABLE_NAME TABLA, ''T1.''||LISTAGG(D.COLUMN_NAME, ''|T1.'') WITHIN GROUP (ORDER BY D.POSITION_KEY) CLAVE_TABLA
           , D.ESQUEMA_REF||''.''||D.TABLE_REFERENCED TABLA_REF, ''T2.''||LISTAGG(D.COLUMN_REFERENCED, ''|T2.'') WITHIN GROUP (ORDER BY D.POSITION_KEY_REFERENCED) CLAVE_REF
        FROM DEPENDENCIAS D
        GROUP BY D.ESQUEMA, D.TABLE_NAME, D.CONSTRAINT_NAME, D.ESQUEMA_REF, D.TABLE_REFERENCED, D.CONSTRAINT_REFERENCED
        ORDER BY DECODE(D.TABLE_REFERENCED,''BIE_CAR_CARGAS'',0,''ACT_ONV_OBRA_NUEVA'',0,''ACT_AGR_AGRUPACION'',1,''ACT_VAL_VALORACIONES'',1,''ACT_LLV_LLAVE'',1,''ACT_TBJ_TRABAJO'',2)';

    OPEN V_VAL_CURSOR FOR V_STMT_VAL;
        LOOP
        FETCH V_VAL_CURSOR INTO TABLA, CLAVE_TABLA, TABLA_REF, CLAVE_REF;
        EXIT WHEN V_VAL_CURSOR%NOTFOUND;

        BEGIN
            V_MSQL := 'DELETE FROM '||TABLA||' T1 WHERE EXISTS (SELECT 1 FROM '||TABLA_REF||' T2 WHERE '||CLAVE_TABLA||' = '||CLAVE_REF||')';
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('      [INFO - BORRADO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han borrado '||SQL%ROWCOUNT||' filas en '||TABLA||'');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('      [ERROR] No se encuentra la clave para '||TABLA||': '||CLAVE_TABLA||'.');
        END;
        END LOOP;

    CLOSE V_VAL_CURSOR;
    
    --#########################
    --#######  BORRADO  #######
    --#########################

    FOR I IN V_FUN.FIRST .. V_FUN.LAST 
      LOOP
      V_TMP_VAR := V_FUN(I);  

      V_MSQL := 'DELETE FROM '||V_TMP_VAR(1);
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('      [INFO - BORRADO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han borrado '||SQL%ROWCOUNT||' filas en '||V_TMP_VAR(1));
    
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[FIN] Borrado físico de interfaces a cargar desde cero');

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