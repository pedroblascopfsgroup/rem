package es.pfsgroup.plugin.rem.restclient.schedule;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

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

	private DeteccionCambiosBDTask schedulerTask;

	public void setSchedulerTask(DeteccionCambiosBDTask t) {
		this.schedulerTask = t;
	}

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		schedulerTask.detectaCambios();

	}

}
