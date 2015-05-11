package es.pfsgroup.plugin.recovery.masivo.api;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVFileItem;

/**
 * Manager encargado de la gestión de ficheros.
 * @author manuel
 *
 */
public interface MSVFileManagerApi {

	final public static String MSV_BO_UPLOAD_FICHERO = "es.pfsgroup.plugin.recovery.masivo.api.MSVFileManagerApi.uploadFile";
	final public static String MSV_BO_GET_FILE = "es.pfsgroup.plugin.recovery.masivo.api.MSVFileManagerApi.getFile";

	/**
	 * Guarda un fichero en base de datos.
	 * 
	 * @param fileItem objeto que contiene el fichero.
	 * @return resultado de la subida del fichero.
	 *
	 * @throws BusinessOperationException Si los parámetros de entrada son nulos devuelve una excepción.
	 * 
	 */
	// DIANA: cambiamos este método para pasarle en objeto webfileitem donde está el tipo de fichero
	@BusinessOperationDefinition(MSV_BO_UPLOAD_FICHERO)
	MSVDtoResultadoSubidaFicheroMasivo uploadFile(WebFileItem uploadForm) throws BusinessOperationException;
	
	/**
	 * Devuelve un fichero de la base de datos.
	 * 
	 * @param idFichero id del fichero 
	 * @return Devuelve un objeto MSVFileItem con toda la información necesaria sobre un fichero.
	 * @throws BusinessOperationException Si el parámetro de entrada idFichero es nulo lanza una excepción.
	 */
	@BusinessOperationDefinition(MSV_BO_GET_FILE)
	MSVFileItem getFile(Long idFichero) throws BusinessOperationException;

}
