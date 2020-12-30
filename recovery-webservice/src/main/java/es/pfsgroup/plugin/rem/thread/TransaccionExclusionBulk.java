package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.expedienteComercial.ExpedienteComercialManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacionofertas.TramitacionOfertasManager;



public class TransaccionExclusionBulk implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ExpedienteComercialManager expedienteComercialManager;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idExclusion = null;

	public TransaccionExclusionBulk(Long idExclusion, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idExclusion = idExclusion;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			expedienteComercialManager.guardaExclusionBulk(idExclusion);
		} catch (Exception e) {
			logger.error("error creando expediente comercial", e);
		}

	}

}
