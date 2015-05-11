package es.capgemini.pfs.batch.recobro.simulacion;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroSimulacionEsquemaManager;

/**
 * Proceso de Control de la Simulaci�n
 * @author Guillem
 *
 */
public class ProcesoControlSimulacionTasklet implements Tasklet, StepExecutionListener {
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private RecobroSimulacionEsquemaManager recobroSimulacionEsquemaManager;

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
			logger.debug("Iniciando el job de control de la simulaci�n");
			Long numeroProcesosPendientes = recobroSimulacionEsquemaManager.obtenerNumeroProcesosEstadoPendiente();
			if(numeroProcesosPendientes == 0){
				logger.debug("No se ha encontrado ning�n proceso de simulaci�n en estado pendiente. Se termina el proceso.");
				return ExitStatus.NOOP;
			}else if(numeroProcesosPendientes == 1){
				logger.debug("Encontrado un proceso de simulaci�n en estado pendiente.");
				return ExitStatus.FINISHED;
			}else{
				logger.debug("Se han encontrado m�s de 1 proceso de simulaci�n en estado pendiente. Se aborta el proceso.");
				return ExitStatus.FAILED;
			}
		} catch (Throwable e) {
			logger.fatal("Se ha producido una excepci�n durante el job de control de la simulaci�n: ", e);
			return ExitStatus.FAILED;
		}
	}

}
