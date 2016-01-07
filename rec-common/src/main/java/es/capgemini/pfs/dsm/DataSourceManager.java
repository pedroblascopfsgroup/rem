package es.capgemini.pfs.dsm;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.lookup.JndiDataSourceLookup;

import es.capgemini.devon.dao.datasource.InitializingDataSourceFactoryBean;
import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.startup.Initializable;
import es.capgemini.pfs.DevonPropertiesConstants.DatabaseConfig;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.Encriptador;

/**
 * @author Nicol�s Cornaglia
 */
public class DataSourceManager implements Initializable {

	private static Log logger = LogFactory.getLog(EntityDataSource.class);

    public static final String JNDI_NAME_KEY = "jndiName";
    public static final String DRIVER_CLASS_NAME_KEY = "driverClassName";
    public static final String URL_KEY = "url";
    public static final String USER_NAME_KEY = "username";
    public static final String PASSWORD_KEY = "password";
    public static final String INITIAL_ID_KEY = "initialId";
    public static final String SCHEMA_KEY = "schema";
    public static final String PATH_TO_SQLLOADER = "pathToSqlLoader";
    public static final String CONTROL_FILE = "controlFile";
    public static final String CONNECTION_INFO = "connectionInfo";
    public static final String SQLLDR_PARAMS = "sqlLoaderParameters";

    public static final Long NO_DATASOURCE_ID = 0L;
    public static final Long MASTER_DATASOURCE_ID = -1L;
    
    @Autowired
    private EntidadDao entidadDao;
    
    @javax.annotation.Resource
    private EventManager eventManager;

    @javax.annotation.Resource
    private DataSource masterDataSource;

    @javax.annotation.Resource
    private EntityDataSource entityDataSource;

    @javax.annotation.Resource
    private Properties appProperties;

    private String[] initScripts;
    private String[] destroyScripts;
    private String flagTable;
    private boolean allwaysInitialize = false;

    private boolean preferJNDI = true;

    /**
     * Create the connections.
     *
     * @see es.capgemini.devon.startup.Initializable#initialize()
     */
    @Override
    public void initialize() {
        Map<Long, DataSource> targetDataSources = new HashMap<Long, DataSource>();

        List<Entidad> entidades = entidadDao.getList();
        for (Entidad entidad : entidades) {

            //String workingCode = entidad.configValue(Entidad.WORKING_CODE_KEY);
            String jndiName = entidad.configValue(JNDI_NAME_KEY);
            String driverClassName = entidad.configValue(DRIVER_CLASS_NAME_KEY);
            String url = entidad.configValue(URL_KEY);
            String username = entidad.configValue(USER_NAME_KEY);
            String password = entidad.configValue(PASSWORD_KEY);
            if (appProperties.getProperty(DatabaseConfig.ENABLE_PASSWORD_ENCRYPT_KEY,DatabaseConfig.ENABLE_PASSWORD_ENCRYPT_VALUE_NO).equalsIgnoreCase(DatabaseConfig.ENABLE_PASSWORD_ENCRYPT_VALUE_SI)) {
            	try {
                	String password_desencriptada = Encriptador.desencriptarPw(password);
		            if (url.indexOf(password)>0) {
		            	url = url.replace(password, password_desencriptada);
		            } else {
		            	System.out.println("Error en la formación de la url de " + username);
		            }
		            password = password_desencriptada;
				} catch (Exception e1) {
					System.out.println("Error al desencriptar password de " + username + ": "+ e1.getMessage());
				}            	
            }
            String initialId = entidad.configValue(INITIAL_ID_KEY);

            String info = "Entity [" + entidad.getId() + "] Datasource info [";
            if (jndiName != null && preferJNDI) {
                info += jndiName;
            } else {
                info += url;
            }
            info += "]";

        	logger.info(String.format("Inicializando DataSource entidad [%s]...", entidad.getDescripcion()));
            eventManager.fireEvent(EventManager.GENERIC_CHANNEL, "db processing [" + info + "]");

            InitializingDataSourceFactoryBean dataSourceFactory = new InitializingDataSourceFactoryBean();
            dataSourceFactory.setInfo(info);
            dataSourceFactory.setFlagTable(getFlagTable());
            dataSourceFactory.setInitScripts(getInitScripts());
            dataSourceFactory.setDestroyScripts(getDestroyScripts());
            dataSourceFactory.setAllwaysInitialize(allwaysInitialize());
            dataSourceFactory.setProperties(appProperties);

            DataSource innerDataSource = null;
            if (jndiName != null && preferJNDI) {
                // JNDI
                JndiDataSourceLookup jndiDataSourceLookup = new JndiDataSourceLookup();
                innerDataSource = jndiDataSourceLookup.getDataSource(jndiName);
            } else {
                // Commons DBCP
                innerDataSource = new BasicDataSource();
                ((BasicDataSource) innerDataSource).setDriverClassName(driverClassName);
                ((BasicDataSource) innerDataSource).setUrl(url);
                ((BasicDataSource) innerDataSource).setUsername(username);
                ((BasicDataSource) innerDataSource).setPassword(password);
            }

            DataSource dataSource = null;
            if (innerDataSource != null) {
                Map<String, Object> parameters = new HashMap<String, Object>();
                parameters.put("entidadId", entidad.getId());
                parameters.put("entidadDescripcion", entidad.getDescripcion());
                parameters.put("initialId", initialId);
                dataSourceFactory.setParameters(parameters);
                dataSourceFactory.setDataSource(innerDataSource);
                try {
                    dataSourceFactory.afterPropertiesSet();
                    // Force initialize
                    dataSource = (DataSource) dataSourceFactory.getObject();
                } catch (Exception e) {
                	logger.error(String.format("Error de conexión de Base de Datos a la entidad [%s]!!!", entidad.getDescripcion()), e);
                    eventManager.fireEvent(EventManager.ERROR_CHANNEL, new FrameworkException(e, "No se ha podido crear el datasource " + info));
                }
            }
            if (dataSource != null) {
            	logger.info("DataSource inicializado correctamente!");
                targetDataSources.put(entidad.getId(), dataSource);
            }
        }

        // Registrar datasources creados en el RoutingDatasource
    	logger.info("Inicializando DataSource entidad [MASTER]...");
        entityDataSource.setDefaultTargetDataSource(masterDataSource);
        targetDataSources.put(MASTER_DATASOURCE_ID, masterDataSource);
        entityDataSource.registerTargetDataSources(targetDataSources);
    	logger.info("DataSource inicializado correctamente!");
    }

