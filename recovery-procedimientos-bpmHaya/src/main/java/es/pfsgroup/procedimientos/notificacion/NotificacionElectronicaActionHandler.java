package es.pfsgroup.procedimientos.notificacion;


import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class NotificacionElectronicaActionHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private CoreProjectContext coreProjectContext;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		
		if (executionContext.getNode().getName().contains("nodeVieneTramiteAdjudicacion")){
			vieneDeTramiteAdjudicacion(prc, executionContext);
		}
	}

	private void vieneDeTramiteAdjudicacion(Procedimiento prc, ExecutionContext executionContext) {
		
		Procedimiento prcPadre = prc.getProcedimientoPadre();
		String codigoPadre = prcPadre.getTipoProcedimiento().getCodigo();
		
		if(codigoPadre.equals("H005")){
			executionContext.getToken().signal("Si");
		}else{
			executionContext.getToken().signal("No");
		}
		
	}

}