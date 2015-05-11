
/*
* SCRIPT CORRECCION DE GENERACIÓN DE DATOS BPM: Trámite de aceptacion de concurso (por letrado)
* BPM: P404 tramiteAceptacionConcurso
* FECHA: 20141021
* PARTES: 1/1
*/


SET DEFINE OFF;

update tap_tarea_procedimiento set tap_view = 'plugin/procedimientos/tramiteAceptacionConcurso/aceptacionConcurso', tap_script_decision = 'valores[''P404_RegistrarAceptacionAsunto''][''decisionAceptacion''] == DDSiNo.SI ? ''SI'' : ''NO''' where tap_codigo = 'P404_RegistrarAceptacionAsunto';
