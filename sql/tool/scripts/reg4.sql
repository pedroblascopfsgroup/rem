whenever sqlerror exit sql.sqlcode;

set linesize 200
SET FEEDBACK OFF;
SET VERIFY OFF;

DECLARE
  v_RSR_NOMBRE_SCRIPT VARCHAR2(200 CHAR);
  v_RSR_FECHACREACION VARCHAR2(200 CHAR);
  v_RSR_ESQUEMA_EJECUCION VARCHAR2(200 CHAR);
  v_RSR_RESULTADO VARCHAR2(200 CHAR);
  v_RSR_ERROR_SQL VARCHAR2(200 CHAR);

BEGIN

  v_RSR_NOMBRE_SCRIPT := '&&1';
  v_RSR_FECHACREACION := '&&2';
  v_RSR_ESQUEMA_EJECUCION := '&&3';
  v_RSR_RESULTADO := '&&4';
  v_RSR_ERROR_SQL := '&&5';

  #ESQUEMA#.RSR_PASO4(
    v_RSR_NOMBRE_SCRIPT => v_RSR_NOMBRE_SCRIPT,
    v_RSR_FECHACREACION => v_RSR_FECHACREACION,
    v_RSR_ESQUEMA_EJECUCION => v_RSR_ESQUEMA_EJECUCION,
    v_RSR_RESULTADO => v_RSR_RESULTADO,
    v_RSR_ERROR_SQL => v_RSR_ERROR_SQL
  );


EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(SQLERRM);
        
        ROLLBACK;
        RAISE;

END;
/

exit
