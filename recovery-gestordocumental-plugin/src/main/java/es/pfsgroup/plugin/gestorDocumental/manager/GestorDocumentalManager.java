package es.pfsgroup.plugin.gestorDocumental.manager;

import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.glassfish.jersey.media.multipart.file.FileDataBodyPart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCatalogoDocumental;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestordocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestordocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearVersionDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearVersionMetadatosDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DescargaDocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.ModificarMetadatosDto;

@Component
public class GestorDocumentalManager implements GestorDocumentalApi {

	@Autowired
	private RestClientApi restClientApi;
	
	private static final String USUARIO_PATH = "usuario=";
	private static final String PASSWORD_PATH = "password=";
	private static final String USUARIO_OPERACIONAL_PATH = "usuarioOperacional=";
	private static final String TIPO_CONSULTA_PATH = "tipoConsulta=";
	private static final String VINCULO_DOCUMENTO_PATH = "vinculoDocumento=";
	private static final String VINCULO_EXPEDIENTE_PATH = "vinculoExpediente=";
	
	private static final String DOCUMENTO = "documento";
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String USUARIO_OPERACIONAL = "usuarioOperacional";
	private static final String DESCRIPCION_DOCUMENTO = "descripcionDocumento";
	private static final String GENERAL_DOCUMENTO = "generalDocumento";
	private static final String ARCHIVO_FISICO = "archivoFisico";	
	
	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_DOCUMENTOS = "rest.client.gestor.documental.documentos";
	
	@Override
	public RespuestaDocumentosExpedientes documentosExpediente(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDocExp(cabecera, docExpDto));
		serverRequest.setResponseClass(RespuestaDocumentosExpedientes.class);
		RespuestaDocumentosExpedientes respuesta = (RespuestaDocumentosExpedientes) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	private String getPathDocExp(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/documentosExpediente");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		sb.append("?").append(USUARIO_PATH).append(docExpDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(docExpDto.getPassword());
		sb.append("&").append(TIPO_CONSULTA_PATH).append(docExpDto.getTipoConsulta());
		sb.append("&").append(VINCULO_DOCUMENTO_PATH).append(docExpDto.getVinculoDocumento());
		sb.append("&").append(VINCULO_EXPEDIENTE_PATH).append(docExpDto.getVinculoExpediente());
		return sb.toString();
	}
	