    public Usuario getUsuarioMultiEntidad(Long id) {
    	return entidadDao.getUsuario(id);
    }
    
    /**
     * @return the masterDataSource
     */
    public DataSource getMasterDataSource() {
        return masterDataSource;
    }

    /**
     * @param masterDataSource the masterDataSource to set
     */
    public void setMasterDataSource(DataSource masterDataSource) {
        this.masterDataSource = masterDataSource;
    }

    /**
     * @return the entidadDao
     */
    public EntidadDao getentidadDao() {
        return entidadDao;
    }

    /**
     * @param entidadDao the entidadDao to set
     */
    public void setentidadDao(EntidadDao entidadDao) {
        this.entidadDao = entidadDao;
    }

    /**
     * @return the initScripts
     */
    public String[] getInitScripts() {
        return initScripts;
    }

    /**
     * @param initScripts the initScripts to set
     */
    public void setInitScripts(String[] initScripts) {
        this.initScripts = initScripts;
    }

    /**
     * @return the flagTable
     */
    public String getFlagTable() {
        return flagTable;
    }

    /**
     * @param flagTable the flagTable to set
     */
    public void setFlagTable(String flagTable) {
        this.flagTable = flagTable;
    }

    /**
     * @param entityDataSource EntityDataSource
     */
    public void setEntityDataSource(EntityDataSource entityDataSource) {
        this.entityDataSource = entityDataSource;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public int getOrder() {
        final int cien = 100;
        return cien;
    }

    /**
     * @param preferJNDI the preferJNDI to set
     */
    public void setPreferJNDI(boolean preferJNDI) {
        this.preferJNDI = preferJNDI;
    }

    /**
     * @return the destroyScripts
     */
    public String[] getDestroyScripts() {
        return destroyScripts;
    }

    /**
     * @param destroyScripts the destroyScripts to set
     */
    public void setDestroyScripts(String[] destroyScripts) {
        this.destroyScripts = destroyScripts;
    }

    /**
     * @return the allwaysInitialize
     */
    public boolean allwaysInitialize() {
        return allwaysInitialize;
    }

    /**
     * @param allwaysInitialize the allwaysInitialize to set
     */
    public void setAllwaysInitialize(boolean allwaysInitialize) {
        this.allwaysInitialize = allwaysInitialize;
    }

    /**
    * {@inheritDoc}
    */
    @Override
    public String toString() {
        return "DataSourceManager: [" + "order:" + getOrder() + ", allwaysInitialize:" + allwaysInitialize + ",preferJNDI:" + preferJNDI + "]";
    }

}
