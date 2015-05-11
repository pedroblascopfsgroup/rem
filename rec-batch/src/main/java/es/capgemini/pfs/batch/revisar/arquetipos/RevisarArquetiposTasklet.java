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
import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;

/**
 * Revision de los arquetipos.
 * @author lgiavedo
 *
 */
public class RevisarArquetiposTasklet implements Tasklet, StepExecutionListener {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private ArquetipoManager arquetipoManager;

    @Resource(name = "arquetiposRuleExecutor")
    private RuleExecutor rExecutor;

    @Autowired
    private DDRuleManager rManager;

    /**
     * Inicia el job de revisión de arquetipos.
     * @return ExisEstatus codigo
     */
    @SuppressWarnings("unchecked")
    @Override
    public ExitStatus execute() {
        rManager.regenerateData(rExecutor.getConfig());
        logger.debug("Iniciando Revision de arquetipos");
        rExecutor.execRules(arquetipoManager.getList());
        logger.debug("Revision de arquetipos finalizada");
        return ExitStatus.FINISHED;
    }

    /*--------------------------------------------------------------------
     * StepExecutionListener methods
     *--------------------------------------------------------------------*/

    /**
     * @param stepExecution step
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus afterStep(StepExecution stepExecution) {
        return null;
    }

    /**
     * @param stepExecution step
     * @param error throwable
     * @return ExitStatus codigo
     */
    @Override
    public ExitStatus onErrorInStep(StepExecution stepExecution, Throwable error) {
        return null;
    }

    /**
     * @param stepExecution step
     */
    @Override
    public void beforeStep(StepExecution stepExecution) {
    }

}
