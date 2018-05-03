CREATE OR REPLACE PROCEDURE SP_004_VALIDACION_DEPENDENCIAS IS

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  err_num NUMBER; 													-- Numero de errores
  err_msg VARCHAR2(2048); 											-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_SEC VARCHAR2(30 CHAR) := 'S_VALIDACIONES_MIGRACION';
  TYPE valCurTyp IS REF CURSOR;
  v_val_cursor valCurTyp;
  v_stmt_val VARCHAR2(4000 CHAR);
  TABLA_VALIDACION VARCHAR2(30 CHAR) := 'VALIDACIONES_MIGRACION';
  vID REM01.VIC_VAL_INTERFAZ_DEP.VALIDACION_ID%TYPE;
  vTABLA_O REM01.VIC_VAL_INTERFAZ_DEP.NOMBRE_INTERFAZ%TYPE;
  vCAMPO_O REM01.VIC_VAL_INTERFAZ_DEP.CAMPO_ORIGEN%TYPE;
  vTABLA_D REM01.VIC_VAL_INTERFAZ_DEP.NOMBRE_INTERFAZ_DEPENDIENTE%TYPE;
  vCAMPO_D REM01.VIC_VAL_INTERFAZ_DEP.CAMPO_DEPENDIENTE%TYPE;
  V_EXIST_MIG NUMBER(1);
  V_EXIST_DEP NUMBER(1);

  vCLAVE VARCHAR2(240 CHAR);
  vCLAVE2 VARCHAR2(240 CHAR);
  vRECHAZO_RD REM01.DICCIONARIO_RECHAZOS.MOTIVO_RECHAZO%TYPE := '4';
  vAUX VARCHAR2(240 CHAR);
  vAUX2 VARCHAR2(240 CHAR);
  
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

    v_stmt_val := 'SELECT VALIDACION_ID, NOMBRE_INTERFAZ, CAMPO_ORIGEN, NOMBRE_INTERFAZ_DEPENDIENTE, CAMPO_DEPENDIENTE
        FROM '||V_ESQUEMA||'.VIC_VAL_INTERFAZ_DEP
        WHERE BORRADO = 0
        ORDER BY PRIORIDAD_DEPENDENCIA, VALIDACION_ID';
    OPEN v_val_cursor FOR v_stmt_val;
        LOOP
        FETCH v_val_cursor INTO vID, vTABLA_O, vCAMPO_O, vTABLA_D, vCAMPO_D;
        EXIT WHEN v_val_cursor%NOTFOUND;
        
        BEGIN
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||vTABLA_O||''' AND COLUMN_NAME = ''VALIDACION'' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXIST_MIG;

            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||vTABLA_D||''' AND COLUMN_NAME = ''VALIDACION'' ';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXIST_DEP;

            IF V_EXIST_MIG > 0 AND V_EXIST_DEP > 0 THEN
                V_MSQL := 'SELECT LISTAGG(CLAVE_DATO, ''||''''|''''||NI.'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO
                        , LISTAGG(CLAVE_DATO, ''||''''|''''||T1.'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO2
                    FROM '||V_ESQUEMA||'.INTERFAZ_CLAVE
                    WHERE NOMBRE_INTERFAZ = REPLACE('''||vTABLA_O||''',''REMMASTER.'','''')
                    GROUP BY NOMBRE_INTERFAZ';
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL INTO vCLAVE, vCLAVE2;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO)
                    SELECT '||V_ESQUEMA||'.'||V_SEC||'.NEXTVAL VALIDACION_ID, NOMBRE_INTERFAZ,CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO FROM (
                    SELECT '''||vTABLA_O||''' NOMBRE_INTERFAZ, NI.'||vCLAVE||' CLAVE_DATO
                        , DR.CODIGO_RECHAZO COD_RECHAZO, DR.MOTIVO_RECHAZO||'' Tabla y campo de la que se depende: '||vTABLA_D||'.'||vCAMPO_D||''' MOTIVO_RECHAZO
                    FROM '||V_ESQUEMA||'.'||vTABLA_O||' NI
                    JOIN '||V_ESQUEMA||'.DICCIONARIO_RECHAZOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_RD||'''
                    LEFT JOIN '||vTABLA_D||' TD ON NI.'||vCAMPO_O||' = TD.'||vCAMPO_D||' AND TD.VALIDACION IN(0,1)
                    WHERE TD.'||vCAMPO_D||' IS NULL AND NI.'||vCAMPO_O||' IS NOT NULL)';
                    --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;
                
                V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||vTABLA_O||' T1
                    USING (SELECT DISTINCT CLAVE_DATO
                        FROM '||V_ESQUEMA||'.'||TABLA_VALIDACION||'
                        WHERE NOMBRE_INTERFAZ = '''||vTABLA_O||'''
                            AND COD_RECHAZO = '''||vRECHAZO_RD||''') T2
                    ON (TO_CHAR(T2.CLAVE_DATO) = TO_CHAR(T1.'||vCLAVE2||'))
                    WHEN MATCHED THEN UPDATE SET
                        T1.VALIDACION = '''||vRECHAZO_RD||'''
                    WHERE T1.VALIDACION IN (0,1)';
                
                DBMS_OUTPUT.PUT_LINE('  [INFO] Validando código, '||vCAMPO_O||', en tabla, '||vTABLA_O||', contra el campo de la tabla, '||vTABLA_D||'.'||vCAMPO_D||'');
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;
            END IF;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('  [ERROR] No se encuentra la clave para '||vTABLA_O||': '||vCLAVE||'.');
        END;
        
        END LOOP;
        
    CLOSE v_val_cursor;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Validaciones de dependencias ejecutadas.');

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