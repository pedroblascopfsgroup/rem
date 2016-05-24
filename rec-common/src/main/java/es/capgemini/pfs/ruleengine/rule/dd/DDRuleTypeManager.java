package es.capgemini.pfs.ruleengine.rule.dd;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Component
public class DDRuleTypeManager {

    @Autowired
    private List<DDRuleType> types;

    private static Map<String, DDRuleType> typesObj;

    /**
     * TODO DOCUMENTAR FO.
     */
    @PostConstruct
    public synchronized void init() {
        if (typesObj == null) {
            typesObj = new HashMap<String, DDRuleType>();
            for (DDRuleType type : types) {
                typesObj.put(type.getKey(), type);
            }
        }
    }

    /**
     * @param type String
     * @return DDRuleType
     */
    public DDRuleType getType(String type) {
        return typesObj.get(type);
    }

}
