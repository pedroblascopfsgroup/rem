package es.capgemini.pfs.ruleengine.json;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.ruleengine.HelperRule;

import net.sf.json.JSONObject;

/**
 * TODO DOCUMENTAR FO.
 */
@SuppressWarnings("unchecked")
public class JSONRule implements HelperRule {

    private List values = new ArrayList();
    private List rules = new ArrayList();
    private String type;
    private String operator;
    private String title;
    private long ruleId;

    /**
     * TODO DOCUMENTAR FO.
     * @param rules list
     */
    public void setRules(List rules) {
        //this.rules = rules;
        for (int i = 0; i < rules.size(); i++) {
            JSONObject jsonObject = JSONObject.fromObject(rules.get(i));
            HelperRule bean = (HelperRule) JSONObject.toBean(jsonObject, JSONRule.class);
            this.rules.add(bean);
        }

    }

    /**
     * TODO DOCUMENTAR FO.
     * @return boolean
     */
    public boolean isGroup() {
        if (getRules() != null && getRules().size() > 0) {
            return true;
        }
        return false;

    }

    /**
     * TODO DOCUMENTAR FO.
     * @param type String
     * @return boolean
     */
    public boolean isType(String type) {
        if (getType() != null) {
            return getType().trim().equalsIgnoreCase(type);
        }
        return false;
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param operator String
     * @return boolean
     */
    public boolean hasOperator(String operator) {
        if (getOperator() != null) {
            return getOperator().trim().equalsIgnoreCase(operator);
        }
        return false;
    }

    /**
     * @return the values
     */
    public List getValues() {
        return values;
    }

    /**
     * @param values the values to set
     */
    public void setValues(List values) {
        this.values = values;
    }

    /**
     * @return the type
     */
    public String getType() {
        return type;
    }

    /**
     * @param type the type to set
     */
    public void setType(String type) {
        this.type = type;
    }

    /**
     * @return the operator
     */
    public String getOperator() {
        return operator;
    }

    /**
     * @param operator the operator to set
     */
    public void setOperator(String operator) {
        this.operator = operator;
    }

    /**
     * @return the title
     */
    public String getTitle() {
        return title;
    }

    /**
     * @param title the title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * @return the ruleId
     */
    public long getRuleId() {
        return ruleId;
    }

    /**
     * @param ruleId the ruleId to set
     */
    public void setRuleId(long ruleId) {
        this.ruleId = ruleId;
    }

    /**
     * @return the rules
     */
    public List getRules() {
        return rules;
    }
}
