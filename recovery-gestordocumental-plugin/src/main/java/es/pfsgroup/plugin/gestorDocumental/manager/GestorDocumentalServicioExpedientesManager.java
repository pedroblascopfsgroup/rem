package es.pfsgroup.plugin.gestorDocumental.manager;

import org.glassfish.jersey.media.multipart.FormDataMultiPart;
import org.glassfish.jersey.media.multipart.MultiPart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalServicioExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.api.RestClientApi;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearEntidadDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGarantiaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearLoanDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearOperacionDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPropuestaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearRelacionDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearReoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.ModificarExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.ServerRequest;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;

@Component
public class GestorDocumentalServicioExpedientesManager implements GestorDocumentalServicioExpedientesApi {

	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES = "rest.client.gestor.documental.expedientes";
	
	
	private static final String USUARIO_PATH = "usuario=";
	private static final String PASSWORD_PATH = "password=";
	private static final String COD_CLASE_PATH = "codClase=";
	private static final String DESCRIPCION_EXPEDIENTE_PATH = "descripcionExpediente=";
	private static final String PROPUESTA_METADATOS_PATH = "propuestaMetadatos=";
	
	private static final String USUARIO = "usuario";
	private static final String PASSWORD = "password";
	private static final String COD_CLASE = "codClase";
	private static final String DESCRIPCION_EXPEDIENTE = "descripcionExpediente";
	private static final String PROPUESTA_METADATOS="propuestaMetadatos";

	@Autowired
	private RestClientApi restClientApi;
	
	@Override
	public RespuestaGeneral crearRelacion(CrearRelacionDto crearRelacion) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearRelacion);
		serverRequest.setResponseClass(RespuestaGeneral.class);
		RespuestaGeneral respuesta = (RespuestaGeneral) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	@Override
	public RespuestaCrearExpediente crearReo(CrearReoDto crearReo) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearReo);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente crearLoan(CrearLoanDto crearLoan) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearLoan);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente crearGarantia(CrearGarantiaDto crearGarantia) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearGarantia);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente crearEntidad(CrearEntidadDto crearEntidad) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearEntidad);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente crearPropuesta(CrearPropuestaDto crearPropuesta) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath(getPathCrearPropuesta(crearPropuesta));
		serverRequest.setMultipart(getMultipartCrearPropuesta(crearPropuesta));
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String getPathCrearPropuesta(CrearPropuestaDto crearPropuesta) {
		StringBuilder sb = new StringBuilder();
		sb.append("/crearPropuesta");
		sb.append("?").append(USUARIO_PATH).append(crearPropuesta.getUsuario());
		sb.append("&").append(PASSWORD_PATH).append(crearPropuesta.getPassword());
		sb.append("&").append(COD_CLASE_PATH).append(crearPropuesta.getCodClase());
		sb.append("&").append(DESCRIPCION_EXPEDIENTE_PATH).append(crearPropuesta.getDescripcionExpediente());
		sb.append("&").append(PROPUESTA_METADATOS_PATH).append(crearPropuesta.getPropuestaMetadatos());
		return sb.toString();
	}
	
	private MultiPart getMultipartCrearPropuesta(CrearPropuestaDto crearPropuesta){
		final MultiPart multipart = new FormDataMultiPart()
				.field(USUARIO, crearPropuesta.getUsuario())
				.field(PASSWORD,  crearPropuesta.getPassword())
				.field(COD_CLASE, crearPropuesta.getCodClase().toString())
				.field(DESCRIPCION_EXPEDIENTE, crearPropuesta.getDescripcionExpediente())
				.field(PROPUESTA_METADATOS, crearPropuesta.getPropuestaMetadatos());
		return multipart;
	}

	@Override
	public RespuestaCrearExpediente crearOperacion(CrearOperacionDto crearOperacion) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_POST);
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearOperacion);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}

	@Override
	public RespuestaCrearExpediente modificarExpediente(ModificarExpedienteDto modificarExpediente) throws GestorDocumentalException {
		ServerRequest serverRequest =  new ServerRequest();
		serverRequest.setMethod(RestClientManager.METHOD_PUT);
		serverRequest.setPath(crearPath("1", "2", "3"));
		//serverRequest.setRequestObject(modificarExpediente);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
	}
	
	private String crearPath(String codTipo, String codClase, String idExpedienteHaya) {
		StringBuilder sb = new StringBuilder();
		sb.append("/documentosExpediente");
		sb.append("/").append(codTipo);
		sb.append("/").append(codClase);
		sb.append("/").append(idExpedienteHaya);
		return sb.toString();
	}
	
	private Object getResponse(ServerRequest serverRequest) {
		serverRequest.setRestClientUrl(URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES);
		return restClientApi.getResponse(serverRequest);
	}

}
