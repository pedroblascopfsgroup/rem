package es.capgemini.pfs.batch.load;

/**
 * Define las constantes comunes para todos los procesos carga batch.
 * @author aesteban
 *
 */
public interface BatchLoadConstants {

    String SOURCE_CHANNEL_KEY = "sourceChannel";
    String CHAIN_END = "END";

    //Se usa para los parámetros
    String ZIP = "zip";
    String TXT = "txt";
    String CSV = "csv";

    String ENTIDAD = "entidad";
    String FILENAME = "fileName";
    String EXTRACTTIME = "extractTime";
    String PATHTOEXTRACT = "pathToExtract";
    String ZIPFILE = "zipFile";
    String ZIPFILETOEXTRACT = "zipFilesToExtract";
    String PATHTOSQLLOADER = "pathToSqlLoader";
    String CONNECTIONINFO = "connectionInfo";
    String SQLLOADERPARAM = "sqlLoaderParameters";
}
