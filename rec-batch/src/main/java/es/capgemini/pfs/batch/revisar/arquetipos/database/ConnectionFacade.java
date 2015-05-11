package es.capgemini.pfs.batch.revisar.arquetipos.database;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotCommitOrCloseConnectionException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotExecuteDDLException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotExecuteInsertException;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.CannotOpenConnectionException;
import es.capgemini.pfs.dsm.EntityDataSource;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.rule.dd.dao.DDRuleDao;

/**
 * Clase fachada para las operaciones contra la BBDD.
 * 
 * @author bruno
 *
 */
@Component
public class ConnectionFacade {
	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private EntityDataSource entityDataSource;

	@Autowired
	private DDRuleDao ruleDao;

	/**
	 * Abre la conexión con la BBDD
	 * 
	 * @throws CannotOpenConnectionException
	 */
	public Connection openConnection() throws CannotOpenConnectionException {
		logger.debug("Abriendo conexión");
		Connection connection = null;
		try {
			connection = entityDataSource.getConnection();
		} catch (SQLException e) {
			logger.error("No se ha podido abrir la conexión");
			throw new CannotOpenConnectionException(e);
		}
		return connection;
	}

	/**
	 * Ejectuta una sentencia INSERT contra la BBDD
	 * 
	 * @param connection
	 * @param sql
	 * @param verboseOnError
	 *            Si es verdadero escribe en el log cualquier error que se
	 *            produce. Si es falso sólo lanza la excepción, sin escribir en
	 *            el log.
	 * @throws CannotExecuteInsertException
	 */
	public long executeInsert(final Connection connection, final String sql,
			final boolean verboseOnError) throws CannotExecuteInsertException {
		try {
			logger.debug("[SQL]" + sql);
			return connection.prepareStatement(sql).executeUpdate();
		} catch (SQLException e) {
			if (verboseOnError) {
				logger.error("[ERROR]" + sql, e);
			}
			throw new CannotExecuteInsertException(e, sql);
		}

	}

	/**
	 * Ejectuta una sentencia DDL contra la BBDD
	 * 
	 * @param connection
	 * @param sql
	 * @param verboseOnError
	 *            Si es verdadero escribe en el log cualquier error que se
	 *            produce. Si es falso sólo lanza la excepción, sin escribir en
	 *            el log.
	 * @throws CannotExecuteInsertException
	 */
	public void executeDDL(final Connection connection, final String sql,
			final boolean verboseOnError) throws CannotExecuteDDLException {
		try {
			logger.debug("[DDL]" + sql);
			connection.prepareStatement(sql).executeUpdate();
		} catch (SQLException e) {
			if (verboseOnError) {
				logger.error("[ERROR]" + sql, e);
			}
			throw new CannotExecuteDDLException(e, sql);
		}

	}

	/**
	 * Comitea y cierra la conexión
	 * 
	 * @throws CannotCommitOrCloseConnectionException
	 */
	public void commitAndClose(final Connection connection)
			throws CannotCommitOrCloseConnectionException {
		try {
			logger.debug("Commit");
			connection.commit();
			logger.debug("Cerrando conexión");
			connection.close();
		} catch (SQLException e) {
			throw new CannotCommitOrCloseConnectionException(e);
		}

	}

	/**
	 * Refresca una vista materializada.
	 * 
	 * @param viewName
	 */
	public void refreshView(final String viewName) {
		if (!StringUtils.isEmpty(viewName)) {
			logger.debug("Refrescando vista: " + viewName);
			final RuleExecutorConfig conf = new RuleExecutorConfig();
			conf.setTableFrom(viewName);
			ruleDao.regenerateData(conf);
		} else {
			logger.warn("Nombre de vista vacío, no se refresca.");
		}

	}

}
