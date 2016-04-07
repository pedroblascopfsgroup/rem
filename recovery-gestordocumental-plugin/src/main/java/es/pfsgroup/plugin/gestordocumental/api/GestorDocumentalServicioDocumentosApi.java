package es.pfsgroup.plugin.gestordocumental.api;

import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCatalogoDocumental;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearVersionDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearVersionMetadatosDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DescargaDocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.ModificarMetadatosDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.UsuarioPasswordDto;

public interface GestorDocumentalServicioDocumentosApi {

	/**
	 * Permite obtener un listado de documentos dentro de un expediente (con o sin relaciones)
	 * 
	 * @param cabecera
	 * @param docExpDto
	 * @return RespuestaDocumentosExpedientes
	 * @throws GestorDocumentalException 
	 */
	RespuestaDocumentosExpedientes documentosExpediente(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) throws GestorDocumentalException;

	/**
	 * Permite crear un documento en el gestor documental con el cuadro de clasificación de Haya
	 * 
	 * @param cabecera
	 * @param crearDoc
	 * @return RespuestaCrearDocumento
	 * @throws GestorDocumentalException 
	 */
	RespuestaCrearDocumento crearDocumento(CabeceraPeticionRestClientDto cabecera, CrearDocumentoDto crearDoc) throws GestorDocumentalException;

	/**
	 * Permite descargar un documento en el gestor documental con el cuadro de clasificación de Haya
	 * 
	 * @param idDocumento
	 * @param login
	 * @return RespuestaDescargarDocumento
	 * @throws GestorDocumentalException 
	 */
	RespuestaDescargarDocumento descargarDocumento(Long idDocumento, UsuarioPasswordDto login) throws GestorDocumentalException;

	/**
	 * Permite obtener un listado de documentos dentro de un expediente (con o sin relaciones)
	 * @param cabecera
	 * @param docExpDto
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException
	 */
	RespuestaGeneral descargarDocumentosExpediente(CabeceraPeticionRestClientDto cabecera, DescargaDocumentosExpedienteDto docExpDto) throws GestorDocumentalException;
	
	/**
	 * Permite crear una nueva versión de documento en el gestor documental
	 * 
	 * @param idDocumento
	 * @param crearVers
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral crearVersion(Long idDocumento, CrearVersionDto crearVers) throws GestorDocumentalException;

	/**
	 * Permite crear una nueva versión de documento en el gestor documental
	 * permitiendo actualizar sólo los metadatos modificables
	 * 
	 * @param idDocumento
	 * @param documento
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral crearVersionYMetadatos(Long idDocumento, CrearVersionMetadatosDto documento) throws GestorDocumentalException;

	/**
	 * Permite modificar únicamente un conjunto de atributos del documento
	 * 
	 * @param idDocumento
	 * @param modifMetadata
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral modificarMetadatos(Long idDocumento, ModificarMetadatosDto modifMetadata) throws GestorDocumentalException;

	/**
	 * Permite un borrado lógico del documento (no físico)
	 * 
	 * @param login
	 * @param idDocumento
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral bajaDocumento(UsuarioPasswordDto login, Integer idDocumento) throws GestorDocumentalException;

	/**
	 * Permite introducir una relación entre un documento y un expediente
	 * 
	 * @param cabecera
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral crearRelacionExpediente(CabeceraPeticionRestClientDto cabecera) throws GestorDocumentalException;

	/**
	 * Permite consultar todo el conjunto de serie documentales, TDN1s y TDN2s
	 * para un tipo y clase de expediente dado
	 * 
	 * @param codTipo
	 * @param codClase
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaCatalogoDocumental catalogoDocumental(String codTipo, String codClase) throws GestorDocumentalException;	

}