package es.pfsgroup.recovery.recobroConfig.ranking.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloDeRankingDto;
import es.pfsgroup.recovery.recobroCommon.ranking.dto.RecobroModeloRankingVariableDto;

public interface RecobroModeloDeRankingControllerApi {
	
	/**
	 * Método que devuelve el jsp de búsqueda, alta, baja y modificación de Modelos de ranking
	 * @param map
	 * @return
	 */
	String openABMModeloRanking(ModelMap map);
	
	/**
	 * Método que llamará al mánager de Modelos de ranking para borrar el modelo quee tenga el id 
	 * que se le pasa como 
	 * parámetro y todas sus relaciones de variables. El borrado será un borrado lógico
	 * @param id
	 * @param map
	 * @return
	 */
	String borrarModeloRanking(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * 
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String editModeloRanking(@RequestParam(value = "idModelo", required = true) Long idModelo, ModelMap map);
	
	/**
	 * 
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscaModelosRanking(RecobroModeloDeRankingDto dto, ModelMap map);
	
	/**
	 * 
	 * @param map
	 * @return
	 */
	String altaModeloRanking(ModelMap map);
	
	/**
	 * 
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String borrarVariableModeloRanking(@RequestParam(value = "id", required = true) Long id, ModelMap map);
	
	/**
	 * Abre la ventana para asociar una variable a un modelo de ranking
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String addVariableRankingModelo(Long idModelo, ModelMap map);
	
	/**
	 * Abre la ventana de alta de variable con los datos rellenos de la variable seleccionada
	 * @param idVariable
	 * @param map
	 * @return
	 */
	String editarVariableModelo(@RequestParam(value = "idVariable", required = true) Long idVariable, ModelMap map);
	
	/**
	 * 
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String buscaVariablesRanking(@RequestParam(value = "idModelo", required = true) Long idModelo, ModelMap map);
	
	/**
	 * Guarda un modelo de ranking si el id es distinto de null y si es null crea uno con los parámetros que se le pasan en el dto
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveModeloRanking(RecobroModeloDeRankingDto dto,  ModelMap map);
	
	/**
	 * Asocia una variable de ranking a un modelo de ranking
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveVariableModelo(RecobroModeloRankingVariableDto dto, ModelMap map);
	
	/**
	 * Crea una nuevo modelo de Ranking que tiene los mismos valores que el modelo de ranking cuyo 
	 * id coincide con el que se le pasa como parámetro.
	 * El nuevo modelo se llamará nombre_copia y se copiarán también todas sus dependencias
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String copiarModeloRanking (@RequestParam(value = "idModelo", required = true) Long idModelo, ModelMap map);
	
	
	/**
	 * Pasa de estado en definición a disponible un modelo de ranking
	 * @param idModelo
	 * @param map
	 * @return
	 */
	String liberarModeloRanking(@RequestParam(value = "idModelo", required = true) Long idModelo, ModelMap map);
	
	

}
