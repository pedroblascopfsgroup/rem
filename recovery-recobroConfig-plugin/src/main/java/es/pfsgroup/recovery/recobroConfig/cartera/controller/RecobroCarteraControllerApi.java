package es.pfsgroup.recovery.recobroConfig.cartera.controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;

/**
 * Api para el controlador de las carteras
 * @author vanesa
 *
 */
public interface RecobroCarteraControllerApi {
	
	
	/**
	 * Método que busca carteras
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaCarteras(RecobroDtoCartera dto, ModelMap map);
	
	/**
	 * Método que da de alta una nueva cartera
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveCartera(RecobroDtoCartera dto, ModelMap map);
	
	/**
	 * Método que abre en una pestaña la información sobre la cartera seleccionada
	 * @param id
	 * @param map
	 * @return
	 */
	String verCartera( @RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Abre la pestaña de búsqueda de carteras
	 * @param map
	 * @return
	 */
	String openABMCarteras(ModelMap map);
	
	/**
	 * Crea una copia de la cartera
	 * @param id
	 * @param map
	 * @return
	 */
	String copiarRecobroCartera(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Marca como disponible una cartera que se encuentra en estado en definición
	 * @param id
	 * @param map
	 * @return
	 */
	String liberarCartera(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Abre la ventana de edición de carteras de recobro
	 * @param id
	 * @param map
	 * @return
	 */
	String editaCartera(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Marca como borrada la cartera cuyo id coincide con el que se le pasa como parámetro
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarCartera(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Devuelve un listado de carteras que cumplen las condiciones del dto y cuyo estado es distinto de "en definición"
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaCarterasDisponibles(RecobroDtoCartera dto, ModelMap map);
	

}
