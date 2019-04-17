package es.pfsgroup.plugin.rem.dao;

import java.io.Serializable;
import java.lang.reflect.Field;
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

	public List<Object> getList(Class<?> clazz) throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, null, (Filter) null);
	}

	public List<Object> getListOrdered(Class<?> clazz, Order order)
			throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, order, (Filter) null);
	}

	public List<Object> getList(Class<?> clazz, Filter... filters)
			throws InstantiationException, IllegalAccessException, Exception {
		return this.getListOrdered(clazz, null, filters);
	}

	@SuppressWarnings("unchecked")
	public List<Object> getListOrdered(Class<?> clazz, Order order, Filter... filters)
			throws InstantiationException, IllegalAccessException, Exception {
		ArrayList<Object> respuesta = new ArrayList<Object>();
		String sql = "SELECT ".concat(obtenerFileds(clazz)).concat(" FROM ").concat(obtenerNombreTabla(clazz));

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

	public <T extends Serializable> T get(Class<?> clazz, Filter... filters) {
		// TODO Auto-generated method stub
		return null;
	}

	private ArrayList<Object> createResponseEntity(Class<?> clazz, List<Object[]> resultados)
			throws InstantiationException, IllegalAccessException {
		ArrayList<Object> respuesta = new ArrayList<Object>();

		if (!Checks.estaVacio(resultados)) {
			for (Object[] resultado : resultados) {
				Object objetoEntity = clazz.newInstance();

				respuesta.add(objetoEntity);
			}
		}

		return respuesta;

	}

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

	private String obtenerFileds(Class<?> clazz) throws Exception {
		String result = "";
		Field[] useField = clazz.getDeclaredFields();
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

}
