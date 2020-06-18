package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.impl.CreacionTrabajosMasivoAsync;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;


public class LiberarFicheroTrabajos implements Runnable {
	@Autowired
	private RestApi restApi;

	@Autowired
	private CreacionTrabajosMasivoAsync creacionTrabajos;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private DtoFichaTrabajo dtoTrabajo = null;

	public LiberarFicheroTrabajos(String userName, DtoFichaTrabajo dtoTrabajo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.dtoTrabajo = dtoTrabajo;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			creacionTrabajos.doCreacionTrabajosAsync(this.dtoTrabajo);
			
			
		} catch (Exception e) {
			logger.error("error procesando trabajos excel", e);
		}

	}

}
