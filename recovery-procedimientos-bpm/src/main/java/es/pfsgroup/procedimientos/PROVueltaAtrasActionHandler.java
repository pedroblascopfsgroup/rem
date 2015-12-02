package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.pfsgroup.recovery.api.TareaExternaApi;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

/**
 * Cancela la tarea actual volviendo a la anterior
 *
 */
public class PROVueltaAtrasActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler, PROJBPMLeaveEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del m�todo onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
    }

    /**
     * Override del m�todo onLeave. Se ejecuta al salir del nodo
     */
    @Override
    public void onLeave(ExecutionContext executionContext) {
        //Desactivamos las fechas de activaci�n de tareas
    	executionContext.getContextInstance().deleteVariable(BPMContants.FECHA_ACTIVACION_TAREAS);

        //Marcamos como cancelada la tarea externa
        TareaExterna tareaExterna = getTareaExterna(executionContext);
        if (tareaExterna != null) {
            tareaExterna.setCancelada(true);
            tareaExterna.setDetenida(false);
            proxyFactory.proxy(TareaExternaApi.class).borrar(tareaExterna);

            //Buscamos si tiene prorroga activa
            Prorroga prorroga = getTareaExterna(executionContext).getTareaPadre().getProrrogaAsociada();

            //Borramos (finalizamos) la prorroga si es que tiene
            if (prorroga != null) {
            	proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(prorroga.getTarea().getId());
            }
            
        }
    }
}
