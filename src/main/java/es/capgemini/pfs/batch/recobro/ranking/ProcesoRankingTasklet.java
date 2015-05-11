package es.capgemini.pfs.batch.recobro.ranking;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.batch.recobro.ranking.manager.CalculoRankingAgenciasRecobroManager;

/**
 * Tasklet del proceso de cálculo del Ranking de las subcarteras 
 * @author Guillem
 *
 */
public class ProcesoRankingTasklet implements Tasklet, StepExecutionListener {

	private final Log logger = LogFactory.getLog(getClass());
	
	
	@Autowired
	private CalculoRankingAgenciasRecobroManager calculoRankingAgenciasRecobroManager;
	 	
	
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

	/**
	 * Inicia el proceso de Facturacion a Agencias de recobro
	 */
	@Override
	public ExitStatus execute() throws Exception {
		try {
			logger.debug("Iniciando proceso Calculo Ranking Agencias");
			calculoRankingAgenciasRecobroManager.CalcularRanking();
			logger.debug("Calculo Ranking Agencias finalizado");
			return ExitStatus.FINISHED;
		} catch (Exception e) {
			logger.fatal("No se ha podido calcular el ranking de las agencias de recobro", e);
			return ExitStatus.FAILED;
		} catch (Throwable e) {
			logger.fatal("No se ha podido calcular el ranking de las agencias de recobro", e);
			return ExitStatus.FAILED;
		}
	}

}
