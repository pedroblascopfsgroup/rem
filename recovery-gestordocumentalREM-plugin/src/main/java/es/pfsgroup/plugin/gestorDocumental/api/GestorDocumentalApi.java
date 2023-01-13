package es.pfsgroup.plugin.gestorDocumental.api;

import es.capgemini.devon.exception.UserException;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.*;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCatalogoDocumental;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

public interface GestorDocumentalApi {
	

	/**
	 * Permite obtener un listado de documentos dentro de un expediente (con o sin relaciones)
	 * 
	 * @param cabecera
	 * @param docExpDto
	 * @return RespuestaDocumentosExpedientes
	 * @throws GestorDocumentalException 
	 */
	RespuestaDocumentosExpedientes documentosExpediente(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) throws GestorDocumentalException;

	RespuestaDocumentosExpedientes documentosExpedienteMultiTipo(List<DocumentosExpedienteDto> docExpDto) throws GestorDocumentalException, UnsupportedEncodingException;

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
	 * @throws IOException 
	 */
	RespuestaDescargarDocumento descargarDocumento(Long idDocumento, BajaDocumentoDto login, String nombreDocumento) throws GestorDocumentalException,UserException, IOException;

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
	RespuestaGeneral bajaDocumento(BajaDocumentoDto login, Integer idDocumento) throws GestorDocumentalException;

	/**
	 * Permite introducir una relación entre un documento y un expediente
	 * 
	 * @param cabecera
	 * @param crearRelacionExpedienteDto 
	 * @param credencialesUsuario
	 * @return RespuestaGeneral
	 * @throws GestorDocumentalException 
	 */
	RespuestaGeneral crearRelacionExpediente(CabeceraPeticionRestClientDto cabecera, CredencialesUsuarioDto credUsuDto, CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException;

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
	
	/**
	 * Método que nos dirá si el gestor documental está activo
	 * @return
	 */
	boolean modoRestClientActivado();


}