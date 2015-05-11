package es.pfsgroup.procedimientos.listener;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.procedimientos.PROBaseActionHandler;

/**
 * 
 * @author manuel
 * Listener que genera la transición 'retrasarTareas' en los nodos en los que no existe.
 * 
 */

public class GenerarTransicionAlertaImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = -9196714388534468397L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTrancisionesDeAlerta(executionContext);

	}

	private void generaTrancisionesDeAlerta(ExecutionContext executionContext) {
		if (existeTransicionDeAlerta(executionContext) && !existeTimerDeAlerta(executionContext)) {
			creaTimerDeAlerta(getTareaExterna(executionContext).getTareaPadre(), executionContext);
			if (logger.isDebugEnabled()) {
				logger.debug("\tCreamos timer de alerta para esta tarea");
			}
		}
	}

}
