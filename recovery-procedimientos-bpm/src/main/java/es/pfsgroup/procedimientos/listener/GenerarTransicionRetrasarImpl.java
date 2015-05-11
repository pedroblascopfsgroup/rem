package es.pfsgroup.procedimientos.listener;

import static es.pfsgroup.procedimientos.PROBPMContants.TRANSICION_RETRASAR_TAREAS;

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
@Component
public class GenerarTransicionRetrasarImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = 5697940702199427196L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicionRetrasar(executionContext);

	}
	
	/**
	 * Crea una transición que permite recalcular los plazos de la tarea sin avanzar el bpm.
	 */
	private void generaTransicionRetrasar(ExecutionContext executionContext) {
		if (!existeTransicion(TRANSICION_RETRASAR_TAREAS, executionContext)) {
			nuevaTransicion(TRANSICION_RETRASAR_TAREAS, executionContext);
		}
	}

}
