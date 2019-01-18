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
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadCompradorDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearExpedienteComercialDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;


@Component
public class GestorDocumentalExpedientesManager implements GestorDocumentalExpedientesApi {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestClientApi restClientApi;
	
	private static final String USUARIO_PATH = "usuario=";
	private static final String PASSWORD_PATH = "password=";
	private static final String COD_CLASE_PATH = "codClase=";
	private static final String CLASE_EXPEDIENTE_PATH = "clase_expediente=";
	private static final String TIPO_EXPEDIENTE_PATH = "tipo_expediente=";
	private static final String DESCRIPCION_EXPEDIENTE_PATH = "descripcionExpediente=";
	private static final String GASTO_METADATOS_PATH = "gastoMetadatos=";
	private static final String EXPEDIENTE_COMERCIAL_METADATOS_PATH = "metadata=";
	private static final String USUARIO_OPERACIONAL_PATH = "usuarioOperacional=";
	
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String COD_CLASE = "codClase";
	private static final String DESCRIPCION_EXPEDIENTE = "descripcionExpediente";
	private static final String GASTO_METADATOS="gastoMetadatos";
	private static final String EXPEDIENTE_COMERCIAL_METADATOS = "operacionMetadatos";

	
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
	
}
