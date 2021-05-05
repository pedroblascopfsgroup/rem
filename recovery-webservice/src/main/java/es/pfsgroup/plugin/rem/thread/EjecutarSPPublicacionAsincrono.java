package es.pfsgroup.plugin.rem.thread;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EjecutarSPPublicacionAsincrono implements Runnable {

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	ArrayList<Long> listaIdActivo = null;
	ArrayList<Long> listaIdActivoSinVisibilidad = null;

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
	
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;

	public EjecutarSPPublicacionAsincrono(String userName, ArrayList<Long> listaIdActivo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listaIdActivo = listaIdActivo;
	}
	
	public EjecutarSPPublicacionAsincrono(String userName, ArrayList<Long> listaIdActivo, ArrayList<Long> listaIdActivoSinVisibilidad ) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listaIdActivo = listaIdActivo;
		this.listaIdActivoSinVisibilidad = listaIdActivoSinVisibilidad;
	}
	
	

	@Override
	@Transactional
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			if (listaIdActivo != null && listaIdActivo.size() > 0) {				
				activoEstadoPublicacionApi.actualizarEstadoPublicacionDelActivoOrAgrupacionRestringidaSiPertenece(listaIdActivo, false);
				
			}
			if(listaIdActivoSinVisibilidad != null) {
				if(!listaIdActivoSinVisibilidad.isEmpty()) {
					recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(listaIdActivoSinVisibilidad);
				}
			}else {
				recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(listaIdActivo);
			}

		} catch (Exception e) {
			logger.error("error ejecutando SP de publicaciones", e);
		}

	}

}
