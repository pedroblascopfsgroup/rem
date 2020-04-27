package es.pfsgroup.plugin.rem.dao;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Table;

import org.hibernate.Query;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.Order;

@Service
public class FlashDao extends AbstractEntityDao<Serializable, Serializable> {

	/**
	 * 
	 * @param clazz
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	public <T extends Serializable> List<T> getList(Class<?> clazz)
			throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, null, (Filter) null);
	}

	/**
	 * 
	 * @param clazz
	 * @param order
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	public <T extends Serializable> List<T> getListOrdered(Class<?> clazz, Order order)
			throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, order, (Filter) null);
	}

	/**
	 * 
	 * @param clazz
	 * @param filters
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	public <T extends Serializable> List<T> getList(Class<?> clazz, Filter... filters)
			throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, null, filters);
	}

	/**
	 * 
	 * @param clazz
	 * @param order
	 * @param filters
	 * @return
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public <T extends Serializable> List<T> getListOrdered(Class<?> clazz, Order order, Filter... filters)
			throws InstantiationException, IllegalAccessException, Exception {
		List<T> respuesta = null;
		String sql = "SELECT ".concat(obtenerCamposSelect(clazz)).concat(" FROM ").concat(obtenerNombreTabla(clazz));

		if (filters != null && filters.length > 0) {
			sql = sql.concat(" WHERE ").concat(createFilters(clazz, filters));
		}

		StringBuilder functionHQL = new StringBuilder(sql);
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());
		List<Object[]> resultados = callFunctionSql.list();

		if (!Checks.estaVacio(resultados)) {
			respuesta = createResponseEntity(clazz, resultados);
		}

		return respuesta;
	}

	/**
	 * 
	 * @param clazz
	 * @param filters
	 * @return
	 */
	public <T extends Serializable> T get(Class<?> clazz, Filter... filters) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 
	 * @param clazz
	 * @param resultados
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private <T extends Serializable> List<T> createResponseEntity(Class<?> clazz, List<Object[]> resultados)
			throws Exception {
		ArrayList<T> respuesta = new ArrayList<T>();
		ArrayList<Field> useField = this.obtenerFields(clazz);
		if (!Checks.estaVacio(resultados)) {
			for (Object[] resultado : resultados) {
				T objetoEntity = (T) clazz.newInstance();
				if (resultado != null && resultado.length == useField.size()) {
					int i = 0;
					for (Object o : resultado) {
						String propertyEntityName = useField.get(i).getName().substring(0, 1).toUpperCase()
								+ useField.get(i).getName().substring(1);
						Method seter = this.getMethod(clazz, "set".concat(propertyEntityName),useField.get(i).getType());
						
						Class<?> theClass = Class.forName(useField.get(i).getType().getCanonicalName());
						try{
							if (seter != null) {
								seter.invoke(objetoEntity, theClass.cast(o));
							}
						}catch(ClassCastException castExc){
							if(theClass.getName().equals("java.lang.String")){
								seter.invoke(objetoEntity, String.valueOf(o));
							} else if(theClass.getName().equals("java.lang.Long")){
								seter.invoke(objetoEntity, Long.getLong(String.valueOf(o)));
							} else if(theClass.getName().equals("java.lang.Double")){
								seter.invoke(objetoEntity, Double.valueOf(String.valueOf(o)));
							}
						}
						
						
						i++;

					}
				}

				respuesta.add(objetoEntity);
			}
		}

		return respuesta;

	}

	/**
	 * 
	 * @param clazz
	 * @param filters
	 * @return
	 * @throws Exception
	 */
	private String createFilters(Class<?> clazz, Filter... filters) throws Exception {
		String result = "";
		for (Filter filter : filters) {
			Field field = clazz.getDeclaredField(filter.getPropertyName());
			if (field != null) {
				Column columna = field.getAnnotation(Column.class);
				if (columna != null && filter.getPropertyValue() != null) {
					if (!result.equals("")) {
						result = result.concat(" AND ");
					}
					String whereToken = columna.name().concat(" = ").concat((String) filter.getPropertyValue());
					result = result.concat(whereToken);
				}
			} else {
				throw new Exception("El filtro no existe");
			}

		}
		return result;
	}

	/**
	 * 
	 * @param clazz
	 * @return
	 * @throws Exception
	 */
	private String obtenerNombreTabla(Class<?> clazz) throws Exception {
		String result = null;
		Table tabla = clazz.getAnnotation(Table.class);
		if (!Checks.esNulo(tabla.name())) {
			result = tabla.name();
		} else {
			throw new Exception("No se ha podido obtener el nombre de la tabla");
		}

		if (!Checks.esNulo(tabla.schema())) {
			// result = tabla.schema().concat(".").concat(result);
		}

		return result;
	}

	/**
	 * 
	 * @param clazz
	 * @return
	 * @throws Exception
	 */
	private String obtenerCamposSelect(Class<?> clazz) throws Exception {
		String result = "";
		ArrayList<Field> useField = this.obtenerFields(clazz);
		for (Field field : useField) {
			Column columna = field.getAnnotation(Column.class);
			if (columna != null) {
				if (!result.equals("")) {
					result = result.concat(",");
				}
				result = result.concat(columna.name());

			}
		}

		return result;
	}
	
	private ArrayList<Field> obtenerFields(Class<?> clazz) throws Exception {
		ArrayList<Field> result = new ArrayList<Field>();
		Field[] useField = clazz.getDeclaredFields();
		for (Field field : useField) {
			Column columna = field.getAnnotation(Column.class);
			if (columna != null) {
				result.add(field);
			}
		}

		return result;
	}

	/**
	 * Obtiene un método ejecutable dado su nombre y su interface
	 * 
	 * @param clase
	 * @param nombreMetodo
	 * @return
	 */
	private Method getMethod(Class<?> clase, String nombreMetodo, Class<?> tipo) throws Exception {
		Method metodo = null;
		metodo = clase.getMethod(nombreMetodo,tipo);
		if (metodo == null) {
			Method[] allMethods = clase.getDeclaredMethods();
			for (Method met : allMethods) {
				if (met.getName().equals(nombreMetodo)) {
					metodo = met;
					break;
				}

			}
		}
		return metodo;
	}

}
