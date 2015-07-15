/*
--######################################################################
--## Author: Roberto
--## Tarea: http://link.pfsgroup.es/jira/browse/HR-351
--## Finalidad: Modificación del BPM
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
BEGIN	
	
    V_MSQL := ' update dd_tpo_tipo_procedimiento set borrado=1 where borrado=0 and dd_tpo_descripcion like ''PARA ELIMINAR%'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;  
    
    V_MSQL := ' update tap_tarea_procedimiento set DD_TPO_ID_BPM=null where dd_tpo_id_bpm in (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_tipo_procedimiento.borrado=1) ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     
    
    V_MSQL := ' update tap_tarea_procedimiento set dd_tpo_id_bpm=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_tipo_procedimiento.dd_tpo_codigo=''H016'') where tap_codigo=''P420_BPMCambiario'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     
    
    V_MSQL := ' update tap_tarea_procedimiento set dd_tpo_id_bpm=(select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_tipo_procedimiento.dd_tpo_codigo=''H026'') where tap_codigo=''P420_BPMVerbal'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    		
	
    V_MSQL := ' delete from ret_requisito_tarea where TFI_REQ in ( '
    		||' select tfi_id '
    		||' from tfi_tareas_form_items where tap_id in ( '
    		||' select t.tap_id '
    		||' from tap_tarea_procedimiento t '
    		||' inner join dd_tpo_tipo_procedimiento tp on tp.dd_tpo_id=t.dd_tpo_id '
    		||' where tp.borrado=1 or t.borrado=1 '
    		||' ) '
    		||' )';
    		
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     		


    V_MSQL := ' delete from tfi_tareas_form_items where tap_id in ( '
    		||' select t.tap_id '
    		||' from tap_tarea_procedimiento t '
    		||' inner join dd_tpo_tipo_procedimiento tp on tp.dd_tpo_id=t.dd_tpo_id '
    		||' where tp.borrado=1 or t.borrado=1 '
    		||' )';
    		
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     		

    
    V_MSQL := ' delete from dd_ptp_plazos_tareas_plazas where tap_id in ( '
    		||' select t.tap_id '
    		||' from tap_tarea_procedimiento t '
    		||' inner join dd_tpo_tipo_procedimiento tp on tp.dd_tpo_id=t.dd_tpo_id '
    		||' where tp.borrado=1 or t.borrado=1 '
    		||' )';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    

    V_MSQL := ' delete from tap_tarea_procedimiento where dd_tpo_id in ( '
    		||' select dd_tpo_id '
    		||' from dd_tpo_tipo_procedimiento tp '
    		||' where tp.borrado=1 '
    		||' ) ';

    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;


    V_MSQL := ' delete from dd_tpo_tipo_procedimiento where borrado=1 '; 

	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
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