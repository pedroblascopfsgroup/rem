package es.pfsgroup.plugin.rem.restclient.schedule;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

public class DeteccionCambiosBDJob extends QuartzJobBean{
	
	private DeteccionCambiosBDTask schedulerTask;
	
	public void setSchedulerTask(DeteccionCambiosBDTask t){
		this.schedulerTask = t;
	}

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		schedulerTask.detectaCambios();
		
	}

}
