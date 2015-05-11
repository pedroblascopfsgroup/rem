package es.capgemini.pfs.ruleengine;

import java.util.Comparator;

import es.capgemini.pfs.ruleengine.state.RuleEndState;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public class RuleSort implements Comparator<RuleEndState> {

    /**
     * {@inheritDoc}
     */
    @Override
    public int compare(RuleEndState o1, RuleEndState o2) {
        return (int) (o1.getPriority() - o2.getPriority());
    }

}
