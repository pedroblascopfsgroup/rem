package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.WebcomEndpoint;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.EstadoTrabajoConstantes;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service
public class ServiciosWebcomManager implements ServiciosWebcomApi {


	@Autowired
	private HttpClientFacade httpClient;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, Long idEstado, String motivoRechazo) {
		Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		HashMap<String, String> params = new HashMap<String, String>();
		params.put(EstadoTrabajoConstantes.FECHA_ACCION, WebcomRequestUtils.formatDate(new Date()));
		params.put(EstadoTrabajoConstantes.ID_USUARIO_REM_ACCION, usuLogado.getUsername());
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_REM, idRem.toString());
		params.put(EstadoTrabajoConstantes.ID_TRABAJO_WEBCOM, idWebcom.toString());
		params.put(EstadoTrabajoConstantes.ID_ESTADO_TRABAJO, idEstado.toString());
		
		if (motivoRechazo != null && (!"".equals(motivoRechazo))) {
			params.put(EstadoTrabajoConstantes.MOTIVO_RECHAZO, motivoRechazo);
		}

		

		try {
			WebcomEndpoint endpoint = WebcomEndpoint.estadoTrabajo();
			ClienteEstadoTrabajo service = new ClienteEstadoTrabajo(httpClient, endpoint);
			Map<String, Object> respuesta = service.enviaPeticion(params);
			service.procesaRespuesta(respuesta);
		} catch (ErrorServicioWebcom e) {
			if (ErrorServicioWebcom.INVALID_SIGNATURE.equals(e.getErrorWebcom())) {
				// TODO Loguear el error
			} else {
				// TODO Reintentar
				//messageBroker.sendAsync(ClienteEstadoTrabajo.class, params);
			}
		}
	}

	

}
