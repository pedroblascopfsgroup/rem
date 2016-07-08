package es.pfsgroup.framework.paradise.bulkUpload.api;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVFileItem;


/**
 * Manager encargado de la gesti�n de ficheros.
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
	 * @throws BusinessOperationException Si los par�metros de entrada son nulos devuelve una excepci�n.
	 * 
	 */
	// DIANA: cambiamos este m�todo para pasarle en objeto webfileitem donde est� el tipo de fichero
	@BusinessOperationDefinition(MSV_BO_UPLOAD_FICHERO)
	MSVDtoResultadoSubidaFicheroMasivo uploadFile(WebFileItem uploadForm) throws BusinessOperationException;
	
	/**
	 * Devuelve un fichero de la base de datos.
	 * 
	 * @param idFichero id del fichero 
	 * @return Devuelve un objeto MSVFileItem con toda la informaci�n necesaria sobre un fichero.
	 * @throws BusinessOperationException Si el par�metro de entrada idFichero es nulo lanza una excepci�n.
	 */
	@BusinessOperationDefinition(MSV_BO_GET_FILE)
	MSVFileItem getFile(Long idFichero) throws BusinessOperationException;

}
