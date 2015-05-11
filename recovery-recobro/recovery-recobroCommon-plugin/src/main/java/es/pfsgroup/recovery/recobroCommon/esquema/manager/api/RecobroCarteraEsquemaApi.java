package es.pfsgroup.recovery.recobroCommon.esquema.manager.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroCarteraEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonEsquemasConstants;

public interface RecobroCarteraEsquemaApi {
	
	/**
	 * Método que devuelve la instancia de la clase RecobroCarteraEsquema cuyo id coincide con el parámetro 
	 * que se le pasa por entrada
	 * @param idCarteraEsquema
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET_BO)
	RecobroCarteraEsquema getRecobroCarteraEsquema(Long idCarteraEsquema);
	
	/**
	 * Método que elimina la instancia de RecobroCarteraEsquema que tenga el id que se le pasa como parámetro
	 * @param idCarteraEsquema
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_DELETE_BO)
	void borrarRecobroCarteraEsquema(Long idCarteraEsquema);
	
	
	/**
	 * Método que modifica los valores de una Cartera del Esquema de Recobro a partir de los datos 
	 * que vienen en el dto.
	 * Si el el idCarteraEsquema del dto es null o no existe el esquema se creará uno nuevo, 
	 * si no modificará la ya existente en base de datos 
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_SAVE_BO)
	void guardarRecobroCarteraEsquema(RecobroCarteraEsquemaDto dto);

	@BusinessOperationDefinition(RecobroCommonEsquemasConstants.PLUGIN_RECOBRO_CARTERAESQUEMAAPI_GET2_BO)
	RecobroCarteraEsquema getRecobroCarteraEsquema(Long idEsquema, Long idCartera);
}
