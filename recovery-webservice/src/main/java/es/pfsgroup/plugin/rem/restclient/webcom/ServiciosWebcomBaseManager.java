package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.api.services.webcom.FaltanCamposObligatoriosException;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.restclient.utils.WebcomRequestUtils;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.webcom.definition.ConstantesGenericas;
import es.pfsgroup.recovery.api.UsuarioApi;

public class ServiciosWebcomBaseManager {

	public ServiciosWebcomBaseManager() {
		super();
	}

	protected void compruebaObligatorios(HashMap<String, Object> params, String... fields) {
		ArrayList<String> missingFields = new ArrayList<String>();
		if (!fieldExists(params, ConstantesGenericas.FECHA_ACCION)) {
			missingFields.add(ConstantesGenericas.FECHA_ACCION);
		}
	
		if (!fieldExists(params, ConstantesGenericas.ID_USUARIO_REM_ACCION)) {
			missingFields.add(ConstantesGenericas.ID_USUARIO_REM_ACCION);
		}
		for (String f : fields) {
			if (!fieldExists(params, f)) {
				missingFields.add(f);
			}
		}
		if (!missingFields.isEmpty()) {
			throw new FaltanCamposObligatoriosException(missingFields);
		}
	}

	private boolean fieldExists(Map<String, Object> params, String field) {
		if ((params.get(field) == null) || ("".equals(params.get(field)))) {
			return false;
		}
		return true;
	}

	protected HashMap<String, Object> createParametersMap(ApiProxyFactory proxyFactory) {
		Usuario usuLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
	
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put(ConstantesGenericas.FECHA_ACCION, WebcomRequestUtils.formatDate(new Date()));
		params.put(ConstantesGenericas.ID_USUARIO_REM_ACCION, usuLogado.getUsername());
		return params;
	}

	protected void invocarServicioRestWebcom(HashMap<String, Object> params, ClienteWebcom servicio) {
		try {
			Map<String, Object> respuesta = servicio.enviaPeticion(params);
			servicio.procesaRespuesta(respuesta);
		} catch (ErrorServicioWebcom e) {
			if (ErrorServicioWebcom.INVALID_SIGNATURE.equals(e.getErrorWebcom())) {
				// TODO Loguear el error
			} else {
				// TODO Reintentar
				// messageBroker.sendAsync(ClienteEstadoTrabajo.class, params);
			}
		}
	}

}