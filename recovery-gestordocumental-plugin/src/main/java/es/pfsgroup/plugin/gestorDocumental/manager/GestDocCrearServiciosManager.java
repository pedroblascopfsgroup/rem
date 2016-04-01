package es.pfsgroup.plugin.gestorDocumental.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
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
import es.pfsgroup.plugin.gestordocumental.api.GestDocCrearServiciosApi;
import es.pfsgroup.plugin.gestordocumental.api.RestClientApi;

@Component
public class GestDocCrearServiciosManager implements GestDocCrearServiciosApi {

	private static final String URL_REST_CLIENT_GESTOR_DOCUMENTAL_EXPEDIENTES = "rest.client.gestor.documental.expedientes";
	
	public static final Integer CLASE_EXP_SUELO = 1;
	public static final Integer CLASE_EXP_OBRA_EN_CURSO = 2;
	public static final Integer CLASE_EXP_OBRA_FINALIZADA = 3;
	public static final Integer CLASE_EXP_NORMAS = 4;
	public static final Integer CLASE_EXP_VENTA = 5;	
	
//	AI	01	SUELO (Proyecto)
//	AI	02	OBRA EN CURSO (Promoción)
//	AI	03	OBRA FINALIZADA (Activo)
//	AI	04	NORMAS E INSTRUMENTOS DE AMBITO GENERAL
//	AI	05	VENTA (AI)*

	
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
		serverRequest.setPath("");
		//serverRequest.setRequestObject(crearPropuesta);
		serverRequest.setResponseClass(RespuestaCrearExpediente.class);
		RespuestaCrearExpediente respuesta = (RespuestaCrearExpediente) getResponse(serverRequest);
		if(!Checks.esNulo(respuesta.getCodigoError())) {
			throw new GestorDocumentalException(respuesta.getMensajeError());
		}
		return respuesta;
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
