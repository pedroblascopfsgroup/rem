
--######################################################################################
--## Author: Roberto
--## Finalidad: Correcciones BPM
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
    --Actualizamos datos

	/*
	update tap_tarea_procedimiento
	set tap_script_validacion_jbpm='((valores[''H002_SenyalamientoSubasta''][''principal'']).toDouble() >= ((valores[''H002_SenyalamientoSubasta''][''costasLetrado'']).toDouble())) ? ''null'' :  ''<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>'' '	
	where tap_codigo='H002_SenyalamientoSubasta'; 
    
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboPostores';
	*/

	update DD_TPO_TIPO_PROCEDIMIENTO set dd_tpo_descripcion='T. Subsanación decreto adjudicación', dd_tpo_descripcion_larga='T. Subsanación decreto adjudicación' where dd_tpo_codigo='H052';
	
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='(valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''] != null ?(valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] != null ? (valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? (damePlazo(valoresBPMPadre[''H005_ConfirmarTestimonio''][''fechaEnvioGestoria'']) + 5*24*60*60*1000L) : 10*24*60*60*1000L) : 10*24*60*60*1000L ) : (damePlazo(valores[''H052_RegistrarPresentacionEscritoSub''][''fechaPresentacion'']) + 30*24*60*60*1000L))'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H052_EntregarNuevoDecreto');	
	
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='(valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''] != null ? (valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? (valoresBPMPadre[''H005_ConfirmarTestimonio''][''fechaEnvioGestoria''] + 5*24*60*60*1000L) : 10*24*60*60*1000L ) : 10*24*60*60*1000L)'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H052_RegistrarPresentacionEscritoSub');	
    
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