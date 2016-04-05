package es.pfsgroup.procedimientos.acuerdos;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class TramitesAcuerdosLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;
	
	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	
	private ExecutionContext executionContext;
	
	@Autowired
	//TODO

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass,
			ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		personalizamosTramitesAcuerdos(executionContext);
	}

	

	private void personalizamosTramitesAcuerdos(ExecutionContext executionContext) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());

		if (executionContext.getNode().getName().contains("DefinirDocumentacionAportar")) {
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
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}

	/**
	 * Este método consultará todos los datos de los bienes para determinar que
	 * caracteristicas tiene, y así devolver la rama correspondiente A, B, CEH,
	 * DEFGH,...
	 * 
	 * @return Array con los valores para decidir, uno por cada Rama en orden
	 *         0-Primera rama, 1-Segunda rama,...
	 */
	protected Boolean[] getValoresRamas() {
		Procedimiento proc = getProcedimiento(executionContext);

		// Consulta los contratos.
		//Boolean[] valores = (Boolean[]) executor.execute("es.pfsgroup.recovery.subasta.bpmGetValoresRamasCelebracion",				proc, getTareaExterna(executionContext));
		return null;
	}

}
