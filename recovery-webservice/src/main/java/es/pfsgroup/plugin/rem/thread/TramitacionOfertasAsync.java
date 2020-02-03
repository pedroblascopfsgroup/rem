package es.pfsgroup.plugin.rem.thread;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacion.TramitacionOfertasManager;



public class TramitacionOfertasAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private TramitacionOfertasManager tramitacionOfertasManager;
	
	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;
	private Boolean aceptado = null;
	private Long idTrabajo = null;
	private Long idOferta = null;
	private Long idExpedienteComercial = null;

	public TramitacionOfertasAsync(Long idActivo, Boolean aceptado, Long idTrabajo, Long idOferta, 
			Long idExpedienteComercial, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
		this.aceptado = aceptado;
		this.idTrabajo = idTrabajo;
		this.idOferta = idOferta;
		this.idExpedienteComercial = idExpedienteComercial;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			if(aceptado) {	
				tramitacionOfertasManager.doTramitacionAsincrona(idActivo, idTrabajo, idOferta, idExpedienteComercial);
			}
			
		} catch (Exception e) {
			logger.error("error creando expediente comercial", e);
		}

	}

}
