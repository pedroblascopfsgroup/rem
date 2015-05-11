package es.pfsgroup.recovery.recobroConfig.agenciasRecobro.controller.api;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestParam;

import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;

/**
 * Api para el controlador del módulo de  configuración de Agencias de Recobro
 * @author diana
 *
 */
public interface RecobroAgenciaControllerApi {
	
	/**
	 * Método que a partir de un dto de búsqueda devuelve un JSON con el listado paginado de 
	 * Agencias que cumplen esos criterios
	 *
	 * @param dto
	 * @param map
	 * @return
	 */
	String buscarAgencia(
			RecobroAgenciaDto dto, ModelMap map);
	
	/**
	 * Método que a partir de un dto con los datos de la agencia llamará al mánager de agencias que
	 * creará una nueva instancia de la clase RecobroAgencia
	 * @param map
	 * @return
	 */
	String crearAgencia(
			 ModelMap map);
	
	/**
	 * Método que llamará al mánager de Agencias para borrar la Agencia que tenga el id que se le pasa como 
	 * parámetro. El borrado será un borrado lógico
	 * @param idAgencia
	 * @param map
	 * @return
	 */
	String borrarAgencia(
			@RequestParam(value = "idAgencia", required = true) Long idAgencia, ModelMap map);
	
	/**
	 * Método que a partir de un dto donde se le pasará el id de la clase RecobroAgencia modificará los valores de 
	 * esta según los parámetros del dto
	 * @param idAgencia
	 * @param map
	 * @return
	 */
	String actualizarAgencia(
			@RequestParam(value = "idAgencia", required = true) Long idAgencia, ModelMap map);
	
	/**
	 * Método que devuelve el jsp de búsqueda, alta, baja y modificación de Agencias de Recobro
	 * @param map
	 * @return
	 */
	String openABMAgencia( ModelMap map);
	
	/**
	 * Método que a partir de un dto de alta creará o modificará una agencia ya existente, 
	 * dependiendo de que el campo id del dto esté relleno o no
	 * @param dto
	 * @param map
	 * @return
	 */
	String saveAgencia(RecobroAgenciaDto dto, ModelMap map);
	
	/**
	 * Método que devuelve el JSON donde se mapearán los valores de las poblaciones dada una provincia
	 * @param id de la provincia
	 * @return
	 */
	String getLocalidadesByProvincia(Long id, ModelMap map);

	 /**
     * Devuelve la lista de gestores de un despacho.
     * @param lista de identificadores de despacho separados por coma
     * @return la lista de gestores.
     */
	String getGestoresListadoDespachos(String listadoDespachos, ModelMap map);
	
}
