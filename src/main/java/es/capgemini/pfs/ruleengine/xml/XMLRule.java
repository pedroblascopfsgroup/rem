package es.capgemini.pfs.ruleengine.xml;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;
import com.thoughtworks.xstream.annotations.XStreamImplicit;

import es.capgemini.pfs.ruleengine.HelperRule;

public class XMLRule implements HelperRule {

    @XStreamAsAttribute
    private String values;

    @XStreamImplicit
    private List<HelperRule> rules = new ArrayList<HelperRule>();

    @XStreamAsAttribute
    private String type;

    @XStreamAsAttribute
    private String operator;

    @XStreamAsAttribute
    private String title;

    @XStreamAsAttribute
    private long ruleId;

    public long getRuleId() {
        return ruleId;
    }

    public void setRuleId(long ruleId) {
        this.ruleId = ruleId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<String> getValues() {
        if (values == null || StringUtils.isEmpty(values)) return new ArrayList<String>();
        String r = values;
        r = r.substring(1, r.length() - 1);
        return Arrays.asList(r.split(","));
    }

    public void setValues(String values) {
        this.values = values;
    }

    public List<HelperRule> getRules() {
        return rules;
    }

    @SuppressWarnings("unchecked")
    public void setRules(List rules) {
        this.rules = rules;
        //        for (int i = 0; i < rules.size(); i++) {
        //            JSONObject jsonObject = JSONObject.fromObject(rules.get(i));
        //            XMLRule bean = (XMLRule) JSONObject.toBean(jsonObject, XMLRule.class);
        //            this.rules.add(bean);
        //        }

    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = String.valueOf(operator);
    }

    public boolean isGroup() {
        if (getRules() != null && getRules().size() > 0) return true;
        return false;

    }

    public boolean isType(String type) {
        if (getType() != null) return getType().trim().equalsIgnoreCase(type);
        return false;
    }

    public boolean hasOperator(String operator) {
        if (getOperator() != null) return getOperator().trim().equalsIgnoreCase(operator);
        return false;
    }

    @Override
    @SuppressWarnings("unchecked")
    public void setValues(List values) {
        // TODO Implementar este método?

    }
}
