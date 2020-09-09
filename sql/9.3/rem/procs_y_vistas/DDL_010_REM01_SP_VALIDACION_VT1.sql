create or replace PROCEDURE SP_VALIDACION_VT1 IS

    WHENEVER SQLERROR EXIT SQL.SQLCODE;
    SET SERVEROUTPUT ON; 
    SET DEFINE OFF;

    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(4000 CHAR);

    V_TABLA VARCHAR2(30 CHAR) := 'ACT_BBVA_VT1_RECHAZADOS';

    vCodigo         REM01.DD_VALIDACION_VT1.DD_VAL_VT1_CODIGO%TYPE;
    vDescripcion    REM01.DD_VALIDACION_VT1.DD_VAL_VT1_DESCRIPCION%TYPE;
    vOperacion      REM01.DD_VALIDACION_VT1.DD_VAL_VT1_OPERACION%TYPE;
    vQuery          REM01.DD_VALIDACION_VT1.DD_VAL_VT1_QUERY%TYPE;

    CURSOR TABLES_CURSOR IS
		  SELECT DD_VAL_VT1_CODIGO, DD_VAL_VT1_DESCRIPCION, DD_VAL_VT1_OPERACION, DD_VAL_VT1_QUERY
		  FROM DD_VALIDACION_VT1
		  WHERE BORRADO = 0
    ;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    OPEN TABLES_CURSOR;
    LOOP
        FETCH TABLES_CURSOR INTO vCodigo, vDescripcion, vOperacion, vQuery;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('  [INFO] Validando: '||vCodigo||' - '||vDescripcion||'...');

            -- Insertamos los registros en la tabla REJECTS que no han superado la validacion
            V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ACT_NUM_ACTIVO, FECHA_PROCESADO, OPERACION, COD_ERROR, DESC_ERROR)
                        VALUES (('||vQuery||'), SYSDATE, '''||vOperacion||''', '''||vCodigo||''', '''||vDescripcion||''')';
            EXECUTE IMMEDIATE V_SQL;
            

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
