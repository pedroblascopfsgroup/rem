package es.pfsgroup.procedimientos.subasta;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class HipotecarioLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -632044366261916195L;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		//Solo si el handle ha sido invocado por el guardado de la tarea, dentro del flujo BPM, realiza las acciones determinadas
		//Si ha sido invocado por una acción de paralizar la tarea o por una acción autoprorroga, no realiza las acciones determinadas 
		if (!tareaTemporal) {
			// Establece las variables de salida.
			estableceContexto(executionContext);
		}
	}

	private void estableceContexto(ExecutionContext executionContext) {

		String valor = (String)executor.execute("es.pfsgroup.recovery.subasta.obtenerPropiedadAsunto", getProcedimiento(executionContext).getId());

		executionContext.setVariable("BPMTramiteSubastaDecision", valor);
		
	}

}
