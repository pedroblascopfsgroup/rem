package es.capgemini.pfs.ruleengine;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;

import es.capgemini.devon.validation.ErrorMessage;
import es.capgemini.devon.validation.Severity;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.ruleengine.json.JSONRule;
import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.RuleManager;
import es.capgemini.pfs.ruleengine.rule.conjunction.Rules;
import es.capgemini.pfs.ruleengine.rule.conjunction.imp.AndRules;
import es.capgemini.pfs.ruleengine.rule.conjunction.imp.OrRules;
import es.capgemini.pfs.ruleengine.rule.dd.DDRule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleManager;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleTypeManager;
import es.capgemini.pfs.ruleengine.rule.dd.type.TypeLink;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinitionManager;
import es.capgemini.pfs.ruleengine.xml.XMLRule;

@Component
public class RuleConverterUtil {

    @Autowired
    private DDRuleManager ddRuleManager;

    @Autowired
    private RuleDefinitionManager ruleDefinitionManager;

    @Autowired
    private DDRuleTypeManager ddRuleTypeManager;

    @Autowired
    private RuleManager ruleManager;

    private final Log logger = LogFactory.getLog(getClass());

    public Rule HelperRuleToRule(HelperRule tmpRule, RuleExecutorConfig config) throws ValidationException {
        Rule rule = null;
        if (tmpRule.isGroup()) {
            //Es un grupo de reglas
            if (tmpRule.isType(AndRules.AND_RESTRICTION)) {
                //AND
                rule = new AndRules();
            }
            if (tmpRule.isType(OrRules.OR_RESTRICTION)) {
                //OR
                rule = new OrRules();
            }
            if (rule == null) {
                ErrorMessage em = new ErrorMessage(this, "No se ha encontrado ningun Tipo de Grupo valido para: " + tmpRule.getType(), Severity.ERROR);
                logger.error(em);
                List<ErrorMessage> eml = new ArrayList<ErrorMessage>();
                eml.add(em);
                throw new ValidationException(eml);
            }

            List<HelperRule> rules = tmpRule.getRules();
            for (int i = 0; i < rules.size(); i++) {
                ((Rules) rule).addRule(HelperRuleToRule(rules.get(i),config));
            }

        } else {
            //Es solo una regla

            //Link a otra regla?
            if (tmpRule.isType(TypeLink.TYPE_LINK)) {
                if(tmpRule instanceof JSONRule)
                    rule = JSONToRule(ruleDefinitionManager.getRule(tmpRule.getRuleId()).getRuleDefinition(),config);
                if(tmpRule instanceof XMLRule)
                    rule = XMLToRule(ruleDefinitionManager.getRule(tmpRule.getRuleId()).getRuleDefinition(),config);
                if(rule == null)
                    throwValidationException("HelperRule no implementado para regla de tipo link. ["+tmpRule+"]"); 
                
            } else {//No se trata de un link.
                //Es una regla puntual
            	DDRule ruleDef = ddRuleManager.getRule(tmpRule.getRuleId());

            	if (ruleDef == null) {
                    throwValidationException("No se ha encontrado definicion para la regla: " + tmpRule.getRuleId());
                }
                
                //Validamos que el tipo es correcto
                /*
                DDRuleType ruleType = ddRuleTypeManager.getType(jsonRule.getType());
                if(ruleType == null)
                    throwValidationException("El tipo de regla: "+jsonRule.getType()+" NO es valido!");
                */
                DDRuleType ruleType = ddRuleTypeManager.getType(ruleDef.getType());

                //Validamos que el operator sea correcto para el tipo de regla
                if (!ruleType.isValidOperator(tmpRule.getOperator()))
                    throwValidationException(ruleDef.getTitle() + "-> El operador: " + tmpRule.getOperator() + " NO es valido para la regla: "
                            + ruleType.getKey() + "!");

                //Verificamos si la cantidad de valores es la correcta
                if (ruleType.numberOfValues() != tmpRule.getValues().size())
                    throwValidationException(ruleDef.getTitle() + "-> La cantidad de valores es incorrecta! Se esperaban ["
                            + ruleType.numberOfValues() + "] valores y se han enviado [" + tmpRule.getValues().size() + "]. Datos: ("
                            + tmpRule.getValues() + ")");

                //Verificamos si el tipo de regla solo posee un operador
                if (ruleType.getValidOperators().length == 1)
                    rule = ruleManager.getRule(ruleType.getValidOperators()[0]);
                else
                    rule = ruleManager.getRule(tmpRule.getOperator());
                /*   
                //Regla de tipo Comparar1
                   if(jsonRule.isType(TypeComparar.TYPE_COMPARAR1)){
                       if(jsonRule.hasOperator(Rule.OPERATOR_GREATER_THAN)){
                           rule=new RuleGreaterThan();
                       }
                       if(jsonRule.hasOperator(Rule.OPERATOR_LESS_THAN)){
                           rule=new RuleLessThan();
                       }
                       if(jsonRule.hasOperator(Rule.OPERATOR_EQUAL)){
                           rule=new RuleEqual();
                       }
                   }
                   
                 //Regla de tipo Comparar2
                   if(jsonRule.isType(TypeComparar2.TYPE_COMPARAR2)){
                       rule=new RuleBetween();
                       ((RuleBetween)rule).setValue2(jsonRule.getValues().get(1));
                   }
                 //Regla de tipo Diccionario
                   if(jsonRule.isType(TypeDiccionario.TYPE_DICCIONARIO)){
                       if(jsonRule.hasOperator(Rule.OPERATOR_EQUAL)){
                           rule=new RuleEqual();
                       }
                       if(jsonRule.hasOperator(Rule.OPERATOR_NOT_EQUAL)){
                           rule=new RuleNotEqual();
                       }
                   }*/

                //No ha entrado en ninguna condicion           
                if (rule == null) {
                    throwValidationException(ruleDef.getTitle() + "-> No se ha encontrado ningun Operador valido para: " + tmpRule.getOperator());
                }

                rule.setData(config.getTableFrom().trim()+"."+ruleDef.getColumn());
                rule.setFormat(ruleDef.getFormat());

                for (String value : tmpRule.getValues()) {
                    rule.addValue(value);
                }
            }
        }

        return rule;

    }

