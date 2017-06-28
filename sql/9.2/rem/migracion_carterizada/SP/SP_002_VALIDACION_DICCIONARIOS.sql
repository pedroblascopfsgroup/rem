create or replace PROCEDURE SP_002_VALIDACION_DICCIONARIOS IS

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  err_num NUMBER;-- Numero de errores
  err_msg VARCHAR2(2048);-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_SEC VARCHAR2(30 CHAR) := 'S_VALIDACIONES_MIGRACION';
  TYPE valCurTyp IS REF CURSOR;
  v_val_cursor valCurTyp;
  v_stmt_val VARCHAR2(4000 CHAR);
  TABLA_VALIDACION VARCHAR2(30 CHAR) := 'VALIDACIONES_MIGRACION';
  vID REM01.VIC_VAL_INTERFAZ_DD.VALIDACION_ID%TYPE;
  vTABLA REM01.VIC_VAL_INTERFAZ_DD.NOMBRE_INTERFAZ%TYPE;
  vDICCIONARIO REM01.VIC_VAL_INTERFAZ_DD.NOMBRE_DICCIONARIO%TYPE;
  vCAMPO REM01.VIC_VAL_INTERFAZ_DD.NOMBRE_CAMPO%TYPE;
  vCODIGO REM01.VIC_VAL_INTERFAZ_DD.NOMBRE_CODIGO%TYPE;
  vREQUERIDO REM01.VIC_VAL_INTERFAZ_DD.REQUERIDO%TYPE;
  vCLAVE VARCHAR2(240 CHAR);
  vCLAVE2 VARCHAR2(240 CHAR);
  vRECHAZO_DD REM01.DICCIONARIO_RECHAZOS.MOTIVO_RECHAZO%TYPE := '2';
  vRECHAZO_REQ REM01.DICCIONARIO_RECHAZOS.MOTIVO_RECHAZO%TYPE := '3';
  vAUX VARCHAR2(240 CHAR);
  vAUX2 VARCHAR2(240 CHAR);
  V_EXIST_MIG NUMBER(1);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    v_stmt_val := 'SELECT VALIDACION_ID, NOMBRE_INTERFAZ, NOMBRE_CAMPO, NOMBRE_DICCIONARIO, NOMBRE_CODIGO, REQUERIDO
        FROM '||V_ESQUEMA||'.VIC_VAL_INTERFAZ_DD
        WHERE BORRADO = 0';

    OPEN v_val_cursor FOR v_stmt_val;
        LOOP
        FETCH v_val_cursor INTO vID, vTABLA, vCAMPO, vDICCIONARIO, vCODIGO, vREQUERIDO;
        EXIT WHEN v_val_cursor%NOTFOUND;

        BEGIN
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||vTABLA||''' AND COLUMN_NAME = ''VALIDACION'' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXIST_MIG;

            IF V_EXIST_MIG > 0 THEN
                V_MSQL := 'SELECT LISTAGG(CLAVE_DATO, ''||''''|''''||'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO
                        , LISTAGG(CLAVE_DATO, ''||''''|''''||T1.'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO2
                    FROM '||V_ESQUEMA||'.INTERFAZ_CLAVE
                    WHERE NOMBRE_INTERFAZ = REPLACE('''||vTABLA||''',''REMMASTER.'','''')
                    GROUP BY NOMBRE_INTERFAZ';
                EXECUTE IMMEDIATE V_MSQL INTO vCLAVE, vCLAVE2;
                
                IF vDICCIONARIO != 'REM01.MIG2_USU_USUARIOS' THEN
                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO)
                      SELECT '||V_ESQUEMA||'.'||V_SEC||'.NEXTVAL VALIDACION_ID, '''||vTABLA||''' NOMBRE_INTERFAZ, '||vCLAVE||' CLAVE_DATO
                          , DR.CODIGO_RECHAZO COD_RECHAZO, DR.MOTIVO_RECHAZO||'||''' '||' '||vTABLA||'.'||vCAMPO||' <> '||vDICCIONARIO||'.'||vCODIGO||'.'' MOTIVO_RECHAZO
                      FROM '||V_ESQUEMA||'.'||vTABLA||' NI
                      JOIN '||V_ESQUEMA||'.DICCIONARIO_RECHAZOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_DD||'''
                      LEFT JOIN '||vDICCIONARIO||' DD ON '||vCAMPO||' = DD.'||vCODIGO||' AND DD.BORRADO = 0
                      WHERE DD.'||vCODIGO||' IS NULL AND '||vCAMPO||' IS NOT NULL';                  
                ELSE
                  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO)
                      SELECT '||V_ESQUEMA||'.'||V_SEC||'.NEXTVAL VALIDACION_ID, '''||vTABLA||''' NOMBRE_INTERFAZ, '||vCLAVE||' CLAVE_DATO
                          , DR.CODIGO_RECHAZO COD_RECHAZO, DR.MOTIVO_RECHAZO||'||''' '||' '||vTABLA||'.'||vCAMPO||' <> '||vDICCIONARIO||'.'||vCODIGO||'.'' MOTIVO_RECHAZO
                      FROM '||V_ESQUEMA||'.'||vTABLA||' NI
                      JOIN '||V_ESQUEMA||'.DICCIONARIO_RECHAZOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_DD||'''
                      LEFT JOIN '||vDICCIONARIO||' DD ON '||vCAMPO||' = DD.'||vCODIGO||'
                      WHERE DD.'||vCODIGO||' IS NULL AND '||vCAMPO||' IS NOT NULL'; 
                END IF;
                EXECUTE IMMEDIATE V_MSQL;

                IF vREQUERIDO = 1 THEN
                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO)
                        SELECT '''||vTABLA||''' NOMBRE_INTERFAZ, '||vCLAVE||' CLAVE_DATO
                            , DR.CODIGO_RECHAZO COD_RECHAZO, DR.MOTIVO_RECHAZO||'||''' Campo requerido, '||vCAMPO||', vacío.'' MOTIVO_RECHAZO
                        FROM '||V_ESQUEMA||'.'||vTABLA||' NI
                        JOIN '||V_ESQUEMA||'.DICCIONARIO_RECHAZOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_REQ||'''
                        WHERE '||vCAMPO||' IS NULL';
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Validando requerimiento de campo, '||vCAMPO||', en tabla, '||vTABLA||'.');
                    EXECUTE IMMEDIATE V_MSQL;
                END IF;
        
                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||vTABLA||' T1
                    USING (SELECT DISTINCT CLAVE_DATO
                        FROM '||V_ESQUEMA||'.'||TABLA_VALIDACION||'
                        WHERE NOMBRE_INTERFAZ = '''||vTABLA||'''
                            AND COD_RECHAZO = '''||vRECHAZO_DD||''') T2
                    ON (TO_CHAR(T2.CLAVE_DATO) = TO_CHAR(T1.'||vCLAVE2||'))
                    WHEN MATCHED THEN UPDATE SET
                        T1.VALIDACION = '''||vRECHAZO_DD||'''
                    WHERE T1.VALIDACION = 0';
        
                DBMS_OUTPUT.PUT_LINE('  [INFO] Validando código, '||vCAMPO||', en tabla, '||vTABLA||', contra diccionario, '||vDICCIONARIO||'.');
                EXECUTE IMMEDIATE V_MSQL;
            END IF;
    
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('  [ERROR] No se encuentra la clave para '||vTABLA||': '||vCLAVE||'.');
        END;

        END LOOP;

    CLOSE v_val_cursor;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Validaciones de diccionarios ejecutadas.');

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.PUT_LINE(vID);
    ROLLBACK;
    RAISE;

END;
/
EXIT