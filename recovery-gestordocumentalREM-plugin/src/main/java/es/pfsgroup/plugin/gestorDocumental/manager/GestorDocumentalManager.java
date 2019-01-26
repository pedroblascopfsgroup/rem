package es.pfsgroup.plugin.gestorDocumental.manager;

import java.io.IOException;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.glassfish.jersey.media.multipart.file.FileDataBodyPart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearVersionDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearVersionMetadatosDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CredencialesUsuarioDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DescargaDocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.ModificarMetadatosDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCatalogoDocumental;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import net.sf.json.JSONObject;

@Component
public class GestorDocumentalManager implements GestorDocumentalApi {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestClientApi restClientApi;
	
	private static final String USUARIO_PATH = "usuario=";
	private static final String PASSWORD_PATH = "password=";
	private static final String USUARIO_OPERACIONAL_PATH = "usuarioOperacional=";
	private static final String TIPO_CONSULTA_PATH = "tipoConsultaRelacion=";
	private static final String VINCULO_DOCUMENTO_PATH = "vinculoDocumento=";
	private static final String VINCULO_EXPEDIENTE_PATH = "vinculoExpediente=";
	private static final String TIPO_RELACION_PATH = "tipo_relacion=";
	private static final String ID_OPENTEXT_PATH = "id_opentext=";
	private static final String TIPO_EXPEDIENTE_PATH = "tipo_expediente=";
	private static final String CLASE_EXPEDIENTE_PATH = "clase_expediente=";
	private static final String ID_ACTIVO_PATH = "id_activo=";
	private static final String OPERACION_PATH = "operacion=";
	
	private static final String DOCUMENTO = "documento";
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String USUARIO_OPERACIONAL = "usuarioOperacional";
	private static final String DESCRIPCION_DOCUMENTO = "descripcionDocumento";
	private static final String METADATA = "metadata";
	
	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_DOCUMENTOS = "rest.client.gestor.documental.documentos";
	private static final String ERROR_SERVER_NOT_RESPONDING="El servidor de gestor documental no responde.";
	
