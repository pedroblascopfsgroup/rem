package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class ReactivarActivosAgrupacion implements Runnable {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	private Long idAgrupacion = null;

	private String userName = null;

	public ReactivarActivosAgrupacion(Long idAgrupacion, String userName) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idAgrupacion = idAgrupacion;
	}

	@Override
	public void run() {

		try {
			restApi.doSessionConfig(this.userName);
			activoApi.reactivarActivosPorAgrupacion(idAgrupacion);
		} catch (Exception e) {
			logger.error("error hilo reactivar activos de la agrupacion", e);
		}

	}

}
