package es.capgemini.pfs.tareaNotificacion.process;

import es.capgemini.pfs.BPMContants;

/**
 * Interfaz con las constates usadas en el BPM de tarea.
 * @author Andrés Esteban
 *
 */
public interface TareaBPMConstants extends BPMContants{

   String TAREA_PROCESO = "tareaSolicitada";

   String ESPERA = "espera";
   String PLAZO_PROPUESTA = "fechaPropuesta";
   String ID_TAREA = "idTarea";
   String ID_ENTIDAD_INFORMACION = "idEntidad";
   String CODIGO_SUBTIPO_TAREA = "subtipoTarea";
   String CODIGO_TIPO_ENTIDAD = "tipoEntidad";
   String PRORROGA_ASOCIADA = "prorroga";
   String COMUNICACION_BPM = "comunicacionBPM";
   String DESCRIPCION_TAREA = "descripcionTarea";

   String TRANSITION_ALERTA_ACTIVADA = "AlertaActivada";
   String TRANSITION_ACTIVAR_ALERTA = "ActivarAlerta";
   String TRANSITION_TAREA_RESPONDIDA= "TareaRespondida";
   String TRANSITION_TAREA_SOLICITADA= "TareaSolicitada";
   String TRANSITION_FIN = "Fin";

   String TIMER_TAREA_SOLICITADA = "timerTareaSolicitada";

   String NODE_ACTIVAR_ALERTA = "ActivarAlerta";

   int MILLISECONDS = 1000;
}
