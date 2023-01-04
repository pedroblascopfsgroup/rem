package es.pfsgroup.plugin.gestorDocumental.manager;

import java.io.IOException;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.glassfish.jersey.uri.UriComponent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearActuacionTecnicaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearConductasInapropiadasDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadCompradorDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearJuntaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPlusvaliaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearProyectoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearTributoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearProveedorDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;


@Component
public class GestorDocumentalExpedientesManager implements GestorDocumentalExpedientesApi {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestClientApi restClientApi;
	
	private static final String USUARIO_PATH = "usuario=";
	private static final String PASSWORD_PATH = "password=";
	private static final String CLASE_EXPEDIENTE_PATH = "clase_expediente=";
	private static final String TIPO_EXPEDIENTE_PATH = "tipo_expediente=";
	private static final String DESCRIPCION_EXPEDIENTE_PATH = "descripcionExpediente=";
	private static final String EXPEDIENTE_COMERCIAL_METADATOS_PATH = "metadata=";
	private static final String USUARIO_OPERACIONAL_PATH = "usuarioOperacional=";
	
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String COD_CLASE = "codClase";
	private static final String DESCRIPCION_EXPEDIENTE = "descripcionExpediente";
	private static final String GASTO_METADATOS="gastoMetadatos";
	private static final String EXPEDIENTE_COMERCIAL_METADATOS = "operacionMetadatos";
	private static final String EXPEDIENTE_CLASE = "clase_expediente";

	
	public static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES = "rest.client.gestor.documental.expedientes";
	private static final String ERROR_SERVER_NOT_RESPONDING="El servidor de gestor documental no responde.";
	
	
	@Override
	public RespuestaCrearExpediente crearGasto(CrearGastoDto crearGasto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearGasto(crearGasto));
		serverRequest.setMultipart(getMultipartCrearGasto(crearGasto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}
	
	private String getPathCrearGasto(CrearGastoDto crearGasto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearGasto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearGasto.getPassword());
		sb.append("&").append(DESCRIPCION_EXPEDIENTE_PATH).append(UriComponent.encode(crearGasto.getDescripcionExpediente(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearGasto.getCodClase());
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append("AI");
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearGasto.getGastoMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearGasto.getUsuarioOperacional());

		return sb.toString();
	}
	
	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearGasto(CrearGastoDto crearGasto){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearGasto.getUsuario())
				.field(PASSWORD,  crearGasto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, crearGasto.getDescripcionExpediente())
				.field(COD_CLASE, crearGasto.getCodClase().toString())
				.field(GASTO_METADATOS, crearGasto.getGastoMetadatos());
		return multipart;
	}

