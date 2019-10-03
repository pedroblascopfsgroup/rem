package es.pfsgroup.plugin.rem.api;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTributos;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoTributo;

public interface  ActivoTributoApi {

	@BusinessOperationDefinition("ActivoTributoManager.upload")
	public String upload(WebFileItem webFileItem) throws Exception;
	
	/**
	 * Recupera el adjunto del Expediente comercial
	 * 
	 * @param dtoAdjunto
	 * @return
	 */
	public FileItem getFileItemAdjunto(DtoAdjuntoTributo dtoAdjunto);
	
	
	@BusinessOperationDefinition("ActivoTributoManager.download")
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
	@BusinessOperationDefinition("ActivoTributoManager.upload2")
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
	@BusinessOperationDefinition("ActivoTributoManager.uploadDocumento")
	String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, ActivoTributos activoTributo, String matricula) throws Exception;

	/**
	 * Recupera el Activo indicado.
	 * 
	 * @param id
	 *            Long
	 * @return Activo
	 */
	@BusinessOperationDefinition("ActivoTributoManager.get")
	public Activo get(Long id);

	ActivoTributos getTributo(Long id);

	public DtoAdjunto getAdjuntoTributo(Long idTributo);

	public Boolean deleteAdjuntoDeTributo(Long idTributo);

	public Boolean comprobarSiExisteActivoTributo(WebFileItem webFileItem)throws GestorDocumentalException;

	

	
}
