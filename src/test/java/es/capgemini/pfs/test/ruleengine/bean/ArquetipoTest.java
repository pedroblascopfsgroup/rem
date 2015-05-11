package es.capgemini.pfs.test.ruleengine.bean;

import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * @author lgiavedo
 *
 */
public abstract class ArquetipoTest implements RuleEndState {

    protected long id;
    protected String name;
    protected long priority;
    protected String value;
    protected String definitionRule;

    public ArquetipoTest() {
        super();
    }

    public ArquetipoTest(long id, String name, long priority, String value, String jsonRule) {
        super();
        this.id = id;
        this.name = name;
        this.priority = priority;
        this.value = value;
        this.definitionRule = jsonRule;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getPriority() {
        return priority;
    }

    public void setPriority(long priority) {
        this.priority = priority;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDefinitionRule() {
        return definitionRule;
    }

    public void setJsonRule(String jsonRule) {
        this.definitionRule = jsonRule;
    }

    /* (non-Javadoc)
     * @see es.capgemini.pfs.ruleengine.state.RuleEndState#getRuleDefinition()
     */
    @Override
    public String getRuleDefinition() {
        return definitionRule;
    }

    /* (non-Javadoc)
     * @see es.capgemini.pfs.ruleengine.state.RuleEndState#getRule()
     
    @Override
    public Rule getRule() {
        try {
            return rcUtil.JSONToRule(jsonRule);
        } catch (ValidationException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return null;
        }
    }*/

}
