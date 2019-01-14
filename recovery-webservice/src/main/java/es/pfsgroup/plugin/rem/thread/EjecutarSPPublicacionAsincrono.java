package es.pfsgroup.plugin.rem.thread;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EjecutarSPPublicacionAsincrono implements Runnable {

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	ArrayList<Long> listaIdActivo = null;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	public EjecutarSPPublicacionAsincrono(String userName, ArrayList<Long> listaIdActivo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listaIdActivo = listaIdActivo;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			if (listaIdActivo != null && listaIdActivo.size() > 0) {
				for (Long idActivo : listaIdActivo) {
					activoEstadoPublicacionApi
							.actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(idActivo, false);
				}
			}
		} catch (Exception e) {
			logger.error("error ejecutando SP de publicaciones", e);
		}

	}

}
