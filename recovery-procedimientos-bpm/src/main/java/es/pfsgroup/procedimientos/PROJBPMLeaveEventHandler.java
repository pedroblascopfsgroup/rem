package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;

/**
 * Interface que heredan los Handler que ejecutan código al salir del nodo BPM.
 */
public interface PROJBPMLeaveEventHandler {
    /**
     * Se ejecuta al salir del nodo.
     */
    void onLeave(ExecutionContext executionContext);
}