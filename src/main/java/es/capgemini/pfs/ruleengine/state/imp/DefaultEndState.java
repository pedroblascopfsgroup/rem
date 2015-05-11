package es.capgemini.pfs.ruleengine.state.imp;

import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public class DefaultEndState implements RuleEndState {

    private String name = "DEFAULT RULE";
    private long priority = 0;
    private String ruleDefinition = "";
    private String value = "0";

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the priority
     */
    public long getPriority() {
        return priority;
    }

    /**
     * @return the ruleDefinition
     */
    public String getRuleDefinition() {
        return ruleDefinition;
    }

    /**
     * @return the value
     */
    public String getValue() {
        return value;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @param priority the priority to set
     */
    public void setPriority(long priority) {
        this.priority = priority;
    }

    /**
     * @param ruleDefinition the ruleDefinition to set
     */
    public void setRuleDefinition(String ruleDefinition) {
        this.ruleDefinition = ruleDefinition;
    }

    /**
     * @param value the value to set
     */
    public void setValue(String value) {
        this.value = value;
    }

}
