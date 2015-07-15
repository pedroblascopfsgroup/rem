
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
    V_MSQL := 'Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,'
    			|| 'TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,'
    			|| 'FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) '
    			|| ' values (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,'
    			|| ' (SELECT TAP_ID FROM HAYA01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H002_SenyalamientoSubasta''),'
    			|| ' ''7'',''currency'',''principal'',''Principal'',null,null,'
    			|| ' ''procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()*5/100'',null,'
    			|| ' ''0'',''DML'',sysdate,null,null,null,null,''0'')';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL);    			
	EXECUTE IMMEDIATE V_MSQL;
	
	update tap_tarea_procedimiento
	set tap_script_validacion_jbpm='((valores[''H002_SenyalamientoSubasta''][''principal'']).toDouble() >= ((valores[''H002_SenyalamientoSubasta''][''costasLetrado'']).toDouble())) ? ''null'' :  ''<p>&iexcl;Atenci&oacute;n! Las costas del letrado no pueden superar el 5% del principal.</p>'' '	
	where tap_codigo='H002_SenyalamientoSubasta';
	
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboPostores';	
	
	*/
  		
	update tfi_tareas_form_items
	set TFI_LABEL='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En caso de que la entidad haya dado instrucciones espec&iacute;ficas para la cesi&oacute;n de remate, &eacute;stas aparecer&aacute;n precargadas  en el campo instrucciones. De manera inmediata a la celebraci&oacute;n de la subasta, deber&aacute;n realizarse las gestiones necesarias con el Juzgado para que se abra el plazo de cesi&oacute;n de remate. En el caso de no realizarse las mismas, deber&aacute; comunicar a su gestor el motivo por el que no se considera necesario.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de haber realizado las gestiones necesarias para la cesi&oacute;n de remate se lanzar&aacute; la tarea "Registrar comparecencia", en caso contrario se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_AperturaPlazo')
		and tfi_nombre='titulo';
		
	update tfi_tareas_form_items
	set TFI_LABEL='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla, deber&aacute; informar la fecha que ha señalado el juzgado para la realizaci&oacute;n de la comparecencia en la que se formalizar&aacute; la cesi&oacute;n de remate.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Registrar realizaci&oacute;n cesi&oacute;n de remate".</p></div>'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_ResenyarFechaComparecencia')
		and tfi_nombre='titulo';		
		
	update tfi_tareas_form_items
	set TFI_LABEL='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">En esta pantalla, se deber&aacute; poner la fecha en la que se formaliza la comparecencia para la cesi&oacute;n del remate. En el caso de no celebraci&oacute;n de la comparecencia, se habr&aacute; de solicitar auto pr&oacute;rroga.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Si el bien es garant&iacute;a de una operaci&oacute;n titulizada, se lanzar&aacute; el Tr&aacute;mite de adjudicaci&oacute;n y en caso contrario, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_RealizacionCesionRemate')
		and tfi_nombre='titulo';	
		
		
		
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valoresBPMPadre[''H002_SenyalamientoSubasta''][''fechaSenyalamiento'']+5*24*60*60*1000L'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_AperturaPlazo');
		
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valores[''H006_AperturaPlazo''][''fecha'']+5*24*60*60*1000L'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_ResenyarFechaComparecencia');
		
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valores[''H006_ResenyarFechaComparecencia''][''fecha'']+5*24*60*60*1000L'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_RealizacionCesionRemate');	
	
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='7*24*60*60*1000L'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H006_ConfirmarContabilidad');	
		
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