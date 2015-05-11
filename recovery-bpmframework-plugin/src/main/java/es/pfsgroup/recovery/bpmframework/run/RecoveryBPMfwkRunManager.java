package es.pfsgroup.recovery.bpmframework.run;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputExecutor;
import es.pfsgroup.recovery.bpmframework.run.factory.RecoveryBPMfwkInputExecutorFactory;
import es.pfsgroup.recovery.bpmframework.util.RecoveryBPMfwkUtils;

/**
 * Operaciones de negocio para lanzar procesos
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryBPMfwkRunManager implements RecoveryBPMfwkRunApi {
    
    @Autowired
    private transient ApiProxyFactory proxyFactory;
    
    @Autowired
    private transient RecoveryBPMfwkInputExecutorFactory inputExecutorFactory;
    
    /*
     * (non-Javadoc)
     * @see es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi#procesaInput(es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo)
     */
    @Override
    @BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_PROCESA_INPUT)
    public Long procesaInput(final RecoveryBPMfwkInputInfo input) throws RecoveryBPMfwkError {
    	
    	RecoveryBPMfwkUtils.isNotNull(input, "El input no puede ser null");
        
        RecoveryBPMfwkInput persistentInput;
        
        if (input instanceof RecoveryBPMfwkInputDto){
            persistentInput = this.persiste((RecoveryBPMfwkInputDto) input);
        }else if (input instanceof RecoveryBPMfwkInput){
            persistentInput = (RecoveryBPMfwkInput) input;
        }else{
            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS
            		,"Tipo de input desconocido."
            		,new IllegalArgumentException("El input es de un tipo desconocido"));
        }
        
        RecoveryBPMfwkUtils.isNotNull(persistentInput.getId(), "El input no tiene ID");
        
        RecoveryBPMfwkInputExecutor executor = inputExecutorFactory.getExecutorFor(persistentInput);
        try {
        	//Procesamos el input.
			executor.execute(persistentInput);
        } catch (RecoveryBPMfwkError e) {
            throw e;
        } catch (Exception ex){
        	throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.DESCONOCIDO, "Error al ejecutar el input", ex);
        }
        
        return persistentInput.getId();
    }

    private RecoveryBPMfwkInput persiste(final RecoveryBPMfwkInputDto dtoInput) throws RecoveryBPMfwkError {
        try {
            return proxyFactory.proxy(RecoveryBPMfwkInputApi.class).saveInput(dtoInput);
        } catch (RecoveryBPMfwkError e) {
            throw e;
        } catch (Exception ex){
        	throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.DESCONOCIDO, "Error al guarda datos del input", ex);
        }
    }

}
