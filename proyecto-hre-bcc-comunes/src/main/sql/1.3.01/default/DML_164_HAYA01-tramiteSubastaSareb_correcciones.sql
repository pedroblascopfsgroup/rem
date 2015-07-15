
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
	
	
	update tap_tarea_procedimiento 
	set TAP_SCRIPT_DECISION='( valores[''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboSuspender''] == DDSiNo.NO ? ( valores[''H002_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboRequerida''] == DDSiNo.NO ? ''Fin'' : ''SolicitarDueDiligence'' ) : ''SuspenderSubasta'')'
	where tap_codigo='H002_ValidarInformeDeSubastaYPrepararCuadroDePujas';
				
	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL);         
    --EXECUTE IMMEDIATE V_MSQL;   
    
	update tap_tarea_procedimiento 
	set TAP_SCRIPT_VALIDACION_JBPM='(valores[''H002_CelebracionSubasta''][''comboCelebrada''] == DDSiNo.NO ? (valores[''H002_CelebracionSubasta''][''comboDecisionSuspension''] == null ? ''El campo Decisi&oacute;n suspensi&oacute;n Entidad/terceros es obligatorio'' : null) : (valores[''H002_CelebracionSubasta''][''comboCesionRemate''] == null ? ''El campo Cesi&oacute;n de remate es obligatorio'' : (valores[''H002_CelebracionSubasta''][''comboAdjudicadoEntidad''] == null ? ''El campo Adjudicado a Entidad con posibilidad de Cesi&oacute;n de remate es obligatorio'' : null ) ) )'
	where tap_codigo='H002_CelebracionSubasta';
        
	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;     
    
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboPostores';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;     
    
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboCesionRemate';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;    
    
	update tfi_tareas_form_items 
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboAdjudicadoEntidad';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;    

	update tfi_tareas_form_items 
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboDecisionSuspension';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;    
    
	update tfi_tareas_form_items 
	set TFI_ERROR_VALIDACION='', TFI_VALIDACION=''
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_CelebracionSubasta')
		and tfi_nombre='comboMotivoSuspension';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL); 				
    --EXECUTE IMMEDIATE V_MSQL;     
    
	update tfi_tareas_form_items
	set tfi_orden=2
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarInformeDeSubastaYPrepararCuadroDePujas')
		and tfi_nombre='comboSuspender';
    
	update tfi_tareas_form_items
	set tfi_orden=3
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarInformeDeSubastaYPrepararCuadroDePujas')
		and tfi_nombre='comboRequerida'; 		
    
	Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID FROM HAYA01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'H002_ValidarPropuesta'),'2','combo','comboModificacion','Requiere modificación propuesta instrucciones',null,null,null,'DDSiNo','0','DML',sysdate,null,null,null,null,'0');
	
	update tfi_tareas_form_items 
	set tfi_orden=1
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarPropuesta')
	  and tfi_nombre='comboSuspender';
	  
	update tfi_tareas_form_items 
	set tfi_orden=3
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarPropuesta')
	  and tfi_nombre='comboDelegada';  
	  
	update tfi_tareas_form_items 
	set tfi_orden=4
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarPropuesta')
	  and tfi_nombre='comboAtribuciones';    
	  
	update tfi_tareas_form_items 
	set tfi_orden=5
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H002_ValidarPropuesta')
	  and tfi_nombre='observaciones';		
	  
	update tap_tarea_procedimiento
	set TAP_SCRIPT_DECISION='( valores[''H002_ValidarPropuesta''][''comboSuspender''] == DDSiNo.NO ? ( valores[''H002_ValidarPropuesta''][''comboModificacion''] == DDSiNo.NO ?( valores[''H002_ValidarPropuesta''][''comboDelegada''] == DDSiNo.NO ? ''NoDelegada'' : ( valores[''H002_ValidarPropuesta''][''comboAtribuciones''] == DDSiNo.NO ? ''DelegadaSinAtribuciones'' : ''DelegadaConAtribuciones'') ) : ''PrepararPropuestaSubasta''): ''Rechazada'')'
	where tap_codigo='H002_ValidarPropuesta';	  		
	
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