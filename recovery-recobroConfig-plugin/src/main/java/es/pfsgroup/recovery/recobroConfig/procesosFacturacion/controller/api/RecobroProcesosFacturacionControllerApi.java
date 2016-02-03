package es.pfsgroup.recovery.recobroConfig.procesosFacturacion.controller.api;


import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.procesosFacturacion.dto.RecobroProcesosFacturacionDto;


/**
 * Api para el controlador del modelo de facturación
 * @author carlos
 *
 */
public interface RecobroProcesosFacturacionControllerApi {
	
	/**
	 * Método para mostrar el launcher de procesos de facturación
	 * @param map
	 * @return
	 */
	String openLauncher(ModelMap map);
	
	/**
	 * Método que abre el calculo de la facturación
	 * @param map
	 * @return
	 */
	String abrirCalculo(ModelMap map);
	
	/**
	 * Método que abre la pestaña de remesas de facturación
	 * @param map
	 * @return
	 */
	String abrirRemesas(ModelMap map);
	
	/**
	 * Método para buscar los procesos de facturacion
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaProcesosFacturacion(RecobroProcesosFacturacionDto dto, ModelMap map);
	
	/**
	 * Método para descargar el fichero de procesos de facturación
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String descargarFichero(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);
	
	/**
	 * Método para anular un proceso de facturación
	 * @param idProceso
	 * @param map
	 * @return
	 */
	String cancelarProcesoFacturacion(Long idProceso, ModelMap map);
	/**
	 * Devuelve un JSON con un listado de las subcarteras asociadas al modelo de facturación
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String listaSubcarterasProcesoFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);
	
	/**
	 * Abre la ventana de alta y edición de modelos de facturación
	 * @param map
	 * @return
	 */
	String altaProdesoFacturacion(ModelMap map);
	
	/**
	 * Crea un nuevo proceso de Facturación con los datos que vienen en el dto
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveProcesoFacturacion(RecobroProcesosFacturacionDto dto, ModelMap map);
	
	/**
	 * Cambia a estado liberado un proceso de facturación que se encuentra en estado procesado
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String liberarProcesoFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);
	
	/**
	 * Elimina el detalle de facturación cuyo id coincide con el que se le pasa como parámetro
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String borrarDetalleFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);

	/**
	 * Abre una ventana emergente con un grid editable donde se pueden modificar los modelos de facturación aplicables a la subcartera para un 
	 * proceso de facturación
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String corregirModelosFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);
	
	/**
	 * Guarda las modificaciones realizadas en el grid editable de subcarteras de un proceso de facturación
	 * @param subCarteraItems
	 * @param map
	 * @return
	 */
	String saveModelosFacturacionSubcarteras(String subCarteraItems, ModelMap map);
	
	/**
	 * Cambiar el estado de un proceso de facturación a pte de procesar
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String marcarPendienteProcesoFacturacion(@RequestParam(value = "idProcesoFacturacion", required = true) Long idProcesoFacturacion, ModelMap map);

	/**
	 * Método para descargar el fichero de procesos de facturación reducido
	 * @param idProcesoFacturacion
	 * @param map
	 * @return
	 */
	String descargarFicheroReducido(Long idProcesoFacturacion, ModelMap map);
}
