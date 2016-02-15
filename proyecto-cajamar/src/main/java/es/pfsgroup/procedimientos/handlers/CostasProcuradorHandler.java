package es.pfsgroup.procedimientos.handlers;


import org.jbpm.graph.exe.ExecutionContext;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class CostasProcuradorHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1417606815140759L;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		if(!Checks.esNulo(prc.getAsunto().getProcurador())){
			executionContext.getToken().signal("avanzaConProcu");
		}else{
			executionContext.getToken().signal("avanza");
		}
	}

}