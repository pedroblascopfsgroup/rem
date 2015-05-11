package es.capgemini.pfs.ruleengine;

import java.util.List;

/**
 * TODO DOCUMENTAR FO.
 */
@SuppressWarnings("unchecked")
public interface HelperRule {

    /**
     * @return long
     */
    long getRuleId();

    /**
     * @param ruleId long
     */
    void setRuleId(long ruleId);

    /**
     * @return String
     */
    String getTitle();

    /**
     * @param title string
     */
    void setTitle(String title);

    /**
     * @return list
     */
    List<String> getValues();

    /**
     * @param values list
     */
    void setValues(List values);

    /**
     * @return list
     */
    List<HelperRule> getRules();

    /**
     * @param rules list
     */
    void setRules(List rules);

    /**
     * @return String
     */
    String getType();

    /**
     * @param type string
     */
    void setType(String type);

    /**
     * @return string
     */
    String getOperator();

    /**
     * @param operator string
     */
    void setOperator(String operator);

    /**
     * @return boolean
     */
    boolean isGroup();

    /**
     * @param type String
     * @return boolean
     */
    boolean isType(String type);

    /**
     * @param operator String
     * @return boolean
     */
    boolean hasOperator(String operator);
    
    
}