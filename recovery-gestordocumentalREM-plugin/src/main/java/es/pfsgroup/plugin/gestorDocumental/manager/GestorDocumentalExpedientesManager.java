package es.pfsgroup.plugin.gestorDocumental.manager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.glassfish.jersey.uri.UriComponent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
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
	private static final String DESCRIPCION_EXPEDIENTE_PATH = "descripcionExpediente=";
	private static final String GASTO_METADATOS_PATH = "gastoMetadatos=";
	
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String COD_CLASE = "codClase";
	private static final String DESCRIPCION_EXPEDIENTE = "descripcionExpediente";
	private static final String GASTO_METADATOS="gastoMetadatos";
	
	
	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES = "rest.client.gestor.documental.expedientes";
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
			throw new GestorDocumentalException(respuesta.getCodigoError() + "-" + respuesta.getMensajeError());
		}
		if (Checks.esNulo(respuesta)) {
			throw new GestorDocumentalException(ERROR_SERVER_NOT_RESPONDING);			
		}
		
		return respuesta;
	}
	
	private String getPathCrearGasto(CrearGastoDto crearGasto) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearGasto");
		sb.append("?").append(USUARIO_PATH).append(crearGasto.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearGasto.getPassword());
		sb.append("&").append(DESCRIPCION_EXPEDIENTE_PATH).append(crearGasto.getDescripcionExpediente());
		sb.append("&").append(COD_CLASE_PATH).append(crearGasto.getCodClase());
		sb.append("&").append(GASTO_METADATOS_PATH).append(UriComponent.encode(crearGasto.getGastoMetadatos(), UriComponent.Type.QUERY_PARAM_SPACE_ENCODED));
		return sb.toString();
	}
	
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
		return restClientApi.getResponse(serverRequest);
	}
}
