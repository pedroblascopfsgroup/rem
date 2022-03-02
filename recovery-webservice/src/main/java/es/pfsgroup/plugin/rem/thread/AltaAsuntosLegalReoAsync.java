package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.AltaAsuntosLegalReoApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class AltaAsuntosLegalReoAsync implements Runnable {
	
	@Autowired
	private RestApi restApi;

	@Autowired
	private AltaAsuntosLegalReoApi altaAsuntosLegalReoApi;
	
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private List<Long> numActivosList = null;
	private ModelMap model = null;
	private String userName = null;
	private int segundosTimeout = 0;
	
	public AltaAsuntosLegalReoAsync(List<Long> numActivosList, String userName, int segundosTimeout, ModelMap model) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.numActivosList = numActivosList;
		this.model = model;
		this.userName = userName;
		this.segundosTimeout = segundosTimeout;
	}
	
	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			altaAsuntosLegalReoApi.altaAsuntosLegalReo(this.numActivosList, this.userName, this.segundosTimeout, this.model);
			
		} catch (Exception e) {
			logger.error("error en la comunicación REM-RCV", e);
		}
		
	}

}
