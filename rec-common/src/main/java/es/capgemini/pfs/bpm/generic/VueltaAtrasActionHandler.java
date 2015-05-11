package es.capgemini.pfs.bpm.generic;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.model.Prorroga;

/**
 * Cancela la tarea actual volviendo a la anterior
 *
 */
@Component(BPMContants.TRANSICION_VUELTA_ATRAS)
public class VueltaAtrasActionHandler extends BaseActionHandler implements JBPMEnterEventHandler, JBPMLeaveEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter() {
    }

    /**
     * Override del método onLeave. Se ejecuta al salir del nodo
     */
    @Override
    public void onLeave() {
        //Desactivamos las fechas de activación de tareas
        getExecutionContext().getContextInstance().deleteVariable(BPMContants.FECHA_ACTIVACION_TAREAS);

        //Marcamos como cancelada la tarea externa
        TareaExterna tareaExterna = getTareaExterna();
        if (tareaExterna != null) {
            tareaExterna.setCancelada(true);
            tareaExterna.setDetenida(false);
            tareaExternaManager.borrar(tareaExterna);

            //Buscamos si tiene prorroga activa
            Prorroga prorroga = getTareaExterna().getTareaPadre().getProrrogaAsociada();

            //Borramos (finalizamos) la prorroga si es que tiene
            if (prorroga != null) {
                tareaNotificacionManager.borrarNotificacionTarea(prorroga.getTarea().getId());
            }
        }
    }
}
