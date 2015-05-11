package es.capgemini.pfs.ruleengine.rule.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;

/**
 * TODO DOCUMENTAR FO.
 */
@Component
public class RuleNotBetween extends Rule {

    /**
     * TODO DOCUMENTAR FO.
     */
    public RuleNotBetween() {
        super();
    }

    public String getValue2() {
        return getValues().get(1);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String generateSQL() {
        return "(" + getData() + " NOT BETWEEN " + getValueFormated() + " AND " + formatValue(getValue2()) + " )";
    }
}
