package es.pfsgroup.recovery.recobroConfig.esquema.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroCarteraEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroSubcarteraDto;

/**
 * Api para el controlador del módulo de  configuración de esquemas de Agencias de Recobro
 * @author diana
 *
 */
public interface RecobroEsquemaControllerApi {
	
	/**
	 * Método que devuelve el jsp de búsqueda, alta, baja y modificación de Esquemas de recobro
	 * @param map
	 * @return
	 */
	String openABMEsquema( ModelMap map);
	
	/**
	 * Método que a partir de un dto de búsqueda devuelve un JSON con el listado paginado de 
	 * Esquemas de Agencias que cumplen esos criterios
	 *
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaRecobroEsquema(
			RecobroEsquemaDto dto, ModelMap map);
	
	
	/**
	 * Método que llamará al mánager de Esquemas para borrar el Esquema que tenga el id que se le pasa como 
	 * parámetro. El borrado será un borrado lógico
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String borrarRecobroEsquema(
			@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);
	
	/**
	 * Método que a partir de un dto donde se le pasará el id de la clase RecobroEsquema modificará los valores de 
	 * esta según los parámetros del dto
	 * @param idEsquema
	 * @param botonPulsado
	 * @param map
	 * @return
	 */
	String abrirRecobroEsquema(
			@RequestParam(value = "idEsquema", required = true) Long idEsquema, String botonPulsado, ModelMap map);
	
	
	/**
	 * Método que a partir de un dto de alta creará o modificará un esquema ya existente, 
	 * dependiendo de que el campo id del dto esté relleno o no
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardarRecobroEsquema(RecobroEsquemaDto dto, ModelMap map);
	
	/**
	 * Devuelve el listado de carteras asociadas a un esquema dado un id de esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String buscaCarterasEsquema(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);

	/**
	 * Método que muestra la ficha con la información completa del esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String abrirFichaEsquema(@RequestParam(value = "idEsquema", required = true) Long idEsquema, 
			@RequestParam(value = "ultimaVersionDelEsquemaModel", required = false) boolean ultimaVersionDelEsquema, 
			ModelMap map);
	
	/**
	 * Método que permite la modificación de los datos del esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String editarRecobroEsquema(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);
	
	/**
	 * Método que conformará las carteras del esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String abrirConformarCarteras(@RequestParam(value = "idEsquema", required = true) Long idEsquema, 
			@RequestParam(value = "ultimaVersionDelEsquemaModel", required = false) boolean ultimaVersionDelEsquema, 
			ModelMap map);
	
	/**
	 * Método que creará o modificará la cartera de un esquema
	 * @param idEsquema
	 * @param idCartera
	 * @param idCarteraEsquema
	 * @param map
	 * @return
	 */
	String abrirFrmCarteraEsquema(@RequestParam(value = "idEsquema", required = false) Long idEsquema, 
			@RequestParam(value = "idCartera", required = false) Long idCartera,			
			@RequestParam(value = "idCarteraEsquema", required = false) Long idCarteraEsquema, ModelMap map);
	
	/**
	 * Asigna o modifica la cartera al esquema
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveCarteraEsquema(RecobroCarteraEsquemaDto dto, ModelMap map);
	
	/**
	 * Desasigna la cartera del esquema
	 * @param idCarteraEsquema
	 * @param map
	 * @return
	 */
	String borrarRecobroCarteraEsquema(Long idCarteraEsquema, ModelMap map);

	/**
	 * Método que devuelve la pantalla de configuración de facturación para un esquema
	 * @param idEsquema, ultimaVersionDelEsquema que indica si el esquema es la última versión o no del esquema
	 * @param map
	 * @return
	 */
	String openFacturacion(@RequestParam(value = "idEsquema", required = true) Long idEsquema, 
			@RequestParam(value = "ultimaVersionDelEsquemaModel", required = false) boolean ultimaVersionDelEsquema,
			ModelMap map);

	/**
	 * Método que devuelve el listado de subcarteras dado un id de carteraEsquema
	 * @param idCarteraEsquema
	 * @param map
	 * @return
	 */
	String buscaSubCarterasCarteraEsquema(@RequestParam(value = "idCarteraEsquema", required = true) Long idCarteraEsquema, ModelMap map);

