package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
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
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
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
			
		} catch (Exception e) {
			logger.error("error procesando trabajos excel", e);
		}

	}

}
