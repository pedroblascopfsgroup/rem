package es.pfsgroup.plugin.recobro.bpm.managers.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recobro.bpm.constants.RecobroConstantsBPM.ManagerBPM;

/**
 * Interfaz de métdos para el Manager del BPM de Recobro
 * @author Guillem
 *
 */
public interface RecobroManagerBPMAPI {

	/**
	 * Comprueba que la meta volante haya sido cumplida
	 * @return
	 */
	@BusinessOperationDefinition(ManagerBPM.BO_RECOBRO_MANAGER_BPM_COMPROBAR_META_VOLANTE)
	public boolean comprobarMetaVolante(Long idExpediente);
	
}
