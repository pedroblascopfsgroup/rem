package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.HashMap;
import java.util.Map;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.ClienteEstadoTrabajo;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

@Service
public class ServiciosWebcomManager implements ServiciosWebcomApi{
	
	private ClienteEstadoTrabajo cliEstadoTrabajo;

	@Override
	public void enviaActualizacionEstadoTrabajo(Long idRem, Long idWebcom, Long idEstado, String motivoRechazo) {
		Map<String, Object> params = new HashMap<String, Object>();
		//TODO Rellenar el HashMap
		try {
			Object respuesta = cliEstadoTrabajo.enviaPeticion(params);
		} catch (ErrorServicioWebcom e) {
			if (ErrorServicioWebcom.INVALID_SIGNATURE.equals(e.getErrorWebcom())){
				//TODO Loguear el error
			}else{
				//TODO Reintentar
				//messageBroker.sendAsync(ClienteEstadoTrabajo.class, params);
			}
		}
	}

}
