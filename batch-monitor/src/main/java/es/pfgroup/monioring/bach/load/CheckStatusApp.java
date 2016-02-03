package es.pfgroup.monioring.bach.load;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;

import es.pfgroup.monioring.bach.load.dao.CheckStatusDao;
import es.pfgroup.monioring.bach.load.dao.CheckStatusDaoOracleJdbcImpl;
import es.pfgroup.monioring.bach.load.dao.jdbc.JDBCConnectionFacace;
import es.pfgroup.monioring.bach.load.dao.jdbc.OracleJdbcEncryptedFacade;
import es.pfgroup.monioring.bach.load.dao.jdbc.OracleJdbcFacade;
import es.pfgroup.monioring.bach.load.dao.model.query.OracleModelQueryBuilder;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusErrorType;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusMalfunctionError;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusRecoverableException;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusUserError;
import es.pfgroup.monioring.bach.load.exceptions.CheckStatusWrongArgumentsException;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogic;
import es.pfgroup.monioring.bach.load.logic.CheckStatusLogicImpl;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceService;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitenceServiceImpl;
import es.pfgroup.monioring.bach.load.persistence.CheckStatusPersitentFile;
import es.pfgroup.monioring.bach.load.persistence.utils.CheckStatusFileStreamBuilder;

/**
 * Apicación que checkea el estado de una carga del batch.
 * 
 * @author bruno
 * 
 */
public class CheckStatusApp {

    private static final String CLAVE_PASSWORD = "dsm.prot.cnts";
	private static final String PW_NO_CODIFICADA = "NO";
	private static final String PW_CODIFICADA = "SI";

	/**
     * Método main que ejecuta la aplicación
     * 
     * @param args
     *            Se espera recibir los siguientes argumentos [codigoEntidad,
     *            nombreJob]
     */
    public static void main(String[] args) {
        
        try {
            final CheckStatusApp application = createApplication();
            final CheckStatusResult status = application.run(args);

            System.out.println(status);
            System.exit(status.ordinal());
        } catch (FileNotFoundException e) {
            throw new CheckStatusMalfunctionError(e);
        } catch (IOException e) {
            throw new CheckStatusMalfunctionError(e);
        }

    }

    public final static CheckStatusApp createApplication() throws IOException, FileNotFoundException {
        final Properties appProperties = new Properties();
        appProperties.load(new FileInputStream("jdbc.properties"));
        final CheckStatusPersitentFile persistentFile = new CheckStatusPersitentFile("run.data");
        final CheckStatusFileStreamBuilder fileStreamBuilder = new CheckStatusFileStreamBuilder();

        JDBCConnectionFacace connectionFacade = null;
        
        /*
         * Instanciamos una fachada u otra dependiendo de las preferencias de encriptado.
         */
        if (appProperties.getProperty(CLAVE_PASSWORD,
        		PW_NO_CODIFICADA).equalsIgnoreCase(
				PW_CODIFICADA)) {
        	connectionFacade = new OracleJdbcEncryptedFacade(appProperties);
        }else{
        	connectionFacade = new OracleJdbcFacade(appProperties);
        	
        }
        
        final CheckStatusDao dao = new CheckStatusDaoOracleJdbcImpl(connectionFacade, new OracleModelQueryBuilder());
        final CheckStatusLogic businessLogic = new CheckStatusLogicImpl(dao);
        final CheckStatusPersitenceService persistenceService = new CheckStatusPersitenceServiceImpl(persistentFile, fileStreamBuilder);

        final CheckStatusApp application = new CheckStatusApp(businessLogic, persistenceService);
        return application;
    }
    

    public CheckStatusLogic getBusinessLogic() {
		return businessLogic;
	}

	public CheckStatusPersitenceService getPersistenceService() {
		return persistenceService;
	}
	
	public CSConfigSingleton getConfig(){
		return CSConfigSingleton.getInstance();
	}


	final private CheckStatusLogic businessLogic;
    final private CheckStatusPersitenceService persistenceService;

    /**
     * Inicializa la aplicación inyectándole la lógica de negocio.
     * 
     * @param logic
     *            Implementación de la lógica de negocio.
     * @param persistenceService
     *            Capa de persistencia para los datos sobre la ejecución del
     *            monitor.
     */
    public CheckStatusApp(final CheckStatusLogic logic, final CheckStatusPersitenceService persistenceService) {
        this.businessLogic = logic;
        this.persistenceService = persistenceService;
    }

    /**
     * Comprueba el estado de una carga del batch.
     * 
     * @param arguments
     *            Se espera recibir los siguientes argumentos [codigoEntidad,
     *            nombreJob]
     * @return Devuelve el resultado de la comprobación.
     */
    public CheckStatusResult run(String[] arguments) {
        if ((arguments == null) || (arguments.length < 2)) {
            throw new CheckStatusUserError(CheckStatusErrorType.MISSING_ARGUMENTS);
        }
        
        try {
            final int entity = Integer.parseInt(arguments[0]);
            final String jobName = arguments[1];
            final Date lastTime = persistenceService.getLastCheckStatusTimeOrNull(entity,jobName);
            
            final BatchExecutionData execData = businessLogic.getExecutionInfo(entity, jobName, lastTime);
            
            if (execData.isRunning()){
                return CheckStatusResult.RUNNING;
            }else if (execData.hasErrors()){
                return CheckStatusResult.ERROR;
            }else if (execData.hasExecuted()){
                persistenceService.saveCheckStatusTime(entity,jobName);
                return CheckStatusResult.OK;
            }else{
                return CheckStatusResult.NOT_EXECUTED;
            }
            
            
        } catch (CheckStatusWrongArgumentsException e) {
            throw new CheckStatusMalfunctionError(e);
        } catch (CheckStatusRecoverableException e) {
        	throw new CheckStatusMalfunctionError(e);
		}

    }

}
