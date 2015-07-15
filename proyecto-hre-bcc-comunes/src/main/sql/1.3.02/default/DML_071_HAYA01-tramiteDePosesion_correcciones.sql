/*
--######################################################################
--## Author: Roberto
--## Finalidad: Corregir BPM
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
    
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando documentos con códigos DJPOS y DJLPOS  .......');
    
    update ADA_ADJUNTOS_ASUNTOS     
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo='DJP')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo='DJPOS');
	
	update ADA_ADJUNTOS_ASUNTOS 
	set dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo='DJL')
	where dd_tfa_id=(select dd_tfa_id from dd_tfa_fichero_adjunto where dd_tfa_codigo='DJLPOS');
     
    V_MSQL := 'delete from dd_tfa_fichero_adjunto where dd_tfa_codigo in (''DJPOS'',''DJLPOS'')';
    			
    DBMS_OUTPUT.PUT_LINE('[INFO] Eliminando documentos con códigos DJPOS y DJLPOS  .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Documentos ya eliminados.');  
    
    V_MSQL := 'update dd_ptp_plazos_tareas_plazas '
    			|| ' set dd_ptp_plazo_script=''( (valores[''''H015_RegistrarLanzamientoEfectuado''''] != null) && (valores[''''H015_RegistrarLanzamientoEfectuado''''][''''fecha''''] != null) ? damePlazo(valores[''''H015_RegistrarLanzamientoEfectuado''''][''''fecha'''']) : damePlazo(valores[''''H015_RegistrarPosesionYLanzamiento''''][''''fecha''''])  )'' '
    			|| ' where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo=''H015_RegistrarDecisionLlaves'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando plazo de tarea H015_RegistrarDecisionLlaves  .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo ya actualizado.');     			
    			
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