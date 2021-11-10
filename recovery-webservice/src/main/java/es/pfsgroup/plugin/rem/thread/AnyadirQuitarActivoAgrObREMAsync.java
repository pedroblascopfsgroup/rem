package es.pfsgroup.plugin.rem.thread;

import es.pfsgroup.plugin.rem.activo.ActivoAgrupacionManager;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.tramitacionofertas.TramitacionOfertasManager;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import javax.annotation.Resource;


public class AnyadirQuitarActivoAgrObREMAsync implements Runnable {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoAgrupacionManager activoAgrupacionManager;

	@Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;

	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private Long idActivo = null;
	private Boolean anyadir = null;
	private Long idAgrupacion = null;

	public AnyadirQuitarActivoAgrObREMAsync(Long idActivo, Long idAgrupacion, Boolean anyadir, String userName) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.idActivo = idActivo;
		this.anyadir = anyadir;
		this.idAgrupacion = idAgrupacion;
	}

	@Override
	public void run() {
		
		try {
			restApi.doSessionConfig(this.userName);
			
			if(anyadir) {
				activoAgrupacionManager.anyadirActivoEnAgrupacionRestringidaDesdeObRem(idActivo, idAgrupacion);
			}else{
				activoAgrupacionManager.borrarActivoEnAgrupacionRestringidaDesdeObRem(idActivo, idAgrupacion);
			}
			
		} catch (Exception e) {
			logger.error("error creando expediente comercial", e);
		}

	}

}
