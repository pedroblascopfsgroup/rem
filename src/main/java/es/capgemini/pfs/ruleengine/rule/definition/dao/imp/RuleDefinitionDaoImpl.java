package es.capgemini.pfs.ruleengine.rule.definition.dao.imp;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.ruleengine.rule.definition.dao.RuleDefinitionDao;


/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Repository("RuleDefinitionDaoImpl")
public class RuleDefinitionDaoImpl extends AbstractEntityDao<RuleDefinition, Long> implements RuleDefinitionDao{

}
