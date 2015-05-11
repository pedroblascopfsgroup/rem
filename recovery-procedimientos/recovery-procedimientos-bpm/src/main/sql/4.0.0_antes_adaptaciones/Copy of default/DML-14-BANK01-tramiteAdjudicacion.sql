SET DEFINE OFF;


	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
--1. Coger datos de subasta para el trámite de Adjudicación y poner los plazos correctos

--P413_SolicitudDecretoAdjudicacion
update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 20*24*60*60*1000L:5*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P413_SolicitudDecretoAdjudicacion');


--P413_notificacionDecretoAdjudicacionAEntidad
update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='valores[''P401_RegistrarActaSubasta''] != null && valores[''P401_RegistrarActaSubasta''][''fecha''] != null ? damePlazo(valores[''P401_RegistrarActaSubasta''][''fecha'']) + 30*24*60*60*1000L:30*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P413_notificacionDecretoAdjudicacionAEntidad');




--2. Establecer llamadas correctas a otros BPMs
update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteSubsanacionEmbargo') where tap_codigo='P413_BPMTramiteSubsanacionEmbargo1';

update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteSubsanacionEmbargo') where tap_codigo='P413_BPMTramiteSubsanacionEmbargo2';

update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteSubsanacionEmbargo') where tap_codigo='P413_BPMTramiteSubsanacionEmbargo3';


update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteNotificacionV4') where tap_codigo='P413_BPMTramiteNotificacion';


update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteDePosesionV4') where tap_codigo='P413_BPMTramiteDePosesion';


update TAP_TAREA_PROCEDIMIENTO set dd_tpo_id_bpm=(select dd_tpo_id from DD_TPO_TIPO_PROCEDIMIENTO where dd_tpo_xml_jbpm like 'tramiteSaneamientoCargas') where tap_codigo='P413_BPMTramiteSaneamientoCargas';

  
  
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