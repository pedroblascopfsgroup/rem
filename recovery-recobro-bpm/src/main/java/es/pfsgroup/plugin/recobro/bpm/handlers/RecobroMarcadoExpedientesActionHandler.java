package es.pfsgroup.plugin.recobro.bpm.handlers;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.controlcalidad.manager.api.ControlCalidadManager;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.Genericas;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;

/**
 * Action handler para el nodo de marcado de expedientes del procedimiento de Recobro
 * @author Guillem
 *
 */
public class RecobroMarcadoExpedientesActionHandler extends RecobroGenericActionHandler {

	private static final long serialVersionUID = 2432508306623792426L;
	
	@Autowired
	private ControlCalidadManager controlCalidadManager;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;

	/**
	 * Método que realiza el marcado de expedientes del procedimiento de Recobro
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
		try{
			marcarExpedienteRecobro(executionContext);		
			executionContext.getNode().leave(executionContext, Genericas.FIN);
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método process de la clase RecobroMarcadoExpedientesActionHandler", e);
			ExpedienteRecobro expediente = getExpedienteRecobro(executionContext);
			ControlCalidadProcedimientoDto controlCalidadProcedimientoDto = new ControlCalidadProcedimientoDto();
			controlCalidadProcedimientoDto.setDescripcion("Se ha producido un error en el Handler del Marcado de Expedientes"
					+ " de Recobro para el expediente: " + expediente.getId());
			controlCalidadProcedimientoDto.setIdBPM(expediente.getProcessBpm());	
			controlCalidadProcedimientoDto.setIdEntidad(expediente.getId());	
			controlCalidadManager.registrarIncidenciaProcedimientoRecobro(controlCalidadProcedimientoDto);
		}
	}
    
}
