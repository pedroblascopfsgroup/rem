package es.capgemini.pfs.expediente.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que representa a la entidad personas del expediente, en los expedientes de seguimiento
 * para políticas.
 *
 * @author marruiz
 */
@Entity
@Table(name = "PEX_PERSONAS_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ExpedientePersona implements Serializable, Auditable {

    private static final long serialVersionUID = -1339463957394723046L;

    @Id
    @Column(name = "PEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExpedientePersonaGenerator")
    @SequenceGenerator(name = "ExpedientePersonaGenerator", sequenceName = "S_PEX_PERSONAS_EXPEDIENTE")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Persona persona;

    @ManyToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @ManyToOne
    @JoinColumn(name = "DD_AEX_ID")
    private DDAmbitoExpediente ambitoExpediente;

    @Column(name = "PEX_PASE")
    private Integer pase;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * Retorna el atributo auditoria.
     *
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     *
     * @param auditoria
     *            Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     *
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     *
     * @param version
     *            Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * Retorna el atributo id.
     *
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     *
     * @param id
     *            Long
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo persona.
     *
     * @return persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * Setea el atributo persona.
     *
     * @param persona
     *            Persona
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * Retorna el atributo expediente.
     *
     * @return expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * Setea el atributo expediente.
     *
     * @param expediente
     *            Expediente
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the pase
     */
    public Integer getPase() {
        return pase;
    }

    /**
     * @param pase
     *            the pase to set
     */
    public void setPase(Integer pase) {
        this.pase = pase;
    }

    /**
     * @param ambitoExpediente the ambitoExpediente to set
     */
    public void setAmbitoExpediente(DDAmbitoExpediente ambitoExpediente) {
        this.ambitoExpediente = ambitoExpediente;
    }

    /**
     * @return the ambitoExpediente
     */
    public DDAmbitoExpediente getAmbitoExpediente() {
        return ambitoExpediente;
    }
}