	/**
	 * 
	 * Abre la ventana de edición de facturación de la subcartera seleccionada
	 * @param id de la subcartera
	 * @param map
	 * @return
	 */
	String cambiarModeloGestion(@RequestParam(value = "idSubCartera", required = true) Long idSubCartera, ModelMap map);
	
	/**
	 * 
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardarModelosSubcartera(RecobroSubcarteraDto dto, ModelMap map);
	
	/**
	 * Método que repartiras las subcarteras del esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String abrirRepartoSubcarteras(@RequestParam(value = "idEsquema", required = true) Long idEsquema, 
			@RequestParam(value = "ultimaVersionDelEsquemaModel", required = false) boolean ultimaVersionDelEsquema,
			ModelMap map);
	

	/**
	 * Método que crea/modifica una subcartera con reparto estático o dinámico
	 * 
	 * @param idCarteraEsquema
	 * @param idSubCartera
	 * @param codTipoReparto
	 * @param map
	 * @return
	 */
	String abrirFrmRepartoAgencias(Long idCarteraEsquema, Long idSubCartera, String codTipoReparto, ModelMap map);

	/**
	 * Método que devuelve las agencias de una subcartera
	 * 
	 * @param idSubCartera
	 * @param map
	 * @return
	 */
	String buscaSubCarterasAgencias(@RequestParam(value = "idSubCartera", required = true) Long idSubCartera, ModelMap map);
	
	/**
	 * Método que devuelve el ranking de una subcartera
	 * 
	 * @param idSubCartera
	 * @param map
	 * @return
	 */
	String buscaSubCarterasRanking(@RequestParam(value = "idSubCartera", required = true) Long idSubCartera, ModelMap map);

	/**
	 * Método para guardar el reparto estático de las agencias, en caso de no existir la subcartera la crea
	 * 
	 * @param idCarteraEsquema
	 * @param idTipoReparto
	 * @param nomReparto
	 * @param particion
	 * @param idSubCartera
	 * @param reparto	  
	 * @param map
	 * @return
	 */
	String saveSubCartera(RecobroSubcarAgenciaDto dto, ModelMap map);
	
	/**
	 * Borra la subcartera
	 * @param idCarteraEsquema
	 * @param map
	 * @return
	 */
	String borrarRepartoSubCartera(Long idSubCartera, ModelMap map);
	
	/**
	 * Abre la ficha de consulta simulación del esquema
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String openSimulacion(
			@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);

	/**
	 * Cambiar el estado del esquema recibido según el código de estado recibido
	 * @param idCarteraEsquema
	 * @param codEstado
	 * @param map
	 * @return
	 */
	String cambiarEstadoRecobroEsquema(Long idEsquema, String codEstado,
			ModelMap map);
	
	/**
	 * Descarga el fichero de resultados o el detalle según el tipoFichero
	 * @param idEsquema
	 * @param tipoFichero RES=Resultado, DET=Detalle
	 * @param map
	 * @return
	 */
	String descargarFichero(Long idEsquema, String tipoFichero, ModelMap map);
	
	/**
	 * Crea una copia del esquema con todas sus relaciones
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String copiarEsquema(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);


	/**
	 * Devuelve un JSON con la última versión del esquema
	 * @param map
	 * @return
	 */
	String getUltimaVersionEsquema(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);
	
	/**
	 * Llama al método del manager para poner en pte de liberar un esquema
	 * Antes de liberar debe hacer unas validaciones previas
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String liberarEsquemaRecobro(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);
	
	/**
	 * Cambia el estado del esquema a "En definición"
	 * @param idEsquema
	 * @param map
	 * @return
	 */
	String cambiarEstadoDefinicion(@RequestParam(value = "idEsquema", required = true) Long idEsquema, ModelMap map);
	
	/**
	 * Método que visualiza una subcartera con reparto estático o dinámico
	 * 
	 * @param idCarteraEsquema
	 * @param idSubCartera
	 * @param codTipoReparto
	 * @param disable
	 * @param map
	 * @return
	 */
	String abrirFrmRepartoAgenciasVisualizar(Long idCarteraEsquema, Long idSubCartera, String codTipoReparto, boolean disable, ModelMap map);
}
