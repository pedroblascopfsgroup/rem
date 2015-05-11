package es.pfsgroup.procedimientos.listener;

import static es.capgemini.pfs.BPMContants.TRANSICION_ACTIVAR_TAREAS;
import static es.capgemini.pfs.BPMContants.TRANSICION_APLAZAR_TAREAS;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.procedimientos.PROBaseActionHandler;

/**
 * 
 * @author manuel
 * Listener que genera la transición 'aplazarTareas' en los nodos en los que no existe.
 * 
 */
@Component
public class GenerarTransicionAplazamientoImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = -6615469201324859266L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicionesAplazamiento(executionContext);

	}
	
	/**
	 * Crea una transición que permite aplazar las tareas.
	 */
	/**
	 * PONER JAVADOC FO.
	 */
	private void generaTransicionesAplazamiento(ExecutionContext executionContext) {
		if (!existeTransicion(TRANSICION_APLAZAR_TAREAS, executionContext)) {
			nuevaTransicion(TRANSICION_APLAZAR_TAREAS, executionContext);
		}
		if (!existeTransicion(TRANSICION_ACTIVAR_TAREAS, executionContext)) {
			nuevaTransicion(TRANSICION_ACTIVAR_TAREAS, executionContext);
		}
	}

}