    public HelperRule JSONToHelperRule(String json) {
        JSONObject jsonObject = JSONObject.fromObject(json);
        return (HelperRule) JSONObject.toBean(jsonObject, JSONRule.class);
    }

    public HelperRule XMLToHelperRule(String xml)throws ValidationException {
        XStream xstream = new XStream(new DomDriver());
        xstream.processAnnotations(XMLRule.class);
        xstream.alias("rule", XMLRule.class);
        xstream.aliasAttribute("ruleid", "ruleId");
        try{
            return (HelperRule) xstream.fromXML(xml);
        }catch (Exception e) {
            logger.error("Generando regla XML: "+xml,e);
            throwValidationException("Generando regla XML: "+xml);
        }
        return null;
    }

    public Rule JSONToRule(String json, RuleExecutorConfig config) throws ValidationException {
        JSONObject jsonObject = JSONObject.fromObject(json);
        return HelperRuleToRule((HelperRule) JSONObject.toBean(jsonObject, JSONRule.class),config);
    }

    public Rule XMLToRule(String xml, RuleExecutorConfig config) throws ValidationException {
        return HelperRuleToRule(XMLToHelperRule(xml),config);
    }

    private void throwValidationException(String msg) {
        ErrorMessage em = new ErrorMessage(this, msg, Severity.ERROR);
        logger.error(em);
        List<ErrorMessage> eml = new ArrayList<ErrorMessage>();
        eml.add(em);
        throw new ValidationException(eml);
    }

    public DDRuleTypeManager getDdRuleTypeManager() {
        return ddRuleTypeManager;
    }

    public void setDdRuleTypeManager(DDRuleTypeManager ddRuleTypeManager) {
        this.ddRuleTypeManager = ddRuleTypeManager;
    }

    public DDRuleManager getDdRuleManager() {
        return ddRuleManager;
    }

    public void setDdRuleManager(DDRuleManager ddRuleManager) {
        this.ddRuleManager = ddRuleManager;
    }

}
