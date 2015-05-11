package es.pfsgroup.procedimientos;

import java.util.Date;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;

public class PRORetrasarTareaActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3022615631064850781L;
	
	@Autowired
	ApiProxyFactory proxyFactory;

	/**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    public void onEnter(ExecutionContext executionContext) {

        setVariable(BPMContants.FECHA_ACTIVACION_TAREAS, null, executionContext);

        TareaExterna tareaExterna = getTareaExterna(executionContext);

        TareaNotificacion tarea = tareaExterna.getTareaPadre();

        this.calculaNuevaFechaTareas(tarea, executionContext);
        
        //setVariable(BPMContants.FECHA_ACTIVACION_TAREAS, tarea.getFechaInicio(), executionContext);

//        if (existeTransicionDeAlerta(executionContext)) {
//            creaTimerDeAlerta(tarea, executionContext);
//        }
//TODO: hay que hacer algo con los timers? Hay que volver a setear la fecha de activación a la antigua o a la nueva.        
    }

	private void calculaNuevaFechaTareas(TareaNotificacion tarea, ExecutionContext executionContext) {

		Date fechaInicio = new Date();

        Long idProcedimiento = tarea.getProcedimiento().getId();

        Long idTipoJuzgado = null;
        Long idTipoPlaza = null;

        try {
            idTipoJuzgado = tarea.getProcedimiento().getJuzgado().getId();
            idTipoPlaza = tarea.getProcedimiento().getJuzgado().getPlaza().getId();

        } catch (NullPointerException e) {
            ;// El procedimiento puede no tener ni plaza ni juzgado, no se hace
             // nada
        }

        Long idTipoTarea = tarea.getTareaExterna().getTareaProcedimiento().getId();

        Long plazo = getPlazoTareaPorTipoTarea(idTipoPlaza, idTipoTarea, idTipoJuzgado, idProcedimiento, null);

        Date fechaVenc = new Date(fechaInicio.getTime() + plazo);

        tarea.setFechaVenc(fechaVenc);

        tarea.setAlerta(false);
		
	}
	

}
