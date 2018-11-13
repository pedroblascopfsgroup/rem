--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-3577
--## PRODUCTO=NO
--##
--## Finalidad: Actualización e inserción de activos traspasados (TANGO).   
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(2048 CHAR);
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_ACTIVOS_TRASPASADOS';
    V_COLUMN VARCHAR2(30 CHAR) := 'ACT_NUM_ACTIVO_VIEJO';
    V_COLUMN1 VARCHAR2(30 CHAR) := 'ACT_NUM_ACTIVO_NUEVO';
    V_COLUMN2 VARCHAR2(30 CHAR) := 'CODIGO_CARTERA';
    V_COLUMN3 VARCHAR2(30 CHAR) := 'CODIGO_SUBCARTERA';
    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_EXISTS NUMBER(1);
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('6520203','7031653','10','23')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE LA TABLA');
    ELSE
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME IN ('''||V_COLUMN||''','''||V_COLUMN1||''','''||V_COLUMN2||''','''||V_COLUMN3||''') 
            AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;

        IF V_EXISTS = 4 THEN
            FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
                LOOP
                    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
                    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                        USING (SELECT '''||V_TMP_TIPO_DATA(1)||''' '||V_COLUMN||'
                                , '''||V_TMP_TIPO_DATA(2)||''' '||V_COLUMN1||'
                                , '''||V_TMP_TIPO_DATA(3)||''' '||V_COLUMN2||'
                                , '''||V_TMP_TIPO_DATA(4)||''' '||V_COLUMN3||'
                            FROM DUAL) T2
                        ON (T1.'||V_COLUMN||' = T2.'||V_COLUMN||')
                        WHEN MATCHED THEN UPDATE SET
                            T1.'||V_COLUMN1||' = T2.'||V_COLUMN1||'
                            , T1.'||V_COLUMN2||' = T2.'||V_COLUMN2||'
                            , T1.'||V_COLUMN3||' = T2.'||V_COLUMN3||'
                        WHEN NOT MATCHED THEN INSERT (T1.'||V_COLUMN||', T1.'||V_COLUMN1||', T1.'||V_COLUMN2||', T1.'||V_COLUMN3||') 
                        VALUES (T2.'||V_COLUMN||', T2.'||V_COLUMN1||', T2.'||V_COLUMN2||', T2.'||V_COLUMN3||')';
                    EXECUTE IMMEDIATE V_MSQL;
                END LOOP;

            DBMS_OUTPUT.PUT_LINE('  [INFO] TABLA RELLENA');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE ALGÚN CAMPO');
        END IF;
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;          
END;
/
EXIT;
