package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
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

	private static final String MINUS = " MINUS ";

	private static final String WHERE = " WHERE ";

	private static final String FROM = " FROM ";

	private static final String SELECT = "SELECT ";

	private static final String INFO_TABLAS_NO_PUEDE_SER_NULL = "'infoTablas' no puede ser NULL";

	private static final String DTO_CLASS_NO_PUEDE_SER_NULL = "'dtoClass' no puede ser NULL";

	public static final String SEPARADOR_COLUMNAS = ",";

	private static final String REST_USER = "REST-USER";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	@Autowired
	private HibernateExecutionFacade queryExecutor;

	private Long restUserId;

	@Resource
	private Properties appProperties;

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
	 * @param registro
	 *            Objeto en el que se irá dejando trazas de tiempos de
	 *            ejecución. Puede ser NULL si no queremos dejar ninguna traza.
	 * @return
	 */
	public CambiosList listCambios(Class<?> dtoClass, InfoTablasBD infoTablas, RestLlamada registro,
			CambiosList cambios) {
		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException(INFO_TABLAS_NO_PUEDE_SER_NULL);
		}

		// Session session =this.getSessionFactory().getCurrentSession();
		Session session = this.sesionFactoryFacade.getSession(this);
		cambios.clear();

		FieldInfo[] fields = getDtoFields(dtoClass);
		String columns = columns4Select(fields, infoTablas.clavePrimaria());

		try {
			String columIdUsuarioRemAccion = field2column(ConstantesGenericas.ID_USUARIO_REM_ACCION);
			String selectFromDatosActuales = SELECT + columns + FROM + infoTablas.nombreVistaDatosActuales() + WHERE
					+ columIdUsuarioRemAccion + " <> " + getIdRestUser(session);
			String selectFromDatosHistoricos = SELECT + columns + FROM + infoTablas.nombreTablaDatosHistoricos();
			String queryString = selectFromDatosActuales + MINUS + selectFromDatosHistoricos;

			if (cambios.getPaginacion().getTamanyoBloque() != null) {
				queryString = "SELECT " + columns + " FROM (SELECT ROWNUM AS CONTADOR,CONSULTA.* FROM(" + queryString
						+ ") CONSULTA) WHERE CONTADOR >"
						+ String.valueOf(
								cambios.getPaginacion().getTamanyoBloque() * cambios.getPaginacion().getNumeroBloque())
						+ " AND CONTADOR <" + String.valueOf(((cambios.getPaginacion().getNumeroBloque() + 1)
								* cambios.getPaginacion().getTamanyoBloque()) + 1);
			}

			List<Object[]> resultado = null;

			try {
				if (logger.isDebugEnabled()) {
					logger.trace("Ejecutando: " + queryString);
				}
				resultado = queryExecutor.sqlRunList(session, queryString);
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al obtener los registros que difieren", queryString,
						infoTablas, t);
			}

			if (resultado != null && resultado.size() > 0) {
				String selectDatoHistorico = null;
				int posPk = posicionColumna(columns, infoTablas.clavePrimaria());
				try {
					for (Object[] r : resultado) {
						CambioBD cambio = new CambioBD(fields);
						cambio.setDatosActuales(r);
						selectDatoHistorico = selectFromDatosHistoricos + WHERE + infoTablas.clavePrimaria() + " = "
								+ r[posPk];
						if (logger.isDebugEnabled()) {
							logger.trace("Ejecutando: " + selectDatoHistorico);
						}
						Object[] historico = queryExecutor.sqlRunUniqueResult(session, selectDatoHistorico);
						if (historico != null) {
							cambio.setDatosHistoricos(historico);
						}
						cambios.add(cambio);

					}
				} catch (Throwable t) {
					throw new CambiosBDDaoError("Ha ocurrido un error al obtener el registro en 'datos historicos'",
							selectDatoHistorico, infoTablas, t);
				}
			} else {
				if (cambios.getPaginacion().getTamanyoBloque() != null) {
					cambios.getPaginacion().setHasMore(false);
				}
			}
		} finally {
			if (logger.isDebugEnabled()) {
				logger.trace("Cerrando sesión");
			}
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
			if (registro != null) {
				registro.logTiempoSelectCambios();
			}
		}

		return cambios;

	}

	public CambiosList listDatosActuales(Class<?> dtoClass, InfoTablasBD infoTablas, RestLlamada registro,
			CambiosList cambios) {
		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException(INFO_TABLAS_NO_PUEDE_SER_NULL);
		}

		Session session = this.sesionFactoryFacade.getSession(this);

		cambios.clear();

		FieldInfo[] fields = getDtoFields(dtoClass);
		String columns = columns4Select(fields, infoTablas.clavePrimaria());

		String queryString = SELECT + columns + FROM + infoTablas.nombreVistaDatosActuales();
		if (cambios.getPaginacion().getTamanyoBloque() != null) {
			queryString = "SELECT " + columns + " FROM (SELECT ROWNUM AS CONTADOR,CONSULTA.* FROM(" + queryString
					+ ") CONSULTA) WHERE CONTADOR >"
					+ String.valueOf(
							cambios.getPaginacion().getTamanyoBloque() * cambios.getPaginacion().getNumeroBloque())
					+ " AND CONTADOR <" + String.valueOf(((cambios.getPaginacion().getNumeroBloque() + 1)
							* cambios.getPaginacion().getTamanyoBloque()) + 1);
		}
		try {
			List<Object[]> resultado = null;

			try {
				if (logger.isDebugEnabled()) {
					logger.trace("Ejecutando: " + queryString);
				}
				resultado = queryExecutor.sqlRunList(session, queryString);
				if (resultado != null && resultado.size() > 0) {
					for (Object[] r : resultado) {
						CambioBD cambio = new CambioBD(fields);
						cambio.setDatosActuales(r);
						cambios.add(cambio);
					}
				} else {
					if (cambios.getPaginacion().getTamanyoBloque() != null) {
						cambios.getPaginacion().setHasMore(false);
					}
				}
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al obtener los registros que difieren", queryString,
						infoTablas, t);
			}

		} finally {
			if (logger.isDebugEnabled()) {
				logger.trace("Cerrando sesión");
			}
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
			if (registro != null) {
				registro.logTiempoSelectTodosDatos();
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
	 * @param registro
	 *            Objeto en el que se irá dejando trazas de tiempos de
	 *            ejecución. Puede ser NULL si no queremos dejar ninguna traza.
	 */
	public void marcaComoEnviados(Class<?> dtoClass, InfoTablasBD infoTablas, List<RestLlamada> registro) {
		long startTime = System.currentTimeMillis();

		if (dtoClass == null) {
			throw new IllegalArgumentException(DTO_CLASS_NO_PUEDE_SER_NULL);
		}

		if (infoTablas == null) {
			throw new IllegalArgumentException(INFO_TABLAS_NO_PUEDE_SER_NULL);
		}

		FieldInfo[] fields = getDtoFields(dtoClass);
		String columns = columns4Select(fields, infoTablas.clavePrimaria());

		Session session = this.sesionFactoryFacade.getSession(this);
		if (logger.isDebugEnabled()) {
			logger.trace("Inicando transacción");
		}
		Transaction tx = session.beginTransaction();
		try {
			String queryDelete = "TRUNCATE TABLE " + infoTablas.nombreTablaDatosHistoricos();
			try {
				if (logger.isDebugEnabled()) {
					logger.trace("Ejecutando: " + queryDelete);
				}
				queryExecutor.sqlRunExecuteUpdate(session, queryDelete);
				if (registro != null) {
					for (RestLlamada llamada : registro) {
						llamada.logTiempoBorrarHistorico();
					}
				}
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al borrar la tabla de 'datos históricos'",
						queryDelete, infoTablas, t);
			}

			String queryInsert = "INSERT INTO " + infoTablas.nombreTablaDatosHistoricos() + "(" + columns + ")" + SELECT
					+ columns + FROM + infoTablas.nombreVistaDatosActuales();
			try {
				if (logger.isDebugEnabled()) {
					logger.trace("Ejecutando: " + queryInsert);
				}
				queryExecutor.sqlRunExecuteUpdate(session, queryInsert);
				if (registro != null) {
					for (RestLlamada llamada : registro) {
						llamada.logTiempoInsertarHistorico();
					}
				}
			} catch (Throwable t) {
				throw new CambiosBDDaoError("Ha ocurrido un error al insertar registros en 'datos históricos'",
						queryInsert, infoTablas, t);
			}
			if (logger.isDebugEnabled()) {
				logger.trace("Comiteando transacción");
			}
			tx.commit();
		} catch (CambiosBDDaoError e) {
			logger.fatal(
					"Error al marcar como enviados los registros de la BD. Realizando rollback de la transacción.");
			tx.rollback();
			throw e;
		} finally {
			if (logger.isDebugEnabled()) {
				logger.trace("Cerrando sesión");
			}
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}

		if (logger.isDebugEnabled()) {
			logger.trace("TIMER DETECTOR Marcado de cambios: " + (System.currentTimeMillis() - startTime));
		}
	}

	/**
	 * Devuelve los nombres de los campos declarados en el DTO.
	 * 
	 * @param dtoClass
	 * @return
	 */
	public FieldInfo[] getDtoFields(Class<?> dtoClass) {
		ArrayList<FieldInfo> fields = new ArrayList<FieldInfo>();

		for (Field f : dtoClass.getDeclaredFields()) {
			// check si static
			if (!Modifier.isStatic(f.getModifiers())) {
				NestedDto nested = f.getAnnotation(NestedDto.class);

				if (nested == null) {
					String columnName = null;
					MappedColumn mappedColumn = f.getAnnotation(MappedColumn.class);
					if (mappedColumn != null) {
						columnName = mappedColumn.value();
					}
					fields.add(new FieldInfo(f.getName(), columnName));
				} else {
					FieldInfo[] nestedFields = getDtoFields(nested.type());
					if (nestedFields != null) {
						for (FieldInfo fi : nestedFields) {
							String columnName = (fi.getMappedColumnName() == null ? null
									: field2column(f.getName()) + "_" + fi.getMappedColumnName());
							FieldInfo field = new FieldInfo(f.getName() + "." + fi.getFieldName(), columnName);
							fields.add(field);
						}
					}
				}
			} // fin check si static
		}

		return fields.toArray(new FieldInfo[] {});
	}

	/**
	 * Transforma un array de campos de un DTO a un String de columnas de BD.
	 * <p>
	 * Para ello inserta "_" como separador y convierte todo a mayúsculas
	 * </p>
	 * 
	 *
	 * @param fields
	 * @param clavePrimaria
	 * @return
	 */
	public String columns4Select(FieldInfo[] fields, String clavePrimaria) {
		StringBuilder b = new StringBuilder();
		String separador = "";
		boolean pkfound = false;
		for (FieldInfo fi : fields) {
			String s2 = (fi.getMappedColumnName() == null ? field2column(fi.getFieldName()) : fi.getMappedColumnName());
			pkfound = pkfound || s2.equals(clavePrimaria);
			b.append(separador).append(s2);
			separador = SEPARADOR_COLUMNAS;
		}
		if ((clavePrimaria != null) && (!pkfound)) {
			b.append(separador).append(clavePrimaria);
		}
		return b.toString();
	}

	/**
	 * Nos dice la posición que ocupa una columna en el array de campos del DTO
	 * 
	 * @param columnas
	 *            String con las columnas separadas por comas.
	 * @param columna
	 *            Nombre de la columna, en formato COLUMNA_DE_BD
	 * @return
	 */
	private int posicionColumna(String columnas, String columna) {
		String[] cols = columnas.split(SEPARADOR_COLUMNAS);
		int pos = WebcomRequestUtils.buscarEnArray(cols, columna);
		if (pos >= 0) {
			return pos;
		} else {
			throw new CambiosBDDaoError(
					"No se ha podido encontrar la clave primaria [pk=" + columna + ", cols=" + columnas);
		}
	}

	private String field2column(String s) {
		return s.replaceAll("([A-Z])", "_$1").replaceAll("\\.", "_").toUpperCase();
	}

	/**
	 * @param entitySessionFactory
	 *            SessionFactory
	 */
	@Resource
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

	private Long getIdRestUser(Session session) {
		if (logger.isDebugEnabled()) {
			logger.trace("Obteniendo el ID para el usuario: " + REST_USER);
		}
		if (restUserId == null) {
			try {
				if (logger.isDebugEnabled()) {
					logger.trace("Buscando " + REST_USER + " con criteria");
				}
				Criteria criteria = queryExecutor.createCriteria(session, Usuario.class)
						.add(Restrictions.eq("username", REST_USER));
				Usuario restUser = (Usuario) queryExecutor.criteriaRunUniqueResult(criteria);
				if (restUser == null) {
					throw new CambiosBDDaoError("No se ha podido obtener el usuario: " + REST_USER);
				}
				if (logger.isDebugEnabled()) {
					logger.trace("Guardando restUserId en caché");
				}
				this.restUserId = restUser.getId();

			} catch (Throwable e) {
				throw new CambiosBDDaoError("No se ha podido obtener el usuario: " + REST_USER, e);
			}
		}
		if (logger.isDebugEnabled()) {
			logger.trace("Devolviendo restUserId=" + this.restUserId + " de la caché");
		}
		return this.restUserId;

	}

	/**
	 * Refresca la vista materializada
	 * 
	 * @param infoTablas
	 */
	public void refreshMaterializedView(InfoTablasBD infoTablas) {
		Session session = this.sesionFactoryFacade.getSession(this);
		try {
			refreshMaterializedView(infoTablas, session);
		} catch (Throwable t) {
			throw new CambiosBDDaoError(
					"No se ha podido actualizar la vista materializada " + infoTablas.nombreVistaDatosActuales());
		} finally {
			if (logger.isDebugEnabled()) {
				logger.trace("Cerrando sesión");
			}
			if (session != null) {
				if (session.isOpen()) {
					session.close();
				}
			}
		}
	}

	private void refreshMaterializedView(InfoTablasBD infoTablas, Session session) {
		try {
			if (logger.isDebugEnabled()) {
				logger.trace("Refrescando vista matarializada: " + infoTablas.nombreVistaDatosActuales());
			}

			// antes de refrescar la vista principal refrescamos las auxiliares
			if (infoTablas.vistasAuxiliares() != null) {
				for (String vistaAux : infoTablas.vistasAuxiliares()) {
					if(!vistaAux.isEmpty()){
						this.refreshMaterializedView(vistaAux, session);
					}
				}
			}

			this.refreshMaterializedView(infoTablas.nombreVistaDatosActuales(), session);
		} catch (Throwable t) {
			throw new CambiosBDDaoError(
					"No se ha podido actualizar la vista materializada " + infoTablas.nombreVistaDatosActuales());
		}
	}

	private void refreshMaterializedView(String nombreVista, Session session) {
		String sqlRefreshViews = "BEGIN DBMS_SNAPSHOT.REFRESH( '" + nombreVista + "','C',atomic_refresh=>FALSE); end;";
		queryExecutor.sqlRunExecuteUpdate(session, sqlRefreshViews);
	}

}
