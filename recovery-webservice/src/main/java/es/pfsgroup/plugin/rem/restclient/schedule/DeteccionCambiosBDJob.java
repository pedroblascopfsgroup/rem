package es.pfsgroup.plugin.rem.restclient.schedule;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;

/**
 * Esta clase implementa un job Quartz para realizar la comprobación periódica
 * de cambios en BD y enviar llamadas a los servicios REST de WEBCOM
 * 
 * La planificación del scheduler la encontraremos en el optional-configuration
 * ac-rem-deteccion-cambios-bd.xml.
 * 
 * @author bruno
 *
 */
public class DeteccionCambiosBDJob extends QuartzJobBean {
	
	private final Log logger = LogFactory.getLog(getClass());

	private DeteccionCambiosBDTask schedulerTask;

	public void setSchedulerTask(DeteccionCambiosBDTask t) {
		this.schedulerTask = t;
	}

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		try {
			schedulerTask.detectaCambios();
		} catch (ErrorServicioWebcom e) {
			logger.error("error en el job DeteccionCambiosBDJob",e);
		}
	}

}
