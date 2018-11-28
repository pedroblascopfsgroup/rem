package es.capgemini.pfs.dsm;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Logger;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import es.pfsgroup.recovery.txdatasource.TransactionalBasicDataSourceWrapper;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
public class EntityDataSource extends AbstractRoutingDataSource {

	private static Log log = LogFactory.getLog(EntityDataSource.class);
	
	@Resource
	private Properties appProperties;
        
        @Autowired
        private TransactionalBasicDataSourceWrapper transactionalBasicDataSourceWrapper;


	@SuppressWarnings("unused")
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
	@SuppressWarnings("rawtypes")
	public void registerTargetDataSources(Map targetDataSources) {
		setTargetDataSources(targetDataSources);
		super.afterPropertiesSet();
	}

	@Override
	public Connection getConnection() throws SQLException {
            // Sobreescribimos el método para añadirle la gestión de los usuarios
            // transaccionales si aplica
            log.debug("***&*** Ha llamado a EntityDataSource.getConnection() ");
            return transactionalBasicDataSourceWrapper.getConnectionTx(super.getConnection());
	}

	
	public Connection getConnectionMultientidad(String schema) throws SQLException {
		// Sobreescribimos el método para añadirle la gestión de los usuarios
		// transaccionales
		
		return transactionalBasicDataSourceWrapper.getConnectionTxMultientidad(super.getConnection(), schema);
		
	}

	
	@Override
	public Connection getConnection(String username, String password)
			throws SQLException {
            // Sobreescribimos el método para añadirle la gestión de los usuarios
            // transaccionales si aplica
            log.debug("***&*** Ha llamado a EntityDataSource.getConnection() ");
            return transactionalBasicDataSourceWrapper.getConnectionTx(super.getConnection(username, password));
	}

	@Override
	public Logger getParentLogger() throws SQLFeatureNotSupportedException {
		// TODO Auto-generated method stub
		return null;
	}
	
}
