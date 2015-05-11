WHENEVER SQLERROR EXIT SQL.SQLCODE;

BEGIN
 ALTA_BPM_INSTANCES_ALL();
    EXCEPTION
     WHEN OTHERS THEN

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(SQLERRM);

          ROLLBACK;
          RAISE;
END;
/

EXIT;