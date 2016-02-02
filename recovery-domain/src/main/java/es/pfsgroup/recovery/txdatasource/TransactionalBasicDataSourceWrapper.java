package es.pfsgroup.recovery.txdatasource;

import es.capgemini.pfs.dsm.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.dbcp.BasicDataSource;

import org.springframework.stereotype.Component;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.DevonPropertiesConstants;
import es.capgemini.pfs.security.model.UsuarioSecurity;

/**
 * TODO Documentar.
 *
 * @author Bruno Angl�s / JoseVi Jimenez
 */
@Component
public class TransactionalBasicDataSourceWrapper {

    @javax.annotation.Resource
    private Properties appProperties;

    private static Log log = LogFactory.getLog(TransactionalBasicDataSourceWrapper.class);

    private final Map<Long, String> mappingCache = new HashMap<Long, String>();

    
   /**
     * M�todo getConnection(super.conn) utilizado para reemplazar a los de clases DataSource superiores
     * 
     * @param conn
     *            Conexi�n creada en el DS superior
     * @throws SQLException
     *             Si ocurre cualquier problema con el manejo de conexiones
     */
 
    public Connection getConnectionTx(Connection conn) throws SQLException {
            // Sobreescribimos el m�todo para a�adirle la gesti�n de los usuarios
            // transaccionales
            log.debug("***&*** Ha llamado a TransactionalBasicDataSourceWrapper.getConnection() ");
            //Connection cnx = conn.getConnection();

            TransactionalUsersConnectionWrapper cnwrap = new TransactionalUsersConnectionWrapper(conn);

            String transactionalUsers = appProperties
                            .getProperty(DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_KEY);

            if (DevonPropertiesConstants.DatabaseConfig.USE_TRANSACTIONAL_USERS_VALUE_YES
                            .equals(transactionalUsers)) {
                    log.debug("***&***  Se detecta entorno TRANSACCIONAL, se ejecuta ALTER CURRENT SCHEMA ");
                    cambiaCurrentSchema(cnwrap);
                    return cnwrap;
            } else {
                    log.debug("***&*** Se detecta entorno PROPIETARIO ");
                    return conn;
            }
    }

 

    /**
     * Ejecuta ALTER SESSION en Oracle para cambiar el current_schema
     * 
     * @param cnx
     *            Conexi�n
     * @throws SQLException
     *             Si ocurre cualquier problema al ejecutar el cambio de schema
     * @throws RecoveryDSMConfigurationException
     *             Si falta por configurar cualquier cosa en devon.properties
     */
    public void cambiaCurrentSchema(TransactionalUsersConnectionWrapper cnx) throws SQLException {
            Long dbId = (Long) determineCurrentLookupKey();
            if (!DataSourceManager.NO_DATASOURCE_ID.equals(dbId)) {
                    Statement st = cnx.createStatement();
                    if (DataSourceManager.MASTER_DATASOURCE_ID.equals(dbId)) {
                            log.debug("Cambiando la sesi�n de la BBDD: master");
                            String masterSchema = appProperties
                                            .getProperty(DevonPropertiesConstants.DatabaseConfig.MASTER_SCHEMA_KEY);
                            String sql = "ALTER SESSION SET CURRENT_SCHEMA = "
                                            + masterSchema;
                            cnx.setCurrentSchema(masterSchema);
                            log.debug(sql);
                            st.execute(sql);

                    } else {
                            log.debug("Cambiando la sesi�n de la BBDD: entity");
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

    /**
     * Devuelve el usuario mapeado para un determinado id de entidd
     * 
     * @param dbId
     *            Id de entidad
     * @param mapping
     *            Mapeo obtenido de devon.properties
     * @return
     * @throws RecoveryDSMConfigurationException
     *             Si hay cualquier problema de configuraci�n
     */
    private String schemaMapeadoParaEntidad(Long dbId, String mapping) {
            log.debug("Buscando mapeo para dbId = " + dbId + " en [" + mapping + "]");
            String schema = mappingCache.get(dbId);
            if (schema != null) {
                    log.debug("Valor recuperado de la cach�");
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
                                                            // m�todo
                                                            log.debug("Coincide con el buscado");
                                                            log.debug("Guardando el valor en la cach�");
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
                            // Si conseguimos terminar del for sin salir del m�todo es que
                            // no
                            // hemos encontrado el mapeo para la entidad
                            throw new RecoveryDSMConfigurationException(
                                            DevonPropertiesConstants.DatabaseConfig.TRANSACTIONAL_USER_MAPPING_KEY
                                                            + ": No se ha encontrado el mapeo para el id de entidad ["
                                                            + dbId + "]");
                    } else {
                            throw new RecoveryDSMConfigurationException(
                                            DevonPropertiesConstants.DatabaseConfig.TRANSACTIONAL_USER_MAPPING_KEY
                                                            + ": se requiere definici�n en devon.properties al activar usuarios transaccionales");
                    }
            }
    }

    public Object determineCurrentLookupKey() {
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
            }

            if (log.isTraceEnabled()) {
                    log.trace("Retornando ID de BD [" + dbId + "]");
            }
            return dbId;

    }
        
}
