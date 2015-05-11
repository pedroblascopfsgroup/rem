package es.pfsgroup.plugin.recovery.masivo.api;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVAltaCargaDocDto;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVCargaDocumentacionInitDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesosCargaDocs;


public interface MSVCargaDocumentacionApi {

	public static final String MSV_CARGADOC_FIND_AND_PROCESS = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.ejecuta";
	public static final String MSV_CARGADOC_ADJUNTAR_DOC = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.procesaInput";
	public static final String MSV_CARGADOC_MODIFICACION = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.modificaCargaDoc";
	public static final String MSV_CARGADOC_GET_FILES = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.getFicheros";
	public static final String MSV_CARGADOC_PRC_FILE = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.procesarFichero";
	public static final String MSV_CARGADOC_DEL_FILES = "es.pfsgroup.plugin.recovery.masivo.api.MSVCargaDocumentacionApi.eliminarTodosAdjuntos";
	
	/**
	 * Devuelve un listado de ficheros de configuración del directorio de carga
	 * que coincidan con la mascara pasado por el dto
	 * 
	 * @return
	 * @throws Exception 
	 */
	@BusinessOperationDefinition(MSV_CARGADOC_GET_FILES)
	public List<File> getConfigFiles(MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception;
	
	/**
	 * Procesa el fichero de configuración (xls) y adjunta los ficheros al asunto correspondiente
	 * 
	 * @param lista
	 * @return 
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 * @throws Exception 
	 * 
	 * @return lista de ficheros procesados
	 */
	@BusinessOperationDefinition(MSV_CARGADOC_PRC_FILE)
	public List<File> procesarFichero(File file, MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws IllegalArgumentException, IOException, Exception;
		
	/**
	 * Se cambia a deprecated porque se deben llamar a los métodos por separado para que no se llame a una sola transacción 
	 * 
	 * 
	 * Ejecuta el proceso completo de carga de ficheros, buscandolos primero en el directorio de carga
	 * y procesandolos para enviarlos al batch después
	 * 
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 * @throws Exception 
	 */
	@Deprecated
	@BusinessOperationDefinition(MSV_CARGADOC_FIND_AND_PROCESS)
	public void ejecuta(MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws IllegalArgumentException, IOException, Exception; 
	

	/**
	 * Modifica el proceso de carga de documentación
	 * 
	 * @param dto
	 * @return
	 */
	@Transactional(readOnly = false)
	@BusinessOperationDefinition(MSV_CARGADOC_MODIFICACION)
	public MSVProcesosCargaDocs modificaProcesoCargaDoc(MSVAltaCargaDocDto dto);
	
//	/**
//	 * Comprime los ficheros y los mueve al directorio de copia nombrado con el formato fecha
//	 * @param filesToZip
//	 * @param fileConfig
//	 * @param fileErrores
//	 * @param msvCargaDocumentacionDto
//	 * @throws Exception
//	 */
//	public void zipAndMove(List<File> filesToZip, File fileConfig, File fileErrores, MSVCargaDocumentacionInitDto msvCargaDocumentacionDto) throws Exception;
	
	/**
	 * Elinina todos los ficheros que se pasen en el List
	 * 
	 * @param listAllAdjuntos
	 */
	@BusinessOperationDefinition(MSV_CARGADOC_DEL_FILES)
	public void eliminarFicheros(List<File> listAllAdjuntos);
}
