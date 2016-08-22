--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campos de TFI_TAREAS_FORM_ITEMS - DESHACER Obligatorios (script 9214)
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
  

BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando datos de TFI_TAREAS_FORM_ITEMS. DESHACIENDO SCRIPT 9214_..._TFI_OBLIGATORIOS');


    	EXECUTE IMMEDIATE ( 'update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = '''', tfi_error_validacion = '''' ' );
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T001_CheckingDocumentacionAdmision'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T001_CheckingDocumentacionGestion'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T001_CheckingInformacion'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T001_VerificarEstadoPosesorio'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T001_VerificarEstadoPosesorio'') and tfi_nombre = ''comboOcupado'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de autorizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_AutorizacionPropietario'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_ObtencionDocumentoGestoria'') and tfi_nombre = ''comboObtencion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_ObtencionDocumentoGestoria'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_ObtencionLPOGestorInterno'') and tfi_nombre = ''comboObtencion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_ObtencionLPOGestorInterno'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud del documento'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_SolicitudDocumentoGestoria'') and tfi_nombre = ''fechaSolicitud'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud extraordinaria'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_SolicitudExtraordinaria'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud del documento'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_SolicitudLPOGestorInterno'') and tfi_nombre = ''fechaSolicitud'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de validaci&oacute;n del documento'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T002_ValidacionActuacion'') and tfi_nombre = ''fechaValidacion'' '); 
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de autorizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_AutorizacionPropietario'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de cierre econ&oacute;mico'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_CierreEconomico'') and tfi_nombre = ''fechaCierre'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de emisi&oacute;n del documento'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_EmisionCertificado'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de inscripci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_ObtencionEtiqueta'') and tfi_nombre = ''fechaInscripcion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de presentaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_SolicitudEtiqueta'') and tfi_nombre = ''fechaPresentacion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud extraordinaria'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T003_SolicitudExtraordinaria'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de autorizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_AutorizacionPropietario'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de emisi&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_CierreEconomico'') and tfi_nombre = ''fechaCierre'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de emisi&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_EleccionProveedorYTarifa'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar una fecha de finalizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_ResultadoTarificada'') and tfi_nombre = ''fechaFinalizacion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud extraordinaria'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_SolicitudExtraordinaria'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de finalizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_SolicitudPresupuestoComplementario'') and tfi_nombre = ''fechaFinalizacion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar fecha de emisi&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_SolicitudPresupuestos'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de validación'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_ValidacionTrabajo'') and tfi_nombre = ''fechaValidacion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de autorizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T005_AutorizacionPropietario'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de cierre econ&oacute;mico'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T005_CierreEconomico'') and tfi_nombre = ''fechaCierre'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de emisi&oacute;n de tasaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T005_EmisionTasacion'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud extraordinaria'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T005_SolicitudExtraordinaria'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar si hay autorizaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_AutorizacionPropietario'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de cierre económico'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_CierreEconomico'') and tfi_nombre = ''fechaCierre'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de emisi&oacute;n de tasaci&oacute;n'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_EmisionInforme'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud extraordinaria'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_SolicitudExtraordinaria'') and tfi_nombre = ''fecha'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar si hay correcci&oacute;n del informe'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_ValidacionInforme'') and tfi_nombre = ''comboCorreccion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de validaci&oacute;n del informe'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T006_ValidacionInforme'') and tfi_nombre = ''fechaValidacion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de descarga'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T007_DescargaListadoMensual'') and tfi_nombre = ''fechaDescarga'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de env&iacute;o de prefacturas'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T007_EnvioListadoPrefactura'') and tfi_nombre = ''fechaEnvio'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de env&iacute;o de facturas'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T007_RemisionFacturas'') and tfi_nombre = ''fechaEnvio'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de subida de facturas'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T007_SubidaListados'') and tfi_nombre = ''fechaSubida'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de cierre econ&oacute;mico'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T008_CierreEconomico'') and tfi_nombre = ''fechaCierre'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T008_ObtencionDocumento'') and tfi_nombre = ''comboObtencion'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = '''' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T008_ObtencionDocumento'') and tfi_nombre = ''fechaEmision'' ');
		EXECUTE IMMEDIATE (' update '||V_ESQUEMA||'.tfi_tareas_form_items set tfi_validacion = ''false'', tfi_error_validacion = ''Debe indicar la fecha de solicitud del informe'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T008_SolicitudDocumento'') and tfi_nombre = ''fechaSolicitud'' ');


    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Actualizado correctamente.');
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