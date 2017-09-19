--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170623
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2264
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de borrado parcial por cartera
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
    -------------   TABLA  ---------------------CLAVE_TABLA-------------TABLA_REF------------CLAVE_REF
    T_VAR('REM01.ACT_ICO_INFO_COMERCIAL',       'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.ACT_ADM_INF_ADMINISTRATIVA',   'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.ACT_SPS_SIT_POSESORIA',        'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.ACT_REG_INFO_REGISTRAL',       'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.BIE_DATOS_REGISTRALES',        'T1.BIE_ID',        'REM01.BIE_BIEN'  ,      'T2.BIE_ID'),
    T_VAR('REM01.ACT_LOC_LOCALIZACION',         'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.BIE_LOCALIZACION',             'T1.BIE_ID',        'REM01.BIE_BIEN'  ,      'T2.BIE_ID'),
    T_VAR('REM01.ACT_ABA_ACTIVO_BANCARIO',      'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    T_VAR('REM01.ACT_AOB_ACTIVO_OBS',           'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID')
    --T_VAR('REM01.ACT_AJD_ADJJUDICIAL',          'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T2.ACT_ID'),
    --T_VAR('REM01.BIE_ADJ_ADJUDICACION',         'T1.BIE_ID',        'REM01.BIE_BIEN',        'T2.BIE_ID'),
    --T_VAR('REM01.ACT_ADN_ADJNOJUDICIAL',        'T1.ACT_ID',        'REM01.ACT_ACTIVO',      'T1.ACT_ID')
  );
  V_TMP_VAR T_VAR;

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de borrado ');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
        USING (SELECT T2.ACT_ID 
          FROM REM01.MIG_ACA_CABECERA T1
          JOIN REM01.ACT_ACTIVO T2 ON T1.ACT_NUMERO_ACTIVO = T2.ACT_NUM_ACTIVO
          WHERE T1.VALIDACION IN (0,1)) T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.USUARIOBORRAR = SUBSTR(''#ETIQUETA#''||T1.USUARIOBORRAR,0,50)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han marcado '||SQL%ROWCOUNT||' filas en '||V_ESQUEMA||'.ACT_ACTIVO');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_BIEN T1
        USING '||V_ESQUEMA||'.ACT_ACTIVO T2
        ON (T1.BIE_ID = T2.BIE_ID AND T2.USUARIOBORRAR LIKE ''#ETIQUETA#%'')
        WHEN MATCHED THEN UPDATE SET
            T1.USUARIOBORRAR = SUBSTR(''#ETIQUETA#''||T1.USUARIOBORRAR,0,50)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('  [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han marcado '||SQL%ROWCOUNT||' filas en '||V_ESQUEMA||'.BIE_BIEN');

    V_STMT_VAL := 'WITH DEPENDENCIAS AS (
         SELECT T1.OWNER ESQUEMA, T1.TABLE_NAME TABLE_NAME, T1.CONSTRAINT_NAME, T3.COLUMN_NAME COLUMN_NAME, T3.POSITION POSITION_KEY
             , T2.OWNER ESQUEMA_REF, T2.TABLE_NAME TABLE_REFERENCED, T2.CONSTRAINT_NAME CONSTRAINT_REFERENCED, T4.COLUMN_NAME COLUMN_REFERENCED, T4.POSITION POSITION_KEY_REFERENCED
         FROM ALL_CONSTRAINTS T1
         JOIN ALL_CONSTRAINTS T2 ON T2.CONSTRAINT_NAME = T1.R_CONSTRAINT_NAME
             AND T2.CONSTRAINT_TYPE IN (''P'', ''U'')
             AND T2.TABLE_NAME IN (''ACT_ICO_INFO_COMERCIAL'')
         JOIN ALL_CONS_COLUMNS T3 ON T1.CONSTRAINT_NAME = T3.CONSTRAINT_NAME
         JOIN ALL_CONS_COLUMNS T4 ON T2.CONSTRAINT_NAME = T4.CONSTRAINT_NAME
         WHERE T1.CONSTRAINT_TYPE = ''R'' AND T1.STATUS = ''ENABLED'')        
        SELECT D.ESQUEMA||''.''||D.TABLE_NAME TABLA, ''T1.''||LISTAGG(D.COLUMN_NAME, ''|T1.'') WITHIN GROUP (ORDER BY D.POSITION_KEY) CLAVE_TABLA
           , D.ESQUEMA_REF||''.''||D.TABLE_REFERENCED TABLA_REF, ''T2.''||LISTAGG(D.COLUMN_REFERENCED, ''|T2.'') WITHIN GROUP (ORDER BY D.POSITION_KEY_REFERENCED) CLAVE_REF
        FROM DEPENDENCIAS D
        GROUP BY D.ESQUEMA, D.TABLE_NAME, D.CONSTRAINT_NAME, D.ESQUEMA_REF, D.TABLE_REFERENCED, D.CONSTRAINT_REFERENCED';

    OPEN V_VAL_CURSOR FOR V_STMT_VAL;
        LOOP
        FETCH V_VAL_CURSOR INTO TABLA, CLAVE_TABLA, TABLA_REF, CLAVE_REF;
        EXIT WHEN V_VAL_CURSOR%NOTFOUND;

        BEGIN
            V_MSQL := 'DELETE FROM '||TABLA||' T1 WHERE EXISTS (SELECT 1 FROM '||TABLA_REF||' T2, '||V_ESQUEMA||'.ACT_ACTIVO T3 WHERE T3.ACT_ID = T2.ACT_ID AND T3.USUARIOBORRAR LIKE ''#ETIQUETA#%'' AND '||CLAVE_TABLA||' = '||CLAVE_REF||')';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('      [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han borrado '||SQL%ROWCOUNT||' filas en '||TABLA||'');
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

      V_MSQL := 'DELETE FROM '||V_TMP_VAR(1)||' T1 WHERE EXISTS (SELECT 1 FROM '||V_TMP_VAR(3)||' T2 WHERE '||V_TMP_VAR(2)||' = '||V_TMP_VAR(4)||' AND T2.USUARIOBORRAR LIKE ''#ETIQUETA#%'')';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('      [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' - Se han borrado '||SQL%ROWCOUNT||' filas en '||V_TMP_VAR(1)||'');
    
    END LOOP; 

    UPDATE ACT_ACTIVO SET USUARIOBORRAR = REPLACE(USUARIOBORRAR, '#ETIQUETA#', '') WHERE USUARIOBORRAR LIKE '#ETIQUETA#%';

    UPDATE BIE_BIEN SET USUARIOBORRAR = REPLACE(USUARIOBORRAR, '#ETIQUETA#', '') WHERE USUARIOBORRAR LIKE '#ETIQUETA#%';

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Borrado parcial I');

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
EXIT