package es.pfsgroup.procedimientos.handlers;


import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.procedimientos.PROBaseActionHandler;

public class CostasProcuradorHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1417606815140759L;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
	@Autowired
	private CoreProjectContext coreProjectContext;	

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		if(!Checks.esNulo(prc.getAsunto())){ 
			if(extAsuntoManager.tieneActorEnAsunto(prc.getAsunto().getId(), coreProjectContext.getTiposGestorCentroProcura())){	
				executionContext.getToken().signal("avanzaConProcu");
			}else{
				executionContext.getToken().signal("avanza");
			}
		}else{
			executionContext.getToken().signal("avanza");
		}
		
	}

}