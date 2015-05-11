package es.pfsgroup.recovery.bpmframework.run.executors;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

@Component
public class RecoveryBPMfwkInputChainBoBPMExecutor extends RecoveryBPMfwkInputForwardBPMExecutor implements
		RecoveryBPMfwkInputExecutor {
	
    @Autowired
    private transient ApiProxyFactory proxyFactory;
    
	@Autowired
	private transient Executor executor;
	
	public RecoveryBPMfwkInputChainBoBPMExecutor(){
		super();
	}

	@Override
	public void execute(RecoveryBPMfwkInput myInput) throws Exception {
		
        Procedimiento proc = this.getProcedimiento(myInput.getIdProcedimiento());
        
        //recuperamos los nodos en los que se encuentra el BPM antes de que comience el proceso.
        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
        
		this.preExecute(myInput, nodosProcedimiento, proc);
		super.execute(myInput);
		this.postExecute(myInput, nodosProcedimiento, proc);

	}

    @Override
	public String[] getTiposAccion() {
		return new String[]{RecoveryBPMfwkDDTipoAccion.CHAIN_BO};
	}

	private void preExecute(final RecoveryBPMfwkInput myInput, List<String> nodosProcedimiento, Procedimiento proc) {
		this.validaDatosEntrada(myInput);
		 
//        Procedimiento proc = this.getProcedimiento(myInput.getIdProcedimiento());
//        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
        
        for (String nodoProcedimiento : nodosProcedimiento) {
	        RecoveryBPMfwkCfgInputDto config = this.getInputConfig(myInput.getTipo().getCodigo(), proc.getTipoProcedimiento().getCodigo(), nodoProcedimiento);
	        if(config != null){
		        try {
					String bo = config.getPreProcessBo();
					if (bo != null) {
							executor.execute(bo, myInput);
					}		        	
		        } 
		        catch (Exception e) {
		            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_PRE_PROCESADO_INPUT ,"Error en el preProcesado de datos." + e.getMessage() ,e);
		        }
	        }
        }
		
	}



	private void postExecute(final RecoveryBPMfwkInput myInput, List<String> nodosProcedimiento, Procedimiento proc) {
		this.validaDatosEntrada(myInput);
		 
//        Procedimiento proc = this.getProcedimiento(myInput.getIdProcedimiento());
//        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
        
        for (String nodoProcedimiento : nodosProcedimiento) {
	        RecoveryBPMfwkCfgInputDto config = this.getInputConfig(myInput.getTipo().getCodigo(), proc.getTipoProcedimiento().getCodigo(), nodoProcedimiento);
	        if(config != null){
		        try {
					String bo = config.getPostProcessBo();
					if (bo != null) {
							executor.execute(bo, myInput); 
					}
		        }
		        catch (Exception e) {
		            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_POST_PROCESADO_INPUT ,"Error en el postProcesado de datos." + e.getMessage() ,e);
		        }
	        }
        }
		
	}

}
