package es.capgemini.pfs.dsm;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.DevonPropertiesConstants;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * TODO Documentar.
 *
 * @author Nicolás Cornaglia
 */
public class EntityDataSource extends AbstractRoutingDataSource {

	private static Log log = LogFactory.getLog(EntityDataSource.class);

	@Autowired
	DataSourceManager dataSourceManager;
	
	@Resource
	private Properties appProperties;
	
	private Map<Long, String> mappingCache = new HashMap<Long, String>();

	/**
	 * setea el datasource.
	 * 
	 * @return id
	 */
	@Override
	protected Object determineCurrentLookupKey() {
		Long dbId = DataSourceManager.NO_DATASOURCE_ID;
		UsuarioSecurity usuario = (UsuarioSecurity) SecurityUtils
				.getCurrentUser();
		if (usuario == null) {
			if (DbIdContextHolder.getDbId() == null) {
				dbId = DataSourceManager.NO_DATASOURCE_ID;
			} else {
				dbId = DbIdContextHolder.getDbId();
			}
		} else {
			if (usuario.getEntidad() != null) {
				dbId = usuario.getEntidad().getId();
			} else {
				dbId = DataSourceManager.MASTER_DATASOURCE_ID;
			}
			
			Usuario usu = dataSourceManager.getUsuarioMultiEntidad(usuario.getId());
			if(!usu.getEntidad().getId().equals(usuario.getEntidad().getId())) {
				dbId = usu.getEntidad().getId();
			}
		}

		if (log.isTraceEnabled()) {
			log.trace("Retornando ID de BD [" + dbId + "]");
		}
		return dbId;

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
		// Sobreescribimos el método para añadirle la gestión de los usuarios
		// transaccionales
		Connection cnx = super.getConnection();
		TransactionalUsersConnectionWrapper cnwrap = new TransactionalUsersConnectionWrapper(cnx);

		String transactionalUsers = appProperties
				.getProperty(DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_KEY);

		if (DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_VALUE_YES
				.equals(transactionalUsers)) {
			cambiaCurrentSchema(cnwrap);
			return cnwrap;
		} else {
			return cnx;
		}
	}

	
	public Connection getConnectionMultientidad(String schema) throws SQLException {
		// Sobreescribimos el método para añadirle la gestión de los usuarios
		// transaccionales
		Connection cnx = super.getConnection();
		TransactionalUsersConnectionWrapper cnwrap = new TransactionalUsersConnectionWrapper(cnx);
		cambiaCurrentSchemaMultientidad(cnwrap, schema);
		return cnx;
	}

	
	
	@Override
	public Connection getConnection(String username, String password)
			throws SQLException {
		// Sobreescribimos el método para añadirle la gestión de los usuarios
		// transaccionales
		Connection cnx = super.getConnection(username, password);
		TransactionalUsersConnectionWrapper cnwrap = new TransactionalUsersConnectionWrapper(cnx);

		String transactionalUsers = appProperties
				.getProperty(DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_KEY);

		if (DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_VALUE_YES
				.equals(transactionalUsers)) {
			cambiaCurrentSchema(cnwrap);
		}
		return cnx;
	}

