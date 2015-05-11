package es.capgemini.pfs.bpm.generic;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;

/**
 * Handler que se ejecuta al salir o entrar en un nodo mediante la transición avanzaBPM.
 */
@Component(BPMContants.TRANSICION_AVANZA_BPM)
public class AvanzaBPMActionHandler extends BaseActionHandler implements JBPMEnterEventHandler, JBPMLeaveEventHandler {

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
    }

}
