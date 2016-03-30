package es.capgemini.pfs.expediente.process;

import es.capgemini.pfs.BPMContants;

/**
 * Interfaz con las constates usadas en el BPM de expediente.
 * @author Andr�s Esteban
 *
 */
public interface ExpedienteBPMConstants extends BPMContants {

    String EXPEDIENTE_PROCESO = "expediente";
    String EXPEDIENTE_DEUDA_PROCESO = "expedienteDeuda";
    String EXPEDIENTE_MANUAL_ID = "idExpedienteManual";
    String CONTRATO_ID = "idContrato";
    String EXPEDIENTE_ID = "idExpediente";
    String WHERE_TO_GO = "whereToGo";
    String GENERAALERTA = "generaAlerta";
    String STATE_COMPLETAR_EXPEDIENTE = "CompletarExpediente";
    String STATE_REVISION_EXPEDIENTE = "RevisionExpediente";
    String STATE_DECISION_COMITE = "DecisionComite";
    String STATE_FORMALIZAR_PROPUESTA = "FormalizarPropuesta";
    String STATE_EN_SANCION = "EnSancion";
    String STATE_SANCIONADO = "Sancionado";
    String TRANSITION_APROBADOCONCONDICIONES = "AprobadoConCondiciones";
    String TRANSITION_ENVIARAREVISION = "EnviarARevision";
    String TRANSITION_ENVIARAFORMALIZARPROPUESTA = "EnviarAFormalizar";
    String TRANSITION_ENVIARADECISIONCOMITE = "EnviarAComite";
    String TRANSITION_DEVOLVERACOMPLETAR = "DevolverACompletar";
    String TRANSITION_DEVOLVERAREVISION = "DevolverRevision";
    String TRANSITION_DEVOLVERADECISION = "DevolverADecision";
    String TRANSITION_TOMARDECISION = "TomarDecision";
    String TRANSITION_PRORROGA_EXTRA = "EnviarSolicitarProrrogaExtra";
    String TRANSITION_ENVIARAENSANCION = "EnviarAEnSancion";
    String TRANSITION_DEVOLVER_EN_SANCION = "DevolverAEnSancion";
    String TRANSITION_DEVOLVER_SANCIONADO = "DevolverASancionado";
    String TRANSITION_DEVOLVER_COMPLETAR_EXPEDIENTE = "DevolverCompletarExpediente";
    String TRANSITION_ELEVAR_SANCIONADO = "EnviarASancionado";
    String DECISION_COMITE_AUTO = "DecisionComiteAutomatica";
    String SANCIONADO_AUTO = "SancionadoAutomatico";
    String GENERAR_NOTIFICACION = "GenerarNotificacion";
    String SOLICITAR_PRORROGA_EXTRA = "SolicitarProrrogaExtra";
    String COMPLETAR_EXPEDIENTE = "CompletarExpediente";
    String REVISION_EXPEDIENTE = "RevisionExpediente";
    String DECISION_COMITE = "DecisionComite";
    String EN_SANCION = "EnSancion";
    String SANCIONADO = "Sancionado";
    String TAREA_ASOCIADA_CE = "idTareaCE";
    String TAREA_ASOCIADA_RE = "idTareaRE";
    String TAREA_ASOCIADA_DC = "idTareaDC";
    String TAREA_ASOCIADA_ENSAN = "idTareaEnSan";
    String TAREA_ASOCIADA_SANC = "idTareaSanc";
    String TAREA_ASOCIADA_FP = "idTareaFP";
    String TIMER_TAREA_CE = "TIMER_CE";
    String TIMER_TAREA_RE = "TIMER_RE";
    String TIMER_TAREA_DC = "TIMER_DC";
    String TIMER_TAREA_FP = "TIMER_FP";
    String TIMER_TAREA_ENSAN = "TIMER_ENSAN";
    String TIMER_TAREA_SANC = "TIMER_SANC";
    String NEW_TIMER_TIME = "prorrogaEnSegundos";
    String FECHA_PROPUESTA = "fechaPropuesta";
    String RESPUESTA_DEVOLVER_CE = "respuestaDevolverCE";
    String RESPUESTA_DEVOLVER_RE = "respuestaDevolverRE";
    String AVANCE_AUTOMATICO = "AvanceAutomatico";
    String DEVOLVER_COMPLETAR = "DevolverCompletar";
    String DEVOLVER_REVISION = "DevolverRevision";
    String DEVOLVER_ENSANCION = "DevolverAEnSancion";
    String DEVOLVER_SANCIONADO = "DevolverASancionado";
    String FORMALIZAR_PROPUESTA = "FormalizarPropuesta";
    String APROBADO_CON_CONDICIONES = "AprobadoConCondiciones";
}
