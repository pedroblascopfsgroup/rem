/*
--######################################################################
--## Author: Nacho
--## BPM: T. Subasta Terceros (H004) - modificación del BPM
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
	
	 --HR-367
	 V_MSQL := 'Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,'
    			|| 'TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,'
    			|| 'FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) '
    			|| ' values (S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,'
    			|| ' (SELECT TAP_ID FROM HAYA01.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H004_ValidarInformeDeSubastaYPrepararCuadroDePujas''),'
    			|| ' ''5'',''combo'',''comboNotaSimple'',''Nota Simple Actualizada'',null,null,'
    			|| ' null,''DDSiNo'','
    			|| ' ''0'',''DML'',sysdate,null,null,null,null,''0'')';

	--DBMS_OUTPUT.PUT_LINE('Operación: '|| V_MSQL);    			
	EXECUTE IMMEDIATE V_MSQL;	
	
		
	update tfi_tareas_form_items
	set TFI_ORDEN=6
	where tap_id=(select tap_id from tap_tarea_procedimiento where tap_codigo='H004_ValidarInformeDeSubastaYPrepararCuadroDePujas')
		and tfi_nombre='observaciones';		
	
	update tap_tarea_procedimiento
	set tap_script_validacion_jbpm='(valores[''H004_ValidarInformeDeSubastaYPrepararCuadroDePujas''][''comboNotaSimple''] == DDSiNo.SI ? (comprobarExisteDocumentoNOSI() ? null : ''Es necesario adjuntar el documento Nota Simple'' ) : null)'	
	where tap_codigo='H004_ValidarInformeDeSubastaYPrepararCuadroDePujas';	
	
	--HR-367
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_DECISION = ''( (valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''ACEPTADA'''' || valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''ACCONCAM'''' ) ? ''''Aceptada'''' : ( valores[''''H004_ElevarPropuestaAComite''''][''''comboResultadoComite''''] == ''''MODIFICAR'''' ? ''''Modificar'''' : ''''Rechazada'''' ) )'' '
				|| ' WHERE TAP_CODIGO = ''H004_ElevarPropuestaAComite'' ';
 
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --HR-488 por similitud con concursal
    V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION_JBPM = ''(valores[''''H004_CelebracionSubasta''''][''''comboCelebrada''''] == DDSiNo.NO ? ((valores[''''H004_CelebracionSubasta''''][''''comboDecisionSuspension''''] == null || valores[''''H004_CelebracionSubasta''''][''''comboMotivoSuspension''''] == null) ? ''''Los campos Decisi&oacute;n suspensi&oacute;n Entidad/terceros y Motivo suspensi&oacute;n son obligatorios'''' : null) : (valores[''''H004_CelebracionSubasta''''][''''comboCesionRemate''''] == null ? ''''El campo Cesi&oacute;n de remate es obligatorio'''' : (valores[''''H004_CelebracionSubasta''''][''''comboAdjudicadoEntidad''''] == null ? ''''El campo Adjudicado a Entidad con posibilidad de Cesi&oacute;n de remate es obligatorio'''' : null ) ) )'' '
				|| ' WHERE TAP_CODIGO = ''H004_CelebracionSubasta'' ';
 
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