package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class ConvivenciaAlaska implements Runnable{
	
	@Autowired
	private RestApi restApi;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private Long idActivo = null;
	private ModelMap model = null;
	private String userName = null;
	
	public ConvivenciaAlaska(Long idActivo, ModelMap model, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.idActivo = idActivo;
		this.model = model;
		this.userName = userName;
	}
	
	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			alaskaComunicacionManager.datosCliente(this.idActivo, this.model);
			
		} catch (Exception e) {
			logger.error("error en la convivencia REM-REM3 para Alaska", e);
		}
		
	}

}
