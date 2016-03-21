package es.pfsgroup.procedimientos.handlers;


import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

public class CostasProcuradorHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1417606815140759L;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		Procedimiento prc = getProcedimiento(executionContext);
		if(!Checks.esNulo(prc.getAsunto())){
			if(extAsuntoManager.tieneProcurador(prc.getAsunto().getId())){	
				executionContext.getToken().signal("avanzaConProcu");
			}else{
				executionContext.getToken().signal("avanza");
			}
		}else{
			executionContext.getToken().signal("avanza");
		}
		
	}

}