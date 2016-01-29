package es.pfsgroup.plugin.recovery.arquetipos.rules.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.plugin.recovery.arquetipos.rules.dao.ARQRuleDefinitionDao;

@Repository("ARQRuleDefinitionDao")
public class ARQRuleDefinitionDaoImpl extends AbstractEntityDao<RuleDefinition, Long> implements ARQRuleDefinitionDao {

}
