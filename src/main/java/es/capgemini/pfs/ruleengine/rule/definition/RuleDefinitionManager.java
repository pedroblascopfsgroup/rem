package es.capgemini.pfs.ruleengine.rule.definition;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.ruleengine.RuleEngineBusinessOperations;
import es.capgemini.pfs.ruleengine.rule.definition.dao.RuleDefinitionDao;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class RuleDefinitionManager {

    @Autowired
    private RuleDefinitionDao rDao;
    
    public class  RuleDefinitionComparator implements Comparator<RuleDefinition> {
        @Override
        public int compare(RuleDefinition o1, RuleDefinition o2) {
            return (o1.getName().toLowerCase()).compareTo(o2.getName().toLowerCase());
        }
    }

    @BusinessOperation(RuleEngineBusinessOperations.BO_RULE_DEFINITION_GET_LIST)
    public List<RuleDefinition> getList() {
        List<RuleDefinition> rules = rDao.getList();
        Collections.sort(rules, new RuleDefinitionComparator());
        return rules;
        
    }

    @BusinessOperation(RuleEngineBusinessOperations.BO_RULE_DEFINITION_GET_RULE_BY_ID)
    public RuleDefinition getRule(Long id) {
        return rDao.get(id);
    }

    @BusinessOperation(RuleEngineBusinessOperations.BO_RULE_DEFINITION_SAVE_RULE)
    @Transactional(readOnly = false)
    public Long saveRule(RuleDefinition rule) {
        rDao.saveOrUpdate(rule);
        return rule.getId();
    }

    @BusinessOperation(RuleEngineBusinessOperations.BO_RULE_DEFINITION_UPDATE_RULE)
    @Transactional(readOnly = false)
    public void updateRule(RuleDefinition rule) {
        rDao.update(rule);
    }
    
    @BusinessOperation(RuleEngineBusinessOperations.BO_RULE_DEFINITION_DELETE_RULE)
    @Transactional(readOnly=false)
    public void deleteRule(Long id) {
        RuleDefinition mock=rDao.load(id);
        rDao.delete(mock);
    }

}
