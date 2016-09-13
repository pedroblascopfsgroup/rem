package es.pfsgroup.plugin.rem.restclient.webcom.clients;

import java.util.Map;

import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

public interface ClienteWebcom {

	Map<String, Object> enviaPeticion(Map<String, Object> params) throws ErrorServicioWebcom;

	void procesaRespuesta(Map<String, Object> respuesta);

}