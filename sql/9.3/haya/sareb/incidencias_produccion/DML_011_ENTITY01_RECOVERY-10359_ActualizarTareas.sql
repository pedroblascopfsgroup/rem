/*
--##########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20180112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3.02
--## INCIDENCIA_LINK=RECOVERY-10359
--## PRODUCTO=NO
--##
--## Finalidad: Corrección tareas mal migradas
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR):='TAR_TAREAS_NOTIFICACIONES'; -- Nombre de la tabla a tratar

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INI] Inicio de la actualización de tareas');

  V_MSQL:=q'[UPDATE ]'||V_ESQUEMA|| '.' || VAR_TABLENAME || q'[ 
    SET TAR_TAREA='Adjuntar informe del letrado', TAR_DESCRIPCION = 'Adjuntar informe del letrado', 
    USUARIOMODIFICAR = 'RECOVERY-10359', FECHAMODIFICAR=SYSDATE
    WHERE TAR_DESCRIPCION = 'Adjuntar informe letrado' AND BORRADO = 0 AND USUARIOCREAR = 'RECOVERY-7242-MIGSUBS-ELE' ]';
  EXECUTE IMMEDIATE V_MSQL;         
  DBMS_OUTPUT.PUT_LINE('[FIN 1] '||V_ESQUEMA||'.' || VAR_TABLENAME || ' '|| sql%rowcount ||' registros');    
     
  COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;

