package es.capgemini.pfs.dsm;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import es.pfsgroup.recovery.txdatasource.TransactionalBasicDataSourceWrapper;

/**
 * TODO Documentar.
 *
 * @author Nicol�s Cornaglia
 */
public class EntityDataSource extends AbstractRoutingDataSource {

	private static Log log = LogFactory.getLog(EntityDataSource.class);

	@Resource
	private Properties appProperties;
        
        @Autowired
        private TransactionalBasicDataSourceWrapper transactionalBasicDataSourceWrapper;

	private Map<Long, String> mappingCache = new HashMap<Long, String>();

	/**
	 * setea el datasource.
	 * 
	 * @return id
	 */
	@Override
	protected Object determineCurrentLookupKey() {
            return transactionalBasicDataSourceWrapper.determineCurrentLookupKey();
	}

	/**
	 * afterPropertiesSet.
	 */
	@Override
	public final void afterPropertiesSet() {
	}

	/**
	 * registerTargetDataSources.
	 * 
	 * @param targetDataSources
	 *            datasources
	 */
	@SuppressWarnings("unchecked")
	public void registerTargetDataSources(Map targetDataSources) {
		setTargetDataSources(targetDataSources);
		super.afterPropertiesSet();
	}

	@Override
	public Connection getConnection() throws SQLException {
            // Sobreescribimos el m�todo para a�adirle la gesti�n de los usuarios
            // transaccionales si aplica
            log.debug("***&*** Ha llamado a EntityDataSource.getConnection() ");
            return transactionalBasicDataSourceWrapper.getConnectionTx(super.getConnection());
	}

	@Override
	public Connection getConnection(String username, String password)
			throws SQLException {
            // Sobreescribimos el m�todo para a�adirle la gesti�n de los usuarios
            // transaccionales si aplica
            log.debug("***&*** Ha llamado a EntityDataSource.getConnection() ");
            return transactionalBasicDataSourceWrapper.getConnectionTx(super.getConnection(username, password));
	}

}
