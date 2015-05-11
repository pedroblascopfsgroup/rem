--Coger datos de subasta
update BANK01.TFI_TAREAS_FORM_ITEMS set TFI_VALOR_INICIAL='valores[''P401_PrepararCesionRemate''] == null ? '' : (valores[''P401_PrepararCesionRemate''][''instrucciones''])' where TFI_LABEL='Instrucciones' and tap_id=(SELECT tap_id FROM BANK01.tap_tarea_procedimiento WHERE tap_codigo = 'P410_AperturaPlazo');


update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='damePlazo(valoresBPMPadre[''P401_SenyalamientoSubasta''][''fechaSenyalamiento''])+5*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P410_AperturaPlazo');


update BANK01.dd_ptp_plazos_tareas_plazas set DD_PTP_PLAZO_SCRIPT='300*24*60*60*1000L' where tap_id=(SELECT tap_id FROM BANK01.TAP_TAREA_PROCEDIMIENTO tareas WHERE tap_codigo='P410_BPMTramiteAdjudicacion');
