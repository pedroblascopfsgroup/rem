package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.oferta.OfertaManager;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EnviarCorreoFichaComercialExcel implements Runnable{
	
	@Autowired
	private RestApi restApi;

	@Autowired
	private OfertaManager ofertaManager;
	
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private List<Long> ids = null;
	private String reportCode = null;
	private String scheme = null;
	private String serverName = null;
	private String userName = null;
	
	public EnviarCorreoFichaComercialExcel(List<Long> ids, String reportCode,  String scheme, String serverName, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.ids = ids;
		this.reportCode = reportCode;
		this.scheme = scheme;
		this.serverName = serverName;
		this.userName = userName;
	}
	
	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			ofertaManager.enviarCorreoFichaComercial(ids, reportCode, scheme, serverName);
			
		} catch (Exception e) {
			logger.error("error al enviar correo de la ficha comercial", e);
		}
		
	}

}
