package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

public class ReactivarActivosAgrupacion implements Runnable {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private RestApi restApi;
	
	private final Log logger = LogFactory.getLog(getClass());

	private ActivoAgrupacion agrupacion = null;

	public ReactivarActivosAgrupacion(ActivoAgrupacion agrupacion) {
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.agrupacion = agrupacion;
	}

	@Override
	public void run() {

		try {
			restApi.doSessionConfig();
			for (ActivoAgrupacionActivo activo : agrupacion.getActivos()) {
				activoApi.updateActivoAsistida(activo.getActivo());
				updaterState.updaterStateDisponibilidadComercial(activo.getActivo());
				activoApi.saveOrUpdate(activo.getActivo());				
			}
		} catch (Exception e) {
			logger.error("error hilo reactivar activos de la agrupacion",e);
		}

	}

}
