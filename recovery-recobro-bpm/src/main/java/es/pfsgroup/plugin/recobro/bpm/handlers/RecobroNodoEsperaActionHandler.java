package es.pfsgroup.plugin.recobro.bpm.handlers;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.controlcalidad.manager.api.ControlCalidadManager;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.Genericas;
import es.pfsgroup.recovery.recobroCommon.expediente.model.ExpedienteRecobro;

/**
 * Action handler para el nodo de espera controlador del procedimiento de Recobro
 * @author Guillem
 *
 */
public class RecobroNodoEsperaActionHandler extends RecobroGenericActionHandler {

	private static final long serialVersionUID = 2432508306623792426L;
	
	@Autowired
	private ControlCalidadManager controlCalidadManager;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	/**
	 * Control de la transicion a la que ir despues de cumplirse el tiempo de espera
     * 1. Cargar contexto
     * 2. Obtener siguiente transicion a partir del script en Groovy guardado en la BBDD
     * 3. lanzar transici�n calculada
     * @throws Exception e
    */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
		try{
			String nombreTransicion = getDecision(executionContext);
			String nombreDecision = executionContext.getNode().getName() + Genericas.DECISION;
			setVariable(nombreDecision, nombreTransicion, executionContext);
			executionContext.getNode().leave(executionContext, Genericas.AVANZABPM);		
		}catch(Throwable e){
			logger.error("Se ha producido un error en el método process de la clase RecobroNodoEsperaActionHandler", e);
			ExpedienteRecobro expediente = getExpedienteRecobro(executionContext);
			ControlCalidadProcedimientoDto controlCalidadProcedimientoDto = new ControlCalidadProcedimientoDto();
			controlCalidadProcedimientoDto.setDescripcion("Se ha producido un error en el Handler del Nodo de espera"
					+ " de Recobro para el expediente: " + expediente.getId());
			controlCalidadProcedimientoDto.setIdBPM(expediente.getProcessBpm());	
			controlCalidadProcedimientoDto.setIdEntidad(expediente.getId());	
			controlCalidadManager.registrarIncidenciaProcedimientoRecobro(controlCalidadProcedimientoDto);
		}
	}
    
}
