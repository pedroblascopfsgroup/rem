CREATE OR REPLACE PROCEDURE SP_006_VALIDACION_DEPENDENCIAS IS

  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 	-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  err_num NUMBER; 													-- Numero de errores
  err_msg VARCHAR2(2048); 											-- Mensaje de error
  V_MSQL VARCHAR2(4000 CHAR);
  V_MSQL2 VARCHAR2(4000 CHAR);
  V_SEC VARCHAR2(30 CHAR) := 'S_VALIDACIONES_RESULTADOS';
  TYPE valCurTyp IS REF CURSOR;
  v_val_cursor valCurTyp;
  v_stmt_val VARCHAR2(4000 CHAR);
  TABLA_VALIDACION VARCHAR2(30 CHAR) := 'VALIDACIONES_RESULTADOS';
  vID REM01.VALIDACIONES_DEPENDENCIAS.VALIDACION_ID%TYPE;
  vTABLA_O REM01.VALIDACIONES_DEPENDENCIAS.NOMBRE_INTERFAZ%TYPE;
  vCAMPO_O REM01.VALIDACIONES_DEPENDENCIAS.CAMPO_ORIGEN%TYPE;
  vTABLA_D REM01.VALIDACIONES_DEPENDENCIAS.NOMBRE_INTERFAZ_DEPENDIENTE%TYPE;
  vCAMPO_D REM01.VALIDACIONES_DEPENDENCIAS.CAMPO_DEPENDIENTE%TYPE;
  V_EXIST_MIG NUMBER(1);
  V_EXIST_DEP NUMBER(1);

  vCLAVE VARCHAR2(240 CHAR);
  vCLAVE2 VARCHAR2(240 CHAR);
  CAMPO_CLAVE_DATO VARCHAR2(240 CHAR);
  vRECHAZO_RD REM01.VALIDACIONES_TIPOS.MOTIVO_RECHAZO%TYPE := '6';
  vAUX VARCHAR2(240 CHAR);
  vAUX2 VARCHAR2(240 CHAR);
  
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
    
    --BORRAMOS LAS VALIDACIONES QUE PUDIErA HABER PARA ESTE TIPO DE VALIDACION
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||TABLA_VALIDACION||' WHERE COD_RECHAZO = '''||vRECHAZO_RD||'''';
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;

    v_stmt_val := 'SELECT VALIDACION_ID, NOMBRE_INTERFAZ, CAMPO_ORIGEN, NOMBRE_INTERFAZ_DEPENDIENTE, CAMPO_DEPENDIENTE
        FROM '||V_ESQUEMA||'.VALIDACIONES_DEPENDENCIAS
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
                                , LISTAGG(CLAVE_DATO, ''|'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CAMPO_CLAVE_DATO
                    FROM '||V_ESQUEMA||'.INTERFAZ_CLAVE
                    WHERE NOMBRE_INTERFAZ = REPLACE('''||vTABLA_O||''',''REMMASTER.'','''')
                    GROUP BY NOMBRE_INTERFAZ';
                EXECUTE IMMEDIATE V_MSQL INTO vCLAVE, vCLAVE2, CAMPO_CLAVE_DATO;

                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO, CAMPO_CLAVE_DATO)
                    SELECT '||V_ESQUEMA||'.'||V_SEC||'.NEXTVAL VALIDACION_ID, NOMBRE_INTERFAZ,CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO, CAMPO_CLAVE_DATO FROM (   
                    SELECT '''||vTABLA_O||''' NOMBRE_INTERFAZ, NI.'||vCLAVE||' CLAVE_DATO
                        , DR.CODIGO_RECHAZO COD_RECHAZO,
                        CASE WHEN TD.VALIDACION NOT IN (0,1) and TD.'||vCAMPO_D||' IS NOT NULL THEN ''[DEPENDENCIA] El registro del que depende está pero tiene errores de validación. Tabla dependiente -> '||vTABLA_D||'. '' 
                             WHEN TD.'||vCAMPO_D||' IS NULL THEN ''[DEPENDENCIA] El registro del que depende no está. El campo '||vTABLA_O||'.'||vCAMPO_O||' no se encuentra en el campo '||vTABLA_D||'.'||vCAMPO_D||''' 
                        END AS MOTIVO_RECHAZO
                        , '''||CAMPO_CLAVE_DATO||''' CAMPO_CLAVE_DATO
                    FROM '||V_ESQUEMA||'.'||vTABLA_O||' NI
                    JOIN '||V_ESQUEMA||'.VALIDACIONES_TIPOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_RD||'''
                    LEFT JOIN '||vTABLA_D||' TD ON NI.'||vCAMPO_O||' = TD.'||vCAMPO_D||' 
                    WHERE NI.'||vCAMPO_O||' IS NOT NULL
                    )
                    WHERE MOTIVO_RECHAZO IS NOT NULL
                ';

                V_MSQL2 := 'INSERT INTO '||V_ESQUEMA||'.'||TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO, CAMPO_CLAVE_DATO, QUERY_VALIDACION)
                    SELECT '||V_ESQUEMA||'.'||V_SEC||'.NEXTVAL VALIDACION_ID, NOMBRE_INTERFAZ,CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO, CAMPO_CLAVE_DATO, QUERY_VALIDACION FROM (   
                    SELECT '''||vTABLA_O||''' NOMBRE_INTERFAZ, NI.'||vCLAVE||' CLAVE_DATO
                        , DR.CODIGO_RECHAZO COD_RECHAZO,
                        CASE WHEN TD.VALIDACION NOT IN (0,1) and TD.'||vCAMPO_D||' IS NOT NULL THEN ''[DEPENDENCIA] El registro del que depende está pero tiene errores de validación. Tabla dependiente -> '||vTABLA_D||'. '' 
                             WHEN TD.'||vCAMPO_D||' IS NULL THEN ''[DEPENDENCIA] El registro del que depende no está. El campo '||vTABLA_O||'.'||vCAMPO_O||' no se encuentra en el campo '||vTABLA_D||'.'||vCAMPO_D||''' 
                        END AS MOTIVO_RECHAZO
                        , '''||CAMPO_CLAVE_DATO||''' CAMPO_CLAVE_DATO
                        , q''['||V_MSQL||']'' QUERY_VALIDACION
                    FROM '||V_ESQUEMA||'.'||vTABLA_O||' NI
                    JOIN '||V_ESQUEMA||'.VALIDACIONES_TIPOS DR ON DR.CODIGO_RECHAZO = '''||vRECHAZO_RD||'''
                    LEFT JOIN '||vTABLA_D||' TD ON NI.'||vCAMPO_O||' = TD.'||vCAMPO_D||' 
                    WHERE NI.'||vCAMPO_O||' IS NOT NULL
                    )
                    WHERE MOTIVO_RECHAZO IS NOT NULL
                ';
                EXECUTE IMMEDIATE V_MSQL2;
                
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
