package es.pfsgroup.recovery.recobroCommon.ruleengine.rule.definition.manager.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.ruleengine.RuleEngineBusinessOperations;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.recobroCommon.cartera.api.RecobroCarteraApi;
import es.pfsgroup.recovery.recobroCommon.cartera.dto.RecobroDtoCartera;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.ruleengine.rule.definition.manager.RecobroRuleDefinitionApi;

@Component
public class RecobroRuleDefinitionManager implements RecobroRuleDefinitionApi{
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * {@inheritDoc}
	 */
	@BusinessOperation(overrides=RuleEngineBusinessOperations.BO_RULE_DEFINITION_DELETE_RULE)
	@Transactional(readOnly = false)
	public void deleteRule(Long id){		
		RecobroDtoCartera dto = new RecobroDtoCartera();
		dto.setIdRegla(id.toString());
		Page carteras = proxyFactory.proxy(RecobroCarteraApi.class).buscaCarteras(dto);
		if (carteras.getTotalCount()>0){
			throw new BusinessOperationException("No se puede eliminar la regla porque está asociada a una cartera");
		} else {
			genericDao.deleteById(RuleDefinition.class, id);
		}
		
	}

	@Override
	@BusinessOperation(overrides=RuleEngineBusinessOperations.BO_RULE_DEFINITION_UPDATE_RULE)
	public void updateRule(RuleDefinition rule) {
		RecobroDtoCartera dto = new RecobroDtoCartera();
		dto.setIdRegla(rule.getId().toString());
		Page carteras = proxyFactory.proxy(RecobroCarteraApi.class).buscaCarteras(dto);
		if (carteras.getTotalCount()>0){
			throw new BusinessOperationException("No se puede modificar la regla porque está asociada a una cartera");
		} else {
			genericDao.save(RuleDefinition.class, rule);
		}
		
	};

}
