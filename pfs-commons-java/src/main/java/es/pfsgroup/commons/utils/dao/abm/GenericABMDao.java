package es.pfsgroup.commons.utils.dao.abm;

import java.io.Serializable;
import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.pagination.PaginationParams;

/**
 * Esta interfaz define el contrato básico de un DAO que permite operaciones ABM
 * sobre cualquier entidad.
 * 
 * Mediante este DAO genérico es posible obtener (mediante consultas básicas)
 * elementos de cualquier entidad
 * 
 * @author bruno
 * 
 */
public interface GenericABMDao {
	/**
	 * Tipos de filtro.
	 * 
	 * Tipos de filtrado que se pueden usar para obtener entidades de la base de
	 * datos
	 * 
	 * @author bruno
	 * 
	 */
	public enum FilterType {
		EQUALS,
		NULL,
		NOTNULL,
		SIMILARY,
		NOT_EQUALS	
	}

	/**
	 * Filtro.
	 * 
	 * Sirven para expresar las condiciones de obtención de entidadese.
	 * 
	 * @author bruno
	 * 
	 */
	public static interface Filter {
		/**
		 * Tipo de filtrado que se quiere realizar
		 * 
		 * @return
		 */
		FilterType getType();

		/**
		 * Nombre de la propiedad de la entidad que se quiere comparar
		 * 
		 * @return
		 */
		String getPropertyName();

		/**
		 * Valor a comparar
		 * 
		 * @return
		 */
		Object getPropertyValue();

	}

	/**
	 * Tipos de orenaciones posibles.
	 * 
	 * @author bruno
	 * 
	 */
	public static enum OrderType {
		ASC, DESC
	}

	public static interface RWOperations<T extends Serializable> {
		Long save(T o);

		void update(T o);

		void deleteById(Long id);
	}

	/**
	 * FactoryMethod para crear un filtro.
	 * 
	 * Crea filtros interpretables por la implementación concreta del DAO
	 * 
	 * @param type
	 *            Tipo de filtro
	 * @param propertyName
	 *            Nombre de la propiedad a comparar
	 * @param propertyValue
	 *            Valor a comparar
	 * @return
	 */
	Filter createFilter(FilterType type, String propertyName,
			Object propertyValue);
	
	/**
	 * FactoryMethod para crear un filtro.
	 * 
	 * Crea filtros interpretables por la implementación concreta del DAO
	 * 
	 * @param type
	 *            Tipo de filtro
	 * @param propertyName
	 *            Nombre de la propiedad a comparar
	 * @return
	 */
	Filter createFilter(FilterType type, String propertyName);

	/**
	 * Devuelve una lista de entidades
	 * 
	 * @param <T>
	 *            Tipo de la entidad a obtener
	 * @param clazz
	 *            Clase de la entidad a obtener
	 * @return
	 */
	<T extends Serializable> List<T> getList(Class<T> clazz);
	
	

	/**
	 * Devuelve una lista de entidades ordenadas
	 * 
	 * @param <T>
	 *            Tipo de la entidad a obtener
	 * @param clazz
	 *            Clase de la entidad a obtener
	 * @param order
	 *            Orden en el que queremos obtener los resultados. Si no
	 *            especificamos un orden devuelve los resultados sin ordenar
	 *            como el método getList()
	 * @return
	 */
	<T extends Serializable> List<T> getListOrdered(Class<T> clazz, Order order);

	/**
	 * Devuelve una página de entidades
	 * 
	 * @param <T>
	 *            Tipo de la entidad a obtener
	 * @param dto
	 *            DTO con los parámetros de paginación
	 * @param clazz
	 *            Clase de la entidad a obtener
	 * @return
	 */
	<T extends Serializable> Page getPage(Class<T> clazz, PaginationParams dto);

	/**
	 * Devuelve una lista de entidades conforme a una serie de filtros
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param filters
	 *            Listo de filtros que deben cumplir las entidades devuletas. Si
	 *            no se especifica ningún filtro se devuelven todas las
	 *            entidades. Si se especifican varios se hace un AND de todos
	 *            ellos
	 * @return
	 */
	<T extends Serializable> List<T> getList(Class<T> clazz, Filter... filters);
	
	<T extends Serializable> List<T> getList(Class<T> clazz, List<Filter> filters);

	/**
	 * Devuelve una lista de entidades conforme a una serie de filtros
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param order
	 *            Orden en el que queremos obtener los resultados. Si no
	 *            especificamos un orden devuelve los resultados sin ordenar
	 *            como el método getList()
	 * @param filters
	 *            Listo de filtros que deben cumplir las entidades devuletas. Si
	 *            no se especifica ningún filtro se devuelven todas las
	 *            entidades. Si se especifican varios se hace un AND de todos
	 *            ellos
	 * @return
	 */
	<T extends Serializable> List<T> getListOrdered(Class<T> clazz,
			Order order, Filter... filters);
	
	<T extends Serializable> List<T> getListOrdered(Class<T> clazz,
			Order order, List<Filter> filters);

	/**
	 * Devuelve una página de entidades conforme a una serie de filtros
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param dto
	 *            DTO con los parámetros de paginación
	 * @param filters
	 *            Listo de filtros que deben cumplir las entidades devuletas. Si
	 *            no se especifica ningún filtro se devuelven todas las
	 *            entidades. Si se especifican varios se hace un AND de todos
	 *            ellos
	 * @return
	 */
	<T extends Serializable> Page getPage(Class<T> clazz, PaginationParams dto,
			Filter... filters);

	/**
	 * Devuelve una entidad que cumple con una o varias condiciones
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param filters
	 *            Filtros a aplicar. Si se introducen varios filtros se
	 *            realizará un AND de todos ellos.
	 * @return
	 */
	<T extends Serializable> T get(Class<T> clazz, Filter... filters);

	/**
	 * Persiste una entidad nueva
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param object
	 *            Entidad a persisitir
	 * @return Devuelve la entidad ya persisitida
	 */
	<T extends Serializable> T save(Class<T> clazz, T object);

	/**
	 * Actualiza una entidad persistente
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param object
	 *            Entidad a persisitir
	 */
	<T extends Serializable> void update(Class<T> clazz, T object);

	/**
	 * Borra una entidad persistente mediante su ID
	 * 
	 * @param <T>
	 *            Tipo de la entidad
	 * @param clazz
	 *            Clase de la entidad
	 * @param id
	 *            ID De la entidad a borrar.
	 */
	<T extends Serializable> void deleteById(Class<T> clazz, Long id);
	
	<T extends Serializable> List<T> delete(Class<T> clazz, Filter... filters);
	
	<T extends Serializable> RWOperations<T> readWrite(Class<T> clazz);


	
}
