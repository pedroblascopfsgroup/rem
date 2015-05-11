package es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonAgenciasConstants;

public interface RecobroAgenciaApi {
	
	/**
	 * Método que a partir de un dto de búsqueda devuelve una página con todos ç
	 * los objetos de tipo RecobroAgencia que cumplen los criterios de búsqueda
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_BO)
	Page buscaAgencias(RecobroAgenciaDto dto);
	
	/**
	 * Método que devuelve un list con todas agencias
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_BUSCARAGENCIAS_TODAS_BO)
	List<RecobroAgencia> buscaAgencias();
	
	/**
	 * Método que modifica los valores de una Agencia de Recobro a partir de los datos 
	 * que vienen en el dto.
	 * Si el el idAgencia del dto es null o no existe la agencia se creará un a nueva, 
	 * si no modificará la ya existente en base de datos
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_SAVEAGENCIA_BO)
	void saveAgencia(RecobroAgenciaDto dto);
	
	/**
	 * Método que elimina la instancia de RecobroAgencia que tenga el id que se le pasa como parámetro
	 * @param idAgencia
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_DELETEAGENCIA_BO)
	void deleteAgencia(Long idAgencia);
	
	/**
	 * Método que devuelve la instancia de la clase RecobroAgencia cuyo id coincide con el parámetro 
	 * que se le pasa por entrada
	 * @param idAgencia
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBRO_AGENCIAAPI_GET_BO )
	RecobroAgencia getAgencia(Long idAgencia);
	
	/**
	 * Devuelve la lista de agencias de recobro a la que pertenece un usuario.
	 * La búsqueda se realiza a través de los despachos a los que pertenece un usuario y se busca la agencia
	 * filtrando por despacho el despacho de recobro del usuario
	 * @param idUsuario
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYUSUARIO)
	List<RecobroAgencia> buscaAgenciasDeUsuario(Long idUsuario);
	
	/**
	 * Devuelve una lista de agencias asociadas a un despacho externo
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonAgenciasConstants.PLUGIN_RECOBOR_AGENCIAAPI_BUSCABYDESPACHO)
	List<RecobroAgencia> buscaAgenciasDespacho(Long id);

}
