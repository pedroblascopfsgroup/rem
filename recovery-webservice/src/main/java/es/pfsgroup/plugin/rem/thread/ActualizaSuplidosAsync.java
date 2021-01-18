package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.gastoProveedor.GastoProveedorManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;



public class ActualizaSuplidosAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private GastoProveedorManager gastoProveedorManager;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idGasto = null;
	private Long codProveedorRem = null;
	private String referenciaEmisor = null;

	public ActualizaSuplidosAsync(Long idGasto, Long codProveedorRem, String referenciaEmisor, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idGasto = idGasto;
		this.codProveedorRem = codProveedorRem;
		this.referenciaEmisor = referenciaEmisor;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			gastoProveedorManager.actualizaSuplidosAsync(idGasto, codProveedorRem, referenciaEmisor);
			
		} catch (Exception e) {
			logger.error("error actualizando suplidos", e);
		}

	}

}