	private Object getResponse(ServerRequest serverRequest) {
		serverRequest.setRestClientUrl(URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES);
		
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
	public RespuestaCrearExpediente crearExpedienteComercial(CrearExpedienteComercialDto crearExpedienteComercialDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearExpedienteComercial(crearExpedienteComercialDto));
		serverRequest.setMultipart(getMultipartCrearExpedienteComercial(crearExpedienteComercialDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}

	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearExpedienteComercial(CrearExpedienteComercialDto crearExpedienteComercialDto) {
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearExpedienteComercialDto.getUsuario())
				.field(PASSWORD,  crearExpedienteComercialDto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, crearExpedienteComercialDto.getDescripcionExpediente())
				.field(COD_CLASE, crearExpedienteComercialDto.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearExpedienteComercialDto.getOperacionMetadatos());
		return multipart;
	}

	private String getPathCrearExpedienteComercial(CrearExpedienteComercialDto crearExpedienteComercialDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearExpedienteComercialDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearExpedienteComercialDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearExpedienteComercialDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearExpedienteComercialDto.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearExpedienteComercialDto.getTipoClase());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearExpedienteComercialDto.getCodClase());
		return sb.toString();
	}
	
	
	
	//--------------------------------------------- JUNTAS -----------------------------------------
	
	@Override
	public RespuestaCrearExpediente crearJunta(CrearJuntaDto CrearJuntaDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearJunta(CrearJuntaDto));
		serverRequest.setMultipart(getMultipartCrearJunta(CrearJuntaDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}

	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearJunta(CrearJuntaDto CrearJuntaDto) {
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, CrearJuntaDto.getUsuario())
				.field(PASSWORD,  CrearJuntaDto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, CrearJuntaDto.getDescripcionJunta())
				.field(COD_CLASE, CrearJuntaDto.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, CrearJuntaDto.getOperacionMetadatos());
		return multipart;
	}

	private String getPathCrearJunta(CrearJuntaDto CrearJuntaDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(CrearJuntaDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(CrearJuntaDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(CrearJuntaDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(CrearJuntaDto.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(CrearJuntaDto.getTipoClase());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(CrearJuntaDto.getCodClase());
		return sb.toString();
	}
	
	//-----------------------------------------------------------------------------------------------------
	

	@Override
	public RespuestaCrearExpediente crearActivoOferta(CrearEntidadCompradorDto crearActivoOferta) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearActivoOferta(crearActivoOferta));
		serverRequest.setMultipart(getMultipartCrearActivoOferta(crearActivoOferta));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}

		return respuesta;
	}

	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearActivoOferta(CrearEntidadCompradorDto crearActivoOferta) {
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearActivoOferta.getUsuario())
				.field(PASSWORD,  crearActivoOferta.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, "")
				.field(COD_CLASE, crearActivoOferta.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearActivoOferta.getOperacionMetadatos());
		return multipart;
	}

	private String getPathCrearActivoOferta(CrearEntidadCompradorDto crearActivoOferta) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearActivoOferta.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearActivoOferta.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearActivoOferta.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearActivoOferta.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearActivoOferta.getTipoClase());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearActivoOferta.getCodClase());
		return sb.toString();
	}

	@Override
	public RespuestaCrearExpediente crearActuacionTecnica(CrearActuacionTecnicaDto crearActuacionTecnicaDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearActuacionTecnica(crearActuacionTecnicaDto));
		serverRequest.setMultipart(getMultipartCrearActuacionTecnica(crearActuacionTecnicaDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}

		return respuesta;
	}

	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearActuacionTecnica(CrearActuacionTecnicaDto crearActuacionTecnicaDto) {
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearActuacionTecnicaDto.getUsuario())
				.field(PASSWORD,  crearActuacionTecnicaDto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, crearActuacionTecnicaDto.getDescripcionActuacion())
				.field(COD_CLASE, crearActuacionTecnicaDto.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearActuacionTecnicaDto.getOperacionMetadatos());
		return multipart;
	}

	private String getPathCrearActuacionTecnica(CrearActuacionTecnicaDto crearActuacionTecnicaDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearActuacionTecnicaDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearActuacionTecnicaDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearActuacionTecnicaDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearActuacionTecnicaDto.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearActuacionTecnicaDto.getTipoClase());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearActuacionTecnicaDto.getCodClase());
		return sb.toString();
	}
	
	@Override
	public RespuestaCrearExpediente crearProveedor(CrearProveedorDto crearProveedorDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearProveedor(crearProveedorDto));
		serverRequest.setMultipart(getMultipartCrearProveedor(crearProveedorDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}

		return respuesta;
	}

	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearProveedor(CrearProveedorDto crearProveedorDto) {
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearProveedorDto.getUsuario())
				.field(PASSWORD,  crearProveedorDto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, crearProveedorDto.getDescripcionProveedor())
				.field(COD_CLASE, crearProveedorDto.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearProveedorDto.getOperacionMetadatos());
		return multipart;
	}

	private String getPathCrearProveedor(CrearProveedorDto crearProveedorDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearProveedorDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearProveedorDto.getPassword());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearProveedorDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearProveedorDto.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearProveedorDto.getTipoClase());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearProveedorDto.getCodClase());
		return sb.toString();
	}

	@Override

	public RespuestaCrearExpediente crearPlusvalia(CrearPlusvaliaDto crearPlusvaliaDto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearPlusvalia(crearPlusvaliaDto));
		serverRequest.setMultipart(getMultipartCrearPlusvalia(crearPlusvaliaDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente crearTributo(CrearTributoDto crearTributo) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearTributo(crearTributo));
		serverRequest.setMultipart(getMultipartCrearTributo(crearTributo));

		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}
	
	@Override
	public RespuestaCrearExpediente crearProyecto(CrearProyectoDto crearProyecto) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearProyecto(crearProyecto));
		serverRequest.setMultipart(getMultipartCrearProyecto(crearProyecto));

		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);

		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}


	
	private String getPathCrearPlusvalia(CrearPlusvaliaDto crearPlusvaliaDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearPlusvaliaDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearPlusvaliaDto.getPassword());
		sb.append("&").append(DESCRIPCION_EXPEDIENTE_PATH).append(UriComponent.encode(crearPlusvaliaDto.getDescripcionPlusvalia(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearPlusvaliaDto.getCodClase());
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearPlusvaliaDto.getTipoClase());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearPlusvaliaDto.getOperacionMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearPlusvaliaDto.getUsuarioOperacional());
		
		return sb.toString();
	}

	private String getPathCrearTributo(CrearTributoDto crearTributo) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearTributo.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearTributo.getPassword());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(crearTributo.getCodClase());
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_OPERACIONES);
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearTributo.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearTributo.getTributoMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		


		return sb.toString();
	}
	
	@SuppressWarnings("resource")
	private MultiPart getMultipartCrearPlusvalia(CrearPlusvaliaDto crearPlusvaliaDto){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearPlusvaliaDto.getUsuario())
				.field(PASSWORD,  crearPlusvaliaDto.getPassword())
				.field(DESCRIPCION_EXPEDIENTE, crearPlusvaliaDto.getDescripcionPlusvalia())
				.field(COD_CLASE, crearPlusvaliaDto.getCodClase().toString())
				.field(GASTO_METADATOS, crearPlusvaliaDto.getOperacionMetadatos());
		return multipart;
	}


	private MultiPart getMultipartCrearTributo(CrearTributoDto crearTributo){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearTributo.getUsuario())
				.field(PASSWORD,  crearTributo.getPassword())
				.field(COD_CLASE, crearTributo.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearTributo.getTributoMetadatos())
				.field(DESCRIPCION_EXPEDIENTE, crearTributo.getTributoDescripcion());
		return multipart;
	}
	
	private String getPathCrearProyecto(CrearProyectoDto proyectoDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(proyectoDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(proyectoDto.getPassword());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append(proyectoDto.getCodClase());
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(proyectoDto.getCodTipo());
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(proyectoDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(proyectoDto.getProyectoMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		


		return sb.toString();
	}

	private MultiPart getMultipartCrearProyecto(CrearProyectoDto proyectoDto){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, proyectoDto.getUsuario())
				.field(PASSWORD,  proyectoDto.getPassword())
				.field(COD_CLASE, proyectoDto.getCodClase().toString())
				.field(EXPEDIENTE_COMERCIAL_METADATOS, proyectoDto.getProyectoMetadatos())
				.field(DESCRIPCION_EXPEDIENTE, proyectoDto.getProyectoDescripcion());
		return multipart;
	}

	@Override
	public RespuestaCrearExpediente crearConductasInapropiadas(CrearConductasInapropiadasDto crearConductasInapropiadasDto) throws GestorDocumentalException {
		ServerRequest serverRequest = new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearConductasInapropiadas(crearConductasInapropiadasDto));
		serverRequest.setMultipart(getMultipartCrearConductasInapropiadas(crearConductasInapropiadasDto));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		
		if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getMensajeError())) {
			logger.debug(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if(Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);
		}
		
		return respuesta;
	}
	
	private String getPathCrearConductasInapropiadas(CrearConductasInapropiadasDto crearConductasInapropiadasDto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/CrearContenedor");
		sb.append("?").append(USUARIO_PATH).append(crearConductasInapropiadasDto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearConductasInapropiadasDto.getPassword());
		sb.append("&").append(CLASE_EXPEDIENTE_PATH).append("01");
		sb.append("&").append(USUARIO_OPERACIONAL_PATH).append(crearConductasInapropiadasDto.getUsuarioOperacional());
		sb.append("&").append(EXPEDIENTE_COMERCIAL_METADATOS_PATH).append(UriComponent.encode(crearConductasInapropiadasDto.getMetadata(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		sb.append("&").append(TIPO_EXPEDIENTE_PATH).append(crearConductasInapropiadasDto.getTipoClase());
		return sb.toString();
	}
	
	private MultiPart getMultipartCrearConductasInapropiadas(CrearConductasInapropiadasDto crearConductasInapropiadasDto){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearConductasInapropiadasDto.getUsuario())
				.field(PASSWORD,  crearConductasInapropiadasDto.getPassword())
				.field(EXPEDIENTE_CLASE, "01")
				.field(EXPEDIENTE_COMERCIAL_METADATOS, crearConductasInapropiadasDto.getMetadata())
				.field(DESCRIPCION_EXPEDIENTE, crearConductasInapropiadasDto.getDescripcionConductasInapropiadas());
		return multipart;
	}
	
}