	/**
	 * Ejecuta ALTER SESSION en Oracle para cambiar el current_schema
	 * 
	 * @param cnx
	 *            Conexión
	 * @throws SQLException
	 *             Si ocurre cualquier problema al ejecutar el cambio de schema
	 * @throws RecoveryDSMConfigurationException
	 *             Si falta por configurar cualquier cosa en devon.properties
	 */
	private void cambiaCurrentSchema(TransactionalUsersConnectionWrapper cnx) throws SQLException {
		Long dbId = (Long) determineCurrentLookupKey();
		if (!DataSourceManager.NO_DATASOURCE_ID.equals(dbId)) {
			Statement st = cnx.createStatement();
			if (DataSourceManager.MASTER_DATASOURCE_ID.equals(dbId)) {
				log.debug("Cambiando la sesión de la BBDD: master");
				String masterSchema = appProperties
						.getProperty(DevonPropertiesConstants.DatabaseConfig.MASTER_SCHEMA_KEY);
				String sql = "ALTER SESSION SET CURRENT_SCHEMA = "
						+ masterSchema;
				cnx.setCurrentSchema(masterSchema);
				log.debug(sql);
				st.execute(sql);

			} else {
				log.debug("Cambiando la sesión de la BBDD: entity");
				String mapping = appProperties
						.getProperty(DevonPropertiesConstants.DatabaseConfig.TRANSACTIONAL_USER_MAPPING_KEY);
				try {
					String entitySchema = schemaMapeadoParaEntidad(dbId,
							mapping);
					String sql = "ALTER SESSION SET CURRENT_SCHEMA = "
							+ entitySchema;
					cnx.setCurrentSchema(entitySchema);
					log.debug(sql);
					st.execute(sql);
				} catch (RecoveryDSMConfigurationException ce) {
					log.fatal("No se ha podido cambiar el current_schema por problemas con el mapeo de usuarios transaccionales");
					throw ce;
				}
			}
		}
	}
	
	private void cambiaCurrentSchemaMultientidad(TransactionalUsersConnectionWrapper cnx, String schema) throws SQLException {
		Statement st = cnx.createStatement();
		String sql = "ALTER SESSION SET CURRENT_SCHEMA = "
				+ schema;
		cnx.setCurrentSchema(schema);
		log.debug(sql);
		st.execute(sql);
	}

	/**
	 * Devuelve el usuario mapeado para un determinado id de entidd
	 * 
	 * @param dbId
	 *            Id de entidad
	 * @param mapping
	 *            Mapeo obtenido de devon.properties
	 * @return
	 * @throws RecoveryDSMConfigurationException
	 *             Si hay cualquier problema de configuración
	 */
	private String schemaMapeadoParaEntidad(Long dbId, String mapping) {
		log.debug("Buscando mapeo para dbId = " + dbId + " en [" + mapping + "]");
		String schema = mappingCache.get(dbId);
		if (schema != null) {
			log.debug("Valor recuperado de la caché");
			return schema;
		} else {
			if (mapping != null) {
				String[] mappingArray = mapping.split(";");
				log.debug("Se han encontrado " + mappingArray.length
						+ " mapeos");
				for (String m : mappingArray) {
					log.debug("Mapeo actual = [" + m + "]");
					String[] subArray = m.split("->");
					if (subArray.length == 2) {
						try {
							Long schemaId = Long.parseLong(subArray[0].trim());
							log.debug("Schema id actual = " + schemaId);
							schema = subArray[1];
							if (schemaId.equals(dbId)) {
								// Tan pronto encontramos el mapeo salimos del
								// método
								log.debug("Coincide con el buscado");
								log.debug("Guardando el valor en la caché");
								mappingCache.put(dbId, schema);
								return schema;
							} else {
								log.debug("No coincide con el buscado");
							}

						} catch (NumberFormatException nfe) {
							throw new RecoveryDSMConfigurationException(m
									+ ": El id de entidad debe ser un entero");
						}
					} else {
						throw new RecoveryDSMConfigurationException(
								m
										+ ": El mapeo de usuarios transaccionales no es correcto");
					}
				}
				// Si conseguimos terminar del for sin salir del método es que
				// no
				// hemos encontrado el mapeo para la entidad
				throw new RecoveryDSMConfigurationException(
						DevonPropertiesConstants.DatabaseConfig.TRANSACTIONAL_USER_MAPPING_KEY
								+ ": No se ha encontrado el mapeo para el id de entidad ["
								+ dbId + "]");
			} else {
				throw new RecoveryDSMConfigurationException(
						DevonPropertiesConstants.DatabaseConfig.TRANSACTIONAL_USER_MAPPING_KEY
								+ ": se requiere definición en devon.properties al activar usuarios transaccionales");
			}
		}
	}
}
