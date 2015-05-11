package es.capgemini.pfs.bpm.generic;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Handler que se ejecuta al activar las tareas después de una paralización.
 */
@Component(BPMContants.TRANSICION_ACTIVAR_TAREAS)
public class ActivarTareaActionHandler extends BaseActionHandler implements JBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    public void onEnter() {
        //Seteamos el tiempo de aplazamiento
        setVariable(BPMContants.FECHA_APLAZAMIENTO_TAREAS, null);

        TareaExterna tareaExterna = getTareaExterna();

        if (tareaExterna.getDetenida()) {
            TareaNotificacion tarea = tareaExterna.getTareaPadre();

            iniciaFechasTarea(tarea);

            tareaExternaManager.activar(tareaExterna);

            if (existeTransicionDeAlerta()) {
                creaTimerDeAlerta(tarea);
            }
        }

        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 0L);
    }

}
