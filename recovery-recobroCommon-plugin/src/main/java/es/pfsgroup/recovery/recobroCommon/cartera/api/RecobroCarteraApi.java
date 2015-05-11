package es.pfsgroup.recovery.recobroCommon.cartera.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.CarteraCommonConstants;

public interface RecobroCarteraApi {
	
	public static final String BO_GET_DD_RCF_ESTADO_CARTERA = "es.pfsgroup.plugin.recovery.core.api.getEstadoCartera";
	

	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GET_ESQUEMAS_BO)
	public List<RecobroEsquema> listaEsquemas();
	
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERAS_BO)
	public Page buscaCarteras(RecobroDtoCartera dto);
	
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_ALTA_CARTERAS_BO)
	public void altaCartera(RecobroDtoCartera dto);
	
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_ELIMINAR_CARTERAS_BO)
	public void eliminarCartera(Long idCartera);
	
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GET_CARTERAS_BO)
	public RecobroCartera getCartera(Long idCartera);


	/**
	 * Crea una copia de la cartera cuyo id se le pasa como parámetro
	 * @param id
	 */
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_COPIAR_CARTERAS_BO)
	public void copiarRecobroCartera(Long id);

	/**
	 * Cambia el estado de una cartera a aquel cuyo código coincide con el que se le pasa como parámetro
	 * @param id
	 * @param codigoEstado
	 */
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_CAMBIARESTADO_CARTERAS_BO)
	public void cambiarEstadoCartera(Long id,
			String codigoEstado);

	/**
	 * Devuelve una lista paginada de todas las carteras dadas de alta en la base de datos
	 * que cumplan los criterios de búsqueda del dto y además no estén en estado en definición
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_BUSCAR_CARTERASDISPONIBLES_BO)
	public Page buscaCarterasDisponibles(RecobroDtoCartera dto);


	/**
	 * Devuelve una lista de RecobroCartera
	 * @return
	 */
	@BusinessOperationDefinition(CarteraCommonConstants.PLUGIN_RCF_API_CARTERA_GETLIST_BO)
	public List<RecobroCartera> getList();
	
}
