create or replace PROCEDURE SP_MIG_GEN_INFORME_KPIS ( USUARIO_MIGRACION VARCHAR2 ) AUTHID CURRENT_USER IS

    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    vIndicador VARCHAR2(4000 CHAR);

    CURSOR TABLES_CURSOR IS
    SELECT INF.KPI_INDICADOR
    FROM REM01.MIG2_COUNTS_INFORME_KPIS INF
    WHERE BORRADO = 0
    ORDER BY INF.ID
    ;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Informe KPIs');
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.MIG2_INFORME_KPIS';

    DBMS_OUTPUT.PUT_LINE('  [INFO] Generando resultados de KPI');

    OPEN TABLES_CURSOR;

    LOOP
        FETCH TABLES_CURSOR INTO vIndicador;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;
        
        vIndicador := REPLACE(vIndicador, '#USUARIO_MIGRACION#', ' '''||USUARIO_MIGRACION||''' ');
        
        V_SQL := '
            INSERT INTO '||V_ESQUEMA||'.MIG2_INFORME_KPIS
            SELECT S_MIG2_INFORME_KPIS.NEXTVAL, AUX.* FROM ('||vIndicador||') AUX ';
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL;

    END LOOP;
    CLOSE TABLES_CURSOR;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('  [FIN] Indicadores para informe KPIs generados.');

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
EXIT;