package es.pfsgroup.procedimientos.listener;

import static es.capgemini.pfs.BPMContants.TRANSICION_PRORROGA;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.procedimientos.PROBaseActionHandler;

/**
 * 
 * @author manuel
 * Listener que genera la transici�n 'activarProrroga' en los nodos en los que no existe.
 * 
 */
@Component
public class GenerarTransicionProrrogaImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = -6204184256333027776L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicionProrroga(executionContext);

	}
	
	/**
	 * Crea una transici�n para activar una pr�rroga.
	 */
	private void generaTransicionProrroga(ExecutionContext executionContext) {
		if (!existeTransicion(TRANSICION_PRORROGA, executionContext)) {
			nuevaTransicion(TRANSICION_PRORROGA, executionContext);
		}
	}

}
