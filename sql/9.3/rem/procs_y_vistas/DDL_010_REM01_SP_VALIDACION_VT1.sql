--/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20200915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11061
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
    SET SERVEROUTPUT ON; 
    SET DEFINE OFF;

create or replace PROCEDURE SP_VALIDACION_VT1 (PL_OUTPUT OUT VARCHAR2) AS

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
    WHEN NO_DATA_FOUND THEN
        PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || 'KO. No se ha podido completar la operativa: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_VALIDACION_VT1;
/
EXIT;
