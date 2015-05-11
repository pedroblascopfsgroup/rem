whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: Insert inicial en tabla de registro
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
v_RSR_ESQUEMA_EJECUCION VARCHAR2(255 CHAR) := '&&2';
v_RSR_AUTOR VARCHAR2(100 CHAR) := '&&3';
v_RSR_ARTEFACTO VARCHAR2(50 CHAR) := '&&4';
v_RSR_VERSION_ARTEFACTO VARCHAR2(50 CHAR) := '&&5';
v_RSR_FECHACREACION VARCHAR2(20 CHAR) := '&&6';
v_RSR_INCIDENCIA_LINK VARCHAR2(255 CHAR) := '&&7';
v_RSR_PRODUCTO VARCHAR2(2 CHAR) := '&&8';

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Inserción inicial de los datos de ejecución del script ' 
	|| v_RSR_NOMBRE_SCRIPT || ' con fecha de creación ' 
	|| v_RSR_FECHACREACION || ' en RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'DELETE from ' || v_schema || '.RSR_REGISTRO_SQLS WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT 
	|| ''' AND RSR_FECHACREACION = ''' || v_RSR_FECHACREACION || ''' AND RSR_RESULTADO IS NULL';

EXECUTE IMMEDIATE 'INSERT INTO ' || v_schema || '.RSR_REGISTRO_SQLS ' ||
	'(RSR_ID, RSR_NOMBRE_SCRIPT, RSR_FECHACREACION, RSR_ESQUEMA, RSR_AUTOR, RSR_ARTEFACTO, ' ||
	'RSR_VERSION_ARTEFACTO, RSR_INCIDENCIA_LINK, RSR_PRODUCTO, RSR_INICIO) ' ||
	' VALUES (' || v_schema || '.S_RSR_REGISTRO_SQLS.nextval, ''' || v_RSR_NOMBRE_SCRIPT ||
	''',''' || v_RSR_FECHACREACION || ''',''' || v_RSR_ESQUEMA_EJECUCION || ''',''' || v_RSR_AUTOR || 
	''',''' || v_RSR_ARTEFACTO || ''',''' || v_RSR_VERSION_ARTEFACTO || ''',''' || v_RSR_INCIDENCIA_LINK ||
	''',''' || v_RSR_PRODUCTO || ''', SYSDATE)';

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
