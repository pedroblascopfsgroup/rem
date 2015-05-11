package es.capgemini.pfs.ruleengine.rule.definition;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
@Entity
@Table(name = "RULE_DEFINITION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RuleDefinition implements Serializable, Auditable {

    private static final long serialVersionUID = 8663242757883877055L;

    @Id
    @Column(name = "RD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RuleDefinitionGenerator")
    @SequenceGenerator(name = "RuleDefinitionGenerator", sequenceName = "S_RULE_DEFINITION")
    private Long id;

    @Column(name = "RD_DEFINITION")
    private String ruleDefinition;

    @Column(name = "RD_NAME")
    private String name;

    @Column(name = "RD_NAME_LONG")
    private String nameLong;

    public String getNameLong() {
        return nameLong;
    }

    public void setNameLong(String nameLong) {
        this.nameLong = nameLong;
    }

    @Embedded
    private Auditoria auditoria;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the ruleDefinition
     */
    public String getRuleDefinition() {
        return ruleDefinition;
    }

    /**
     * @param ruleDefinition the ruleDefinition to set
     */
    public void setRuleDefinition(String ruleDefinition) {
        this.ruleDefinition = ruleDefinition;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public Auditoria getAuditoria() {
        return auditoria;
    }

    @Override
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

}
