package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;

/**
 * Interface que heredan los Handler que ejecutan código al entrar al nodo BPM.
 */
public interface PROJBPMEnterEventHandler {

    /**
     * Se ejecuta al entrar al nodo.
     */
    void onEnter(ExecutionContext executionContext);
}
