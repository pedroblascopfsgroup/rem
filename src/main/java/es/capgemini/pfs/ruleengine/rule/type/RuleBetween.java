package es.capgemini.pfs.ruleengine.rule.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;

/**
 * TODO DOCUMENTAR FO.
 */
@Component
public class RuleBetween extends Rule {

    /**
     * TODO DOCUMENTAR FO.
     */
    public RuleBetween() {
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
        return "(" + getData() + " BETWEEN " + getValueFormated() + " AND " + formatValue(getValue2()) + " )";
    }
}
