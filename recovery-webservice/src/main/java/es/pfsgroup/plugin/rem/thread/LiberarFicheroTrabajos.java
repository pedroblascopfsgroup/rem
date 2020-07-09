package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.trabajo.TrabajoManager;


public class LiberarFicheroTrabajos implements Runnable {
	@Autowired
	private RestApi restApi;

	@Autowired
	private TrabajoManager trabajoManager;
	
	@Autowired
	private ProcessAdapter processAdapter;
	
	private final Log logger = LogFactory.getLog(getClass());
	private Usuario user = null;
	private DtoFichaTrabajo dtoTrabajo = null;

	public LiberarFicheroTrabajos(Usuario user, DtoFichaTrabajo dtoTrabajo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.user = user;
		this.dtoTrabajo = dtoTrabajo;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.user.getUsername());
			trabajoManager.doCreacionTrabajosAsync(this.dtoTrabajo, this.user);
			processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			
		} catch (Exception e) {
			processAdapter.addFilaProcesada(dtoTrabajo.getIdProceso(), false);
			processAdapter.setStateProcessed(dtoTrabajo.getIdProceso());
			logger.error("error procesando trabajos excel", e);
		}

	}

}
