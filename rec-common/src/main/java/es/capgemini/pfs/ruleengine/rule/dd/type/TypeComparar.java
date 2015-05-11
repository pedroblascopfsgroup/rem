package es.capgemini.pfs.ruleengine.rule.dd.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class TypeComparar extends DDRuleType {

    public static final String TYPE_COMPARAR1 = "compare1";

    @Override
    public int numberOfValues() {
        return 1;
    }

    @Override
    public String[] getValidOperators() {
        return new String[] { Rule.OPERATOR_NOT_EQUAL, Rule.OPERATOR_EQUAL, Rule.OPERATOR_GREATER_THAN, Rule.OPERATOR_LESS_THAN };
    }

    @Override
    public String getKey() {
        return TYPE_COMPARAR1;
    }

}
