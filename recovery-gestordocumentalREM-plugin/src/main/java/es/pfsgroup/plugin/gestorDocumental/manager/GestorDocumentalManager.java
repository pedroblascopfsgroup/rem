package es.pfsgroup.plugin.gestorDocumental.manager;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
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

import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
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
	private static final String BLACK_LIST_MATRICULAS_PATH = "blacklistmatriculas=";
	private static final String METADATA_TDN_1_PATH = "tdn1metadata=";
	
	private static final String DOCUMENTO = "documento";
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String USUARIO_OPERACIONAL = "usuarioOperacional";
	private static final String DESCRIPCION_DOCUMENTO = "descripcionDocumento";
	private static final String METADATA = "metadata";
	private static final String METADATATDN1 = "metadatatdn1";
	
	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_DOCUMENTOS = "rest.client.gestor.documental.documentos";
	public static final String ERROR_SERVER_NOT_RESPONDING="El servidor de gestor documental no responde.";
	private static final Map<String, String> contents;
	private static final String ENTIDAD_ACTIVO = "activo";
	
	static {
		contents = new HashMap<String, String>();
		contents.put(".csv", "text/csv");
		contents.put(".doc", "application/msword");
		contents.put(".htm", "text/html");
		contents.put(".me", "application/x-troff-me");
		contents.put(".ppt", "application/vnd.ms-powerpoint");
		contents.put(".xml", "text/xml");
		contents.put(".eml", "message/rfc822");
		contents.put(".zip", "application/x-zip-compressed");
		contents.put(".gif", "image/gif");
		contents.put(".pps", "application/vnd.ms-pps");
		contents.put(".xlsm", "application/vnd.ms-excel.sheet.macroEnabled.12");
		contents.put(".txt", "text/plain");
		contents.put(".xlk", "application/octet-stream");
		contents.put(".css", "text/css");
		contents.put(".mpt", "application/vnd.ms-project");
		contents.put(".docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
		contents.put(".js", "application/javascript");
		contents.put(".url", "application/x-url");
		contents.put(".xls", "application/vnd.ms-excel");
		contents.put(".bmp", "image/bmp");
		contents.put(".mpp", "application/vnd.ms-project");
		contents.put(".rar", "application/x-rar-compressed");
		contents.put(".rtf", "application/rtf");
		contents.put(".tif", "image/tiff");
		contents.put(".xlsb", "application/vnd.ms-excel.sheet.binary.macroEnabled.12");
		contents.put(".odt", "application/vnd.oasis.opendocument.text");
		contents.put(".pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");
		contents.put(".docm", "application/vnd.ms-word.document.macroEnabled.12");
		contents.put(".html", "text/html");
		contents.put(".log", "application/octet-stream");
		contents.put(".jpeg", "image/pjpeg");
		contents.put(".jpg", "image/jpeg");
		contents.put(".ods", "application/vnd.oasis.opendocument.spreadsheet");
		contents.put(".msg", "application/vnd.ms-outlook-template");
		contents.put(".pdf", "application/pdf");
		contents.put(".dot", "application/msword");
		contents.put(".tiff", "image/tiff");
		contents.put(".exe", "application/x-exe");
		contents.put(".png", "image/png");
		contents.put(".xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	}
	
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
		if(docExpDto.getBlacklistmatriculas() == null) {
			docExpDto.setBlacklistmatriculas("");
		}
		sb.append("&").append(BLACK_LIST_MATRICULAS_PATH).append(docExpDto.getBlacklistmatriculas());
		sb.append("&").append(METADATA_TDN_1_PATH).append(true);
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
		MultiPart multipart  = null;
		if(crearDoc.getMetadatatdn1() != null) {
			 multipart = createMultipartDocumento(crearDoc);
		}else {
			multipart = new FormDataMultiPart()
				.field(USUARIO, crearDoc.getUsuario())
				.field(PASSWORD,  crearDoc.getPassword())
				.field(USUARIO_OPERACIONAL, crearDoc.getUsuarioOperacional())
				.field(METADATA, crearDoc.getGeneralDocumento())
				.field(DESCRIPCION_DOCUMENTO, crearDoc.getDescripcionDocumento())
				.bodyPart(filePart);
		}
		return multipart;
	}
	
	@Override
	public RespuestaDescargarDocumento descargarDocumento(Long idDocumento, BajaDocumentoDto login, String nombreDocumento) throws GestorDocumentalException,UserException, IOException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_GET);
		serverRequest.setPath(getPathDescargarDoc(idDocumento, login));		
		serverRequest.setResponseClass(RespuestaDescargarDocumento.class);
		Object respuesta = this.getBinaryResponse(serverRequest,"");
		byte[] bytes = null;
		if(respuesta instanceof String) {
			throw new UserException((String)respuesta);
		}
		else if(respuesta instanceof byte[]) {
			bytes = (byte[]) respuesta;
		}
		else {
			throw new GestorDocumentalException("Error al descargarDocumento ["+idDocumento+"].");
		}
		
		return this.rellenarRespuestaDescarga(bytes,nombreDocumento);
	}
	
	private RespuestaDescargarDocumento rellenarRespuestaDescarga(byte[] contenido, String nombreDocumento) throws IOException{
		
		//Byte[] bytes = ArrayUtils.toObject(contenido);
		
		RespuestaDescargarDocumento respuesta = new RespuestaDescargarDocumento();
		
		respuesta.setNombreDocumento(nombreDocumento);
		String nomFichero = respuesta.getNombreDocumento();
		String ext = null;
		String contentType = respuesta.getContentType();
		
		if(respuesta.getNombreDocumento().contains(".")){
			
			nomFichero = respuesta.getNombreDocumento().substring(0, respuesta.getNombreDocumento().lastIndexOf("."));
			ext =respuesta.getNombreDocumento().substring(respuesta.getNombreDocumento().lastIndexOf("."));
			
			if(Checks.esNulo(respuesta.getContentType())){
				contentType = contents.get(ext.toLowerCase());
			}
		}
		
		if(!Checks.esNulo(contentType) && Checks.esNulo(ext)){
			for (Map.Entry<String, String> entry : contents.entrySet())
			{
				if(entry.getValue().equals(contentType)){
					ext = entry.getKey();
				}
			}
		}
		
		File fileSalidaTemporal = null;
		FileItem resultado = new FileItem();
		InputStream stream =  new ByteArrayInputStream(contenido);
		if(ext == null || ext.isEmpty() || ext.length() < 3){
			ext = "tmp";
		}
		
		
		fileSalidaTemporal = File.createTempFile(generateRandomString(), ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado.setFileName(nomFichero + ext);
		if(!Checks.esNulo(contentType)) {
			resultado.setContentType(contentType);	
		}		
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream();
        IOUtils.copy(stream, outputStream);
		outputStream.close();
		respuesta.setFileItem(resultado);
		return respuesta;
		
	}
	
	public String generateRandomString(){
		int length = 10;
	    boolean useLetters = true;
	    boolean useNumbers = false;
	    return RandomStringUtils.random(length, useLetters, useNumbers);
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
	
	@SuppressWarnings("resource")
	private MultiPart createMultipartDocumento(CrearDocumentoDto crearDoc){
		final FileDataBodyPart filePart = new FileDataBodyPart(DOCUMENTO,  crearDoc.getDocumento());
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearDoc.getUsuario())
				.field(PASSWORD,  crearDoc.getPassword())
				.field(USUARIO_OPERACIONAL, crearDoc.getUsuarioOperacional())
				.field(METADATA, crearDoc.getGeneralDocumento())
				.field(METADATATDN1, crearDoc.getMetadatatdn1())
				.field(DESCRIPCION_DOCUMENTO, crearDoc.getDescripcionDocumento())
				.bodyPart(filePart);

		
		return multipart;
	}

}