	@Override
	public RespuestaDocumentosExpedientes documentosExpediente(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDocExp(cabecera, docExpDto));
		serverRequest.setResponseClass(RespuestaDocumentosExpedientes.class);
		RespuestaDocumentosExpedientes respuesta = (RespuestaDocumentosExpedientes) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getCodigoError() + " - " + respuesta.getMensajeError(),respuesta.getCodigoError());
		}
		return respuesta;
	}

	private String getPathDocExp(CabeceraPeticionRestClientDto cabecera, DocumentosExpedienteDto docExpDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/ListarDocumentos");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		sb.append("?").append(USUARIO_PATH).append(docExpDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(docExpDto.getPassword());
		sb.append("&").append(TIPO_CONSULTA_PATH).append(docExpDto.getTipoConsulta());
		sb.append("&").append(VINCULO_DOCUMENTO_PATH).append(docExpDto.getVinculoDocumento());
		sb.append("&").append(VINCULO_EXPEDIENTE_PATH).append(docExpDto.getVinculoExpediente());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(docExpDto.getUsuarioOperacional());
		return sb.toString();
	}
	
	@Override
	public RespuestaCrearDocumento crearDocumento(CabeceraPeticionRestClientDto cabecera, CrearDocumentoDto crearDoc) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearDoc(cabecera));
		serverRequest.setMultipart(getMultipartCrearDocumento(crearDoc));
		serverRequest.setResponseClass(RespuestaCrearDocumento.class);
		logger.error(">>>>>>>>>>>>>>>>>>> crearDocumento ServerREquest"+serverRequest.toString());
		RespuestaCrearDocumento respuesta = (RespuestaCrearDocumento) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError(),respuesta.getCodigoError());
		}
		return respuesta;
	}
	
	private String getPathCrearDoc(CabeceraPeticionRestClientDto cabecera) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearDocumento");
		sb.append("/").append(cabecera.getCodTipo());
		sb.append("/").append(cabecera.getCodClase());
		sb.append("/").append(cabecera.getIdExpedienteHaya());
		return sb.toString();
	}
	
	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearDocumento(CrearDocumentoDto crearDoc){
		final FileDataBodyPart filePart = new FileDataBodyPart(DOCUMENTO,  crearDoc.getDocumento());
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearDoc.getUsuario())
				.field(PASSWORD,  crearDoc.getPassword())
				.field(USUARIO_OPERACIONAL, crearDoc.getUsuarioOperacional())
				.field(METADATA, crearDoc.getGeneralDocumento())
				.field(DESCRIPCION_DOCUMENTO, crearDoc.getDescripcionDocumento())
				.bodyPart(filePart);
		return multipart;
	}
	
	@Override
	public RespuestaDescargarDocumento descargarDocumento(Long idDocumento, BajaDocumentoDto login, String nombreDocumento) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDescargarDoc(idDocumento, login));		
		serverRequest.setResponseClass(RespuestaDescargarDocumento.class);
		Object respuesta = this.getBinaryResponse(serverRequest,"");
		byte[] bytes = null;
		
		if(respuesta instanceof byte[]) {
			bytes = (byte[]) respuesta;
		}
		else {
			throw new GestorDocumentalException("Error al descargarDocumento ["+idDocumento+"].");
		}
		
		return this.rellenarRespuestaDescarga(bytes,nombreDocumento);
	}
	
	private RespuestaDescargarDocumento rellenarRespuestaDescarga(byte[] contenido, String nombreDocumento){
		
		Byte[] bytes = ArrayUtils.toObject(contenido);
		
		RespuestaDescargarDocumento respuesta = new RespuestaDescargarDocumento();
		respuesta.setContenido(bytes);
		respuesta.setNombreDocumento(nombreDocumento);
		
		return respuesta;
	}
	
	private String getPathDescargarDoc(Long idDocumento, BajaDocumentoDto login) {
		StringBuilder sb = new StringBuilder();
		sb.append("/DescargarDocumento");
		sb.append("/").append(idDocumento);
		sb.append("?").append(USUARIO_PATH).append(login.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(login.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(login.getUsuarioOperacional());
		return sb.toString();
	}
	
	private Object getBinaryResponse(ServerRequest serverRequest, String fileName) {
		serverRequest.setRestClientUrl(URL_REST_CLIENT_GESTOR_DOCUMENTAL_DOCUMENTOS);
		Object respuesta = restClientApi.getBinaryResponse(serverRequest);
		
		return respuesta;
	}
	
	@Override
	public RespuestaGeneral descargarDocumentosExpediente(CabeceraPeticionRestClientDto cabecera, DescargaDocumentosExpedienteDto docExpDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDocExp(cabecera, docExpDto));
		serverRequest.setResponseClass(RespuestaDocumentosExpedientes.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
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
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
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
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
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
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
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
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathBajaDoc(baja, new Long(idDocumento)));
		serverRequest.setMultipart(getMultipartBajaDoc(baja));
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
		}
		return respuesta;
	}	
	
	private String getPathBajaDoc(BajaDocumentoDto baja, Long idDocumento) {
		StringBuilder sb = new StringBuilder();
		sb.append("/BajaDocumento");
		sb.append("/").append(idDocumento);
		sb.append("?").append(USUARIO_PATH).append(baja.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(baja.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(baja.getUsuarioOperacional());
		return sb.toString();
	}
	
	
	@SuppressWarnings("resource")
	private MultiPart getMultipartBajaDoc(BajaDocumentoDto baja){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, baja.getUsuario())
				.field(PASSWORD,  baja.getPassword())
				.field(USUARIO_OPERACIONAL, baja.getUsuarioOperacional());
		return multipart;
	}

	@Override
	public RespuestaGeneral crearRelacionExpediente(CabeceraPeticionRestClientDto cabecera, CredencialesUsuarioDto credUsu,CrearRelacionExpedienteDto crearRelacionExpedienteDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(getPathCrearRelExp(cabecera, credUsu,crearRelacionExpedienteDto));
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
		}
		return respuesta;
	}
	
	private String getPathCrearRelExp(CabeceraPeticionRestClientDto cabecera, CredencialesUsuarioDto credUsuDto, CrearRelacionExpedienteDto crearRelacionExpedienteDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/Relacion");
		sb.append("?").append(USUARIO_PATH).append(credUsuDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(credUsuDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(credUsuDto.getUsuarioOperacional());
		sb.append("&").append(TIPO_RELACION_PATH).append(crearRelacionExpedienteDto.getTipoRelacion());
		sb.append("&").append(ID_OPENTEXT_PATH).append(cabecera.getIdDocumento());
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(cabecera.getCodTipo());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(cabecera.getCodClase());
		sb.append("&").append(ID_ACTIVO_PATH).append(cabecera.getIdExpedienteHaya());
		sb.append("&").append(OPERACION_PATH).append(crearRelacionExpedienteDto.getOperacion());
		return sb.toString();
	}

	@Override
	public RespuestaCatalogoDocumental catalogoDocumental(String codTipo, String codClase) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathCatalogoDoc(codTipo, codClase));
		serverRequest.setResponseClass(RespuestaCatalogoDocumental.class);
		RespuestaCatalogoDocumental respuesta = (RespuestaCatalogoDocumental) getResponse(serverRequest);
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getMensajeError(),respuesta.getCodigoError());
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
		Object resp = restClientApi.getResponse(serverRequest);
		
		logger.debug("--------------------------");
		logger.debug(" RestClient RESPONSE");
		logger.debug("--------------------------");
		ObjectMapper mapper = new ObjectMapper();
		if (resp != null) {
			String respInString = "El servidor del gestor documental no envió la respuesta correctamente.";
			try {
				respInString = mapper.writeValueAsString(resp);
				JSONObject jsonObject = JSONObject.fromObject(respInString);
				jsonObject.remove("contenido");
				respInString = jsonObject.toString();	
			} catch (JsonGenerationException e) {
				e.printStackTrace();
			} catch (JsonMappingException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			logger.debug("\n"+respInString);
		} else {
			logger.debug(" No hay respuesta del servidor.");
		}

		logger.debug("--------------------------");
		
		return resp;
	}
	
	@Override
	public boolean modoRestClientActivado() {
		
		return restClientApi.modoRestClientActivado();
		
	}

}
