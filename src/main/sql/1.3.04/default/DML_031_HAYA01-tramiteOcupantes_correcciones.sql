
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
    
	--Tarea 3
	update tfi_tareas_form_items
	set TFI_VALOR_INICIAL='(valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] != null ? valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaVista''] : null)'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
		and tfi_nombre='fechaVista';

	update tfi_tareas_form_items
	set TFI_VALOR_INICIAL='(valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] != null ? valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] : null)'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
		and tfi_nombre='fechaFinAle';	
		
	--Tarea 4
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
			|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
			|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H048_RegistrarRecepcionDoc''),'
			|| ' 2,'
			|| ' ''combo'','
			|| ' ''comboOcupado'','
			|| ' ''Bien ocupado'','
			|| ' ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'','
			|| ' ''valor != null && valor != '''' ? true : false'','
			|| ' null,'
			|| ' ''DDSiNo'','
			|| ' 0,'
			|| ' ''DML'','
			|| ' sysdate,'
			|| ' 0'
			|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
			|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
			|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H048_RegistrarRecepcionDoc''),'
			|| ' 3,'
			|| ' ''combo'','
			|| ' ''comboDocumentacion'','
			|| ' ''Documentación'','
			|| ' ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'','
			|| ' ''valor != null && valor != '''' ? true : false'','
			|| ' null,'
			|| ' ''DDSiNo'','
			|| ' 0,'
			|| ' ''DML'','
			|| ' sysdate,'
			|| ' 0'
			|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;   
    
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
			|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
			|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H048_RegistrarRecepcionDoc''),'
			|| ' 4,'
			|| ' ''combo'','
			|| ' ''comboInquilino'','
			|| ' ''Existe algún inquilino'','
			|| ' ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'','
			|| ' ''valor != null && valor != '''' ? true : false'','
			|| ' null,'
			|| ' ''DDSiNo'','
			|| ' 0,'
			|| ' ''DML'','
			|| ' sysdate,'
			|| ' 0'
			|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
			|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
			|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H048_RegistrarRecepcionDoc''),'
			|| ' 5,'
			|| ' ''date'','
			|| ' ''fechaContrato'','
			|| ' ''Fecha contrato arrendamiento'','
			|| ' null,'
			|| ' null,'
			|| ' null,'
			|| ' ''DDSiNo'','
			|| ' 0,'
			|| ' ''DML'','
			|| ' sysdate,'
			|| ' 0'
			|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;    
    
	V_MSQL := 'INSERT INTO TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) values ( '
			|| ' S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,' 
			|| ' (select tap_id from tap_tarea_procedimiento where tap_codigo=''H048_RegistrarRecepcionDoc''),'
			|| ' 6,'
			|| ' ''text'','
			|| ' ''nombreArrendatario'','
			|| ' ''Nombre arrendatario'','
			|| ' null,'
			|| ' null,'
			|| ' null,'
			|| ' ''DDSiNo'','
			|| ' 0,'
			|| ' ''DML'','
			|| ' sysdate,'
			|| ' 0'
			|| ' )';	
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     
	
    update tfi_tareas_form_items
	set tfi_orden=7
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
	  and tfi_nombre='fechaVista';
    
    update tfi_tareas_form_items
	set tfi_orden=8
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
	  and tfi_nombre='fechaFinAle';    
    
    update tfi_tareas_form_items
	set tfi_orden=9
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
	  and tfi_nombre='observaciones';    

	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='(valores[''H048_TrasladoDocuDeteccionOcupantes''][''comboDocumentacion''] == DDSiNo.SI ? 1*24*60*60*1000L : damePlazo(valores[''H048_RegistrarRecepcionDoc''][''fecha'']) )'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarInformeSituacion');
	  	              
	
	update tfi_tareas_form_items
	set tfi_label='<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deber&aacute; adjuntar al procedimiento el informe de situaci&oacute;n de los ocupantes seg&uacute;n el formato establecido por la entidad. Una vez adjuntado el informe deber&aacute; informar el resultado de dicho informe, ya sea positivo o no para los intereses de la entidad y la fecha en que haya dado por finalizada la preparación del informe.  As&iacute; mismo deber&aacute; enviar una notificaci&oacute;n a Sareb de aquellos inmuebles que se encuentren alquilados, u ocupados por personas f&iacute;sicas en situaci&oacute;n de exclusi&oacute;n u otra situaci&oacute;n que resulte socialmente sensible, realizando propuesta de actuaci&oacute;n.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene &eacute;sta pantalla se lanzar&aacute; la tarea "Revisar informe de letrado".</p></div>'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarInformeSituacion')
	  and tfi_nombre='titulo';
	  	  
	  
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', TFI_VALIDACION='valor != null && valor != '''' ? true : false'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RegistrarRecepcionDoc')
		and tfi_nombre='fecha';		
		
	--Tarea 5			
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valores[''H048_RegistrarInformeSituacion''][''fecha''] + 5*24*60*60*1000L'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RevisarInformeLetrado');	
	
	update tfi_tareas_form_items
	set TFI_ERROR_VALIDACION='tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', TFI_VALIDACION='valor != null && valor != '''' ? true : false'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_RevisarInformeLetrado')
		and tfi_nombre='fecha';
	
	--Tarea 6
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] != null ? valores[''H048_TrasladoDocuDeteccionOcupantes''][''fechaFinAle''] : valores[''H048_RegistrarRecepcionDoc''][''fechaFinAle'']'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_PresentarEscritoAlegaciones');
	
	/*
	Tarea 7 - Confirmar vista:
                * El plazo debe ser 1 día desde fecha fin de presentación de alegaciones si la hubiera, en caso contrario 1 día desde 
                * fecha fin de la revisión del informe del letrado.
                 * Si no hay vista no debe permitir guardar la fecha de la vista (PRC_ID = 100172438)
                 * En caso de vista debe obligar a introducir la fecha de la vista (PRC_ID =  100172446)
    */
	update dd_ptp_plazos_tareas_plazas
	set dd_ptp_plazo_script='valores[''H048_PresentarEscritoAlegaciones''] != null ? valores[''H048_PresentarEscritoAlegaciones''][''fechaPresentacion''] : valores[''H048_RevisarInformeLetrado''][''fecha'']'
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H048_ConfirmarVista');

	update tap_tarea_procedimiento 
	set tap_view='plugin/procedimientos-bpmHaya/tramiteOcupantes/confirmarVista' 
	where tap_codigo='H048_ConfirmarVista';
	
	
	/*
	Tarea 8 - Registrar celebración vista:
               * El plazo debe ser: 1 día a partir de fecha celebración de la vista
               * Mensaje de error y no guarda el resultado de la tarea. No se puede avanzar. Ver adjunto (PRC_ID = 100172446)
    */
	--H048_RegistrarCelebracionVista

	/*
	Tarea 9 - Registrar resolución:
                * Error que no permite continuar. Ver adjunto (PRC_ID = 100172438)
               * Debe obligar a meter la fecha de resolución (PRC_ID = 100172453)
	*/
	--H048_RegistrarResolucion

	/*	
	Tarea 10 - Resolución firme:
                * Excepción no controlada que no permite continuar. Ver adjunto (PRC_ID = 100172443)
                * La fecha debe ser obligatoria (PRC_ID = 100172453)
	*/
	--H048_ResolucionFirme
	
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