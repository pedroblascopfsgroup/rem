package es.capgemini.devon.bo;

import es.capgemini.devon.bo.annotations.BusinessOperation;

/**
 * Clase de constantes para definir nombres de operaciones de negocio
 * 
 * @see BusinessOperation
 * @author Nicolás Cornaglia
 */
public final class FwkBusinessOperations {

    public static final String NAMESPACE = "http://www.capgemini.com/devon/schemas";

    // Echo
    public static final String ECHO = "echo";
    public static final String TRANSACTIONAL_ECHO = "transactionalEcho";

    // Profiler
    public static final String PROFILER_GET_STATISTICS = "getStatistics";
    public static final String PROFILER_CHANGE_STATISTICS_MODE = "changeStatisticsMode";
    public static final String PROFILER_RESET = "reset";

    // BusinessOperation Manager
    public static final String BO_OPERATIONS_LIST = "operationsList";

    // Hibernate
    public static final String HIBERNATE_GET_STATISTICS1 = "getStatistics1";
    public static final String HIBERNATE_GET_STATISTICS2 = "getStatistics2";
    public static final String HIBERNATE_CHANGE_STATISTICS_MODE1 = "changeStatisticsMode1";
    public static final String HIBERNATE_CHANGE_STATISTICS_MODE2 = "changeStatisticsMode2";
    public static final String HIBERNATE_CLEAR_SESSION1 = "clearSession1";
    public static final String HIBERNATE_CLEAR_SESSION2 = "clearSession2";

    // FileUpload
    public static final String FILEUPLOAD_SERVICE = "fileUploadManager";
    public static final String FILEUPLOAD_UPLOAD = "fileUpload.fileUpload";
    public static final String FILEUPLOAD_GET_PROGRESS_INFO = "fileUpload.getProgressInfo";

    /**
     * Esta clase no está hecha para instanciarse, solo para contener constantes
     */
    private FwkBusinessOperations() {

    }

}
