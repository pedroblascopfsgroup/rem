package es.capgemini.pfs.ruleengine.executor.imp;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.RuleExecutor;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;

@Component
public class ArquetiposRuleExecutor extends RuleExecutor{
    
    @Resource(name="arquetiposRuleExecutorConf")
    private RuleExecutorConfig aRuleExecutorConfig;

    /**
     * @param config the config to set
     */
    public void setARuleExecutorConfig(RuleExecutorConfig config) {
       this.aRuleExecutorConfig=config;
       setConfig(config);
    }

    /* (non-Javadoc)
     * @see es.capgemini.pfs.ruleengine.RuleExecutor#getConfig()
     */
    @Override
    public RuleExecutorConfig getConfig() {
        return aRuleExecutorConfig;
    }

}
