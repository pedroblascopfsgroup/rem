-- Cambiamos el tipo de componente de la tarea de Dictar instrucciones del Tr�mite de Subasta para hacerlo readOnly
update tfi_tareas_form_items set tfi_tipo = 'htmllabel' where tap_id = 210 and tfi_nombre = 'observaciones'; 
