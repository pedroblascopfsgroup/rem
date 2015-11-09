package es.pfsgroup.procedimientos.listener;

import static es.capgemini.pfs.BPMContants.TRANSICION_ALERTA_TIMER;

import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

/**
 * 
 * @author manuel
 * Listener que genera la transici�n 'activarAlerta' en los nodos en los que no existe.
 * 
 */
@Component
public class GenerarTransicionActivarAlertaImpl extends PROBaseActionHandler implements GenerarTransicionListener {

	private static final long serialVersionUID = -6204184256333027776L;

	@Override
	public void fireEvent(Map<String, Object> map) {
		
		ExecutionContext executionContext = (ExecutionContext) map.get(CLAVE_EXECUTION_CONTEXT);
		this.generaTransicion(executionContext);

	}
	
	/**
	 * Crea una transici�n para activar una pr�rroga.
	 */
	private void generaTransicion(ExecutionContext executionContext) {
		
		if (existeTransicion(TRANSICION_ALERTA_TIMER, executionContext)) {
			return;
		}
		
		// Para tareas que deriven en otro procedimientos no se crea la transición activarAlerta.
		TareaProcedimiento tareaProcedimiento = getTareaProcedimiento(executionContext);
		if (tareaProcedimiento!=null && tareaProcedimiento.getTipoProcedimientoBPMHijo()==null) {
			nuevaTransicion(TRANSICION_ALERTA_TIMER, executionContext);
		}
		
	}

}
