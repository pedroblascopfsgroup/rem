package es.pfsgroup.recovery.recobroCommon.esquema.manager.api;

import java.util.Date;
import java.util.List;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

public interface RecobroSubCarteraApi {
	
	/**
	 * Método que a partir de un itinerario obtiene todas las subcartera que están asociados al mismo
	 * @param id del itinerario de metas volantes
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BUSCAR_SUBCATERA_BY_ITI_BO)
	List buscaSubCarteraPorItinerario(Long idItinerario);
	

	/**
	 * Método que devuelve la subCartera por id
	 * 
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_GET_SUBCATERA_BY_ID_BO)
	RecobroSubCartera getRecobroSubCartera(Long id);
	
	/**
	 * Método que borra una subcartera y el reparto de agencias
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RCF_API_ESQUEMA_BORRA_SUBCATERA_BO)
	void borrarSubCartera(Long id);

}
