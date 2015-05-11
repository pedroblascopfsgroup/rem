package es.pfsgroup.procedimientos.contratos;

import java.util.List;
import java.util.Random;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

/**
 * Esta clase permite generar la decisión de salida en función de los tipos de contrato marcados
 * para el análisis. Establecerá estas variables en el contexto de JBPM para decidir si se
 * ejecutan o no:
 * 
 * Rama_1: si/no
 * Rama_2: si/no
 * Rama_3: si/no
 * 
 * 
 * @author gonzalo
 *
 */
public class AnalisisOperacionesLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial Version ID 
	 */
	private static final long serialVersionUID = 1L;
	
	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	
	private ExecutionContext executionContext;
	
	@Autowired
	Executor executor;
	
	/**
	 * Procesa tras la salida del estado JBPM
	 */
	@Override 
	protected void finalizarTarea(ExecutionContext executionContext) {
		
		// Realiza las acciones del padre
		super.finalizarTarea(executionContext);
		
		this.executionContext = executionContext;
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		//Solo si el handle ha sido invocado por el guardado de la tarea, dentro del flujo BPM, realiza las acciones determinadas
		//Si ha sido invocado por una acción de paralizar la tarea o por una acción autoprorroga, no realiza las acciones determinadas 
		if (!tareaTemporal) {
			// Establece las varialbles de salida.
			estableceContexto();
		}
	}
	
	
	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */
	private void estableceContexto() {
		Boolean[] valoresRamas = getValoresRamas();
		for (int i=0; i<valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i+1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}

	/**
	 * TODO: Este método consultará los contratos y devolverá una cadena de tipo ABC, BC, A, AB,... indicando las ramas que se cumplen.
	 * De momento está tuneado hasta que tengamos la lógica de contratos.
	 * 
	 * @return
	 * 	Array con los valores para decidir, uno por cada Rama en orden 0-Primera rama, 1-Segunda rama,... 
	 */
	protected Boolean[] getValoresRamas() {
		Procedimiento proc = getProcedimiento(executionContext);
		Long idAsunto = proc.getAsunto().getId();
		
		// Consulta los contratos.
		Boolean[] valores = (Boolean[])executor.execute("es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.bpmGetValoresRamas", idAsunto);
		return valores;
	}
	
}
