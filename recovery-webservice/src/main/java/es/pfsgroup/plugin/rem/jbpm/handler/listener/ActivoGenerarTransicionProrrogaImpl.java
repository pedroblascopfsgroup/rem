package es.pfsgroup.plugin.rem.jbpm.handler.listener;

import static es.capgemini.pfs.BPMContants.TRANSICION_PRORROGA;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.genericlistener.GenerarTransicionListener;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoBaseActionHandler;
/**
 * 
 * @author manuel
 * Listener que genera la transición 'activarProrroga' en los nodos en los que no existe.
 * 
 */
@Component
public class ActivoGenerarTransicionProrrogaImpl extends ActivoBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = -6204184256333027776L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicionProrroga(executionContext);

	}
	
	/**
	 * Crea una transición para activar una prórroga.
	 */
	private void generaTransicionProrroga(ExecutionContext executionContext) {
		if (!existeTransicion(TRANSICION_PRORROGA, executionContext)) {
			nuevaTransicion(TRANSICION_PRORROGA, executionContext);
		}
//		if (!existeTransicion(TRANSICION_PRORROGA)) {
//			nuevaTransicion(TRANSICION_PRORROGA);
//		}
	}

}
