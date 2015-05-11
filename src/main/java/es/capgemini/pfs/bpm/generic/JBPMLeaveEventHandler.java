package es.capgemini.pfs.bpm.generic;

/**
 * Interface que heredan los Handler que ejecutan código al salir del nodo BPM.
 */
public interface JBPMLeaveEventHandler {
    /**
     * Se ejecuta al salir del nodo.
     */
    void onLeave();
}