	@Override
	public RespuestaCrearDocumento crearDocumento(CabeceraPeticionRestClientDto cabecera, CrearDocumentoDto crearDoc) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearDoc(cabecera));
		serverRequest.setMultipart(getMultipartCrearDocumento(crearDoc));
		serverRequest.setResponseClass(RespuestaCrearDocumento.class);
		RespuestaCrearDocumento respuesta = (RespuestaCrearDocumento) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCrearDoc(CabeceraPeticionRestClientDto cabecera) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearDocumento");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		return sb.toString();
	}
	
	private MultiPart getMultipartCrearDocumento(CrearDocumentoDto crearDoc){
		final FileDataBodyPart filePart = new FileDataBodyPart(DOCUMENTO,  crearDoc.getDocumento());
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearDoc.getUsuario())
				.field(PASSWORD,  crearDoc.getPassword())
				.field(USUARIO_OPERACIONAL, crearDoc.getUsuarioOperacional())
				.field(GENERAL_DOCUMENTO, crearDoc.getGeneralDocumento())
				.field(ARCHIVO_FISICO, crearDoc.getArchivoFisico())
				.field(DESCRIPCION_DOCUMENTO, crearDoc.getDescripcionDocumento())
				.bodyPart(filePart);
		return multipart;
	}
	
	@Override
	public RespuestaDescargarDocumento descargarDocumento(Long idDocumento, BajaDocumentoDto login) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDescargarDoc(idDocumento, login));		
		serverRequest.setResponseClass(RespuestaDescargarDocumento.class);
		RespuestaDescargarDocumento respuesta = (RespuestaDescargarDocumento) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathDescargarDoc(Long idDocumento, BajaDocumentoDto login) {
		StringBuilder sb = new StringBuilder();
		sb.append("/descargarDocumento");
		sb.append("/").append(idDocumento);
		sb.append("?").append(USUARIO_PATH).append(login.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(login.getPassword());
		return sb.toString();
	}
	
	@Override
	public RespuestaGeneral descargarDocumentosExpediente(CabeceraPeticionRestClientDto cabecera, DescargaDocumentosExpedienteDto docExpDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDocExp(cabecera, docExpDto));
		serverRequest.setResponseClass(RespuestaDocumentosExpedientes.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	private String getPathDocExp(CabeceraPeticionRestClientDto cabecera, DescargaDocumentosExpedienteDto docExpDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/documentosExpediente");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		sb.append("?").append(USUARIO_PATH).append(docExpDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(docExpDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(docExpDto.getUsuarioOperacional());
		sb.append("&").append(TIPO_CONSULTA_PATH).append(docExpDto.getTipoConsulta());
		sb.append("&").append(VINCULO_DOCUMENTO_PATH).append(docExpDto.getVinculoDocumento());
		sb.append("&").append(VINCULO_EXPEDIENTE_PATH).append(docExpDto.getVinculoExpediente());
		return sb.toString();
	}

	@Override
	public RespuestaGeneral crearVersion(Long idDocumento, CrearVersionDto crearVers) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathCrearVer(idDocumento));
		//TODO Crear MultipartPOST
		serverRequest.setMultipart(null);
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCrearVer(Long idDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearVersion");
		sb.append("/").append(idDocumento);
		return sb.toString();
	}

	@Override
	public RespuestaGeneral crearVersionYMetadatos(Long idDocumento,
			CrearVersionMetadatosDto crearVersMetadata) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathCrearVerMetadata(idDocumento));
		//TODO Crear MultipartPOST
		serverRequest.setMultipart(null);
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCrearVerMetadata(Long idDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearVersionYMetadatos");
		sb.append("/").append(idDocumento);
		return sb.toString();
	}

	@Override
	public RespuestaGeneral modificarMetadatos(Long idDocumento, ModificarMetadatosDto modifMetadata) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathModifMetadata(idDocumento));
		//TODO Crear MultipartPOST
		serverRequest.setMultipart(null);
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathModifMetadata(Long idDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("/modificarMetadatos");
		sb.append("/").append(idDocumento);
		return sb.toString();
	}

	@Override
	public RespuestaGeneral bajaDocumento(BajaDocumentoDto baja, Integer idDocumento) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathBajaDoc(baja, new Long(idDocumento)));
		serverRequest.setMultipart(getMultipartBajaDoc(baja));
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}	
	
	private String getPathBajaDoc(BajaDocumentoDto baja, Long idDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("/bajaDocumento");
		sb.append("/").append(idDocumento);
		sb.append("?").append(USUARIO_PATH).append(baja.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(baja.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(baja.getUsuarioOperacional());
		return sb.toString();
	}
	
	
	private MultiPart getMultipartBajaDoc(BajaDocumentoDto baja){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, baja.getUsuario())
				.field(PASSWORD,  baja.getPassword())
				.field(USUARIO_OPERACIONAL, baja.getUsuarioOperacional());
		return multipart;
	}

	@Override
	public RespuestaGeneral crearRelacionExpediente(CabeceraPeticionRestClientDto cabecera) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathCrearRelExp(cabecera));
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCrearRelExp(CabeceraPeticionRestClientDto cabecera) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearRelacionExpediente");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		sb.append("/").append(cabecera.getIdDocumento());
		return sb.toString();
	}

	@Override
	public RespuestaCatalogoDocumental catalogoDocumental(String codTipo, String codClase) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathCatalogoDoc(codTipo, codClase));
		serverRequest.setResponseClass(RespuestaCatalogoDocumental.class);
		RespuestaCatalogoDocumental respuesta = (RespuestaCatalogoDocumental) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCatalogoDoc(String codTipo, String codClase) {
		StringBuilder sb = new StringBuilder();
		sb.append("/catalogoDocumental");
		sb.append("/").append(codTipo);
		sb.append("/").append(codClase);
		return sb.toString();
	}
	
	private Object getResponse(ServerRequest serverRequest) {
		serverRequest.setRestClientUrl(URL_REST_CLIENT_GESTOR_DOCUMENTAL_DOCUMENTOS);
		return restClientApi.getResponse(serverRequest);
	}

}
