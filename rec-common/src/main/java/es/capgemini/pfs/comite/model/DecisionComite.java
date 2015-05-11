package es.capgemini.pfs.comite.model;

import java.io.Serializable;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;

/**
 * Clase que representa una decisióndel comité.
 * @author pamuller
 */
@Entity
@Table(name = "DCO_DECISION_COMITE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class DecisionComite implements Serializable, Auditable {

    private static final long serialVersionUID = -3488623837576317465L;

    @Id
    @Column(name = "DCO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DecisionComiteGenerator")
    @SequenceGenerator(name = "DecisionComiteGenerator", sequenceName = "S_DCO_DECISION_COMITE")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "SES_ID")
    private SesionComite sesion;

    @OneToMany(mappedBy = "decisionComite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Expediente> expedientes;

    @OneToMany(mappedBy = "decisionComite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Asunto> asuntos;

    @Column(name = "DCO_OBSERVACIONES")
    private String observaciones;

    @Version
    private Integer version;

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
     * @return the sesion
     */
    public SesionComite getSesion() {
        return sesion;
    }

    /**
     * @param sesion the sesion to set
     */
    public void setSesion(SesionComite sesion) {
        this.sesion = sesion;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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
     * @return the expedientes
     */
    public Set<Expediente> getExpedientes() {
        return expedientes;
    }

    /**
     * @param expedientes the expedientes to set
     */
    public void setExpedientes(Set<Expediente> expedientes) {
        this.expedientes = expedientes;
    }

    /**
     * @return the asuntos
     */
    public Set<Asunto> getAsuntos() {
        return asuntos;
    }

    /**
     * @param asuntos the asuntos to set
     */
    public void setAsuntos(Set<Asunto> asuntos) {
        this.asuntos = asuntos;
    }

    /**
     * Indica la cantidad de asuntos y/o expedientes que se trataron.
     * @return int
     */
    public int getCantidadPuntosTratados() {
        int cant = 0;
        if (expedientes != null) {
            cant += expedientes.size();
        }
        if (asuntos != null) {
            cant += asuntos.size();
        }
        return cant;
    }

}
