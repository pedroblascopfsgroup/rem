package es.capgemini.pfs.ruleengine.rule.conjunction;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.ruleengine.rule.Rule;

/**
 * TODO DOCUMENTAR FO.
 *
 */
public abstract class Rules extends Rule {

    private List<Rule> rules = new ArrayList<Rule>();

    public List<Rule> getRules() {
        return rules;
    }

    public void setRules(List<Rule> rules) {
        this.rules = rules;
    }

    public void addRule(Rule rule) {
        this.rules.add(rule);
    }

}
