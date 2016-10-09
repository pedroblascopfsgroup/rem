package es.pfsgroup.plugin.rem.rest.api;

import java.beans.IntrospectionException;
import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

import org.springframework.transaction.annotation.Transactional;

public interface DtoToEntityApi {

	/**
	 * Guarda los datos de un dto en bbdd
	 * 
	 * @param dto
	 * @param objetoEntity
	 * @return
	 * @throws IllegalAccessException
	 * @throws IllegalArgumentException
	 * @throws InvocationTargetException
	 * @throws IntrospectionException
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws NoSuchMethodException
	 * @throws SecurityException
	 */
	@Transactional(readOnly = false)
	public Serializable saveDtoToBbdd(Object dto, ArrayList<Serializable> objetoEntity)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, IntrospectionException,
			ClassNotFoundException, InstantiationException, NoSuchMethodException, SecurityException;

	/**
	 * Obtiene un objeto de bbdds partiendo de la clave dada
	 * 
	 * @param idValue
	 * @param entity
	 * @param fieldActivo
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	@SuppressWarnings("rawtypes")
	public Serializable obtenerObjetoEntity(Long idValue, Class entity, String fieldActivo)
			throws InstantiationException, IllegalAccessException;

}
