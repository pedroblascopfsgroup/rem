package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class ValidarFichero implements Runnable{
	
	private String userName = null;
	private Long idProcess;
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RestApi restApi;
	@Autowired
	ProcessAdapter processAdapter;
	
	public ValidarFichero(Long idProcess,String userName){
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idProcess = idProcess;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			
			processAdapter.validarMasivo(idProcess);
			
			
		} catch (Exception e) {
			logger.error("error validando fichero", e);
			processAdapter.setStateError(idProcess);
		}
		
	}

}
