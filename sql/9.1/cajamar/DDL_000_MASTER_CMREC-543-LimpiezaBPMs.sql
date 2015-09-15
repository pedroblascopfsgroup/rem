--/*
--##########################################
--## AUTOR=BRUNO ANGLES ROBLES
--## FECHA_CREACION=20150911
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-543
--## PRODUCTO=NO
--## 
--## Este script realiza una limpieza de las tablas JPBM_* 
--## INSTRUCCIONES:  
--##   Ese script debe lanzarse con un usuario con permisos para realizar DDL
--##     sobre el SCHEMA en el que residan las tablas JBPM_* (MASTER_SCHEMA)
--## VERSIONES:
--##        0.1
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    -- Otras variables

 BEGIN

  DBMS_OUTPUT.put_line('PASO 1: Deshabilitamos constranints para permitir la limpieza, se habilitarán en el paso 3');
  FOR C IN (SELECT OWNER, CONSTRAINT_NAME, TABLE_NAME FROM ALL_CONSTRAINTS WHERE TABLE_NAME LIKE 'JBPM_%' AND CONSTRAINT_TYPE = 'R' AND STATUS = 'ENABLED')
  LOOP
    DBMS_OUTPUT.put_line('Deshabilitado constraint '||C.CONSTRAINT_NAME);
    EXECUTE IMMEDIATE  'ALTER TABLE '||C.OWNER||'.'||C.TABLE_NAME||' DISABLE CONSTRAINT '||C.CONSTRAINT_NAME;
  END LOOP;
  
  DBMS_OUTPUT.put_line('');
  DBMS_OUTPUT.put_line('PASO 2: Limpiamos el contenido de las tablas');
  FOR T IN (SELECT OWNER, TABLE_NAME FROM ALL_TABLES WHERE TABLE_NAME LIKE 'JBPM_%')
  LOOP
    DBMS_OUTPUT.put_line('Limpieza tabla'||T.TABLE_NAME);
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||T.OWNER||'.'||T.TABLE_NAME;
  END LOOP;

  DBMS_OUTPUT.put_line('');
  DBMS_OUTPUT.put_line('PASO 3: Volvemos a activar las constraints');
  FOR C IN (SELECT OWNER, CONSTRAINT_NAME, TABLE_NAME FROM ALL_CONSTRAINTS WHERE TABLE_NAME LIKE 'JBPM_%' AND CONSTRAINT_TYPE = 'R' AND STATUS = 'DISABLED')
  LOOP
    DBMS_OUTPUT.put_line('Habilitado constraint '||C.CONSTRAINT_NAME);
    EXECUTE IMMEDIATE  'ALTER TABLE '||C.OWNER||'.'||C.TABLE_NAME||' ENABLE CONSTRAINT '||C.CONSTRAINT_NAME;
  END LOOP;
  DBMS_OUTPUT.put_line('Fin');

 EXCEPTION


    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
