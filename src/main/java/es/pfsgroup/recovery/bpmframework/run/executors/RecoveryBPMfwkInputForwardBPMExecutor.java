package es.pfsgroup.recovery.bpmframework.run.executors;

import org.springframework.stereotype.Component;

import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Clase que sabe cómo procesar un input de tipo forward
 * @author bruno
 *
 */
@Component
public class RecoveryBPMfwkInputForwardBPMExecutor extends RecoveryBPMfwkInputAvanzarBPMExecutor {

    public RecoveryBPMfwkInputForwardBPMExecutor() {
        super();
    }
    
    @Override
	public String[] getTiposAccion() {
		return new String[]{RecoveryBPMfwkDDTipoAccion.FORWARD, RecoveryBPMfwkDDTipoAccion.INFORMAR_DATOS_RECALCULAR};
	}
	
    @Override
    public void execute(final RecoveryBPMfwkInput myInput)  throws Exception {
        super.execute(myInput);
        // En principio hacemos lo mismo que el de avanzar normal, la transición definida en el BPM ya avanzará los nodos que hagan falta
    }

}
