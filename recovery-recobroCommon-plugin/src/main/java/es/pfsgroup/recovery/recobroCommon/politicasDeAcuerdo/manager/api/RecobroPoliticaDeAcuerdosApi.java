package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.acuerdo.model.RecobroDDSubtipoPalanca;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaAcuerdosPalancaDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaAcuerdosPalanca;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonPoliticaDeAcuerdosConstants;

public interface RecobroPoliticaDeAcuerdosApi {

	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BUSCARPOLITICAS_BO)
	Page buscaPoliticas(RecobroPoliticaDeAcuerdosDto dto);
	
	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICASDEACUERDO_BO)
	List<RecobroPoliticaDeAcuerdos> getListaPoliticasDeAcuerdo();

	/**
	 * Método que devuelve la política de acuerdo correspondiente al id recibido
	 * @param id de la politica de acuerdos
	 * @return RecobroPoliticaDeAcuerdos
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPOLITICADEACUERDO_BO)
	RecobroPoliticaDeAcuerdos getPoliticaDeAcuerdo(Long idPoliticaDeAcuerdo);

	/**
	 * Método que guarda la política de acuerdos con los datos que se le pasan en el dto.
	 * Si en id es null crea un nuevo objeto y si no guarda el ya existente.
	 * Al guardar abre una pestaña con la información sobre la política
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_SAVEPOLITICADEACUERDO_BO)
	Long savePolitica(RecobroPoliticaDeAcuerdosDto dto);

	/**
	 * Dado un id de Política de acuerdos borra esa política y todas sus relaciones con palancas
	 * @param id
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_DELETE_POLITICADEACUERDO_BO)
	void borrarPolitica(Long id);

	
	/**
	 * Guarda los datos asociados a una palanca de una política dado un dto de entrada.
	 * Si el id de palanca es distinto de null modifica, si no crea una nueva relación
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GUARDA_PALANCA_POLITICA_BO)
	void guardaPalancaPolitica(RecobroPoliticaAcuerdosPalancaDto dto);
	
	/**
	 * Dado un id devuelve el objeto RecobroPoliticaAcuerdosPalanca que se corresponde con ese id
	 * @param idPoliticaPalanca
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETPALANCAPOLITICA_BO)
	RecobroPoliticaAcuerdosPalanca getPoliticaDeAcuerdosPalanca(Long idPoliticaPalanca);

	/**
	 * Borra la relacion política-palanca que se corresponde con el id que se le pasa como parámetro
	 * @param id de la relacion politica-palanca
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCAPOLITICA_BO)
	void borrarPalancaPoliticaDeAcuerdos(Long id);
	
	/**
	 * Borrar la relacion de política-palanca y recalcular prioridades de las palancas restantes
	 * @param id
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_BORRAR_PALANCA_RECALC_PRIOR_BO)
	void borrarPalancaRecualculoPrioridades(Long id);

	/**
	 * Método que dado un código de palanca devuelve todos los subtipos que pertenecen a ese tipo
	 * @param codigoTipoPalanca
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_GETSUBPALANCAS_BO)
	List<RecobroDDSubtipoPalanca> getSubTiposPalanca(String codigoTipoPalanca);

	/**
	 * Crea una copia con todas sus dependencias de la política de acuerdos que se le pasa por parámetro
	 * @param id
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_COPIA_POLITICA_BO)
	void copiarPoliticaAcuerdos(Long id);

	/**
	 * Cambia el estado del la política de acuerdos cuyo id coincide con el que se le pasa como parámetro
	 * al esetado que coincide con el código que se le pasa como parámetro
	 * @param id
	 * @param rcfDdEesEstadoComponenteDisponible
	 */
	@BusinessOperationDefinition(RecobroCommonPoliticaDeAcuerdosConstants.PLUGIN_RECOBRO_POLITICAAPI_CAMBIARESTADO_POLITICA_BO)
	void cambiarEstadoPoliticaAcuerdos(Long id,
			String codigoEstado);
}
