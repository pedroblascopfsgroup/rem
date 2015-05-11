package es.pfsgroup.recovery.recobroConfig.metasVolantes.controller.api;

import org.springframework.ui.ModelMap;

import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoItinerario;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dto.RecobroDtoMetaVolante;

/**
 * Api para el controlador de las itinerarios
 * @author vanesa
 *
 */
public interface RecobroItinerarioControllerApi {
	
	/**
	 * Método que abre el abm de itinerarios
	 * @return
	 */
	String abreABMItinerariosRecobro(ModelMap map);
	
	/**
	 * Método que busca carteras
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaItinerariosRecobro(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que da de alta un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String altaItinerarioRecobro(ModelMap map);
	
	/**
	 * Método que edita para su modificación un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String editaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que guarda un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que abre un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String openItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que obtiene las metas de un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String getMetasItinerario(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que modifica las metas volantes
	 * @param dto
	 * @param map
	 * @return
	 */
	String editaMetasVolantes(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Método que guarda las metas volantes
	 * @param dto
	 * @param map
	 * @return
	 */
	String guardaMetasVolantes(RecobroDtoMetaVolante dto, ModelMap map);
	
	/**
	 * Método que hace un borrado lógico re un itinerario
	 * @param dto
	 * @param map
	 * @return
	 */
	String eliminaItinerarioRecobro(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * 
	 */
	String descartaCambiosMetasVolantes(RecobroDtoItinerario dto, ModelMap map);
	
	/**
	 * Crea un nuevo itinerario de metas volantes identico a aquel cuyo id se le pasa como parámetro
	 * Copia el itinerario y todas sus relaciones de metas volantes
	 * @param id
	 * @param map
	 * @return
	 */
	String copiarItinerarioMetasVolantes(Long id, ModelMap map);
	
	/**
	 * Marca como disponible un itinerario de metas volantes que está en estado en definición
	 * @param id
	 * @param map
	 * @return
	 */
	String liberarItinerarioMetasVolantes(Long id, ModelMap map);

}
