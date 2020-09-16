package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EnvioDocumentoGestorDocBulk implements Runnable {
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	private List<Long> listaIdsExpedientesCom = null;
	private WebFileItem webFileItem = null;
	private String codSubtipoDocumento = null;
	private String username = null;

	public EnvioDocumentoGestorDocBulk(List<Long> listaIdsExpedientesCom, WebFileItem webFileItem, String codSubtipoDocumento, String username) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.listaIdsExpedientesCom = listaIdsExpedientesCom;
		this.webFileItem = webFileItem;
		this.codSubtipoDocumento = codSubtipoDocumento;
		this.username = username;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.username);
			expedienteComercialApi.uploadDocumentosBulkGD(listaIdsExpedientesCom, webFileItem, codSubtipoDocumento, username);
		} catch (GestorDocumentalException ex) {
			logger.error("Error subida documento de ofertas Bulk en Gestor Documental ", ex);
		} catch (Exception e) {
			logger.error("Error ", e);
		}
	}

}
