package es.capgemini.pfs.cliente.process;

import es.capgemini.pfs.BPMContants;

/**
 * Interfaz con las constates usadas en el BPM de cliente.
 * @author Andrés Esteban
 *
 */
public interface ClienteBPMConstants extends BPMContants {

    String PROCESO_CLIENTE = "cliente";
    String PERSONA_ID = "idPersona";
    String CLIENTE_ID = "idCliente";

    String TIMER_INICIAR_PROCESO_CLIENTE = "iniciarProcesoCliente";
    String TRANSTION_CREA_CLIENTE = "crearCliente";

    String TIMER_CARENCIA_CLIENTE = "carenciaCliente";
    String TRANSTION_ENVIAR_GESTION_VENCIDOS = "EnviarGestionVencidos";

    String TIMER_GESTION_VENCIDO_CLIETE = "gestionVencidoCliente";
    String TRANSITION_EXPEDIMENTAR_CLIENTE = "EnviarExpedimentarCliente";
    String TRANSITION_GESTION_VENCIDOS = "EnviarGestionVencidos";
    String TRANSITION_VERIFICAR_UNMBRAL = "EnviarAVerificarUmbral";

    String TRANSITION_VERIFICAR_TELECOBRO = "EnviarAVerificarTelecobro";
    String TRANSITION_SOLICITAR_EXCLUSION_TELECOBRO = "EnviarASolicitarExcluirTelecobro";
    String TRANSITION_CON_TELECOBRO = "EnviarAConTelecobro";
    String TRANSITION_SIN_TELECOBRO = "EnviarASinTelecobro";

    String TIMER_TELECOBRO = "timerTelecobro";
    String TAREA_ASOCIADA_TELECOBRO = "idTareaTelecobro";
    String SOLICITUD_ASOCIADA_TELECOBRO_ID = "solicitud";

    String OBSERVACION = "observacion";
    String RESPUESTA = "respuesta";
    String MOTIVO_EXCLUSION_ID = "motivoExclusionId";

    String ID_TAREA_GV = "idTareaGV";

    String TIEMPO_VENCIDO_CLIENTE = "tiempoVencido";

    Long UN_SEGUNDO = 1000L;
}
