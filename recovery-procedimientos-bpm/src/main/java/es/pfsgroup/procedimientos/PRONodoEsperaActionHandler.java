package es.pfsgroup.procedimientos;

import java.util.HashMap;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.procedimientos.PROGenericActionHandler;
import es.pfsgroup.recovery.api.JBPMProcessApi;
import es.pfsgroup.recovery.api.TareaProcedimientoApi;


public class PRONodoEsperaActionHandler extends PROGenericActionHandler {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2432508306623792426L;
	
	@Autowired
	protected ApiProxyFactory proxyFactory;
	
	/**
	 * Control de la transicion a la que ir despues de cumplirse el tiempo de espera
     * 1. Cargar contexto
     * 2. Obtener siguiente transicion a partir del script en Groovy guardado en la BBDD
     * 3. lanzar transición calculada
     * @throws Exception e
    */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext)
			throws Exception {
		
		String nombreTransicion = getDecision(executionContext);
		String nombreDecision = executionContext.getNode().getName() + "Decision";
		setVariable(nombreDecision, nombreTransicion, executionContext);
		
		executionContext.getNode().leave(executionContext, "avanzaBPM");
		
	}
    
    protected String getDecision(ExecutionContext executionContext) {
    	
    	String name = executionContext.getNode().getName();
		Procedimiento procedimiento = getProcedimiento(executionContext);
		TareaProcedimiento tp = proxyFactory.proxy(TareaProcedimientoApi.class).
				getByCodigoTareaIdTipoProcedimiento(procedimiento.getTipoProcedimiento().getId(), name);
    	String script = tp.getScriptDecision();
        
    	String result = null;
        Map<String, Object> context = new HashMap<String, Object>();
        context.put("idProcedimiento", getProcedimiento(executionContext).getId());

        try {
            result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(getProcedimiento(executionContext).getId(), null, null,
            			context, script).toString();
        } catch (Exception e) {
            logger.error("Error en el script de decisión [" + script + "]. Procedimiento [" + getProcedimiento(executionContext).getId() + "], nodo ["
                    + name + "].", e);
            throw new UserException("bpm.error.script");
        }
        return result;
    }
    
}
