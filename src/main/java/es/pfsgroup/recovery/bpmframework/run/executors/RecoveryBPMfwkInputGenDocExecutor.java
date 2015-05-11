package es.pfsgroup.recovery.bpmframework.run.executors;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

/**
 * Clase que sabe cómo generar un documento a partir de los datos de un input.
 * Si se indica en la configuración también avanzará el BPM y grabará los datos.
 * 
 * @author manuel
 * 
 */

@Component
public class RecoveryBPMfwkInputGenDocExecutor extends RecoveryBPMfwkInputInformarDatosExecutor {

    public static final String ENTIDAD_EXT_ASUNTO = "EXTAsunto";

    @Autowired
	private transient ApiProxyFactory proxyFactory;

    public RecoveryBPMfwkInputGenDocExecutor() {
        super();
    }
    
    @Override
	public String[] getTiposAccion() {
		return new String[]{RecoveryBPMfwkDDTipoAccion.GEN_DOC};
	}

    /* (non-Javadoc)
     * @see es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor#execute()
     */
    @SuppressWarnings("unchecked")
	@Override
    public void execute(final RecoveryBPMfwkInput myInput)  throws Exception {
    	
    	//FIXME Esto está mal, se debe revisar los tipos de acción que vamos a utilizar.
        Procedimiento proc = super.getProcedimiento(myInput.getIdProcedimiento());
        //String nodoProcedimiento = proxyFactory.proxy(JBPMProcessApi.class).getActualNode(proc.getProcessBPM());
        List<String> nodosProcedimiento = proxyFactory.proxy(EXTJBPMProcessApi.class).getCurrentNodes(proc.getProcessBPM());
        //Guarda los datos.
    	super.execute(myInput);
    	
        //Procedimiento proc = super.getProcedimiento(myInput.getIdProcedimiento());
        //String nodoProcedimiento = proxyFactory.proxy(JBPMProcessApi.class).getActualNode(proc.getProcessBPM());
        
    	//Repetimos por cada nodo del procedimiento.
        for (String nodoProcedimiento : nodosProcedimiento) {


	        RecoveryBPMfwkCfgInputDto config = super.getInputConfig(myInput.getTipo().getCodigo(), proc.getTipoProcedimiento().getCodigo(), nodoProcedimiento);
	        
	        //TODO: comprobar si se va a utilizar con otro tipo de entidades.
	        //Versión inicial sujeta a cambios.
	    	//TODO: En principio, la premisa es que hay que lanzar por correo todos los documentos que se generen (todos se adjuntarán al asunto).
//	    	Boolean enviarPorEmail = null;
//	    	boolean adjuntarEntidad = true;
	    	//De momento se pasa un adjunto
	    	String tipoEntidad = RecoveryBPMfwkInputGenDocExecutor.ENTIDAD_EXT_ASUNTO;
	    	
			try {
				if (config != null && config.getCodigoPlantilla() != null) {
				
					GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto(tipoEntidad, config.getCodigoPlantilla(),
							proc.getAsunto().getId(), proc);
					
				  Map<String, Object> precalculados=new HashMap<String, Object>();
					
					proxyFactory.proxy(GENINFInformesApi.class).generarEscritoEditable(
							generarEscritoDto, precalculados);
					
//					proxyFactory.proxy(GENINFInformesApi.class).generarEscrito(
//							tipoEntidad, config.getCodigoPlantilla(),
//							proc.getAsunto().getId(), enviarPorEmail, proc);
				}
			} catch (Exception e) {
				throw new RecoveryBPMfwkError(
						RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
						"Error al generar el documento", e);
			}

		}

    }

}
