
--######################################################################################
--## Author: Roberto
--## Finalidad: Correcciones de los ids de las subtareas de los nuevos tipos de gestor
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
declare
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar 
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas       
        
begin  
	DBMS_OUTPUT.PUT_LINE('Desactivamos la constraint TAP_TAREA_PROC_SUBTIPO_TAR');
	
	V_MSQL := 'alter table TAP_TAREA_PROCEDIMIENTO DISABLE constraint TAP_TAREA_PROC_SUBTIPO_TAR';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Desactivamos la constraint FK_TAR_TARE_FK_TAR_DD_DD_STA_S');

	V_MSQL := 'alter table TAR_TAREAS_NOTIFICACIONES DISABLE constraint FK_TAR_TARE_FK_TAR_DD_DD_STA_S';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    DBMS_OUTPUT.PUT_LINE('Creamos el campo temporal TMP_ANTIGUO_STA en la tabla TAP_TAREA_PROCEDIMIENTO');
	
	V_MSQL := 'alter table TAP_TAREA_PROCEDIMIENTO add TMP_ANTIGUO_STA varchar2(250)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('Creamos el campo temporal TMP_ANTIGUO_STA en la tabla TAR_TAREAS_NOTIFICACIONES');
    
	V_MSQL := 'alter table TAR_TAREAS_NOTIFICACIONES add TMP_ANTIGUO_STA varchar2(250)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Guardamos los código antiguos en el campo temporal de la tabla TAP_TAREA_PROCEDIMIENTO');

	V_MSQL := 'update TAP_TAREA_PROCEDIMIENTO t '
				||' set t.TMP_ANTIGUO_STA=(select s.dd_sta_descripcion from HAYAMASTER.dd_sta_subtipo_tarea_base s where s.dd_sta_id=t.dd_sta_id)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Guardamos los código antiguos en el campo temporal de la tabla TAR_TAREAS_NOTIFICACIONES');
				
	V_MSQL := 'update TAR_TAREAS_NOTIFICACIONES t '
				||' set t.TMP_ANTIGUO_STA=(select s.dd_sta_descripcion from HAYAMASTER.dd_sta_subtipo_tarea_base s where s.dd_sta_id=t.dd_sta_id)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    
    DBMS_OUTPUT.PUT_LINE('Actualizamos las subtareas de los tipos de gestor y le sumamos 1000');
    
	V_MSQL := 'update HAYAMASTER.dd_sta_subtipo_tarea_base '
				||' set dd_sta_id=(dd_sta_id+1000) '
				||' where dd_sta_codigo in ( '
				||' ''813'','
				||' ''812'','
				||' ''811'','
				||' ''810'','
				||' ''809'','
				||' ''808'','
				||' ''807'','
				||' ''806'','
				||' ''805'','
				||' ''804'','
				||' ''803'','
				||' ''802'','
				||' ''801'','
				||' ''800'','
				||' ''815'','
				||' ''814'','
				||' ''102'','
				||' ''103'','
				||' ''104'' '
				||' )';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;	
    
    DBMS_OUTPUT.PUT_LINE('Actualizamos las subtareas de los tipos de gestor y le ponemos el código que deberían tener.');

	V_MSQL := 'update HAYAMASTER.dd_sta_subtipo_tarea_base '
				||' set dd_sta_id=to_number(dd_sta_codigo) '
				||' where dd_sta_codigo in ( '
				||' ''813'','
				||' ''812'','
				||' ''811'','
				||' ''810'','
				||' ''809'','
				||' ''808'','
				||' ''807'','
				||' ''806'','
				||' ''805'','
				||' ''804'','
				||' ''803'','
				||' ''802'','
				||' ''801'','
				||' ''800'','
				||' ''815'','
				||' ''814'','
				||' ''102'','
				||' ''103'','
				||' ''104'' '
				||' )';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    DBMS_OUTPUT.PUT_LINE('Actualizamos los códigos de subtareas en la tabla TAP_TAREA_PROCEDIMIENTO');

	V_MSQL := 'update TAP_TAREA_PROCEDIMIENTO t '
				||' set t.dd_sta_id=(select dd_sta_id from HAYAMASTER.dd_sta_subtipo_tarea_base where dd_sta_descripcion=''t.TMP_ANTIGUO_STA'' and dd_sta_descripcion is not null)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Actualizamos los códigos de subtareas en la tabla TAR_TAREAS_NOTIFICACIONES');
				
	V_MSQL := 'update TAR_TAREAS_NOTIFICACIONES t '
				||' set t.dd_sta_id=(select dd_sta_id from HAYAMASTER.dd_sta_subtipo_tarea_base where dd_sta_descripcion=''t.TMP_ANTIGUO_STA'' and dd_sta_descripcion is not null)';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    DBMS_OUTPUT.PUT_LINE('Activamos la constraint TAP_TAREA_PROC_SUBTIPO_TAR');

	V_MSQL := 'alter table TAP_TAREA_PROCEDIMIENTO ENABLE constraint TAP_TAREA_PROC_SUBTIPO_TAR';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;	
	
    DBMS_OUTPUT.PUT_LINE('Activamos la constraint FK_TAR_TARE_FK_TAR_DD_DD_STA_S');
    
	V_MSQL := 'alter table TAR_TAREAS_NOTIFICACIONES ENABLE constraint FK_TAR_TARE_FK_TAR_DD_DD_STA_S';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;	
    
    
    DBMS_OUTPUT.PUT_LINE('Eliminamos la columna TMP_ANTIGUO_STA de la tabla TAP_TAREA_PROCEDIMIENTO');
    
    V_MSQL := 'alter table TAP_TAREA_PROCEDIMIENTO drop column TMP_ANTIGUO_STA';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
    DBMS_OUTPUT.PUT_LINE('Eliminamos la columna TMP_ANTIGUO_STA de la tabla TAR_TAREAS_NOTIFICACIONES');
    
    V_MSQL := 'alter table TAR_TAREAS_NOTIFICACIONES drop column TMP_ANTIGUO_STA';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
	
  	commit;
  
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
end;
/
EXIT;