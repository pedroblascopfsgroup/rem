package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;

/**
 * Interface que heredan los Handler que ejecutan código al entrar al nodo BPM.
 */
public interface ActivoJBPMEnterEventHandler {

    /**
     * Se ejecuta al entrar al nodo.
     */
    void onEnter(ExecutionContext executionContext);
}
