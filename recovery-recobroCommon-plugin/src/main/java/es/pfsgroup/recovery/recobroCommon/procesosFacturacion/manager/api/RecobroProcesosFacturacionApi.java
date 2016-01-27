package es.pfsgroup.recovery.recobroCommon.procesosFacturacion.manager.api;


import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.model.RecobroProcesoFacturacion;
import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.serder.EditModelosFacturacionSubcarterasItem;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;

public interface RecobroProcesosFacturacionApi {

	/**
	 * Recupera el proceso de facturación en estado liberado que tiene la fecha hasta más actual y devuelve 
	 * un String con el texto desde-hasta
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOFACTURACION_ULTIMAFECHA_BO)
	String buscaUltimoPeriodoFacturado();

	/**
	 * Busca los procesos de facturación
	 * @param dto
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_BUSCARPROCESOS_BO)
	Page buscarProcesos(RecobroProcesosFacturacionDto dto);
	
	/**
	 * Busca los procesos de facturación filtrando por su estado
	 * @param estado String: Constante de RecobroDDEstadoProcesoFacturable
	 * @return ArrayList<RecobroProcesoFacturacion> con los procesos de facturacion resultantes
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GETPROCESOSBYSTATE_BO)
	List<RecobroProcesoFacturacion> getProcesosByState(String estado);

	/**
	 * Anula un proceso de facturación, si está liberado lo cancela, de lo contrario lo elimina
	 * @param idProceso
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_CANCELARPROCESO_BO)
	void cancelarProcesoFacturacion(Long idProceso);

	/**
	 * Recupera el objeto de la clase RecobroProcesoFacturacion cuyo id se corresponde con el que se pasa por parámetro
	 * @param idProcesoFacturacion
	 * @return
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOFACTURACION_GET_BO)
	RecobroProcesoFacturacion getProcesoFacturacion(Long idProcesoFacturacion);

	/**
	 * Crea un nuevo proceso de facturación con los datos que vienen en el dto
	 * @param dto
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_SAVE_PROCESO_BO)
	void saveProcesoFacturacion(RecobroProcesosFacturacionDto dto);

	/**
	 * Cambia el estado del proceso de facturación por el que se corresponde con el código que se le pasa como parámetro
	 * @param idProcesoFacturacion 
	 * @param codigoEstado
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_CAMBIA_ESTADO_PROCESO_BO)
	void cambiaEstadoProcesoFacturacion(
			Long idProcesoFacturacion, String codigoEstado);

	void cambiaEstadoProcesoFacturacion(Long id, String codigoEstado, String errorBatch);
	
	/**
	 * Elimina el detalle de facturación con el id que se le pasa como parámetro
	 * @param idDetalleFacturacion
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_BORRARDETALLE_BO)
	void borrarDetalleFacturacion(Long idDetalleFacturacion);

	/**
	 * Genera un excel con los procesos de facturación y el detalle
	 * @param idProcesoFacturacion
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCEL_PROCESOS_BO)
	FileItem generarExcelProcesosFacturacion(Long idProcesoFacturacion);

	/**
	 * Guarda los nuevos modelos de facturación a aplicar a las subcarteras de un proceso de facturación
	 * @param gridItems
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GUARDARMODELOS)
	void guardarModelosFacturacionSubcarteras(
			EditModelosFacturacionSubcarterasItem gridItems);
	
	/**
	 * Genera un excel con los procesos de facturación y el detalle sin importes a pagar 0.0
	 * @param idProcesoFacturacion
	 */
	@BusinessOperationDefinition(RecobroCommonProcesosFacturacionConstants.PLUGIN_RECOBRO_PROCESOSFACTURACION_GENERAREXCELREDUCIDO_PROCESOS_BO)
	FileItem generarExcelProcesosFacturacionReducido(Long idProcesoFacturacion);

	
}
