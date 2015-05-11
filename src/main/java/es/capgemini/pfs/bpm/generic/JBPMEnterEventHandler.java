package es.capgemini.pfs.bpm.generic;

/**
 * Interface que heredan los Handler que ejecutan c�digo al entrar al nodo BPM.
 */
public interface JBPMEnterEventHandler {

    /**
     * Se ejecuta al entrar al nodo.
     */
    void onEnter();
}
