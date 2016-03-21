package es.capgemini.pfs.ruleengine.rule.dd;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.ruleengine.RuleEngineBusinessOperations;
import es.capgemini.pfs.ruleengine.RuleExecutorConfig;
import es.capgemini.pfs.ruleengine.rule.dd.dao.DDRuleDao;
import es.capgemini.pfs.ruleengine.rule.dd.type.TypeDiccionario;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class DDRuleManager {

    @Autowired
    private DDRuleDao ruleDefinitionDao;
    @Autowired
    private Executor executor;
    
    private final Log logger = LogFactory.getLog(getClass());
    

    @SuppressWarnings({ "unchecked", "rawtypes" })
	@BusinessOperation(RuleEngineBusinessOperations.BO_DDRULE_GET_LIST)
	public List<DDRule> getList() {
		List<DDRule> ddRules = ruleDefinitionDao.getList();
		for (DDRule ddRule : ddRules) {
			if (TypeDiccionario.TYPE_DICCIONARIO.equalsIgnoreCase(ddRule
					.getType())) {
				if (ddRule.getBusinessOperation() == null
						|| StringUtils.isEmpty(ddRule.getBusinessOperation()
								.trim())) {
					logger.warn("No se ha definifo BO para el dictionary: ID "
							+ ddRule.getId() + " - " + ddRule.getTitle()
							+ " - " + ddRule.getColumn());
					continue;
				}
				try {
					List listaValoresDiccionario = (List) executor.execute(
							ComunBusinessOperation.BO_DICTIONARY_GET_LIST,
							ddRule.getBusinessOperation());
					
					Collections.sort(listaValoresDiccionario, new Comparator<Dictionary>() {

						@Override
						public int compare(Dictionary first, Dictionary second) {
							return first.getDescripcion().compareTo(second.getDescripcion());
						}
					});
					ddRule.setValues(listaValoresDiccionario);
				} catch (Exception e) {
					logger.error(
							"Error al intentar obtener los valores para el dictionary: ID "
									+ ddRule.getId() + " - "
									+ ddRule.getTitle() + " - "
									+ ddRule.getColumn(), e);
				}
			}
		}

		return ddRules;
	}

    @BusinessOperation(RuleEngineBusinessOperations.BO_DDRULE_GET_RULE_BY_ID)
    public DDRule getRule(Long id) {
        return ruleDefinitionDao.get(id);
    }
    
    @BusinessOperation(RuleEngineBusinessOperations.BO_DDRULE_SAVE_RULE)
    public Long saveRule(DDRule rule) {
        return ruleDefinitionDao.save(rule);
    }
    
    public void regenerateData(RuleExecutorConfig config) {
        ruleDefinitionDao.regenerateData(config);
    }

}
