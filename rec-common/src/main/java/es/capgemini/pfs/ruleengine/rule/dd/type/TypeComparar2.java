package es.capgemini.pfs.ruleengine.rule.dd.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class TypeComparar2 extends DDRuleType {

    public static final String TYPE_COMPARAR2 = "compare2";

    @Override
    public int numberOfValues() {
        return 2;
    }

    @Override
    public String[] getValidOperators() {
        return new String[] { Rule.OPERATOR_BETWEEN, Rule.OPERATOR_NOT_BETWEEN };
    }

    @Override
    public String getKey() {
        return TYPE_COMPARAR2;
    }

}
