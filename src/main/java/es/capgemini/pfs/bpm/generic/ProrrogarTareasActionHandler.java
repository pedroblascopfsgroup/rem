package es.capgemini.pfs.bpm.generic;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye los timers asociados a la tarea
 *
 */
@Component(BPMContants.TRANSICION_PRORROGA)
public class ProrrogarTareasActionHandler extends BaseActionHandler implements JBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter() {
        TareaExterna tareaExterna = getTareaExterna();
        TareaNotificacion tarea = tareaExterna.getTareaPadre();

        tarea.setAlerta(false);
        tareaExternaManager.saveOrUpdate(tareaExterna);

        //Recreamos el timer
        creaTimerDeAlerta(tarea);
        logger.debug("\tRecreamos el timer de alerta [" + getNombreNodo() + "]");
    }
}
