
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
    
	Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID FROM HAYA01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'H004_ValidarPropuesta'),'2','combo','comboModificacion','Requiere modificación propuesta instrucciones',null,null,null,'DDSiNo','0','DML',sysdate,null,null,null,null,'0');
	
	update tfi_tareas_form_items 
	set tfi_orden=1
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_ValidarPropuesta')
	  and tfi_nombre='comboSuspender';
	  
	update tfi_tareas_form_items 
	set tfi_orden=3
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_ValidarPropuesta')
	  and tfi_nombre='comboDelegada';  
	  
	update tfi_tareas_form_items 
	set tfi_orden=4
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_ValidarPropuesta')
	  and tfi_nombre='comboAtribuciones';    
	  
	update tfi_tareas_form_items 
	set tfi_orden=5
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_ValidarPropuesta')
	  and tfi_nombre='observaciones';		
	  
	update tap_tarea_procedimiento
	set TAP_SCRIPT_DECISION='( valores[''H004_ValidarPropuesta''][''comboSuspender''] == DDSiNo.NO ? ( valores[''H004_ValidarPropuesta''][''comboModificacion''] == DDSiNo.NO ? ( valores[''H004_ValidarPropuesta''][''comboDelegada''] == DDSiNo.NO ? ''NoDelegada'' : ( valores[''H004_ValidarPropuesta''][''comboAtribuciones''] == DDSiNo.NO ? ''DelegadaSinAtribuciones'' : ''DelegadaConAtribuciones'') ) : ''PrepararPropuestaSubasta'') : ''Rechazada'')'
	where tap_codigo='H004_ValidarPropuesta';	  
		
	update tap_tarea_procedimiento
	set dd_sta_id=(select dd_sta_id from HAYAMASTER.dd_sta_subtipo_tarea_base where dd_sta_codigo='815')
	where tap_codigo='H004_ValidarPropuesta';	
	
		
	
	Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, (SELECT TAP_ID FROM HAYA01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'H004_SenyalamientoSubasta'),'5','textarea','letradoYOProcurador','Indicar el letrado y/o procurador',null,null,null,null,'0','DML',sysdate,null,null,null,null,'0');
	
	update tfi_tareas_form_items 
	set tfi_orden=6
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_SenyalamientoSubasta')
	  and tfi_nombre='observaciones'; 	
	
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