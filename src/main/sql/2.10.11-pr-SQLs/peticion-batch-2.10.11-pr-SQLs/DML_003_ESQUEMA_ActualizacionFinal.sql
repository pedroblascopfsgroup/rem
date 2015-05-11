whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: Actualización final en tabla de registro
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON

DECLARE
v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

v_RSR_NOMBRE_SCRIPT VARCHAR2(255 CHAR) := '&&1';
v_RSR_FECHACREACION VARCHAR2(20 CHAR) := '&&2';
v_RSR_RESULTADO VARCHAR2(100 CHAR) := '&&3';
v_RSR_ERROR_SQL VARCHAR2(255 CHAR) := '&&4';

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Actualización final de los datos de ejecución del script ' 
	|| v_RSR_NOMBRE_SCRIPT || ' con fecha de creación ' 
	|| v_RSR_FECHACREACION || ' en RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'UPDATE ' || v_schema || '.RSR_REGISTRO_SQLS SET ' ||
	'RSR_RESULTADO=''' || v_RSR_RESULTADO || ''',' ||
	'RSR_ERROR_SQL=''' || v_RSR_ERROR_SQL || ''',' ||
	'RSR_FIN=SYSDATE ' || 
	'WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT || ''' AND ' ||
	'RSR_FECHACREACION=''' || v_RSR_FECHACREACION || '''';

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
