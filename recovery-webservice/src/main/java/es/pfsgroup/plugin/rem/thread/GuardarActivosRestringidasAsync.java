package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacionofertas.TramitacionOfertasManager;



public class GuardarActivosRestringidasAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoApi activoApi;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;

	

	public GuardarActivosRestringidasAsync(Long idActivo, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
	
				activoApi.propagarTerritorioAgrupacionRestringida(idActivo);

			
		} catch (Exception e) {
			logger.error("error propagando datos agrupacion asistida asincrono", e);
		}

	}

}
