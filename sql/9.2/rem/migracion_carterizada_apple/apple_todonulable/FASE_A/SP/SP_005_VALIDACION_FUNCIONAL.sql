create or replace PROCEDURE SP_005_VALIDACION_FUNCIONAL IS

    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(4000 CHAR);

    V_TABLA_VALIDACION VARCHAR2(30 CHAR) := 'VALIDACIONES_RESULTADOS';
    V_TABLA_VALIDACION_SEC VARCHAR2(30 CHAR) := 'S_VALIDACIONES_RESULTADOS';
    CODIGO_RECHAZO_FUN REM01.VALIDACIONES_TIPOS.CODIGO_RECHAZO%TYPE := '5';

    vCodigo REM01.VALIDACIONES_FUNCIONALES.CODIGO%TYPE;
    vSeveridad REM01.VALIDACIONES_FUNCIONALES.SEVERIDAD%TYPE;
    vValidacion REM01.VALIDACIONES_FUNCIONALES.VALIDACION%TYPE;
    vTabla REM01.VALIDACIONES_FUNCIONALES.NOMBRE_INTERFAZ%TYPE;
    vQuery REM01.VALIDACIONES_FUNCIONALES.QUERY%TYPE;
    vMotivoRechazo REM01.VALIDACIONES_RESULTADOS.MOTIVO_RECHAZO%TYPE;
    vClave VARCHAR2(256 CHAR);
    vClave2 VARCHAR2(256 CHAR);
    CAMPO_CLAVE_DATO VARCHAR2(256 CHAR);

    CURSOR TABLES_CURSOR IS
      SELECT CODIGO, SEVERIDAD, VALIDACION, NOMBRE_INTERFAZ, QUERY
      FROM VALIDACIONES_FUNCIONALES 
      WHERE BORRADO = 0
      ORDER BY CODIGO
    ;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    --BORRAMOS LAS VALIDACIONES QUE PUDIErA HABER PARA ESTE TIPO DE VALIDACION
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_VALIDACION||' WHERE COD_RECHAZO = '''||CODIGO_RECHAZO_FUN||'''';
    EXECUTE IMMEDIATE V_MSQL;
    COMMIT;

    OPEN TABLES_CURSOR;

    LOOP
        FETCH TABLES_CURSOR INTO vCodigo, vSeveridad, vValidacion, vTabla, vQuery;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;
        
        vValidacion := '[FUNCIONAL] '||vValidacion;

        DBMS_OUTPUT.PUT_LINE('  [INFO] Validando: '||vCodigo||' - '||vValidacion||'...');

        -- Obtenemos campos clave por interfaz
        BEGIN
            V_SQL := 'SELECT LISTAGG(CLAVE_DATO, ''||''''|''''||'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO
                           , LISTAGG(CLAVE_DATO, ''||''''|''''||T1.'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CLAVE_DATO2
                           , LISTAGG(CLAVE_DATO, ''|'') WITHIN GROUP (ORDER BY CLAVE_POSICION) CAMPO_CLAVE_DATO
                FROM '||V_ESQUEMA||'.INTERFAZ_CLAVE
                WHERE NOMBRE_INTERFAZ = REPLACE('''||vTabla||''',''REMMASTER.'','''')
                GROUP BY NOMBRE_INTERFAZ';
            EXECUTE IMMEDIATE V_SQL INTO vClave, vClave2, CAMPO_CLAVE_DATO;

            -- Formamos el motivo de rechazo
            V_SQL := 'SELECT CASE FUNC.SEVERIDAD
                        WHEN 1 THEN ''[FUNCIONAL] [CRITICAL] - [''||FUNC.CODIGO ||''] - ''||FUNC.VALIDACION||''''
                               ELSE ''[FUNCIONAL] [WARNING] - [''||FUNC.CODIGO ||''] - ''||FUNC.VALIDACION||''''
                      END AS CODIGO_RECHAZO
                      FROM VALIDACIONES_FUNCIONALES FUNC, VALIDACIONES_TIPOS DIC
                      WHERE FUNC.CODIGO = '''||vCodigo||''' AND CODIGO_RECHAZO = '''||CODIGO_RECHAZO_FUN||'''';
            EXECUTE IMMEDIATE V_SQL INTO vMotivoRechazo;
           
            -- Formamos el Select Statement
            vQuery := REPLACE(vQuery, '#SELECT_STATEMENT#', ' '''||vTabla||''', AUX.'||vClave||', '''||CODIGO_RECHAZO_FUN||''', '''||vMotivoRechazo||''' ');

            -- Insertamos en VALIDACIONES_RESULTADOS
            V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_VALIDACION||' (VALIDACION_ID, NOMBRE_INTERFAZ, CLAVE_DATO, COD_RECHAZO, MOTIVO_RECHAZO, CAMPO_CLAVE_DATO, QUERY_VALIDACION) 
                SELECT '||V_ESQUEMA||'.'||V_TABLA_VALIDACION_SEC||'.NEXTVAL, TABLA.*, '''||CAMPO_CLAVE_DATO||''', q''['||vQuery||']''
                FROM ('||vQuery||') TABLA';
            EXECUTE IMMEDIATE V_SQL;
 
            -- Actualizamos los registros de las interfaces que no han superado la validacion
            -- UPDATED 06/03/19, SOLO PONEMOS CODIGO DE RECHAZO SI LA SERVERIDAD ES 1, SINO SE QUEDA A 0 PARA QUE PASE
            IF vSeveridad > 0 THEN
                V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||vTabla||' T1
                    USING (SELECT DISTINCT CLAVE_DATO
                        FROM '||V_ESQUEMA||'.'||V_TABLA_VALIDACION||'
                        WHERE NOMBRE_INTERFAZ = '''||vTabla||'''
                            AND COD_RECHAZO = '''||CODIGO_RECHAZO_FUN||'''
                            AND MOTIVO_RECHAZO LIKE ''[FUNCIONAL] [CRITICAL]%'') T2
                    ON (TO_CHAR(T2.CLAVE_DATO) = TO_CHAR(T1.'||vClave2||'))
                    WHEN MATCHED THEN UPDATE SET
                        T1.VALIDACION = '''||CODIGO_RECHAZO_FUN||'''';
                EXECUTE IMMEDIATE V_SQL;
            END IF;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('  [ERROR] NO SE ENCUENTRA LA PALABRA CLAVE PARA '||vTabla||': '||vClave||'.');
        END;

    END LOOP;
    CLOSE TABLES_CURSOR;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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
EXIT
