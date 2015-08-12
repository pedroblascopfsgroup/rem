whenever sqlerror exit sql.sqlcode;

set linesize 200
SET FEEDBACK OFF;

DECLARE
  V_RSR_NOMBRE_SCRIPT VARCHAR2(200);
  V_RSR_FECHACREACION VARCHAR2(200);
  V_RESULTADO VARCHAR2(20);

SQL_YA_EJECUTADO EXCEPTION;
PRAGMA EXCEPTION_INIT(SQL_YA_EJECUTADO, -20001);

BEGIN
  V_RSR_NOMBRE_SCRIPT := '&&1';
  V_RSR_FECHACREACION := '&&2';

  V_RESULTADO := RSR_PASO2(
    V_RSR_NOMBRE_SCRIPT => V_RSR_NOMBRE_SCRIPT,
    V_RSR_FECHACREACION => V_RSR_FECHACREACION
  );

  IF V_RESULTADO = 'YA_EXISTE' THEN
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
