package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;

/**
 * Esta clase es un DAO genéfico para obtener registros que han cambiado en BD.
 * 
 * <p>
 * Para ello se basa en una comparación entre uan visa y una tabla
 * </p>
 * <p>
 * <code>
 * SELECT COL1, COL2 FROM VISTA_DATOS_ACTUALES
 * MINUS
 * SELECT COL1, COL2 FROM TABLA_DATOS_HISTORICO
 * </code>
 * </p>
 * 
 * <p>
 * Para ello esa clase es capaz de hacer dos cosas
 * <dl>
 * <dt>listCambios</dt>
 * <dd>devolver un listado de registros que han cambiado en la BD (aka
 * {@link CambioBD})</dd>
 * <dt>marcaComoEnviados</dt>
 * <dd>marcar los registros como procesados, igualando el contenido de
 * <code>VISTA_DATOS_ACTUALES</code> y <code>TABLA_DATOS_HISTORICO</code></dd>
 * </dl>
 * </p>
 *
 * @author bruno
 *
 */
@Repository
public class CambiosBDDao extends AbstractEntityDao<CambioBD, Long> {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	/**
	 * Devuelve los registros que han cambiado en la BD
	 * 
	 * @param dtoClass
	 *            Esta clase se usa para construir la <code>SELECT</code>.
	 *            Mediante reflection se obtendrán las variables de clase (aka
	 *            {@link Field}) y se añadirán como columnas del
	 *            <code>SELECT</code>
	 * 
	 * @param infoTablas
	 *            Este objeto debe proporcionar métodos con los que podamos
	 *            saber los nombres de la vista, tabla y clave primaria, para
	 *            poder construir la <code>SELECT</code>
	 * @return
	 */
	public List<CambioBD> listCambios(Class dtoClass, InfoTablasBD infoTablas) {
		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException("'infoTablas' no puede ser NULL");
		}

		Session session = this.sesionFactoryFacade.getSession(this);
		ArrayList<CambioBD> cambios = new ArrayList<CambioBD>();

		try {
			DbIdContextHolder.setDbId(1L);
			String[] fields = getDtoFields(dtoClass);
			String columns = columns4Select(fields);
			String columIdUsuarioRemAccion = columns4Select(new String[] { ConstantesGenericas.ID_USUARIO_REM_ACCION });
			String selectFromDatosActuales = "SELECT " + columns + " FROM " + infoTablas.nombreVistaDatosActuales() + " WHERE " + columIdUsuarioRemAccion + " <> '" + RestApi.REST_LOGGED_USER_USERNAME + "'";
			String selectFromDatosHistoricos = "SELECT " + columns + " FROM " + infoTablas.nombreTablaDatosHistoricos();
			String queryString = selectFromDatosActuales + " MINUS " + selectFromDatosHistoricos;

			List<Object[]> resultado = null;
			try {
				logger.debug("Ejecutando: " + queryString);
				Query query = createQuery(session, queryString);
				resultado = query.list();
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al obtener los registros que difieren", queryString,
						infoTablas, t);
			}

			if (resultado != null) {
				String selectDatoHistorico = null;
				try {
					for (Object[] r : resultado) {
						CambioBD cambio = new CambioBD(fields);
						cambio.setDatosActuales(r);
						selectDatoHistorico = selectFromDatosHistoricos + " WHERE " + infoTablas.clavePrimaria() + " = "
								+ r[0];
						Object[] historico = (Object[]) session.createSQLQuery(selectDatoHistorico).uniqueResult();
						cambio.setDatosHistoricos(historico);
						cambios.add(cambio);

					}
				} catch (Throwable t) {
					throw new CambiosBDDaoError("Ha ocurrido un error al obtener el registro en 'datos historicos'",
							selectDatoHistorico, infoTablas, t);
				}
			}
		} finally {
			logger.debug("Cerrando sesión");
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}

		return cambios;

	}

	/**
	 * Iguala el contenido de <code>VISTA_DATOS_ACTUALES</code> y
	 * <code>TABLA_DATOS_HISTORICO</code>
	 * <p>
	 * Para ello primero borra el contenido de
	 * <code>TABLA_DATOS_HISTORICO</code> y luego rellena los datos haciendo un
	 * <code>INSERT INTO TABLA_DATOS_HISTORICO (...) SELECT ... FROM VISTA_DATOS_ACTUALES</code>
	 * . Ambas operaciones se realizan en una misma transacción.
	 * </p>
	 * 
	 * @param dtoClass
	 *            Esta clase se usa para construir la <code>SELECT</code>.
	 *            Mediante reflection se obtendrán las variables de clase (aka
	 *            {@link Field}) y se añadirán como columnas del
	 *            <code>SELECT</code>
	 * 
	 * @param infoTablas
	 *            Este objeto debe proporcionar métodos con los que podamos
	 *            saber los nombres de la vista, tabla y clave primaria, para
	 *            poder construir la <code>SELECT</code>
	 */
	public void marcaComoEnviados(Class dtoClass, InfoTablasBD infoTablas) {
		if (dtoClass == null) {
			throw new IllegalArgumentException("'dtoClass' no puede ser NULL");
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException("'infoTablas' no puede ser NULL");
		}

		String[] fields = getDtoFields(dtoClass);
		String columns = columns4Select(fields);

		Session session = this.sesionFactoryFacade.getSession(this);
		logger.debug("Inicando transacción");
		Transaction tx = session.beginTransaction();
		try {
			String queryDelete = "DELETE FROM " + infoTablas.nombreTablaDatosHistoricos();
			try {
				logger.debug("Ejecutando: " + queryDelete);
				createQuery(session, queryDelete).executeUpdate();
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al borrar la tabla de 'datos históricos'",
						queryDelete, infoTablas, t);
			}

			String queryInsert = "INSERT INTO " + infoTablas.nombreTablaDatosHistoricos() + "(" + columns
					+ ") SELECT  FROM " + infoTablas.nombreVistaDatosActuales();
			try {
				logger.debug("Ejecutando: " + queryInsert);
				createQuery(session, queryInsert).executeUpdate();
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al insertar registros en 'datos históricos'",
						queryInsert, infoTablas, t);
			}

			logger.debug("Comiteando transacción");
			tx.commit();
		} catch (CambiosBDDaoError e) {
			logger.fatal(
					"Error al marcar como enviados los registros de la BD. Realizando rollback de la transacción.");
			tx.rollback();
			throw e;
		} finally {
			logger.debug("Cerrando sesión");
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}
	}

	/**
	 * Devuelve los nombres de los campos declarados en el DTO.
	 * 
	 * @param dtoClass
	 * @return
	 */
	private String[] getDtoFields(Class dtoClass) {
		ArrayList<String> fields = new ArrayList<String>();

		for (Field f : dtoClass.getDeclaredFields()) {
			fields.add(f.getName());
		}

		return fields.toArray(new String[] {});
	}

	/**
	 * Transforma un array de campos de un DTO a un String de columnas de BD.
	 * <p>
	 * Para ello inserta "_" como separador y convierte todo a mayúsculas
	 * </p>
	 * 
	 * @param fields
	 * @return
	 */
	private String columns4Select(String[] fields) {
		StringBuilder b = new StringBuilder();
		String separador = "";
		for (String s : fields) {
			String s2 = s.replaceAll("([A-Z])", "_$1").toUpperCase();
			b.append(separador).append(s2);
			separador = ", ";
		}
		return b.toString();
	}

	private SQLQuery createQuery(Session session, String queryString) {
		return session.createSQLQuery(queryString);
	}

	/**
	 * @param entitySessionFactory
	 *            SessionFactory
	 */
	@Resource
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

}
