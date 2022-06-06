package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacionofertas.TramitacionOfertasManager;



public class CongelarOfertasAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private OfertaApi ofertaApi;

	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private List<Long> idOfertaList = null;

	public CongelarOfertasAsync(List<Long> idOfertaList, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idOfertaList = idOfertaList;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			ofertaApi.congelarOfertasThread(idOfertaList);
			
		} catch (Exception e) {
			logger.error("Error en la congelación asyn", e);
		}

	}

}
