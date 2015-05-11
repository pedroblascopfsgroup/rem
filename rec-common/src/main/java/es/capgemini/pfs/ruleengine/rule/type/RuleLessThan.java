package es.capgemini.pfs.ruleengine.rule.type;

import org.springframework.stereotype.Component;

import es.capgemini.pfs.ruleengine.rule.Rule;

/**
 * TODO DOCUMENTAR FO.
 */
@Component
public class RuleLessThan extends Rule {

    /**
     * TODO DOCUMENTAR FO.
     */
    public RuleLessThan() {
        super();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String generateSQL() {
        return getData() + " < " + getValueFormated();
    }
}
