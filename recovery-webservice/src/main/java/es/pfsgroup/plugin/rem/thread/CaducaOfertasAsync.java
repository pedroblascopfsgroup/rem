package es.pfsgroup.plugin.rem.thread;

import es.pfsgroup.plugin.rem.api.ConcurrenciaApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import javax.annotation.Resource;


public class CaducaOfertasAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ConcurrenciaApi concurrenciaApi;

	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;
	private Long idOferta = null;

	public CaducaOfertasAsync(Long idActivo, Long idOferta, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
		this.idOferta = idOferta;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			concurrenciaApi.caducaOfertasRelacionadasConcurrencia(idActivo, idOferta);
			
		} catch (Exception e) {
			logger.error("error caducando ofertas en concurrencia", e);
		}

	}

}
