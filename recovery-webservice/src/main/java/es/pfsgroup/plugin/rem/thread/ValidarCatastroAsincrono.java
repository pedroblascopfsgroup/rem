package es.pfsgroup.plugin.rem.thread;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.CatastroApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class ValidarCatastroAsincrono implements Runnable {

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	ArrayList<String> listaRefCatastro = null;
	Long idActivo = null;

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private CatastroApi catastroApi;
	

	public ValidarCatastroAsincrono(String userName, ArrayList<String> listaRefCatastro, Long idActivo) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listaRefCatastro = listaRefCatastro;
		this.idActivo = idActivo;
	}
	
	

	@Override
	@Transactional
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			catastroApi.validaAsincrono(listaRefCatastro, idActivo);
			
		} catch (Exception e) {
			logger.error("error validando los datos del catastro", e);
		}

	}

}
