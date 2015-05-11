
/*
* SCRIPT PARA GENERACIÓN DE DATOS BPM: Trámite de aceptacion de concurso - letrado y procurador
* BPM: P404 tramiteAceptacionConcurso
* FECHA: 20141021
* PARTES: 1/1
*/

SET DEFINE OFF;


--Se corrige el usuario que debe recibir derivaciones de la tarea 1 de este tramite (supervisor). Anteriores scripts lo designaron mal, sobre tarea 2
update tap_tarea_procedimiento set tap_supervisor = 0, dd_sta_id = 39 where tap_codigo = 'P404_RegistrarAceptacionAsunto';
update tap_tarea_procedimiento set tap_supervisor = 1, dd_sta_id = 40 where tap_codigo = 'P404_ValidarAsignacionLetrado';

commit;
