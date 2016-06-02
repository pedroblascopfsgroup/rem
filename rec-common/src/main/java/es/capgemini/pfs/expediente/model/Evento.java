package es.capgemini.pfs.expediente.model;

import java.io.Serializable;

import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

public class Evento implements Serializable {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public static final int TIPO_EVENTO_EXPEDIENTE = 1;
    public static final int TIPO_EVENTO_PERSONA = 2;
    public static final int TIPO_EVENTO_ASUNTO = 3;

    int tipoEvento = 0;
    TareaNotificacion tarea;

    /**
     * Constructor a partir de una tarea notificacion
     * @param tareaNotificacion
     */
    public Evento(TareaNotificacion tarea, int tipoEvento) {
        setTarea(tarea);
        setTipoEvento(tipoEvento);
    }

    /**
     * Constructor por defecto.
     */
    public Evento() {
    }

    /**
     * @return the tipoEvento
     */
    public int getTipoEvento() {
        return tipoEvento;
    }

    /**
     * @param tipoEvento the tipoEvento to set
     */
    public void setTipoEvento(int tipoEvento) {
        this.tipoEvento = tipoEvento;
    }

    /**
     * @return the tareaNotificacion
     */
    public TareaNotificacion getTarea() {
        return tarea;
    }

    /**
     * @param tarea the tarea to set
     */
    public void setTarea(TareaNotificacion tarea) {
        this.tarea = tarea;
    }

    /**
     * Devuelve una descripción procesada de la tarea.
     * @return String
     */
    public String getDescripcion() {
        String descripcion = null;
        switch (tipoEvento) {
	        case TIPO_EVENTO_EXPEDIENTE:
	            descripcion = getDescripcionEventoExpediente();
	            break;
        }

        if (descripcion == null) {
            return tarea.getDescripcionTarea();
        } else {
            return descripcion;
        }
    }

    private String getDescripcionEventoExpediente() {

        //Si se trata de una tarea CE, RE, DC, devolvemos la descripción larga
        if (SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_REVISAR_EXPEDIENE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_DECISION_COMITE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_TAREA_EN_SANCION.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_TAREA_SANCIONADO.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                || SubtipoTarea.CODIGO_FORMALIZAR_PROPUESTA.equals(tarea.getSubtipoTarea().getCodigoSubtarea())) {

        			return tarea.getSubtipoTarea().getDescripcionLarga();
        }

        return tarea.getDescripcionTarea();
    }

}
