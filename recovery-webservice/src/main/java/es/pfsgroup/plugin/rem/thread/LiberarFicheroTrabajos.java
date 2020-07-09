package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.plugin.rem.api.impl.CreacionTrabajosMasivoAsync;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;


public class LiberarFicheroTrabajos implements Runnable {
	@Autowired
	private RestApi restApi;

	@Autowired
	private CreacionTrabajosMasivoAsync creacionTrabajos;
	
	@Autowired
	private ProcessAdapter processAdapter;
	
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
			processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			
		} catch (Exception e) {
			processAdapter.addFilaProcesada(dtoTrabajo.getIdProceso(), false);
			processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			logger.error("error procesando trabajos excel", e);
		}

	}

}
