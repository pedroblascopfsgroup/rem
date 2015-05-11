package es.pfsgroup.procedimientos.listener;

import static es.capgemini.pfs.BPMContants.TRANSICION_ACTIVAR_TAREAS;
import static es.capgemini.pfs.BPMContants.TRANSICION_PARALIZAR_TAREAS;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.procedimientos.PROBaseActionHandler;

/**
 * 
 * @author manuel
 * Listener que genera la transición 'paralizarTareas' en los nodos en los que no existe.
 * 
 */
@Component
public class GenerarTransicionParalizacionImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = 713509277683996344L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicionesParalizacion(executionContext);

	}
	
	/**
	 * Crea una transición que permite paralizar el procedimiento.
	 */
	private void generaTransicionesParalizacion(ExecutionContext executionContext) {
		if (!existeTransicion(TRANSICION_PARALIZAR_TAREAS, executionContext)) {
			nuevaTransicion(TRANSICION_PARALIZAR_TAREAS, executionContext);
		}
		if (!existeTransicion(TRANSICION_ACTIVAR_TAREAS, executionContext)) {
			nuevaTransicion(TRANSICION_ACTIVAR_TAREAS, executionContext);
		}
	}

}
