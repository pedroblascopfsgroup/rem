package es.capgemini.pfs.ruleengine.rule.dd.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class TypeDiccionario extends DDRuleType {

    public static final String TYPE_DICCIONARIO = "dictionary";

    @Override
    public int numberOfValues() {
        return 1;
    }

    @Override
    public String[] getValidOperators() {
        return new String[] { Rule.OPERATOR_EQUAL, Rule.OPERATOR_NOT_EQUAL, Rule.OPERATOR_NULL, Rule.OPERATOR_NOT_NULL };
    }

    @Override
    public String getKey() {
        return TYPE_DICCIONARIO;
    }

}
