package es.pfsgroup.recovery.bpmframework.run.factory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;
import es.pfsgroup.recovery.bpmframework.util.RecoveryBPMfwkUtils;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Factoría de InputExecutors.
 * 
 * <p>
 * Esta factoría devuelve el executor en función del tipo de acción definido en
 * el tipo de operación
 * </p>
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryBPMfwkInputExecutorFactoryImpl implements RecoveryBPMfwkInputExecutorFactory, ApplicationContextAware {
    
	private final Log logger = LogFactory.getLog(getClass());
	
    @Autowired
    private ApiProxyFactory proxyFactory;
    
    private ApplicationContext mApplicationContext;
    
    private Map<String, String> executorsBeansMap = new HashMap<String, String>();
    
	@Override
	@SuppressWarnings("unchecked")
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		mApplicationContext = applicationContext;
		
		Map<String, RecoveryBPMfwkInputExecutor> beansMap = mApplicationContext.getBeansOfType(RecoveryBPMfwkInputExecutor.class);
		
		if (beansMap.isEmpty()) 
		{
            Error noProcessorError = new Error("No existen beans configurados del tipo RecoveryBPMfwkInputExecutor");
            throw noProcessorError;
        }
		
		for(Map.Entry<String,RecoveryBPMfwkInputExecutor> entry : beansMap.entrySet()){
			String[] tiposAccion = entry.getValue().getTiposAccion();
			for (String tipoAccion : tiposAccion){
				executorsBeansMap.put(tipoAccion, entry.getKey());
			}
		}
	}

    @Override
    public RecoveryBPMfwkInputExecutor getExecutorFor(final RecoveryBPMfwkInput input) throws RecoveryBPMfwkError {
        RecoveryBPMfwkUtils.isNotNull(input, "El input a procesar no puede ser NULL");
        RecoveryBPMfwkUtils.isNotNull(input.getIdProcedimiento(), "El input debe contener un ID de procedimiento");
        RecoveryBPMfwkUtils.isNotNull(input.getTipo(), "El tipo de input no puede ser null");

        RecoveryBPMfwkInputExecutor executor = null;

        String codigoTipoProcedimiento = this.getTipoProcedimiento(input.getIdProcedimiento());
        List<String> nodosProcedimiento = this.getNodosProcedimiento(input.getIdProcedimiento());
        
        RecoveryBPMfwkUtils.isNotNull(codigoTipoProcedimiento, "El input no tiene un procedimiento correcto");
        
        List<RecoveryBPMfwkCfgInputDto> configuraciones = new ArrayList<RecoveryBPMfwkCfgInputDto>();
        
        for (String nodoProcedimiento : nodosProcedimiento) {
		
        	RecoveryBPMfwkCfgInputDto configuracion = this.getConfiguracion(input.getTipo().getCodigo(), codigoTipoProcedimiento, nodoProcedimiento);
        	if (configuracion != null)
        		configuraciones.add(configuracion);
		}
        
        if (configuraciones == null || configuraciones.size() == 0) {
        	throw new IllegalArgumentException("No existe configuración para el tipo de Input: " + input.getTipo().getCodigo());
        }
        
//        if (config == null){
//        	throw new IllegalArgumentException("No se encuentra la configuración para el tipo de input indicado");
//        }
        	
        //FIXME: esto hay que cambiarlo cuando devuelva más de un executor.
//        String beanName = executorsBeansMap.get(config.getCodigoTipoAccion());
//
//        if (beanName == null) {
//            throw new IllegalArgumentException("No se encuentra el ejecutor para el tipo de acción " + config.getCodigoTipoAccion());
//        }
//
//        executor = (RecoveryBPMfwkInputExecutor) mApplicationContext.getBean(beanName);
        
        // Se va a devolver siempre el executor de chain_bo para que se puede hacer cualquier cosa.
        //executor = (RecoveryBPMfwkInputExecutor) mApplicationContext.getBean("recoveryBPMfwkInputForwardBPMExecutor");
        executor = (RecoveryBPMfwkInputExecutor) mApplicationContext.getBean("recoveryBPMfwkInputChainBoBPMExecutor");
        return executor;
    }

	/**
     * Obtiene una configuración para un input.
     * 
     * @param codigoTipoInput codigo del tipo de input.
     * @param codigoTipoProcedimiento codigo del tipo de procedimiento.
	 * @param nodoProcedimiento nombre del nodo.
     * @return
     */
    private RecoveryBPMfwkCfgInputDto getConfiguracion(String codigoTipoInput, String codigoTipoProcedimiento, String nodoProcedimiento) {
        try {
            return proxyFactory.proxy(RecoveryBPMfwkConfigApi.class).getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento);
        } catch (Exception e) {
        	logger.warn(e.getMessage());
            return null;
        }
    }

    /**
     * Obtiene un tipo de procedimiento
     * @param idProcedimiento 
     * @return Este método devuelve NULL si no existe el procedimiento o si éste no tiene tipo (o si el tipo no tienen código)
     */
    private String getTipoProcedimiento(Long idProcedimiento) {
        String codigo = null;
        
       Procedimiento proc = this.getProcedimiento(idProcedimiento);
       if (proc != null){
           TipoProcedimiento tipo = proc.getTipoProcedimiento();
           if (tipo != null){
               codigo = tipo.getCodigo();
           }
       }
       return codigo;
    }
    
    /**
     * Devuelve el nombre de los nodos del bpm en el que se encuentra un procedimiento.
     * @param idProcedimiento id del procedimiento
     * @return lista de nombre de nodos.
     */
    private List<String> getNodosProcedimiento(Long idProcedimiento) {
        List<String> nodos = null;
        
       Procedimiento proc = this.getProcedimiento(idProcedimiento);
       if (proc != null){
           //nodo = proxyFactory.proxy(JBPMProcessApi.class).getActualNode(proc.getProcessBPM());
           nodos = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
       }
       return nodos;
	}

	/**
	 * Devuelve un objeto procedimiento.
	 * @param idProcedimiento id del procedimiento.
	 * @return el objeto {@link Procedimiento}
	 */
	private Procedimiento getProcedimiento(Long idProcedimiento) {
		return proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
	}



}
