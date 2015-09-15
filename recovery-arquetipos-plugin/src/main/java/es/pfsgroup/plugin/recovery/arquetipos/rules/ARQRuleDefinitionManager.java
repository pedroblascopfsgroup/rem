package es.pfsgroup.plugin.recovery.arquetipos.rules;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.rules.dao.ARQRuleDefinitionDao;

@Service("ARQRuleDefinitionManager")
public class ARQRuleDefinitionManager {
	
	@Autowired
	private ARQRuleDefinitionDao ruleDao;
	
	public ARQRuleDefinitionManager(){
		
	}
	
	
	
	public ARQRuleDefinitionManager(ARQRuleDefinitionDao ruleDao){
		super();
		this.ruleDao = ruleDao;
	}
	
	/**
	 * 
	 * @param id
	 * @return devuelve el objeto rule definition cuyo id coincide con el parámetro que se le pasa
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.RULE_MGR_GET)
	public RuleDefinition getRule(Long id){
		return ruleDao.get(id);
	}
	
	/**
	 * devulve la lista de todos los paquetes dados de alta en la base de datos
	 * 
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.RULE_MGR_LIST)
	public List<RuleDefinition> listaRule(){
		 return ruleDao.getList();
	}
	
	

}
