package es.pfsgroup.procedimientos.subastaElectronica;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class TramiteSubElectronicaLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;
	
	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	
	@SuppressWarnings("unused")
	private ExecutionContext executionContext;
	
	@Autowired
	TramitesElectronicosApi tramitesElectronicos;
	
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass,
			ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		personalizamosTramiteSubastaElectronica(executionContext);
	}

	

	private void personalizamosTramiteSubastaElectronica(ExecutionContext executionContext) {

		if (executionContext.getNode().getName().contains("RevisarDocumentacion")) {
			estableceContexto(executionContext);
		}

	}
	
	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */
	private void estableceContexto(ExecutionContext executionContext) {
		Boolean[] valoresRamas = getValoresRamas(executionContext);
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}

	/**
	 * Este método consultará todos los datos para determinar que
	 * caracteristicas tiene, y así devolver la rama correspondiente A, B, C
	 * 
	 * @return Array con los valores para decidir, uno por cada Rama en orden
	 *         0-Primera rama, 1-Segunda rama,...
	 */
	protected Boolean[] getValoresRamas(ExecutionContext executionContext) {
		Procedimiento proc = getProcedimiento(executionContext);

		Boolean[] valores = (Boolean[]) tramitesElectronicos.bpmGetValoresRamasRevisarDocumentacion(proc, getTareaExterna(executionContext));
		
		
		return valores;
	}

}
