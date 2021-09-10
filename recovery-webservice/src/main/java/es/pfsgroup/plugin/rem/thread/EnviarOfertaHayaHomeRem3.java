package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.boardingComunicacion.BoardingComunicacionManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.recoveryComunicacion.RecoveryComunicacionManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EnviarOfertaHayaHomeRem3 implements Runnable{
	
	@Autowired
	private RestApi restApi;

	@Autowired
	private BoardingComunicacionManager boardingComunicacionManager;
	
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private Long numOferta = null;
	private ModelMap model = null;
	private String userName = null;
	
	public EnviarOfertaHayaHomeRem3(Long numOferta, ModelMap model, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.numOferta = numOferta;
		this.model = model;
		this.userName = userName;
	}
	
	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			boardingComunicacionManager.enviarOfertaHayaHome(numOferta, model, BoardingComunicacionManager.TIMEOUT_30_SEGUNDOS);
			
		} catch (Exception e) {
			logger.error("Error al enviar la oferta a Haya Home.", e);
		}
		
	}

}
