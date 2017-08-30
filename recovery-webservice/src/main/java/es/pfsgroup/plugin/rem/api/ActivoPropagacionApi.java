package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.rest.dto.ActivoPropagacionDto;

/**
 * Servicio que ayuda con la propagacion de datos entre activos
 */
public interface ActivoPropagacionApi {

	/**
	 * Metodo que dado un activo recupera toda la informacion necesaria para realizar una propagacion de datos hacia diferentes activos.
	 * 
	 * Devuelve un listado de activos pretendientes de la propagacion de cambios y un array con los campos que están permitidos propagarse
	 * 
	 * @param idActivo
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	List<ActivoPropagacionDto> getAllActivosAgrupacionPorActivo(final Long idActivo);
}

