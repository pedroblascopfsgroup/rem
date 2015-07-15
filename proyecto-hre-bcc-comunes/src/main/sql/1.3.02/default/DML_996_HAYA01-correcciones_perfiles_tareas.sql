/*
--######################################################################
--## Author: Roberto
--## Finalidad: Corregir perfiles de tareas
--## INSTRUCCIONES: Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    /*
    * CONFIGURACION: ESQUEMAS
    *---------------------------------------------------------------------
    */
    PAR_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01';               -- [PARAMETRO] Configuracion Esquemas
    PAR_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';    -- [PARAMETRO] Configuracion Esquemas

    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar     

    ERR_NUM NUMBER(25);                                 -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);                        -- Vble. auxiliar para registrar errores en el script.

    
BEGIN	

    /*
    *---------------------------------------------------------------------------------------------------------
    *                                COMIENZO - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */
    DBMS_OUTPUT.PUT_LINE('[INICIO-SCRIPT]------------------------------------------------------- ');
    
    --Actualizo los gestores de tareas tipo "GESTOR" a "LETRADO"  
    V_MSQL := 'update tap_tarea_procedimiento '
    			|| ' set DD_STA_ID=(select dd_sta_id from hayamaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo=''814'') '
    			|| ' where ( tap_codigo like ''H%'' or tap_codigo like ''P400%'' or tap_codigo like ''P404%'' or tap_codigo like ''P420%'') '
    			|| '      and DD_STA_ID=(select dd_sta_id from hayamaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo=''39'')';
    			
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando las tareas con Gestor tipo GESTOR a LETRADO.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya actualizadas las tareas con Gestor tipo GESTOR a LETRADO.');
    
    --Actualizo los gestores de tareas tipo "SUPERVISOR" a "SUPER_UCL" 
    V_MSQL := 'update tap_tarea_procedimiento '
    			|| ' set DD_STA_ID=(select dd_sta_id from hayamaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo=''815'') '
    			|| ' where ( tap_codigo like ''H%'' or tap_codigo like ''P400%'' or tap_codigo like ''P404%'' or tap_codigo like ''P420%'') '
    			|| '      and DD_STA_ID=(select dd_sta_id from hayamaster.DD_STA_SUBTIPO_TAREA_BASE where dd_sta_codigo=''40'')';    
    			
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando las tareas con Gestor tipo SUPERVISOR a SUPER_UCL.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya actualizadas las tareas con Gestor tipo SUPERVISOR a SUPER_UCL.');
    
	--Actualizo los supervisores de tareas tipo "GESTOR" a "LETRADO"   
    V_MSQL := 'update tap_tarea_procedimiento '
    			|| ' set DD_TSUP_ID=(select dd_tge_id from hayamaster.dd_tge_tipo_gestor where DD_TGE_CODIGO=''LETR'') '
    			|| ' where ( tap_codigo like ''H%'' or tap_codigo like ''P400%'' or tap_codigo like ''P404%'' or tap_codigo like ''P420%'') '
  				|| '      and DD_TSUP_ID=(select dd_tge_id from hayamaster.dd_tge_tipo_gestor where DD_TGE_CODIGO=''GEXT'')'; 
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando las tareas con Supervisor tipo GESTOR a LETRADO.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya actualizadas las tareas con Supervisor tipo GESTOR a LETRADO.');	 
    
    --Actualizo los supervisores de tareas tipo "SUPERVISOR" a "SUPER_UCL"  
    V_MSQL := 'update tap_tarea_procedimiento '
    			|| ' set DD_TSUP_ID=(select dd_tge_id from hayamaster.dd_tge_tipo_gestor where DD_TGE_CODIGO=''SUCL'') '
    			|| ' where ( tap_codigo like ''H%'' or tap_codigo like ''P400%'' or tap_codigo like ''P404%'' or tap_codigo like ''P420%'') '
  				|| '      and DD_TSUP_ID=(select dd_tge_id from hayamaster.dd_tge_tipo_gestor where DD_TGE_CODIGO=''SUP'')';
  				
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando las tareas con Supervisor tipo SUPERVISOR a SUPER_UCL.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya actualizadas las tareas con Supervisor tipo SUPERVISOR a SUPER_UCL.');    

    /*
    * COMMIT ALL BLOCK-CODE
    *---------------------------------------------------------------------
    */
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[COMMIT ALL]...............................................');
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]-----------------------------------------------------------');
    /*
    *---------------------------------------------------------------------------------------------------------
    *                                FIN - BLOQUE DE CODIGO DEL SCRIPT
    *---------------------------------------------------------------------------------------------------------
    */

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