
update tap_tarea_procedimiento
set tap_script_validacion_jbpm = '( ((valores[''P25_admisionOposicionYSenalamientoVista''][''admisionOp''] == DDSiNo.SI) && (valores[''P25_admisionOposicionYSenalamientoVista''][''fechaResol''] == '''')) || ((valores[''P25_admisionOposicionYSenalamientoVista''][''comboVista''] == DDSiNo.SI) && (valores[''P25_admisionOposicionYSenalamientoVista''][''fechaVista''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':null', 
tap_script_decision = 'valores[''P25_admisionOposicionYSenalamientoVista''][''comboVista''] == DDSiNo.NO || valores[''P25_admisionOposicionYSenalamientoVista''][''admisionOp''] == DDSiNo.NO  ? ''NO'' : (valores[''P25_admisionOposicionYSenalamientoVista''][''comboVista''] == DDSiNo.SI ? ''SI'': ''NO'' )',
tap_codigo = 'P25_admisionOposicionYSenalamientoVista'
where tap_codigo = 'P25_admisionOposicionYSeñalamientoVista';

update DD_PTP_PLAZOS_TAREAS_PLAZAS
set dd_ptp_plazo_script = 'damePlazo(valores[''P25_admisionOposicionYSenalamientoVista''][''fechaVista'']) + 2*24*60*60*1000L'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_registrarVista');
 
--COMMIT;




