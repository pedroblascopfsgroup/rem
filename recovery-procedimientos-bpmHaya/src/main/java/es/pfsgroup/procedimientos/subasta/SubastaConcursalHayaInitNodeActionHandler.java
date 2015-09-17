package es.pfsgroup.procedimientos.subasta;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.subasta.dao.SubastaDao;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;

public class SubastaConcursalHayaInitNodeActionHandler extends PROGenericEnterActionHandler {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2432508306623792426L;
	
	@Autowired
	protected GenericABMDao genericDao;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;	
	
	@Autowired
	protected SubastaDao subastaDao;

	@Autowired
	private JBPMProcessManager jbpmUtil;
	
    @Autowired
    private SubastaCalculoManager subastaCalculoManager;
        
	/**
	 * Control de la transicion a la que ir despues de crearse la tarea.
	 * Creación o inicialización de la entidad subasta
	 * 
	 * @throws Exception
	 *             e
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {

			Procedimiento procedimiento=getProcedimiento(executionContext);
			subastaCalculoManager.crearSubasta(procedimiento);
			
			//Avanzamos BPM
			executionContext.getToken().signal();

	}

	
	
}