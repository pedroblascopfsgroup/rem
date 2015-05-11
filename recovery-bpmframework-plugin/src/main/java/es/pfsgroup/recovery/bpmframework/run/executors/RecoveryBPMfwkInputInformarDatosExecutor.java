package es.pfsgroup.recovery.bpmframework.run.executors;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Clase que sabe cómo guardar los datos que vienen en el input
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryBPMfwkInputInformarDatosExecutor implements RecoveryBPMfwkInputExecutor {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
    private transient RecoveryBPMfwkDatosProcedimientoApi datosProcedimientoManager;

    @Autowired
    private transient ApiProxyFactory proxyFactory;

	public String[] getTiposAccion() {
		return new String[]{RecoveryBPMfwkDDTipoAccion.INFORMAR_DATOS};
	}


    public void execute(final RecoveryBPMfwkInput myInput) throws Exception {
    	
        this.validaDatosEntrada(myInput);

        Procedimiento proc = this.getProcedimiento(myInput.getIdProcedimiento());
        //String nodoProcedimiento = proxyFactory.proxy(JBPMProcessApi.class).getActualNode(proc.getProcessBPM());
        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
        
        for (String nodoProcedimiento : nodosProcedimiento) {
	        RecoveryBPMfwkCfgInputDto config = this.getInputConfig(myInput.getTipo().getCodigo(), proc.getTipoProcedimiento().getCodigo(), nodoProcedimiento);
	        if(config != null){
	        	//throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.DESCONOCIDO,"La configuración es nula");
		        try {
		            datosProcedimientoManager.guardaDatos(myInput.getIdProcedimiento(), myInput.getDatos(), config);
		        } catch (RecoveryBPMfwkError e) {
		            throw e;
		        } 
		        catch (Exception e) {
		            throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION ,"Error al intentar guardar los datos." ,e);
		        }
	        }
        }

    }
    



	protected void validaDatosEntrada(final RecoveryBPMfwkInput myInput) {
		checkStateNotNull(myInput, "El input no puede ser null");
        checkStateNotNull(myInput.getIdProcedimiento(), "El input no tiene un idProcedimiento");
        checkStateNotNull(myInput.getTipo(), "El input debe tener un tipo");
        checkStateNotNull(myInput.getTipo().getCodigo(), "El tipo de input no tiene un código informado");
	}

    /**
     * Lanza una Illegal argument exception si el objeto es nulo
     * 
     * @param o
     *            Objeto a evaluar
     * @param msg
     *            mensaje de la excepción
     */
    protected void checkStateNotNull(Object o, String msg) {
    	
        if (o == null) {
            throw new IllegalArgumentException(msg);
        }

    }

    protected Procedimiento getProcedimiento(final Long idProcedimiento) {
    	
        return proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
    }
    
	protected RecoveryBPMfwkCfgInputDto getInputConfig(String codigoTipoInput, String codigoTipoProcedimiento, String nodoProcedimiento) {
		
		RecoveryBPMfwkCfgInputDto config;
        try {
            config = proxyFactory.proxy(RecoveryBPMfwkConfigApi.class).getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, nodoProcedimiento);
        } catch (Exception e) {
        	logger.warn(e.getMessage());
            config = null;
        }
		return config;
	}





}
