create or replace PROCEDURE SP_MIG_GEN_INFORME_CAJA_NEGRA ( USUARIO_MIGRACION VARCHAR2 ) AUTHID CURRENT_USER IS

    V_SQL VARCHAR2(4000 CHAR); 								-- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; 				  	-- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; 			-- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); 								-- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  									-- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); 							-- Vble. auxiliar para registrar errores en el script.
    VINDICADOR VARCHAR2(4000 CHAR);
    --USUARIO_MIGRACION VARCHAR2(4000 CHAR):= 'MIG_LIBERBANK';

    CURSOR TABLES_CURSOR IS
		SELECT INF.CAJA_NEGRA_INDICADOR
		FROM REM01.MIG2_COUNTS_INFORME_CAJA_NEGRA INF
		WHERE BORRADO = 0
		ORDER BY INF.ID
    ;
    
    TABLE_CURSOR_2                 SYS_REFCURSOR;    

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Informe de Caja Negra');

    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.MIG_INFORME_CAJA_NEGRA';

    DBMS_OUTPUT.PUT_LINE('  [INFO] Generando resultados de Caja Negra');

    OPEN TABLES_CURSOR;
    LOOP
        FETCH TABLES_CURSOR INTO VINDICADOR;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;
        
            VINDICADOR := REPLACE(VINDICADOR, '#USUARIO_MIGRACION#', ''||USUARIO_MIGRACION||'');
          
                V_SQL := '
                    INSERT INTO '||V_ESQUEMA||'.MIG_INFORME_CAJA_NEGRA
                    SELECT S_MIG_INFORME_CAJA_NEGRA.NEXTVAL, AUX.* FROM ('||VINDICADOR||') AUX ';
                EXECUTE IMMEDIATE V_SQL;
            
    END LOOP;
    CLOSE TABLES_CURSOR;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('  [FIN] Indicadores para informe de Caja Negra generados.');

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
