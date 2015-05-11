package es.pfsgroup.recovery.recobroCommon.ruleengine.rule.definition.manager;

import es.capgemini.pfs.ruleengine.RuleEngineBusinessOperations;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface RecobroRuleDefinitionApi {
	
	/**
	 * Sobreescribimos este operación de negocio para que antes de borrar una regla
	 * compruebe que no está asociada a ninguna cartera
	 * @param id
	 */
	@BusinessOperationDefinition(RuleEngineBusinessOperations.BO_RULE_DEFINITION_DELETE_RULE)
	public void deleteRule(Long id);
	
	/**
	 * Sobreescribimos esta operación de negocio para que no deje modificar una regla
	 * que esté asociada a una cartera
	 * @param rule
	 */
	@BusinessOperationDefinition(RuleEngineBusinessOperations.BO_RULE_DEFINITION_UPDATE_RULE)
	public void updateRule(RuleDefinition rule);

}
