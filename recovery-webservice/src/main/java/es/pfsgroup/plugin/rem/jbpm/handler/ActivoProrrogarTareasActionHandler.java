package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye los timers asociados a la tarea
 *
 */
public class ActivoProrrogarTareasActionHandler extends ActivoBaseActionHandler implements ActivoJBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    @Autowired
    ActivoTareaExternaApi activoTareaExternaApi;
    
    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
        TareaExterna tareaExterna = getTareaExterna(executionContext);
        TareaNotificacion tarea = tareaExterna.getTareaPadre();

        tarea.setAlerta(false);
        activoTareaExternaApi.saveOrUpdate(tareaExterna);

        //Recreamos el timer
        creaTimerDeAlerta(tarea, executionContext);
        logger.debug("\tRecreamos el timer de alerta [" + getNombreNodo(executionContext) + "]");
    }
}