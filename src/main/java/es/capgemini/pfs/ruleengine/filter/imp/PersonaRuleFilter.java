package es.capgemini.pfs.ruleengine.filter.imp;

import es.capgemini.pfs.ruleengine.filter.RuleFilter;

/**
 * TODO DOCUMENTAR FO.
 */
public class PersonaRuleFilter implements RuleFilter {

    private long personaId = -1;

    /**
     * TODO DOCUMENTAR FO.
     */
    public PersonaRuleFilter() {
        super();
    }

    /**
     * TODO DOCUMENTAR FO.
     * @param personaId long
     */
    public PersonaRuleFilter(long personaId) {
        super();
        this.personaId = personaId;
    }

    /**
     * @return the personaId
     */
    public long getPersonaId() {
        return personaId;
    }

    /**
     * @param personaId the personaId to set
     */
    public void setPersonaId(long personaId) {
        this.personaId = personaId;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String generateSQL() {
        return "PER_ID = " + personaId;
    }

}
