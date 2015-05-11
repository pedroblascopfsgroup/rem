package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;

/**
 * Interface que heredan los Handler que ejecutan c�digo al entrar al nodo BPM.
 */
public interface PROJBPMEnterEventHandler {

    /**
     * Se ejecuta al entrar al nodo.
     */
    void onEnter(ExecutionContext executionContext);
}
