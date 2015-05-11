package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.BPMContants;

/**
 * Handler que se ejecuta al salir o entrar en un nodo mediante la transición avanzaBPM.
 */
public class PROAvanzaBPMActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler, PROJBPMLeaveEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
    }

    /**
     * Override del método onLeave. Se ejecuta al salir del nodo
     */
    @Override
    public void onLeave(ExecutionContext executionContext) {
        //Desactivamos las fechas de activación de tareas
        executionContext.getContextInstance().deleteVariable(BPMContants.FECHA_ACTIVACION_TAREAS);
    }

}
