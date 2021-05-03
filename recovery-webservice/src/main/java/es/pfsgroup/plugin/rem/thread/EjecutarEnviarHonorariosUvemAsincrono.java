package es.pfsgroup.plugin.rem.thread;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class EjecutarEnviarHonorariosUvemAsincrono implements Runnable {

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private List<Long> listaIdsAuxiliar = null;

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericApi genericApi;

	public EjecutarEnviarHonorariosUvemAsincrono(String userName, List<Long> listaIdsAuxiliar) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listaIdsAuxiliar = listaIdsAuxiliar;
	}

	@Override
	public void run() {
		try {
			restApi.doSessionConfig(this.userName);
			genericApi.actualizaHonorariosUvem(listaIdsAuxiliar);
			
		} catch (Exception e) {
			logger.error("error ejecutando Thread de EjecutarEnviarHonorariosUvemAsincrono", e);
		}

	}

}
