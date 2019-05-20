--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20170616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2264
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de secuencias usadas en las tablas de volcado
--##      
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
  
  TYPE T_VIC IS TABLE OF VARCHAR2(4000 CHAR);
  TYPE T_ARRAY_VIC IS TABLE OF T_VIC;
  TABLE_COUNT NUMBER(3);                      -- Vble. para validar la existencia de las Tablas.
  err_num NUMBER;                           -- Numero de errores
  err_msg VARCHAR2(2048);                       -- Mensaje de error
  V_ID VARCHAR2(30 CHAR);
  V_MSQL VARCHAR2(4000 CHAR);
  V_EXIST NUMBER(10);
  V_SEC NUMBER(16);

  V_VIC T_ARRAY_VIC := T_ARRAY_VIC(
      T_VIC('REMMASTER.S_USU_USUARIOS','REMMASTER.USU_USUARIOS','USU_ID'),
      T_VIC('REMMASTER.S_GRU_GRUPOS_USUARIOS','REMMASTER.GRU_GRUPOS_USUARIOS','GRU_ID'));
  V_TMP_VIC T_VIC;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]  Inicio del proceso');

    FOR I IN V_VIC.FIRST .. V_VIC.LAST
        LOOP
            V_TMP_VIC := V_VIC(I);
            V_SEC := NULL;
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = REPLACE(REPLACE('''||V_TMP_VIC(2)||''',''REM01.'',''''),''REMMASTER.'','''') ';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;
            
            IF V_EXIST = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [WARNING]   No existe la tabla: '''||V_TMP_VIC(2)||''' ');
            ELSE
                V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = REPLACE(REPLACE('''||V_TMP_VIC(1)||''',''REM01.'',''''),''REMMASTER.'','''') ';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXIST;
                IF V_EXIST = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [WARNING]   No existe la secuencia: '''||V_TMP_VIC(1)||''' ');
                ELSE
                    --DBMS_OUTPUT.PUT_LINE('  [INFO]      Existe la línea: T_VIC('''||V_TMP_VIC(1)||''','''||V_TMP_VIC(2)||''','''||V_TMP_VIC(3)||''')');
                    V_MSQL := 'SELECT MAX('||V_TMP_VIC(3)||')+1 FROM '||V_TMP_VIC(2)||'';
                    EXECUTE IMMEDIATE V_MSQL INTO V_SEC;
                    IF V_SEC IS NULL THEN
                        DBMS_OUTPUT.PUT_LINE('  [INFO]  La secuencia '||V_TMP_VIC(1)||' no se actualizará.');
                    ELSE
                        V_MSQL := 'DROP SEQUENCE '||V_TMP_VIC(1);
                        EXECUTE IMMEDIATE V_MSQL;
                        V_MSQL := 'CREATE SEQUENCE '||V_TMP_VIC(1)||' MINVALUE '||V_SEC||' MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||V_SEC||' CACHE 20 NOORDER NOCYCLE';    
                        EXECUTE IMMEDIATE V_MSQL;
                        DBMS_OUTPUT.PUT_LINE('  [INFO]  El MINVALUE para la secuencia '||V_TMP_VIC(1)||' será '||V_SEC||'.');
                    END IF;
                END IF;
            END IF;
        END LOOP;
    
    V_TMP_VIC := NULL;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Creación secuencias terminada.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.put_line('[ERROR]   No existe PK para la tabla:'||V_TMP_VIC(2));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR]   Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT

