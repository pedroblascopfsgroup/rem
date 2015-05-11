package es.pfsgroup.recovery.recobroCommon.facturacion.manager.api;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionTramoCorrectorDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroCorrectorFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTarifaCobro;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroTramoFacturacion;
import es.pfsgroup.recovery.recobroCommon.facturacion.serder.RecobroTarifaCobroTramoItems;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonModeloFacturacionConstants;

public interface RecobroModeloFacturacionApi {
	
	/**
	 * Metodo que devuelve los modelos en estado Disponible o bloqueado
	 * @author Sergio
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_BO)
	List<RecobroModeloFacturacion> getListModelosFacturacion();
	
	/**
	 * Método que devuelve el objeto de la clase RecobroModeloFacturación que coincide con el id que se
	 * le pasa como parámetro
	 * @param id
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_BO)
	RecobroModeloFacturacion getModeloFacturacion(Long id);

	/**
	 * Método que devuelve los tipos de cobros habilitados o desahabilitados de un modelo de facturación según la variable "habilitados" 
	 * @param idModFact
	 * @param habilitados
	 * @param facturables
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_COBROS_BO)
	Page getCobros(RecobroDDTipoCobroDto dto);


	/**
	 * Método que habilita un tipo de cobro al modelo de facturación, también crea todos los conceptos a ese cobro
	 * @param idModFact
	 * @param idTipoCobro
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_HABILITAR_COBRO_BO)
	void habilitarCobro(Long idModFact, Long idTipoCobro);

	/**
	 * Método que deshabilita un tipo de cobro al modelo de facturación, también elimina los conceptos de ese cobro
	 * @param idModFact
	 * @param idTipoCobro
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DESHABILITAR_COBRO_BO)
	public void desHabilitarCobro(Long idModFact, Long idTipoCobro);
	
	/**
	 * Método que devuelve una lista paginada de modelos de facturación que cumplen los 
	 * criterios de búsqueda que se le pasan en el dto
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_BUSCARMODELOS_BO)
	Page buscarModelosFacturacion(RecobroModeloFacturacionDto dto);

	/**
	 * Guarda un modelo de facturación con los datos que vienen en el dto
	 * Si el id es null crea un nuevo modelo, si no modifica el que tiene ese id
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_SAVEMODELO_BO)
	RecobroModeloFacturacion guardaModeloFacturacion(
			RecobroModeloFacturacionDto dto);

	/**
	 * Devuelve todos los tramos de un modelo de facturación
	 * @param idModFact
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TRAMOS_BO)
	List<RecobroTramoFacturacion> getListTramosFacturacion(Long idModFact);

	/**
	 * Devuelve una lista con las tarifas de un cobro de un modelo de facturación
	 * @param idModFact
	 * @param idCobro
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GETLIST_TARIFAS_COBRO_BO)
	List<RecobroTarifaCobro> getListTarifasCobro(Long idModFact, Long idCobro);

	/**
	 * Elimina el modelo de facturación cuyo id coincide con el que se le pasa como parámetro 
	 * de momento no se borran todas sus relaciones, sólo se borra el modelo hasta nuevas definiciones de 
	 * cuando se puede o no borrar el modelo
	 * @param id
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_MODELO_BO)
	void borrarModeloFacturacion(Long id);

	/**
	 * Crea un nuevo tramo de días para un modelo de facturación.
	 * Al crearlo se crea también una relación de ese tramo con cada cobro autorizado por concepto de cobro
	 * El número de tramos máximo se cogerá de una variable del devon.properties
	 * @param dto
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_SAVE_TRAMO_FACTURACION_BO)
	void guradarTramoFacturacion(RecobroModeloFacturacionDto dto);

	/**
	 * Elimina el tramo de facturación cuyo id coincide con el que se le pasa como parámetro.
	 * Al eliminarlo debe eliminar también todas sus relaciones con tarifas-cobros autorizados
	 * @param idTramoFacturacion
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_DELETE_TRAMO_BO)
	void borrarTramoFacturacion(Long idTramoFacturacion);
	
	/**
	 * Devuelve el tramo de facturación que se corresponde con ese id
	 * @param idTramoFacturacion
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GET_TRAMO_BO)
	RecobroTramoFacturacion getTramoFacturacion(Long idTramoFacturacion);

	/**
	 * Método que a partir de un modelo de facturación guarda el tipo de corrector y su objetivo si fuera necesario 
	 * @param dto con los valores de tipo de corrector y objetivo si procede rellenos
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TIPO_CORRECTOR)
	void guardarTipoDeCorrector(RecobroModeloFacturacionDto dto);

	/**
	 * Método que a partir del dto guarda en base de datos el tramo corrector de la facturacion
	 * @param dto con los valores del tramo corrector
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_GUARDAR_TRAMO_CORRECTOR_BO)
	void guardarTramoCorrector(RecobroModeloFacturacionTramoCorrectorDto dto);

	/**
	 * Método que a partir del identificador del tramo corrector lo devuelve
	 * @param identificador del tramo corrector
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_GET_TRAMO_CORRECTOR_BO)
	RecobroCorrectorFacturacion getCorrectorFacturacion(Long id);

	/**
	 * Método que a partir de un identificador de tramo corrector procede a su borrado
	 * @param identificador del tramo corrector
	 * @param map
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_DELETE_TRAMO_CORRECTOR_BO)
	void borrarTramoCorrector(Long idTramoCorrector);

	/**
	 * Método para guardar los limites máximo/mínimo de la tarifa del cobro o el porcentaje del tramo de la tarifa
	 * @param gridItems
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBROCONFIG_SAVE_TARIFAS_TRAMOS_BO)
	void guardaTarifasTramos(RecobroTarifaCobroTramoItems gridItems);

	/**
	 * Cambia el estado de un modelo de facturación a aquel cuyo código coincide con el que se le pasa como
	 * parámetro
	 * @param idModFact
	 * @param rcfDdEesEstadoComponenteDisponible
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_CAMBIAESTADO_BO)
	void cambiaEstadoModeloFacturacion(Long idModFact,
			String codigoEstado);

	/**
	 * Crea un nuevo modelo de facturación que será una copia exacta con todas sus relaciones de aquel cuyo id se le pasa como parámetro
	 * @param idModFact
	 */
	@BusinessOperationDefinition(RecobroCommonModeloFacturacionConstants.PLUGIN_RECOBRO_MODELOFACTURACION_COPIAMODELO_BO)
	void copiarModeloFacturacion(Long idModFact);

	

}
