package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoProyecto;

public interface  ActivoProyectoApi {

	@BusinessOperationDefinition("ActivoProyectoManager.upload")
	public String upload(WebFileItem webFileItem) throws Exception;
	
	/**
	 * Recupera el adjunto del Expediente comercial
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	public FileItem getFileItemAdjunto(DtoAdjuntoProyecto dtoAdjunto);

	/**
	 * Recupera info de los adjuntos asociados al expediente comercial
	 * 
	 * @param id
	 * @return
	 */
	public List<DtoAdjuntoProyecto> getAdjuntos(Long idActivo);
	
	
	@BusinessOperationDefinition("ActivoProyectoManager.download")
	public FileItem download(Long id) throws Exception;
	
	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient
	 * guarde el identificador obtenido en base de datos
	 * 
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition("ActivoProyectoManager.upload2")
	String upload2(WebFileItem webFileItem, Long idDocRestClient) throws Exception;
	
	/**
	 * Sirve para que después de guardar un fichero en el servicio de RestClient
	 * guarde el identificador obtenido en base de datos
	 * 
	 * @param webFileItem
	 * @param idDocRestClient
	 * @return
	 * @throws Exception
	 */
	@BusinessOperationDefinition("ActivoProyectoManager.uploadDocumento")
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activo, String matricula)
			throws Exception;

	/**
	 * Recupera el Activo indicado.
	 * 
	 * @param id
	 *            Long
	 * @return Activo
	 */
	@BusinessOperationDefinition("ActivoProyectoManager.get")
	public Activo get(Long id);
    
	/**
	 * Elimina un adjunto
	 *
	 * @return
	 */
	@BusinessOperationDefinition("ActivoProyectoManager.deleteAdjunto")
	boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	
}
