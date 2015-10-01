package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.recovery.api.TareaExternaApi;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye los timers asociados a la tarea
 *
 */
public class PROProrrogarTareasActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
        TareaExterna tareaExterna = getTareaExterna(executionContext);
        TareaNotificacion tarea = tareaExterna.getTareaPadre();

        tarea.setAlerta(false);
        proxyFactory.proxy(TareaExternaApi.class).saveOrUpdate(tareaExterna);

        //Recreamos el timer
        creaTimerDeAlerta(tarea, executionContext);
        logger.debug("\tRecreamos el timer de alerta [" + getNombreNodo(executionContext) + "]");
    }
}
