package es.capgemini.pfs.ruleengine.rule.dd.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class TypeZonaCentro extends DDRuleType {

    public static final String TYPE_VALOR = "centro";

    @Override
    public int numberOfValues() {
        //Zona + Centro
        return 2;
    }

    @Override
    public String[] getValidOperators() {
        return new String[] { Rule.OPERATOR_LIKE, Rule.OPERATOR_NOT_LIKE };
    }

    @Override
    public String getKey() {
        return TYPE_VALOR;
    }

}
