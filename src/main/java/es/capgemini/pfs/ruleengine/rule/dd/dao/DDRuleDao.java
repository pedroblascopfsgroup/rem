package es.capgemini.pfs.ruleengine.rule.dd.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.rule.dd.DDRule;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public interface DDRuleDao extends AbstractDao<DDRule, Long> {
    
    public void regenerateData(RuleExecutorConfig config);
}
