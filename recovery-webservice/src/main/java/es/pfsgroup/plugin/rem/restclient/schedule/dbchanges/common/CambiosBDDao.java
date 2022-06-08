package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.WebcomRESTDevonProperties;

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

	public static final String MINUS = " MINUS ";

	public static final String WHERE = " WHERE ";

	public static final String OR = " OR ";

	public static final String IN = " IN ";

	public static final String FROM = " FROM ";

	public static final String SELECT = "SELECT ";

	public static final String AND = " AND ";

	public static final String INFO_TABLAS_NO_PUEDE_SER_NULL = "'infoTablas' no puede ser NULL";

	public static final String DTO_CLASS_NO_PUEDE_SER_NULL = "'dtoClass' no puede ser NULL";

	public static final String SEPARADOR_COLUMNAS = ",";

	private static final String MARCADOR_CAMBIOS = "_M";

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private SessionFactoryFacade sesionFactoryFacade;

	@Autowired
	private HibernateExecutionFacade queryExecutor;

	@Resource
	private Properties appProperties;

	@Autowired
	private RestApi restApi;

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
			CambiosList cambios) throws CambiosBDDaoError {
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

		try {
			String nombreVistaDatosActuales = infoTablas.nombreVistaDatosActuales();
			trace("[DETECCIÓN CAMBIOS] Obteniedno cambios de "+ nombreVistaDatosActuales);
			if (infoTablas.procesarSoloCambiosMarcados()) {
				nombreVistaDatosActuales = nombreVistaDatosActuales.concat(MARCADOR_CAMBIOS);
			}

			String selectFromDatosActuales = SELECT + columns + FROM + nombreVistaDatosActuales;
			String selectFromDatosHistoricos = SELECT + columns + FROM + infoTablas.nombreTablaDatosHistoricos();
			String queryString = selectFromDatosActuales + MINUS + selectFromDatosHistoricos;

			queryString = this.paginarConsulta(cambios, columns, queryString, infoTablas);

			List<Object[]> resultado = null;

			resultado = queryExecutor.sqlRunList(session, queryString, infoTablas);

			if (resultado != null && !resultado.isEmpty()) {
				if (cambios.getPaginacion().getTamanyoBloque() != null) {
					cambios.getPaginacion().setTotalFilas(
							((BigDecimal) resultado.get(resultado.size()-1)[resultado.get(0).length-1]).intValue());
				}
				List<Object[]> historicos = obtenerHistoricosBloque(session, columns, infoTablas, resultado);
				int posPk = posicionColumna(columns, infoTablas.clavePrimaria());
				for (Object[] r : resultado) {
					CambioBD cambio = new CambioBD(fields);
					cambio.setDatosActuales(r);
					Object[] historico = obtenerRegistroHistorico(historicos, posPk,  r[posPk]);
					if (historico != null) {
						cambio.setDatosHistoricos(historico);
					}
					if (cambio.getCambios() != null && cambio.getCambios().size() > 0) {
						cambios.add(cambio);
					}

				}

			} else {
				if (cambios.getPaginacion().getTamanyoBloque() != null) {
					cambios.getPaginacion().setHasMore(false);
					cambios.getPaginacion().setTotalFilas(0);
				}
			}
		} finally {
			if (registro != null) {
				registro.logTiempoSelectCambios();
			}
			cerrarSesionBbdd(session);
		}

		return cambios;

	}

	public CambiosList listDatosActuales(Class<?> dtoClass, InfoTablasBD infoTablas, RestLlamada registro,
			CambiosList cambios) throws CambiosBDDaoError {
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

		trace("[DETECCIÓN CAMBIOS] obteniedo registros "+ infoTablas.nombreVistaDatosActuales());
		String queryString = SELECT + columns + FROM + infoTablas.nombreVistaDatosActuales();
		queryString = this.paginarConsulta(cambios, columns, queryString, infoTablas);
		try {
			List<Object[]> resultado = null;

			resultado = queryExecutor.sqlRunList(session, queryString, infoTablas);
			if (resultado != null && !resultado.isEmpty()) {
				if (cambios.getPaginacion().getTamanyoBloque() != null) {
					cambios.getPaginacion().setTotalFilas(resultado.size());
				}
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

		} finally {
			if (registro != null) {
				registro.logTiempoSelectTodosDatos();
			}
			cerrarSesionBbdd(session);
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
	@SuppressWarnings("rawtypes")
	public void marcaComoEnviados(Class<?> dtoClass, DetectorCambiosBD infoTablas, List<RestLlamada> registro)
			throws CambiosBDDaoError {
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
		
		Transaction tx = session.beginTransaction();
		try {
			String queryDelete = "TRUNCATE TABLE " + infoTablas.nombreTablaDatosHistoricos();
			queryExecutor.sqlRunExecuteUpdate(session, queryDelete, infoTablas);
			if (registro != null) {
				for (RestLlamada llamada : registro) {
					llamada.logTiempoBorrarHistorico();
				}
			}

			String queryInsert = "INSERT INTO " + infoTablas.nombreTablaDatosHistoricos() + "(" + columns + ")" + SELECT
					+ columns + FROM + infoTablas.nombreVistaDatosActuales();
			queryExecutor.sqlRunExecuteUpdate(session, queryInsert, infoTablas);
			if (registro != null) {
				for (RestLlamada llamada : registro) {
					llamada.logTiempoInsertarHistorico();
				}
			}
			
			tx.commit();
		} catch (CambiosBDDaoError e) {
			logger.fatal(
					"Error al marcar como enviados los registros de la BD. Realizando rollback de la transacción.");
			tx.rollback();
			throw e;
		} finally {
			cerrarSesionBbdd(session);
		}

		if (logger.isDebugEnabled()) {
			logger.trace("TIMER DETECTOR Marcado de cambios: " + (System.currentTimeMillis() - startTime));
		}
	}

	public void excuteQuery(String query) throws CambiosBDDaoError {
		Session session = this.sesionFactoryFacade.getSession(this);
		try {
			queryExecutor.sqlRunExecuteUpdate(session, query);
		} finally {
			cerrarSesionBbdd(session);
		}
	}

	@SuppressWarnings("rawtypes")
	public void marcarComoEnviadosMarcadosComun(CambiosList listPendientes, DetectorCambiosBD infoTablas,
			Class<?> dtoClass) throws Exception {
		boolean cambios = false;
		if (listPendientes != null && !listPendientes.isEmpty()) {
			String pkMdodificadas = "(";
			FieldInfo[] fields = getDtoFields(dtoClass);
			String columns = columns4Select(fields, infoTablas.clavePrimaria());

			String[] tokens = infoTablas.clavePrimariaJson().toLowerCase().split("_");
			String dtoPk = "get";
			for (String token : tokens) {
				dtoPk = dtoPk.concat(token.substring(0, 1).toUpperCase() + token.substring(1));
			}

			for (int i = 0; i < listPendientes.size(); i++) {
				WebcomRESTDto cambio = (WebcomRESTDto) listPendientes.get(i);
				if (restApi.getValue(cambio, dtoClass, dtoPk) == null) {
					continue;
				}

				String id = null;
				if (restApi.getValue(cambio, dtoClass, dtoPk) instanceof LongDataType) {
					Long idAux = ((LongDataType) restApi.getValue(cambio, dtoClass, dtoPk)).getValue();
					id = String.valueOf(idAux);
				} else if (restApi.getValue(cambio, dtoClass, dtoPk) instanceof StringDataType) {
					id = ((StringDataType) restApi.getValue(cambio, dtoClass, dtoPk)).getValue();
				} else {
					throw new Exception("La clave primaria ha de ser LongDataType O StringDataType");
				}

				if (pkMdodificadas != null && !pkMdodificadas.equals("(")) {
					pkMdodificadas = pkMdodificadas.concat(",");
				}
				
				if(pkMdodificadas != null) {
					pkMdodificadas = pkMdodificadas.concat(id);
				}
				cambios = true;

			}

			pkMdodificadas = pkMdodificadas + ")";

			Session session = this.sesionFactoryFacade.getSession(this);
			Transaction tx = session.beginTransaction();
			if (cambios) {
				try {
					// borramos del historico las filas modificadas

					String querydelete = "DELETE FROM " + infoTablas.nombreTablaDatosHistoricos() + WHERE
							+ infoTablas.clavePrimariaJson() + IN + pkMdodificadas;

					queryExecutor.sqlRunExecuteUpdate(session, querydelete, infoTablas);

					// insertamos en el historico las filas modificada
					String queryInsert = "INSERT INTO " + infoTablas.nombreTablaDatosHistoricos() + "(" + columns + ")"
							+ SELECT + columns + FROM + infoTablas.nombreVistaDatosActuales().concat(MARCADOR_CAMBIOS)
							+ WHERE + infoTablas.clavePrimariaJson() + IN + pkMdodificadas;

					queryExecutor.sqlRunExecuteUpdate(session, queryInsert);
					tx.commit();

				} catch (Exception e) {
					logger.fatal(
							"Error al marcar como enviados los registros de la BD. Realizando rollback de la transacción.");
					tx.rollback();
					throw e;
				} finally {
					cerrarSesionBbdd(session);
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
	 * Para ello inserta "_" como separador y convierte to do a mayúsculas
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
	@Override
	public void setEntitySessionFactory(SessionFactory entitySessionFactory) {
		super.setSessionFactory(entitySessionFactory);
	}

	/**
	 * Refresca la vista materializada
	 * 
	 * @param infoTablas
	 */
	public void refreshMaterializedView(InfoTablasBD infoTablas) throws CambiosBDDaoError {

		trace("[DETECCIÓN CAMBIOS] Refrescando vista matarializada: " + infoTablas.nombreVistaDatosActuales());
		

		// antes de refrescar la vista principal refrescamos las auxiliares
		if (infoTablas.vistasAuxiliares() != null) {
			for (String vistaAux : infoTablas.vistasAuxiliares()) {
				if (!vistaAux.isEmpty()) {
					trace("[DETECCIÓN CAMBIOS] Refrescando vista matarializada: " + vistaAux);
					this.refreshMaterializedView(vistaAux);
				}
			}
		}
		String nombreVistaDatosActuales = infoTablas.nombreVistaDatosActuales();
		if (infoTablas.procesarSoloCambiosMarcados()) {
			nombreVistaDatosActuales = nombreVistaDatosActuales.concat(MARCADOR_CAMBIOS);
		}
		this.refreshMaterializedView(nombreVistaDatosActuales);
	}

	private void refreshMaterializedView(String nombreVista) throws CambiosBDDaoError {
		Session session = this.sesionFactoryFacade.getSession(this);
		try {
			String sqlRefreshViews = "BEGIN DBMS_SNAPSHOT.REFRESH( '" + nombreVista
					+ "','C',atomic_refresh=>FALSE); end;";
			queryExecutor.sqlRunExecuteUpdate(session, sqlRefreshViews);
		} finally {
			cerrarSesionBbdd(session);
		}
	}

	private String paginarConsulta(CambiosList cambios, String columns, String queryString, InfoTablasBD infoTabla) {
		String clavePrimaria = infoTabla.clavePrimariaJson(), query = "";
		if (cambios.getPaginacion().getTamanyoBloque() != null) {
			query = "SELECT " + columns + ", DENSE_RANK() OVER(ORDER BY " + clavePrimaria + ") "
					+ "AS NUM_FILAS FROM (SELECT "
					+ "DENSE_RANK() OVER(ORDER BY CONSULTA." + clavePrimaria + ") " 
					+ "AS CONTADOR, CONSULTA.* FROM(" + queryString
					+ ") CONSULTA) WHERE CONTADOR > "
					+ String.valueOf(
							cambios.getPaginacion().getTamanyoBloque() * cambios.getPaginacion().getNumeroBloque())
					+ " AND CONTADOR < " + String.valueOf(((cambios.getPaginacion().getNumeroBloque() + 1)
							* cambios.getPaginacion().getTamanyoBloque()) + 1);
		}
		return query;
	}

	private void cerrarSesionBbdd(Session session) {
		if (logger.isDebugEnabled()) {
			logger.trace("Cerrando sesión");
		}
		if (session != null) {
			if (session.isOpen()) {
				session.close();
			}
		}
	}
	
	/**
	 * Obtiene el historico del bloque
	 * 
	 * @param session
	 * @param columns
	 * @param infoTablas
	 * @param resultado
	 * @return
	 * @throws CambiosBDDaoError
	 */

	public List<Object[]> obtenerHistoricosBloque(Session session, String columns, InfoTablasBD infoTablas,
												  List<Object[]> resultado) throws CambiosBDDaoError{
		List<Object[]> historicos = null;

		if (resultado != null && !resultado.isEmpty()) {
			String selectDatoHistorico = SELECT + columns + FROM + infoTablas.nombreTablaDatosHistoricos() + WHERE;
			int posPk = posicionColumna(columns, infoTablas.clavePrimaria());
			boolean primeraIteracion = true;
			for (Object[] r : resultado) {
				String condicion = infoTablas.clavePrimaria() + " = " + r[posPk];
				if (!primeraIteracion) {
					selectDatoHistorico = selectDatoHistorico.concat(OR);
				} else {
					primeraIteracion = false;
				}
				selectDatoHistorico = selectDatoHistorico.concat(condicion);
			}
			historicos = queryExecutor.sqlRunList(session, selectDatoHistorico, infoTablas);

		}

		return historicos;
	}
	
	/**
	 * Obtiene un registro del bloque de historicos
	 * 
	 * @param historicos
	 * @param posPk
	 * @param calveaBuscar
	 * @return
	 */
	private Object[] obtenerRegistroHistorico(List<Object[]> historicos,int posPk,Object calveaBuscar){
		if (historicos != null && !historicos.isEmpty()) {
			for (Object[] r : historicos) {
				if(calveaBuscar.equals(r[posPk])){
					return r;
				}
			}
			
		}
		return null;
	}
	
	private void trace(String mensaje) {
		Boolean webcomSimulado = Boolean.valueOf(WebcomRESTDevonProperties.extractDevonProperty(appProperties,
				WebcomRESTDevonProperties.WEBCOM_SIMULADO, "true"));
		if (webcomSimulado) {
			logger.error(mensaje);
		} else {
			logger.trace(mensaje);
		}

	}

}
