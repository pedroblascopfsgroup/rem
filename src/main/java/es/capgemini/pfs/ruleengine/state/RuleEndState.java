package es.capgemini.pfs.ruleengine.state;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public interface RuleEndState {
    //public long getId();
    String getName();

    String getValue();

    long getPriority();

    String getRuleDefinition();

}
