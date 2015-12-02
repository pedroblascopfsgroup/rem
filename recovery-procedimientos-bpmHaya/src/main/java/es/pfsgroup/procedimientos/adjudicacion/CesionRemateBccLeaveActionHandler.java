package es.pfsgroup.procedimientos.adjudicacion;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class CesionRemateBccLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AdjudicacionHayaProcedimientoManager hayaProcManager;

	@Override
	protected void setDecisionVariable(ExecutionContext executionContext) {
		Procedimiento prc = getProcedimiento(executionContext);
		if (executionContext
				.getNode()
				.getName()
				.equals("H006_RealizacionCesionRemate")) {
			
       		boolean cargasPrevias = hayaProcManager.existenCargasPreviasActivas(prc.getId());
			this.setVariable("op_cargasPrevias", (cargasPrevias ? "SI" : "NO"), executionContext);
			
		}
		super.setDecisionVariable(executionContext);
	}

}
