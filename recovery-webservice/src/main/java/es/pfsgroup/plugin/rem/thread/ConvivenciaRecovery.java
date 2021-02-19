package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.recoveryComunicacion.RecoveryComunicacionManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class ConvivenciaRecovery implements Runnable{
	
	@Autowired
	private RestApi restApi;

	@Autowired
	private RecoveryComunicacionManager recoveryComunicacionManager;
	
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private Activo activo = null;
	private ModelMap model = null;
	
	public ConvivenciaRecovery(Activo activo, ModelMap model) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.activo = activo;
		this.model = model;
	}
	
	@Override
	public void run() {
		
		try {
			recoveryComunicacionManager.datosCliente(this.activo, this.model);
			
		} catch (Exception e) {
			logger.error("error en la convivencia REM-RCV", e);
		}
		
	}

}
