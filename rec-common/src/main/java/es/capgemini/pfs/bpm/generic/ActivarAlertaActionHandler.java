package es.capgemini.pfs.bpm.generic;

import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

/**
 * Método que genera una alerta en la tarea. Simplemente la marca como alertada y borra su timer de alerta
 *
 */
@Component(BPMContants.TRANSICION_ALERTA_TIMER)
public class ActivarAlertaActionHandler extends BaseActionHandler implements JBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter() {
        TareaExterna tareaExterna = getTareaExterna();
        tareaExternaManager.activarAlerta(tareaExterna);

        logger.debug("\tEjecutamos el timer y caducamos la tarea: " + getNombreNodo());

        String nombreTimer = "timer" + getNombreNodo();
        BPMUtils.deleteTimer(getExecutionContext(), nombreTimer);
    }

}
