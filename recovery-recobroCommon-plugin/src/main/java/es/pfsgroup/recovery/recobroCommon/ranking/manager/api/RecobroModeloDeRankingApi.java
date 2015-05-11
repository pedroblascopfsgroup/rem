package es.pfsgroup.recovery.recobroCommon.ranking.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloRankingVariableDto;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloRankingVariable;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonModeloDeRankingConstants;

public interface RecobroModeloDeRankingApi {

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GETLIST_BO)
	List<RecobroModeloDeRanking> getListaModelosDeRanking();

	/**
	 * Método que devuelve la instancia de la clase RecobroModeloDeRanking cuyo id coincide con el parámetro 
	 * que se le pasa por entrada
	 * @param idModeloRanking
	 * @return RecobroModeloDeRanking
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GET_BO)
	RecobroModeloDeRanking getModeloDeRanking(Long idModeloRanking);

	/**
	 * Método que guarda las modificaciones de un modelo de ranking o crea uno nuevo según los datos que vienen en el dto
	 * @param dto
	 * @return devuelve el id del nuevo objeto creado
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_SAVEMODELORANKING_BO)
	Long saveModeloRanking(RecobroModeloDeRankingDto dto);

	/**
	 * Devuelve una lista paginada con los modelos de ranking que cumplen las condiciones que se le pasan en el dto
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_BUSCARMODELORANKING_BO)
	Page buscarModelosRanking(RecobroModeloDeRankingDto dto);

	/**
	 * Asocia un tipo de variable de ranking a un modelo
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_ASOCIAVARIABLE_BO)
	void asociarVariableRankingModelo(RecobroModeloRankingVariableDto dto);
	
	/**
	 * Devuelve el objeto RecobroModeloRankingVariable que coincide con el id que se le pasa como parámetro
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_GET_VARIABLE_BO)
	RecobroModeloRankingVariable getModeloRankingVariable(Long id);

	/**
	 * Elimina la relación de variable con modelo de ranking cuyo id coincide con el que se le pasa como parámetro
	 * @param idVariable
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_DELETE_VARIABLERANKING_BO)
	void borrarVariableModeloRanking(Long idVariable);

	/**
	 * Elimina el modelo de ranking cuyo id coincide con el que se le pasa como parámetro y todas sus relaciones con variables
	 * @param id
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_DELETE_MODELORANKING_BO)
	void borrarModeloDeRanking(Long id);

	/**
	 *  Crea una nuevo modelo de Ranking que tiene los mismos valores que el modelo de ranking cuyo 
	 * id coincide con el que se le pasa como parámetro.
	 * El nuevo modelo se llamará nombre_copia y se copiarán también todas sus dependencias
	 * @param idModelo
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_COPIAR_MODELORANKING_BO)
	void copiarModeloRanking(Long idModelo);

	/**
	 * Cambia el estado de un modelo de ranking dado al estado cuyo código coincide con el que se le pasa como parámetro
	 * @param idModelo
	 * @param codigoEstado
	 */
	@BusinessOperationDefinition(RecobroCommonModeloDeRankingConstants.PLUGIN_RECOBRO_MODELORANKING_CAMBIAESTADO_MODELORANKING_BO)
	void cambiaEstadoModelo(Long idModelo,
			String rcfDdEesEstadoComponenteDisponible);

}
