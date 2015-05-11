package es.capgemini.pfs.ruleengine.executor.imp;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;

@Component
public class PrepoliticaRuleExecutor extends RuleExecutor{
    
    @Resource(name="prepoliticasRuleExecutorConf")
    private RuleExecutorConfig ppRuleExecutorConfig;

    /**
     * @param config the config to set
     */
    public void setPPRuleExecutorConfig(RuleExecutorConfig config) {
       this.ppRuleExecutorConfig=config;
       setConfig(config);
    }

    /* (non-Javadoc)
     * @see es.capgemini.pfs.ruleengine.RuleExecutor#getConfig()
     */
    @Override
    public RuleExecutorConfig getConfig() {
        return ppRuleExecutorConfig;
    }
    
    
    

}
