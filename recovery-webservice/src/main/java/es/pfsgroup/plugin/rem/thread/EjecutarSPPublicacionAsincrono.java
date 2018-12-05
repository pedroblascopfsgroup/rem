package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EjecutarSPPublicacionAsincrono implements Runnable{
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	public EjecutarSPPublicacionAsincrono(String userName, Long idActivo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
	}

	@Override
	public void run() {
		activoEstadoPublicacionApi.actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(idActivo);
		
	}

}
