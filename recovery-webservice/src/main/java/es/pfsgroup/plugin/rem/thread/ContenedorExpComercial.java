package es.pfsgroup.plugin.rem.thread;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;



public class ContenedorExpComercial implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idExpedienteComercial = null;

	public ContenedorExpComercial(String userName, Long idExpedienteComercial) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idExpedienteComercial = idExpedienteComercial;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			Integer idContenedor = gestorDocumentalAdapterApi.crearExpedienteComercialTransactional(idExpedienteComercial, userName);
			logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + idExpedienteComercial
						+ "]: ID EXPEDIENTE RECIBIDO " + idContenedor);
			
			
		} catch (Exception e) {
			logger.error("error creando contenedor expediente comercial", e);
		}

	}

}
