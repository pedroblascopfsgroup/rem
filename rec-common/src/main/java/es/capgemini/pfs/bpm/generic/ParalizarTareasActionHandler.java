package es.capgemini.pfs.bpm.generic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye los timers asociados a la tarea
 *
 */
@Component(BPMContants.TRANSICION_PARALIZAR_TAREAS)
public class ParalizarTareasActionHandler extends BaseActionHandler implements JBPMEnterEventHandler {

    @Autowired
    private ProcessManager processManager;

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter() {
        TareaExterna tareaExterna = getTareaExterna();
        tareaExternaManager.detener(tareaExterna);

        //Borramos los posibles timers que pudiera tener
        if (processManager.getTimer(getExecutionContext().getProcessInstance(), "timer" + getNombreNodo()) != null)
            BPMUtils.deleteTimer(getExecutionContext(), "timer" + getNombreNodo());

        logger.debug("\tParalizamos la tarea y desactivamos su timer [" + getNombreNodo() + "]");

        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 1L);
    }
}
