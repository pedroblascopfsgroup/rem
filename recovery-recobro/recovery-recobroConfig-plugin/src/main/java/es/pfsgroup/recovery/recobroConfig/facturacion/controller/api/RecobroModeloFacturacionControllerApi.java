package es.pfsgroup.recovery.recobroConfig.facturacion.controller.api;


import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroDDTipoCobroDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionDto;
import es.pfsgroup.recovery.recobroCommon.facturacion.dto.RecobroModeloFacturacionTramoCorrectorDto;


/**
 * Api para el controlador del modelo de facturación
 * @author carlos
 *
 */
public interface RecobroModeloFacturacionControllerApi {
	
	/**
	 * Método que devuelve el jsp de búsqueda, alta, baja y modificación de Esquemas de recobro
	 * @param map
	 * @return
	 */
	String openABMFacturacion( ModelMap map);
	
	/**
	 * Método para mostrar el launcher de configuración del modelo de facturación
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String openLauncher(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Método que a partir de un modelo de facturación configura los datos generales
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String abrirGeneral(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Método que a partir de un modelo de facturación configura los cobros
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String abrirCobros(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	
	/**
	 * Método que a partir de un modelo de facturación configura las tarifas
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String abrirTarifas(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	
	/**
	 * Método que a partir de un modelo de facturación configura las correcciones
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String abrirCorrectores(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);

	/**
	 * Método para buscar los cobros facturables habilitados o deshabilitados de un modelo de facturación
	 * @param idModFact El modelo de facturación
	 * @param habilitados Si es true obtiene los cobros habilitados, de lo contrario los deshabilitados 
	 * @param map
	 * @return
	 */
	String buscaCobros(
			RecobroDDTipoCobroDto dto,
			ModelMap map);
	
	
	/**
	 * Método para habilitar un cobro en un modelo de facturación,
	 * creará también todos los conceptos	
	 * @param idModFact
	 * @param idTipoCobro
	 * @param map
	 * @return
	 */
	String habilitarCobro(
			@RequestParam(value = "idModFact", required = true) Long idModFact,
			@RequestParam(value = "idTipoCobro", required = true) Long idTipoCobro,
			ModelMap map);	
	
	/**
	 * Método para deshabilitar un cobro en un modelo de facturación,
	 * eliminará también todos los conceptos de ese cobro	
	 * @param idModFact
	 * @param idTipoCobro
	 * @param map
	 * @return
	 */
	String desHabilitarCobro(
			@RequestParam(value = "idModFact", required = true) Long idModFact,
			@RequestParam(value = "idTipoCobro", required = true) Long idTipoCobro,
			ModelMap map);	
	/**
	 * Método para buscar los modelos de facturación que se corresponden con unos
	 * ciertos criterios de entrada que se le pasan por parámetro en el dto
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaModelosFacturacion(RecobroModeloFacturacionDto dto, ModelMap map);
	
	/**
	 * Devuelve una lista de todas las subcarteras que tienen asignado ese modelo de facturación
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String buscaSubCarterasModeloFacturacion(@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Abre la ventana de alta de modelos de facturación
	 * @param map
	 * @return
	 */
	String addModelosFacturacion(ModelMap map);
	
	/**
	 * Crea un nuevo modelo de facturación con los datos que vienen en el dto
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardaModeloFacturacion(RecobroModeloFacturacionDto dto, ModelMap map);
	
	/**
	 * Devuelve los conceptos del cobro de un modelo de facturación, 
	 * por el idModFact e idCobro
	 * @param idModFact
	 * @param idCobro
	 * @param map
	 * @return
	 */
	String buscaTarifasConcepCobros(Long idModFact, Long idCobro, ModelMap map);
	
	/**
	 * Elimina un modelo de facturación cuyo id coincide con el que se le pasa como parámetro
	 * Elimina el modelo y todas sus relaciones
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarModeloFacturacion(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Abre la ventana de edición de modelo del facturación seleccionado
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String editaModeloFacturacion(@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Devuelve un JSON con todos los tramos de facturación definidos para el modelo cuyo id coincide con el que se le pasa como
	 * parámetro
	 * @param id
	 * @param map
	 * @return
	 */
	String getTramosModeloFacturacion(@RequestParam(value = "id", required = true) Long id, ModelMap map);

	/**
	 * Abre la ventana de alta de nuevo tramo para un modelo de facturación
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String addTramoFacturacion(@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Elimina un tramo de un modelo de facturación
	 * También se elimina la relación con todos los conceptos de cobro asociados a ese tramo
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarTramoFacturacion(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Crea un nuevo tramo de días para un modelo de facturación.
	 * Al crearlo se crea también una relación de ese tramo con cada cobro autorizado por concepto de cobro
	 * El número de tramos máximo se cogerá de una variable del devon.properties
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardarTramoFacturacion(RecobroModeloFacturacionDto dto, ModelMap map);
	
	/**
	 * Método que a partir de un modelo de facturación permite editar el tipo de corrector 
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String editarTipoCorrector(
			@RequestParam(value = "idModFact", required = true) Long idModFact, ModelMap map);
	
	/**
	 * Método que a partir de un modelo de facturación guarda el tipo de corrector y su objetivo si fuera necesario 
	 * @param dto con los valores de tipo de corrector y objetivo si procede rellenos
	 * @param map
	 * @return
	 */
	String guardarTipoDeCorrector(
			RecobroModeloFacturacionDto dto, ModelMap map);

	/**
	 * Método que a partir de un modelo de facturación devuelve todos los tramos correctores definidos 
	 * @param idModeloFacturacion
	 * @param map
	 * @return
	 */
	String abrirListadoCorrectores(Long idModFact, ModelMap map);

	/**
	 * Método que a partir de un identificador de tramo corrector se abre un pop up para su edicion
	 * @param idModeloFacturacion
	 * @param map
	 * @return
	 */
	String abrirTramoCorrector(Long idModFact, Long idTramoCorrector, ModelMap map);

	/**
	 * Método que a partir del dto de tramo corrector lo guarda en base de datos
	 * @param RecobroModeloFacturacionTramoCorrectorDto
	 * @param map
	 * @return
	 */
	String guardarTramoCorrector(RecobroModeloFacturacionTramoCorrectorDto dto,
			ModelMap map);
	
	/**
	 * Método que a partir de un identificador de tramo corrector lo borra
	 * @param id tramo corrector
	 * @param map
	 * @return
	 */
	String borrarTramoCorrector(Long idTramoCorrector,
			ModelMap map);

	/**
	 * Abre la ventada de modificación de los conceptos del cobro
	 * @param idModFact
	 * @param idCobro
	 * @param map
	 * @return
	 */
	String abrirEditTarifas(Long idModFact, Long idCobro, ModelMap map);
	
	/**
	 * Guarda las tarifas y sus conceptos
	 * @param conceptos
	 * @param map
	 * @return
	 */
	String saveTarifas(String conceptos, ModelMap map);
	
	/**
	 * Cambia el estado del modelo de facturación de en definición a disponible
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String liberarModeloFacturacion(Long idModFact, ModelMap map);
	
	/**
	 * Crea una copia del modelo de facturacion con todas sus relaciones
	 * @param idModFact
	 * @param map
	 * @return
	 */
	String copiarModeloFacturacion(Long idModFact, ModelMap map);
}
