package es.capgemini.pfs;

/**
 *  Interfaz con las constates usadas en los BPM.
 * @author Andrés Esteban
 *
 */
public interface BPMContants {

    int MILLISECONDS = 1000;
    int SECONDS_IN_A_DAY = 24 * 60 * 60;
    String FECHA_EXTRACCION = "fechaExtraccion";
    String ARQUETIPO_ID = "idArquetipo";
    String IDBPMCLIENTE = "IDBPMCLIENTE";
    String TOKEN_JBPM_PADRE = "tokenJbpmPadre";

    String PROCEDIMIENTO_TAREA_EXTERNA = "procedimientoTareaExterna";
    String TRANSICION_ALERTA_TIMER = "activarAlerta";

    String TRANSICION_FIN = "Fin";
    String TRANSICION_PARALIZAR_TAREAS = "paralizarTareas";
    String TRANSICION_APLAZAR_TAREAS = "aplazarTareas";
    String FECHA_APLAZAMIENTO_TAREAS = "fechaAplazamientoTareas";
    String FECHA_ACTIVACION_TAREAS = "fechaActivacionTareas";
    String TRANSICION_ACTIVAR_TAREAS = "activarTareas";

    String BPM_DETENIDO = "bpmParalizado";
    String BPM_VUELTA_ATRAS = "estadoVueltaAtras";
    String BPM_LISTADO_TAREAS_VUELTA_ATRAS = "tareasVueltaAtras";

    String TRANSICION_AVANZA_BPM = "avanzaBPM";
    String TRANSICION_VUELTA_ATRAS = "vueltaAtras";
    String TRANSICION_PRORROGA = "activarProrroga";

    String FUNCIONES_GLOBALES_SCRIPT = "globalFunctions";
}
