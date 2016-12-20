package es.pfsgroup.plugin.rem.rest.api;

import java.io.IOException;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import es.pfsgroup.plugin.rem.rest.dto.FileListResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileResponse;
import es.pfsgroup.plugin.rem.rest.dto.FileSearch;
import es.pfsgroup.plugin.rem.rest.dto.FileUpload;
import es.pfsgroup.plugin.rem.rest.dto.OperationResult;

public interface GestorDocumentalFotosApi {

	/**
	 * Indica si la conexion con el gestor documental esta activa
	 * 
	 * @return
	 */
	public boolean isActive();

	/**
	 * Sube un fichero al gestor documental
	 * 
	 * @param file
	 * @return
	 */
	public FileResponse upload(FileUpload file) throws JsonGenerationException, JsonMappingException, IOException, Exception;
	
	public FileResponse upload(FileUpload file, java.io.File fileToUpload) throws JsonGenerationException, JsonMappingException, IOException, Exception;

	/**
	 * Borra un fichero del gestor documental
	 * 
	 * @param fileId
	 * @return
	 */
	public OperationResult delete(Integer fileId)
			throws JsonGenerationException, JsonMappingException, IOException, Exception;

	/**
	 * Busca los ficheros que cumplan los criterios de busqueda
	 * 
	 * @param fileSearch
	 * @return
	 */
	public FileListResponse get(FileSearch fileSearch)
			throws JsonGenerationException, JsonMappingException, IOException, Exception;
}
