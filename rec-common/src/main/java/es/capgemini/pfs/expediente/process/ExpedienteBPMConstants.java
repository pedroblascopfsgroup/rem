package es.capgemini.pfs.expediente.process;

import es.capgemini.pfs.BPMContants;

/**
 * Interfaz con las constates usadas en el BPM de expediente.
 * @author Andr�s Esteban
 *
 */
public interface ExpedienteBPMConstants extends BPMContants {

    String EXPEDIENTE_PROCESO = "expediente";
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
    String TRANSITION_ENVIARAREVISION = "EnviarARevision";
    String TRANSITION_ENVIARAFORMALIZARPROPUESTA = "EnviarAFormalizar";
    String TRANSITION_ENVIARADECISIONCOMITE = "EnviarAComite";
    String TRANSITION_DEVOLVERACOMPLETAR = "DevolverACompletar";
    String TRANSITION_DEVOLVERAREVISION = "DevolverRevision";
    String TRANSITION_DEVOLVERADECISION = "DevolverADecision";
    String TRANSITION_TOMARDECISION = "TomarDecision";
    String TRANSITION_PRORROGA_EXTRA = "EnviarSolicitarProrrogaExtra";
    String TRANSITION_ENVIARAENSANCION = "EnviarAEnSancion";
    String TRANSITION_DEVOLVER_ES_SANCION = "DevolverAEnSancion";
    String TRANSITION_DEVOLVER_SANCIONADO = "DevolverASancionado";
    String DECISION_COMITE_AUTO = "DecisionComiteAutomatica";
    String GENERAR_NOTIFICACION = "GenerarNotificacion";
    String SOLICITAR_PRORROGA_EXTRA = "SolicitarProrrogaExtra";
    String COMPLETAR_EXPEDIENTE = "CompletarExpediente";
    String REVISION_EXPEDIENTE = "RevisionExpediente";
    String DECISION_COMITE = "DecisionComite";
    String TAREA_ASOCIADA_CE = "idTareaCE";
    String TAREA_ASOCIADA_RE = "idTareaRE";
    String TAREA_ASOCIADA_DC = "idTareaDC";
    String TAREA_ASOCIADA_FP = "idTareaFP";
    String TIMER_TAREA_CE = "TIMER_CE";
    String TIMER_TAREA_RE = "TIMER_RE";
    String TIMER_TAREA_DC = "TIMER_DC";
    String TIMER_TAREA_FP = "TIMER_FP";
    String NEW_TIMER_TIME = "prorrogaEnSegundos";
    String FECHA_PROPUESTA = "fechaPropuesta";
    String RESPUESTA_DEVOLVER_CE = "respuestaDevolverCE";
    String RESPUESTA_DEVOLVER_RE = "respuestaDevolverRE";
    String AVANCE_AUTOMATICO = "AvanceAutomatico";
    String DEVOLVER_COMPLETAR = "DevolverCompletar";
    String DEVOLVER_REVISION = "DevolverRevision";
    String FORMALIZAR_PROPUESTA = "FormalizarPropuesta";
}
