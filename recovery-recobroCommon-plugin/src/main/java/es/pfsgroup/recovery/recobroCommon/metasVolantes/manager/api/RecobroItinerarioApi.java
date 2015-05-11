package es.pfsgroup.recovery.recobroCommon.metasVolantes.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoMetaVolante;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroItinerarioMetasVolantes;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.ItinerariosCommonConstants;

public interface RecobroItinerarioApi {
	
	/**
	 * Método que a partir de un dto de búsqueda devuelve una página con todos
	 * los objetos de tipo RecobroItinerario
	 * @param dto
	 * @return page
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCAR_ITINERARIOS_BO)
	Page buscaItinerarios(RecobroDtoItinerario dto);
	
	/**
	 * Método que guarda en base un nuevo itinerario o modifica los datos de los existentes
	 * Si el el idItinerario del dto es null o no existe el itinerario se creará uno nuevo, 
	 * @param dto
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_ITINERARIO_BO)
	Long guardaItinerarioRecobro(RecobroDtoItinerario dto);
	
	/**
	 * Método que elimina la instancia de RecobroItinerarioMetasVolantes que tenga el id que se le pasa como parámetro
	 * @param idItinerario
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_ELIMINAR_ITINERARIOS_BO)
	void eliminaItinerario(Long idItinerario);
	
	
	/**
	 * Método que devuelve la instancia de la clase RecobroItinerarioMetasVolantes cuyo id coincide con el parámetro 
	 * que se le pasa por entrada
	 * @param idItinerario
	 * @return RecobroItinerarioMetasVolantes
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_ITINERARIO_BO)
	RecobroItinerarioMetasVolantes getItinerarioRecobro(Long idItinerario);
	
	/**
	 * Método que devuelve las metas volantes asociadas a un itinerario que se le pasa como parametro
	 * @param idItinerario
	 * @return RecobroMetasVolantes
	 */
	@SuppressWarnings("rawtypes")
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCA_METAS_POR_ITI_BO)
	List<RecobroMetaVolante> buscaMetasPorItinerario(Long id);
	
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_METAS_BO)
	void guardaMetasVolantes(RecobroDtoMetaVolante dto);
	
	
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_LISTAMETAS_BO)
	void guardaListaMetasVolantes(List<RecobroDtoMetaVolante> dtos);

	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_ITINERARIOS_METAS_VOLANTES_BO)
	List <RecobroItinerarioMetasVolantes> getItinerariosMetasVolantes();
	
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GUARDAR_LISTDDSINO_BO)
	List<DDSiNo> getListDDSiNO ();
	
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_GET_RECOBROMETA_BO)
	RecobroMetaVolante getRecobroMetaVolante(Long idRecobroMeta);
	
	/**
	 * devuelve la lista de metas del itinerario mapeadas en un dto
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_BUSCA_DTOMETAS_POR_ITI_BO)
	List<RecobroDtoMetaVolante> buscaDtoMetasPorIti(Long id);

	/**
	 * Crea un nuevo itinerario de metas volantes con valores idénticos a aquel cuyo id se le pasa como parámetro.
	 * Se copian los datos básicos y todas sus relaciones con metas volantes
	 * @param id
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_COPIAR_ITINERARIOS_BO)
	void copiaItinerarioMetasVolantes(Long id);

	/**
	 * Cambia el estado del itinerario al que coincide con el código que se le pasa como parámetro
	 * @param id
	 * @param codigoEstado
	 */
	@BusinessOperationDefinition(ItinerariosCommonConstants.PLUGIN_RCF_API_ITI_CAMBIAESTADO_ITINERARIOS_BO)
	void cambiaEstadoItinerario(Long id,
			String codigoEstado);
}
