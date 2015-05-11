package es.capgemini.pfs.ruleengine.rule.conjunction.imp;

import java.util.Iterator;

import es.capgemini.pfs.ruleengine.rule.Rule;
import es.capgemini.pfs.ruleengine.rule.conjunction.Rules;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public class AndRules extends Rules {

    public static final String AND_RESTRICTION = "AND";

    @Override
    public String generateSQL() {
        Iterator<Rule> i = getRules().iterator();
        Rule rule;
        StringBuffer sql = new StringBuffer(" ( ");
        while (i.hasNext()) {
            rule = i.next();
            sql.append(rule.generateSQL());
            if (i.hasNext()) {
                sql.append(" " + AND_RESTRICTION + " ");
            }
        }
        sql.append(" ) ");
        return sql.toString();
    }

}
