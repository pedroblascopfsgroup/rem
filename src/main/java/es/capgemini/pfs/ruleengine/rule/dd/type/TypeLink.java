package es.capgemini.pfs.ruleengine.rule.dd.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.dd.DDRuleType;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class TypeLink extends DDRuleType {

    public static final String TYPE_LINK = "link";

    @Override
    public int numberOfValues() {
        //No se admiten Valores
        return 0;
    }

    @Override
    public String[] getValidOperators() {
        //No se admiten operadores
        return null;
    }

    @Override
    public String getKey() {
        return TYPE_LINK;
    }

}
