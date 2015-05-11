package es.capgemini.pfs.batch.revisar.arquetipos;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.batch.core.StepExecution;
import org.springframework.batch.core.StepExecutionListener;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.ExitStatus;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.arquetipo.ArquetipoManager;
import es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions.ExtendedRuleExecutorException;
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;

/**
 * Revision de los arquetipos.
 * 
 * @author lgiavedo
 * 
 */
public class RevisionGenericaArquetiposTasklet implements Tasklet,
		StepExecutionListener {

	private final Log logger = LogFactory.getLog(getClass());

	private RepositorioArquetipos arquetiposRepo;

	private RuleExecutor ruleExecutor;

	public RepositorioArquetipos getArquetiposRepo() {
		return arquetiposRepo;
	}

	public void setArquetiposRepo(RepositorioArquetipos arquetiposRepo) {
		this.arquetiposRepo = arquetiposRepo;
	}

	public RuleExecutor getRuleExecutor() {
		return ruleExecutor;
	}

	public void setRuleExecutor(RuleExecutor ruleExecutor) {
		this.ruleExecutor = ruleExecutor;
	}

	/**
	 * Inicia el job de revisión de arquetipos.
	 * 
	 * @return ExisEstatus codigo
	 */
	@SuppressWarnings("unchecked")
	@Override
	public ExitStatus execute() {
		try {
			logger.debug("Iniciando Revision de arquetipos");
			ruleExecutor.execRules(arquetiposRepo.getList());
			logger.debug("Revision de arquetipos finalizada");
			return ExitStatus.FINISHED;
		} catch (ExtendedRuleExecutorException e) {
			logger.fatal("No se han podido arquetipar las personas", e);
			return ExitStatus.FAILED;
		}

	}

	/*--------------------------------------------------------------------
	 * StepExecutionListener methods
	 *--------------------------------------------------------------------*/

	/**
	 * @param stepExecution
	 *            step
	 * @return ExitStatus codigo
	 */
	@Override
	public ExitStatus afterStep(StepExecution stepExecution) {
		return null;
	}

	/**
	 * @param stepExecution
	 *            step
	 * @param error
	 *            throwable
	 * @return ExitStatus codigo
	 */
	@Override
	public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable error) {
		return null;
	}

	/**
	 * @param stepExecution
	 *            step
	 */
	@Override
	public void beforeStep(StepExecution stepExecution) {
	}

}
