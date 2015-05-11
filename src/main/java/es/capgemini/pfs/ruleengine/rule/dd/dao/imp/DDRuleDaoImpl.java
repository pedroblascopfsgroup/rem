package es.capgemini.pfs.ruleengine.rule.dd.dao.imp;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.rule.dd.DDRule;
import es.capgemini.pfs.ruleengine.rule.dd.dao.DDRuleDao;


/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Repository("RuleDefinitionDao")
public class DDRuleDaoImpl extends AbstractEntityDao<DDRule, Long> implements DDRuleDao{

    @Override
    public void regenerateData(RuleExecutorConfig config) {
        getSession().createSQLQuery("{CALL DBMS_MVIEW.REFRESH('"+config.getTableFrom()+"')}").executeUpdate();
        
    }
    
    

}
