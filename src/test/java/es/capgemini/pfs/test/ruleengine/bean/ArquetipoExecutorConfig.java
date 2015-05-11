package es.capgemini.pfs.test.ruleengine.bean;

import es.capgemini.pfs.ruleengine.RuleExecutorConfig;

/**
 * @author lgiavedo
 *
 */
public class ArquetipoExecutorConfig extends RuleExecutorConfig{

    public ArquetipoExecutorConfig() {
        super();
        tableFrom="V_ARQUETIPOS";
        tableToUpdate="PER_PERSONAS";
        columnToUpdate="ARQ_ID_CALCULADO";
        columnFromRef="PER_ID";
        columnToRef="PER_ID";
    }
    
    
}
