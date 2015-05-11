package es.capgemini.pfs.ruleengine.rule.dd;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public abstract class DDRuleType {

    public abstract int numberOfValues();

    public abstract String[] getValidOperators();

    public boolean isValidOperator(String operator) {
        //Si solo hay un operador no es necesario verificar el valor
        if (operator == null && !(getValidOperators().length > 1)) {
            return true;
        }

        if (operator == null && getValidOperators().length > 1) {
            return false;
        }

        for (String o : getValidOperators()) {
            if (o.equals(operator)) {
                return true;
            }
        }
        return false;
    }

    public abstract String getKey();

}
