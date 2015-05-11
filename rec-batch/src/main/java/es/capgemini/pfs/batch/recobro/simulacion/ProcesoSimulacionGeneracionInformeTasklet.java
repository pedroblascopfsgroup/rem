package es.capgemini.pfs.batch.recobro.simulacion;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.recobro.simulacion.manager.GeneracionInformesSimulacionManager;

/**
 * Proceso de Simulaci�n, generaci�n de excels
 * @author javier
 *
 */
public class ProcesoSimulacionGeneracionInformeTasklet implements Tasklet, StepExecutionListener {
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GeneracionInformesSimulacionManager generacionInformesSimulacionManager;

	@Override
	public void beforeStep(StepExecution stepExecution) {
		
	}

	@Override
	public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable e) {
		return null;
	}

	@Override
	public ExitStatus afterStep(StepExecution stepExecution) {
		return null;
	}

	@Override
	public ExitStatus execute() throws Exception {
		try {
			logger.debug("Iniciando generaci�n excel 1 de simulaci�n");
			generacionInformesSimulacionManager.generarInformeResultadoSimulacion();
			logger.debug("Generada excel 1 de simulaci�n");
			return ExitStatus.FINISHED;
		} catch (Exception e) {
			logger.fatal("No se ha podido generar las excels de simulaci�n", e);
			return ExitStatus.FAILED;
		} catch (Throwable e) {
			logger.fatal("No se ha podido generar las excels de simulaci�n", e);
			return ExitStatus.FAILED;
		}
	}

}
