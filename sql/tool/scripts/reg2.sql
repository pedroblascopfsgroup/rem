whenever sqlerror exit sql.sqlcode;

set linesize 200
SET FEEDBACK OFF;
SET VERIFY OFF;

DECLARE
  v_RSR_NOMBRE_SCRIPT VARCHAR2(200);
  v_RSR_FECHACREACION VARCHAR2(200);
  v_RSR_ESQUEMA VARCHAR2(200);
  v_RESULTADO VARCHAR2(20);

SQL_YA_EJECUTADO EXCEPTION;
PRAGMA EXCEPTION_INIT(SQL_YA_EJECUTADO, -20001);

BEGIN
  v_RSR_NOMBRE_SCRIPT := '&&1';
  v_RSR_FECHACREACION := '&&2';
  v_RSR_ESQUEMA := '&&3';

  v_RESULTADO := #ESQUEMA#.RSR_PASO2(
    v_RSR_NOMBRE_SCRIPT => v_RSR_NOMBRE_SCRIPT,
    v_RSR_FECHACREACION => v_RSR_FECHACREACION,
    v_RSR_ESQUEMA => v_RSR_ESQUEMA
  );

  IF v_RESULTADO = 'YA_EXISTE' THEN
  	raise_application_error(-20001, 'Script ya ejecutado');
  END IF;

EXCEPTION
     WHEN SQL_YA_EJECUTADO THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        RAISE;

     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(SQLERRM);
        
        ROLLBACK;
        RAISE;

END;
/

exit
