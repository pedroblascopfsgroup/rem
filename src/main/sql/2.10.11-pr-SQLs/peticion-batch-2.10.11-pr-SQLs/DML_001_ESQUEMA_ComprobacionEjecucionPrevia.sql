whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: Comprobacion de ejecución previa
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
--SET SERVEROUTPUT OFF

DECLARE
v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

v_RSR_NOMBRE_SCRIPT VARCHAR2(255 CHAR) := '&&1';
v_RSR_FECHACREACION VARCHAR2(20 CHAR) := '&&2';

SQL_YA_EJECUTADO EXCEPTION;
PRAGMA EXCEPTION_INIT(SQL_YA_EJECUTADO, -20001);

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Comprobar si el script &&1 con fecha de creación &&2 está registrado como ejecutado en RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'select count(1) from ' || v_schema || '.RSR_REGISTRO_SQLS WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT 
	|| ''' AND RSR_FECHACREACION = ''' || v_RSR_FECHACREACION || ''' AND RSR_RESULTADO=''OK''' into v_count;

if v_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] Script  &&1 con fecha de creación &&2  YA EJECUTADO');
        raise_application_error(-20001, 'Script ya ejecutado');
else 
	DBMS_OUTPUT.PUT_LINE('[INFO] Script  &&1 con fecha de creación &&2  No se ha ejecutado');
end if;

EXCEPTION
     WHEN SQL_YA_EJECUTADO THEN
	  RAISE;
	  RETURN;

     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/

exit
