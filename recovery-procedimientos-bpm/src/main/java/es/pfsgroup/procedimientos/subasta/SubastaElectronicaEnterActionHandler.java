package es.pfsgroup.procedimientos.subasta;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.procedimientos.PROGenericEnterActionHandler;

public class SubastaElectronicaEnterActionHandler extends PROGenericEnterActionHandler {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	private SubastaCalculoManager subastaCalculoManager;

	@Autowired
	private SubastaProcedimientoApi subastaProcedimientoApi;

	/**
	 * Control de la transicion a la que ir despues de crearse la tarea.
	 * Creación o inicialización de la entidad subasta
	 *  
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());
		
		if (executionContext.getNode().getName().contains("SolicitudSubasta")) {
			// personalización del handler: creación de una subasta
			Procedimiento procedimiento = getProcedimiento(executionContext);
			if (Checks.esNulo(sub)) {
				subastaCalculoManager.crearSubasta(procedimiento);
				Subasta subasta = subastaProcedimientoApi.obtenerSubastaByPrcId(procedimiento.getId());
				if (!Checks.esNulo(subasta)) {
					subastaProcedimientoApi.determinarTipoSubasta(subasta);
				}
			} 
		}
	}

}