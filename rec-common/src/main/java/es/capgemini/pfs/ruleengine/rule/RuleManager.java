package es.capgemini.pfs.ruleengine.rule;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class RuleManager {

    @Autowired
    private List<Rule> rules;

    @SuppressWarnings("unchecked")
    private static Map<String, Class> rulesObj;

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * TODO DOCUMENTAR FO.
     */
    @PostConstruct
    @SuppressWarnings("unchecked")
    public synchronized void init() {
        if (rulesObj == null) {
            rulesObj = new HashMap<String, Class>();
            for (Rule type : rules) {
                rulesObj.put(type.getClass().getSimpleName(), type.getClass());
            }
        }
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param ruleOperator String
     * @return Rule
     */
    public Rule getRule(String ruleOperator) {
        try {
            return (Rule) rulesObj.get("Rule" + StringUtils.capitalize(ruleOperator)).newInstance();
        } catch (InstantiationException e) {
            logger.error(e);
        } catch (IllegalAccessException e) {
            // TODO Auto-generated catch block
            logger.error(e);
        }
        return null;
    }

}
