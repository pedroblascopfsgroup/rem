CREATE OR REPLACE PROCEDURE SP_MIG_GEN_INFORME_CONTRASTE ( USUARIO_MIGRACION VARCHAR2 ) AUTHID CURRENT_USER IS

    V_SQL VARCHAR2(4000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    vInterfaz VARCHAR2(50 CHAR);
    vTablaMig VARCHAR2(50 CHAR);
    vTablaModelo VARCHAR2(50 CHAR);
    vRegistrosEntrada NUMBER(16);
    vResultado NUMBER(16);
    vAuditoria NUMBER(1);
    
    CURSOR TABLES_CURSOR IS 
    SELECT DISTINCT INF.INTERFAZ, REL.TABLA_MIG, REL.TABLA_MODELO, REL.TABLA_MODELO_AUDITORIA, INF.REGISTROS_ENTRADA
    FROM REM01.MIG2_INFORME_CONTRASTE INF 
    INNER JOIN REM01.MIG2_RELACION_DAT_MIG_MODELO REL ON REL.FICHERO_DAT = INF.INTERFAZ
    ORDER BY INF.INTERFAZ
    ;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    OPEN TABLES_CURSOR;

    LOOP
        FETCH TABLES_CURSOR INTO vInterfaz, vTablaMig, vTablaModelo, vAuditoria, vRegistrosEntrada;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('  [INFO] Actualizando volumetrias de la interfaz : '||vInterfaz||'...');
      
        V_SQL := '
          UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE SET 
            REGISTROS_RECHAZADOS = (SELECT '||vRegistrosEntrada||' - (SELECT COUNT(1) FROM '||vTablaMig||') FROM DUAL)
            , REGISTROS_INVALIDOS = (SELECT COUNT(1) FROM '||vTablaMig||' WHERE VALIDACION > 1)
            , REGISTROS_DUPLICADOS = (SELECT COUNT(1) FROM '||vTablaMig||' WHERE VALIDACION = 1)
          WHERE INTERFAZ = '''||vInterfaz||'''
        '
        ;
        --DBMS_OUTPUT.PUT_LINE(V_SQL);
        EXECUTE IMMEDIATE V_SQL;
        
        IF vAuditoria = 1 THEN
        
          V_SQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS = (SELECT COUNT(1) FROM '||vTablaModelo||' WHERE USUARIOCREAR = '''||USUARIO_MIGRACION||''')
            WHERE INTERFAZ = '''||vInterfaz||'''
          '
          ;
          --DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
          
        ELSE

          V_SQL := '
            UPDATE '||V_ESQUEMA||'.MIG2_INFORME_CONTRASTE 
            SET REGISTROS_MIGRADOS = (SELECT COUNT(1) FROM '||vTablaMig||' WHERE VALIDACION = 0)
            WHERE INTERFAZ = '''||vInterfaz||'''
          '
          ;
          --DBMS_OUTPUT.PUT_LINE(V_SQL);
          EXECUTE IMMEDIATE V_SQL;
      
        END IF;
        
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