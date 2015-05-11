package es.capgemini.pfs.exclusionexpedientecliente.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Exclusión de un cliente en la evaluación de un expediente.
 * @author marruiz
 */

@Entity
@Table(name = "SEE_SOL_EXCL_EXP_CLIENTE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ExclusionExpedienteCliente implements Serializable, Auditable {

    private static final long serialVersionUID = 1536729800297614795L;


    @Id
    @Column(name = "SEE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExclusionExpedienteClienteGenerator")
    @SequenceGenerator(name = "ExclusionExpedienteClienteGenerator", sequenceName = "S_SEE_SOL_EXCL_EXP_CLIENTE")
    private Long id;

    @OneToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @Column(name = "SEE_OBSERVACION_SOL")
    private String observacionesSolicitud;

    @ManyToMany
    @JoinTable(name = "CEE_PER_EXP_EXCLUIDOS", joinColumns = { @JoinColumn(name = "SEE_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "PER_ID") })
    private List<Persona> personas;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the personas
     */
    public List<Persona> personas() {
        return personas;
    }


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
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the observacionesSolicitud
     */
    public String getObservacionesSolicitud() {
        return observacionesSolicitud;
    }

    /**
     * @param observacionesSolicitud the observacionesSolicitud to set
     */
    public void setObservacionesSolicitud(String observacionesSolicitud) {
        this.observacionesSolicitud = observacionesSolicitud;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the personas
     */
    public List<Persona> getPersonas() {
        return personas;
    }

    /**
     * @param personas the personas to set
     */
    public void setPersonas(List<Persona> personas) {
        this.personas = personas;
    }
}
